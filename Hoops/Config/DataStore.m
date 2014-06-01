//
//  DataStore.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/15/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "DataStore.h"

@interface DataStore ()

- (void) checkUpdateStatusForTrip:(NSDictionary*)dictionary;
- (void) checkUpdateStatusForImage:(NSDictionary *)dictionary;
- (void) updateMarkedTrips;
- (void) processTripPayload:(NSString*)payload;
- (void) reconstructTripFromData:(NSString*)stringData;
- (void) graphicsImageFetched;
- (void) pruneTrashedGraphics;
- (void) loadLocallyStoredTrips;

@property (nonatomic, strong) NSString *tripsInventoryURL;
@property (nonatomic, strong) NSString *imagesInventoryURL;
@property (nonatomic, strong) NSString *trashesInventoryURL;

@property (nonatomic, strong) NSString *tripURL;
@property (nonatomic, strong) SBJsonParser *parser;

@property (nonatomic, assign) int graphicsOnStore;
@property (nonatomic, assign) int graphicsToBeFetched;

@end

@implementation DataStore

static DataStore *instance;

+ (id) initializeStoreWithDelegate:(id<DataStoreDelegate>)delegate
{
    if (instance == nil) {
        instance = [[DataStore alloc] init];
        [instance setDelegate:delegate];
    }
    return instance;
}

+ (DataStore*) current
{
    return instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.tripsInventoryURL = [App urlForResource:@"inventory" withSubresource:@"trips"];
        self.imagesInventoryURL = [App urlForResource:@"inventory" withSubresource:@"images"];
        self.trashesInventoryURL = [App urlForResource:@"inventory" withSubresource:@"trashes"];
        self.tripURL = [App urlForResource:@"trips" withSubresource:@"show"];
        self.parser = [[SBJsonParser alloc] init];
        
        if ([App isNetworkReachable]) {
            [self updateInventory];
        } else {
            [self loadLocallyStoredTrips];
        }
    }
    return self;
}

- (void) updateInventory
{
    [self updateGeneralImages];
}

- (void) pruneTrashedGraphics
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    comps.month = -1;
    NSDate *lastMonth = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
    calendar = [NSCalendar currentCalendar];
    comps = [NSDateComponents new];
    comps.minute   = -2;
    NSDate *lastTwoMinutes = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
    ARLazyFetcher *fetcher = [ImageOnInventory lazyFetcher];
    [fetcher whereField:@"lastSeenAlive" between:lastMonth and:lastTwoMinutes];
    for (ImageOnInventory *img in [fetcher fetchRecords]) {
        [OperationHelpers removeImageWithFilename:[img.url componentsSeparatedByString:@"/"].lastObject];
        [img dropRecord];
    }
}

- (void) updateGeneralImages
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager setRequestSerializer:requestSerializer];
    
    [manager GET:_imagesInventoryURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *fetchedImages = [_parser objectWithString:[operation responseString] error:nil];
        _graphicsToBeFetched = (int) [fetchedImages count];
        for (NSDictionary *imageDictionary in fetchedImages) {
            [self checkUpdateStatusForImage:imageDictionary];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self loadLocallyStoredTrips];
    }];
}

- (void) checkUpdateStatusForImage:(NSDictionary *)dictionary
{
    NSArray *fetched = [[[ImageOnInventory lazyFetcher] whereField:@"remoteId" equalToValue:[dictionary objectForKey:@"id"]] fetchRecords];
    ImageOnInventory *inventoredImg;
    BOOL newRecord = NO;

    if ([fetched count] > 0) {
        inventoredImg = [fetched objectAtIndex:0];
    } else {
        inventoredImg = [ImageOnInventory initWithDictionary:dictionary];
        newRecord = YES;
    }
    
    if ([[inventoredImg url] isEqualToString:[dictionary objectForKey:@"url"]]) {
        [inventoredImg setLastSeenAlive:[NSDate new]];
    }

    [inventoredImg save];
    
    if ([inventoredImg shouldUpdateBasedOnDateString:[dictionary objectForKey:@"updated_at"]] || newRecord) {
        NSString *filename = [inventoredImg.url componentsSeparatedByString:@"/"].lastObject;
        
        [OperationHelpers fetchImage:inventoredImg.url withResponseBlock:^(UIImage *image) {
            [OperationHelpers storeImage:image withFilename:filename];
            
            if (!newRecord) {
                [inventoredImg updateFieldsFromDictionary:dictionary];
                [inventoredImg save];
            }
            [self graphicsImageFetched];
        }];
    } else {
        [self graphicsImageFetched];
    }
    
}

