//
//  Trip.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/23/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "Trip.h"

@interface Trip ()

- (void) readPoisFromDictionary:(NSDictionary*)dictionary;

@end

@implementation Trip
static NSArray *list;

+ (Trip*) initWithPlistDictionary:(NSDictionary*)dictionary
{
    Trip *trip = [[Trip alloc] init];
    trip.kind = [dictionary objectForKey:@"kind"];
    trip.background = [dictionary objectForKey:@"background"];

    if (![trip isLandingView]) {
        trip.title = [dictionary objectForKey:@"name"];
        trip.mainPic = [dictionary objectForKey:@"picture"];
        trip.isAvailable = [[dictionary objectForKey:@"available"] boolValue];
        trip.cost = [[dictionary objectForKey:@"cost"] floatValue];
        
        trip.complexity = [dictionary objectForKey:@"complexity"];
        trip.distance = [dictionary objectForKey:@"distance"];

        if (trip.isAvailable) {
            // Loading route data
            NSDictionary *route = [dictionary objectForKey:@"route"];
            float oLat = [[[route objectForKey:@"origin"] objectForKey:@"lat"] floatValue];
            float oLon = [[[route objectForKey:@"origin"] objectForKey:@"lon"] floatValue];
            [trip setOriginCoordinate:CLLocationCoordinate2DMake(oLat, oLon)];
            
            float eLat = [[[route objectForKey:@"end"] objectForKey:@"lat"] floatValue];
            float eLon = [[[route objectForKey:@"end"] objectForKey:@"lon"] floatValue];
            [trip setEndCoordinate:CLLocationCoordinate2DMake(eLat, eLon)];
            trip.startZoom = (int) [[route objectForKey:@"start_zoom"] integerValue];
            
            NSMutableArray *pathsTmp = [NSMutableArray array];
            for (NSDictionary *path in [route objectForKey:@"paths"]) {
                [pathsTmp addObject:[Path initWithDictionary:path]];
            }
            trip.paths = pathsTmp;
            
            // Loading orientation markers
            NSMutableArray *directionTmp = [NSMutableArray array];
            for (NSDictionary *dict in [route objectForKey:@"markers"]) {
                DirectionMarker *directionMarker = [DirectionMarker initWithDictionary:dict];
                [directionTmp addObject:directionMarker];
            }
            [trip setDirectionMarkers:directionTmp];
        }
        
        // Load POIs
        [trip readPoisFromDictionary:dictionary];
        // Loading brochure elements
        
        NSMutableArray *brochureList = [NSMutableArray array];
        for (NSDictionary *brochureContent in [dictionary objectForKey:@"contents"]) {
            [brochureList addObject:[BrochureElement initWithDictionary:brochureContent andTripId:trip.remoteId]];
        }
        [trip setBrochureList:brochureList];
        
    }
    
    return trip;
}

+ (Trip*) initWithJsonDictionary:(NSDictionary *)dictionary
{
    Trip *trip = [[Trip alloc] init];
    [trip setRemoteId:[[dictionary objectForKey:@"id"] longValue]];
    [trip setTitle:[dictionary objectForKey:@"title"]];
    [trip setDetails:[dictionary objectForKey:@"details"]];
    [trip setDistance:[dictionary objectForKey:@"distance"]];
    [trip setComplexity:[dictionary objectForKey:@"complexity"]];
    [trip setIsAvailable:([[dictionary objectForKey:@"available"] intValue] == 1)];
    [trip setCost:[[dictionary objectForKey:@"name"] floatValue]];
    
    NSString *backgroundImage = [[dictionary objectForKey:@"background_image"] objectForKey:@"filename"];
    NSString *mainImage = [[[[dictionary objectForKey:@"main_image"] objectForKey:@"url"] componentsSeparatedByString:@"/"] lastObject];

    [trip setBackground:backgroundImage];
    [trip setMainPic:[NSString stringWithFormat:kTripPrefix, [trip remoteId], mainImage]];
    
    [trip setOriginCoordinate:CLLocationCoordinate2DMake([[[dictionary objectForKey:@"start"] objectForKey:@"lat"] floatValue],
                                                         [[[dictionary objectForKey:@"start"] objectForKey:@"lon"] floatValue])];
    [trip setEndCoordinate:CLLocationCoordinate2DMake([[[dictionary objectForKey:@"final"] objectForKey:@"lat"] floatValue],
                                                         [[[dictionary objectForKey:@"final"] objectForKey:@"lon"] floatValue])];
    // Paths loading
    NSMutableArray *pathsTmp = [NSMutableArray array];
    for (NSDictionary *path in [dictionary objectForKey:@"paths"]) {
        [pathsTmp addObject:[Path initWithDictionary:path]];
    }
    trip.paths = pathsTmp;
    
    // Loading POIs
    [trip readPoisFromDictionary:dictionary];
    
    // Brochure list loading
    NSMutableArray *brochureList = [NSMutableArray array];
    for (NSDictionary *brochureContent in [dictionary objectForKey:@"contents"]) {
        [brochureList addObject:[BrochureElement initWithDictionary:brochureContent andTripId:trip.remoteId]];
    }
    [trip setBrochureList:brochureList];
    
    return trip;
}

+ (NSArray*) loadAll
{
    NSArray *listOfTrips = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Trips" ofType:@"plist"]];
    NSMutableArray *tripsTmp = [NSMutableArray array];
    for (NSDictionary *dict in listOfTrips) {
        [tripsTmp addObject:[Trip initWithPlistDictionary:dict]];
    }
    
    list = [NSArray arrayWithArray:tripsTmp];
    
    return list;
}

+ (int) count
{
    return (int) [list count];
}

+ (NSArray*) all
{
    return list;
}

- (void) readPoisFromDictionary:(NSDictionary *)dictionary
{
    // Loading pois
    NSMutableDictionary *poisDict = [NSMutableDictionary dictionary];
    NSMutableArray *poisList = [NSMutableArray array];
    
    for (NSDictionary *dict in [dictionary objectForKey:@"pois"]) {
        Poi *poi = [Poi initWithDictionary:dict andTripId:[self remoteId]];
        
        // Separate listed from unlisted
        if ([[dict objectForKey:kListedKey] boolValue]) {
            NSString *poiCategory = [[dict objectForKey:@"poi_kind"] objectForKey:@"keyword"];
            
            if (![poisDict objectForKey:poiCategory]) {
                [poisDict setObject:[NSMutableArray array] forKey:poiCategory];
            }
            
            [[poisDict objectForKey:poiCategory] addObject:poi];
            _numberOfPOIsListed++;
        }
        
        [poisList addObject:poi];
    }
    [self setCategorizedPois:poisDict];
    [self setAllPois:poisList];
}

- (BOOL) isLandingView
{
    return [self.kind isEqualToString:@"landing"];
}

@end
