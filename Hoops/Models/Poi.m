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
    
    poi.mainTitle = [dictionary objectForKey:@"title"];
    poi.details = [dictionary objectForKey:@"details"];
    poi.kind = [dictionary objectForKey:@"kind"];
    poi.sponsored = [[dictionary objectForKey:@"sponsored"] boolValue];
    
    float lat = [[[dictionary objectForKey:@"location"] objectForKey:@"lat"] floatValue];
    float lon = [[[dictionary objectForKey:@"location"] objectForKey:@"lon"] floatValue];
    poi.position = CLLocationCoordinate2DMake(lat, lon);
    poi.mainPic = [dictionary objectForKey:@"main_pic"];
    poi.icon = [UIImage imageNamed:[[poi kind] stringByAppendingString:@"-icon.png"]];

    return poi;
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

- (NSString*) subtitle
{
    if ([self isAPlaceToEat]) {
        return @"Un restaurante bike-friendly";
    } else if ([self isAPlaceToExplore]) {
        return @"Para explorar";
    } else if ([self isAPlaceToSee]) {
        return @"Un lugar para contemplar";
    } else if ([self isAPlaceToInteract]) {
        return @"Un esacio para interactuar";
    } else if ([self isAServiceStation]) {
        return @"Punto de servicios";
    } else if ([self isABikeSchool]) {
        return @"Bici-escuela";
    } else if ([self isABikeLending]) {
        return @"Préstamo de Bicis";
    }
    return @"Un lugar más";
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

@end
