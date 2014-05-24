//
//  Poi.m
//  Hoops
//
//  Created by Alejandro Cruz on 3/29/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "Poi.h"

@implementation Poi

+ (Poi*) initWithDictionary:(NSDictionary*)dictionary andTripId:(long)tripId
{
    Poi *poi = [[Poi alloc] init];

    poi.remoteId = [[dictionary objectForKey:@"id"] longValue];
    
    poi.theTitle = [dictionary objectForKey:@"title"];
    poi.details = [dictionary objectForKey:@"details"];
    poi.isSlideBased = [[dictionary objectForKey:@"slide_based"] boolValue];
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
    
    NSString *url = [[dictionary objectForKey:@"image"] objectForKey:@"url"];
    poi.mainPic = [NSString stringWithFormat:kPoiPrefix, tripId, [url componentsSeparatedByString:@"/"].lastObject];
    
    UIImage *imageMarker = [UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:[kind objectForKey:@"filename"]]];
    
    poi.icon = [OperationHelpers imageWithImage:imageMarker scaledToSize:CGSizeMake(40, 40)];
    
    [OperationHelpers fetchImage:url withResponseBlock:^(UIImage *image) {
        [OperationHelpers storeImage:image withFilename:poi.mainPic];
    }];
    
    if ([poi isSlideBased]) {

        if([dictionary objectForKey:@"slides"]) {
            NSMutableArray *slideList = [NSMutableArray array];

            for (NSDictionary *slide in [dictionary objectForKey:@"slides"]) {
                SlideElement *slideElement = [[SlideElement alloc] initWithDictionary:slide withTripId:tripId withPoiId:[poi remoteId]];
                [slideList addObject:slideElement];
            }
            [poi setSlideElements:slideList];
            
        }
    } else {
        if([dictionary objectForKey:@"contents"]) {
            NSMutableArray *brochureElements = [NSMutableArray array];
            
            for (NSDictionary *content in [dictionary objectForKey:@"contents"]) {
                BrochureElement *brochureElement = [BrochureElement initWithDictionary:content andTripId:0];
                [brochureElements addObject:brochureElement];
            }
            
            [brochureElements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 order] > [obj2 order];
            }];
    
            [poi setBrochureElements:brochureElements];
        }
    }
    
    return poi;
}

- (NSString*) subtitle
{
    return _kindKeyword;
}

- (NSString*) localizedCategory
{
    return _categoryKeyword;
}

@end