- (void) graphicsImageFetched
{
    _graphicsOnStore++;
    if (_graphicsOnStore == _graphicsToBeFetched) {
        [_delegate imageLoadingPhaseCompleted];
        [self pruneTrashedGraphics];
        [_delegate prunePhaseCompleted];
        [self updateTripsInventory];
    }
}

- (void) updateTripsInventory
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager setRequestSerializer:requestSerializer];
    
    [manager GET:_tripsInventoryURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *fetchedTrips = [_parser objectWithString:[operation responseString] error:nil];
        for (NSDictionary *tripDictionary in fetchedTrips) {
            [self checkUpdateStatusForTrip:tripDictionary];
        }
        [self updateMarkedTrips];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void) checkUpdateStatusForTrip:(NSDictionary *)dictionary
{
    NSNumber *identifier = [NSNumber numberWithLong:[[dictionary objectForKey:@"id"] longValue]];
    NSString *checksum = [dictionary objectForKey:@"checksum"];
    NSString *lang = [dictionary objectForKey:@"lang"];
    NSString *resourceId = [dictionary objectForKey:@"trip_resource"];

    if ([lang isEqualToString:[App currentLang]]) {
        NSArray *trips = [[[TripOnInventory lazyFetcher] whereField:@"remoteId" equalToValue:identifier] fetchRecords];
        
        TripOnInventory *inventory = nil;
        if ([trips count] == 0) {
            // A freshly added trip
            inventory = [TripOnInventory initWithRemoteId:identifier checksumString:checksum langString:lang andResourceId:resourceId];
            [inventory markForUpdate];
            [inventory save];
        } else {
            inventory = [trips objectAtIndex:0];
            if (![[inventory checksum] isEqualToString:checksum]) {
                [inventory setChecksum:checksum];
                [inventory markForUpdate];
                [inventory update];
            }
        }
    }
}

- (void) updateMarkedTrips
{
    NSArray *inventoryList = [[[TripOnInventory lazyFetcher] whereField:@"lang" equalToValue:[App currentLang]] fetchRecords];
    
    for (TripOnInventory *tripOnInventory in inventoryList) {
        if ([tripOnInventory shouldUpdate]) {
            [_delegate startedFetchingTrip];
            [OperationHelpers removeFilesForTripWithResourceId:[tripOnInventory resourceId]];
            NSString *finalTripURL = [_tripURL stringByReplacingOccurrencesOfString:@"<id>"
                                                                         withString:[NSString stringWithFormat:@"%d", [[tripOnInventory remoteId] intValue]]];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
            [requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            [manager setRequestSerializer:requestSerializer];
            
            [manager GET:finalTripURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *data = [operation responseString];
                [tripOnInventory setTripData:data];
                [tripOnInventory markAsUpdated];
                [tripOnInventory update];
                [self processTripPayload:data];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if ([operation.response statusCode] == 404) {
                    [OperationHelpers removeFilesForTripWithResourceId:[tripOnInventory resourceId]];
                    [tripOnInventory dropRecord];
                }
                
                [_delegate failedFetchingTrip];
            }];
        } else {
            [_delegate startedLoadingTrip];
            [self reconstructTripFromData:[tripOnInventory tripData]];
        }
    }
}

- (void) processTripPayload:(NSString *)payload
{
    if (_trips == nil) {
        _trips = [NSMutableArray array];
    }
    
    NSDictionary *dictionary = [_parser objectWithString:payload error:nil];
    Trip *trip = [Trip initWithJsonDictionary:dictionary];
    
    NSDictionary *imageObject = [dictionary objectForKey:@"main_image"];
    [OperationHelpers fetchImage:[imageObject objectForKey:@"url"] withResponseBlock:^(UIImage *image) {
        [OperationHelpers storeImage:image withFilename:[trip mainPic]];
        
        [_trips addObject:trip];
        [_delegate finishedFetchingTrip];
    }];
}

- (void) reconstructTripFromData:(NSString *)stringData
{
    if (_trips == nil) {
        _trips = [NSMutableArray array];
    }

    NSDictionary *object = [_parser objectWithString:stringData error:nil];
    Trip *trip = [Trip initWithJsonDictionary:object];
    [_trips addObject:trip];
    
    [_delegate finishedFetchingTrip];
}

- (void) loadLocallyStoredTrips
{
    NSArray *inventoryList = [[[TripOnInventory lazyFetcher] whereField:@"lang" equalToValue:[App currentLang]] fetchRecords];
    
    for (TripOnInventory *tripOnInventory in inventoryList) {
        [_delegate startedLoadingTrip];
        [self reconstructTripFromData:[tripOnInventory tripData]];
    }
}

@end
