//
//  Poi.m
//  Hoops
//
//  Created by Alejandro Cruz on 3/29/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "Poi.h"

@implementation Poi

+ (Poi*) initWithDictionary:(NSDictionary*)dictionary
{
    Poi *poi = [[Poi alloc] init];
    
    poi.theTitle = [dictionary objectForKey:@"title"];
    poi.kind = [dictionary objectForKey:@"kind"];
    poi.sponsored = [[dictionary objectForKey:@"sponsored"] boolValue];
    poi.category = [dictionary objectForKey:@"category"];
    
    float lat = [[[dictionary objectForKey:@"location"] objectForKey:@"lat"] floatValue];
    float lon = [[[dictionary objectForKey:@"location"] objectForKey:@"lon"] floatValue];
    poi.position = CLLocationCoordinate2DMake(lat, lon);
    poi.mainPic = [dictionary objectForKey:@"main_pic"];
    poi.icon = [UIImage imageNamed:[[poi kind] stringByAppendingString:@"-marker.png"]];
    poi.snippet = nil;
    
    if ([poi isSlideBased]) {
        poi.details = [dictionary objectForKey:@"details"];

        if([dictionary objectForKey:@"slides"]) {
            NSMutableArray *slideList = [NSMutableArray array];

            for (NSDictionary *slide in [dictionary objectForKey:@"slides"]) {
                SlideElement *slideElement = [[SlideElement alloc] initWithDictionary:slide];
                [slideList addObject:slideElement];
            }
            [poi setSlideElements:slideList];
            
        }
    } else {
        if([dictionary objectForKey:@"contents"]) {
            NSMutableArray *brochureElements = [NSMutableArray array];
            
            for (NSDictionary *content in [dictionary objectForKey:@"contents"]) {
                BrochureElement *brochureElement = [BrochureElement initWithDictionary:content];
                [brochureElements addObject:brochureElement];
            }
            [poi setBrochureElements:brochureElements];
        }
    }
    
    return poi;
}

- (NSString*) subtitle
{
    return NSLocalizedString(self.kind, nil);
}

- (NSString*) localizedCategory
{
    return NSLocalizedString(self.category, nil);
}

- (BOOL) isSlideBased
{
    return [self.kind isEqualToString:@"museum"];
}

- (BOOL) isAPlaceToEat {
    return [self.kind isEqualToString: @"food"];
}

- (BOOL) isAPlaceToInteract
{
    return [self.kind isEqualToString: @"art"];
}

- (BOOL) isAPlaceToSee
{
    return [self.kind isEqualToString: @"landmark"];
}

- (BOOL) isAPlaceToFeel
{
    return [self.kind isEqualToString: @"feel"];
}

- (BOOL) isAPlaceToExplore
{
    return [self.kind isEqualToString: @"explore"];
}

- (BOOL) isAServiceStation
{
    return [self.kind isEqualToString: @"service_hub"];
}

- (BOOL) isABikeSchool
{
    return [self.kind isEqualToString: @"bike_school"];
}

- (BOOL) isABikeLending
{
    return [self.kind isEqualToString: @"bicycle_sharing"];
}

- (NSString*) associatedIconName
{
    if ([self isAPlaceToEat]) {
        return @"food-icon.png";
    } else if ([self isAPlaceToExplore]) {
        return @"landmark-icon.png";
    } else if ([self isAPlaceToSee]) {
        return @"landmark-icon.png";
    } else if ([self isAPlaceToInteract]) {
        return @"public_space-icon.png";
    } else if ([self isAServiceStation]) {
        return @"service_hub-icon.png";
    } else if ([self isABikeSchool]) {
        return @"bike_school-icon.png";
    } else if ([self isABikeLending]) {
        return @"bicycle_sharing-icon.png";
    }
    return nil;
}

- (NSString*) iconName
{
    return [self.kind stringByAppendingString:@"-icon.png"];
}

@end
