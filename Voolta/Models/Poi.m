//
//  Poi.m
//  Hoops
//
//  Created by Alejandro Cruz on 3/29/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "Poi.h"

@implementation Poi

+ (Poi*) initWithDictionary:(NSDictionary*)dictionary andTripResourceId:(NSString*)tripResourceId
{
    Poi *poi = [[Poi alloc] init];

    poi.remoteId = [[dictionary objectForKey:@"id"] longValue];
    
    poi.theTitle = [dictionary objectForKey:@"title"];
    poi.details = [dictionary objectForKey:@"details"];
    poi.mode = [dictionary objectForKey:@"mode"];
    NSDictionary *kind = [dictionary objectForKey:@"poi_kind"];
    if ([[kind allKeys] count] > 0) {
        poi.kindKeyword = [kind objectForKey:@"keyword"];
        poi.kindCode = [kind objectForKey:@"content"];
        poi.kindImage = [kind objectForKey:@"filename"];
    }

    poi.snippet = nil;
    
    NSDictionary *category = [dictionary objectForKey:@"poi_category"];
    if ([[category allKeys] count] > 0) {
        poi.categoryKeyword = [category objectForKey:@"keyword"];
        poi.categoryCode = [category objectForKey:@"content"];
        poi.categoryImage = [category objectForKey:@"filename"];
    }

    poi.sponsored = [[dictionary objectForKey:@"sponsored"] boolValue];
    
    float lat = [[[dictionary objectForKey:@"coordinates"] objectForKey:@"lat"] floatValue];
    float lon = [[[dictionary objectForKey:@"coordinates"] objectForKey:@"lon"] floatValue];
    poi.position = CLLocationCoordinate2DMake(lat, lon);
    
    UIImage *imageMarker = [UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:[kind objectForKey:@"filename"]]];
    
    CGSize size = [poi isMiniUIBased] ? CGSizeMake(33, 33) : CGSizeMake(40, 40);
    
    [[OperationHelpers operationQueue] addOperationWithBlock:^{
        poi.icon = [OperationHelpers imageWithImage:imageMarker scaledToSize:size];
    }];
    
    if (![poi isMiniUIBased]) {
        NSString *url = [[dictionary objectForKey:@"image"] objectForKey:@"url"];
        
        poi.mainPic = [NSString stringWithFormat:kPoiPrefix, tripResourceId, [url componentsSeparatedByString:@"/"].lastObject];
        [OperationHelpers fetchImage:url withResponseBlock:^(UIImage *image) {
            [OperationHelpers storeImage:image withFilename:poi.mainPic withResponseBlock:NULL];
        }];
    }
    
    if ([poi isSlideUIBased]) {

        if([dictionary objectForKey:@"slides"]) {
            NSMutableArray *slideList = [NSMutableArray array];

            for (NSDictionary *slide in [dictionary objectForKey:@"slides"]) {
                SlideElement *slideElement = [[SlideElement alloc] initWithDictionary:slide withTripResourceId:tripResourceId];
                [slideList addObject:slideElement];
            }
            
            NSArray *sortedArray = [slideList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 order] > [obj2 order];
            }];
            
            [poi setSlideElements:sortedArray];
            
        }
    } else if([poi isNormalUIBased]) {
        
        if([dictionary objectForKey:@"contents"]) {
            NSMutableArray *brochureElements = [NSMutableArray array];
            
            for (NSDictionary *content in [dictionary objectForKey:@"contents"]) {
                BrochureElement *brochureElement = [BrochureElement initWithDictionary:content andTripResourceId:tripResourceId];
                [brochureElement setRequiresLeftAligment:NO];
                [brochureElements addObject:brochureElement];
            }
            
            NSArray *sortedArray = [brochureElements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 order] > [obj2 order];
            }];
    
            [poi setBrochureElements:sortedArray];
        }
    }
    
    return poi;
}

- (NSString*) subtitle
{
    return _kindKeyword;
}

- (BOOL) isSlideUIBased
{
    return [_mode isEqualToString:@"slide_based"];
}

- (BOOL) isMiniUIBased
{
    return [_mode isEqualToString:@"small"];
}

- (BOOL) isNormalUIBased
{
    return [_mode isEqualToString:@"normal"];
}

@end
