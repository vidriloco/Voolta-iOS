//
//  DirectionMarker.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/5/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "DirectionMarker.h"

@implementation DirectionMarker

+ (id) initWithDictionary:(NSDictionary*)dictionary
{
    DirectionMarker *marker = [[DirectionMarker alloc] init];
    NSLog([dictionary description]);
    float lat = [[dictionary objectForKey:@"lat"] floatValue];
    float lon = [[dictionary objectForKey:@"lon"] floatValue];
    [marker setPosition:CLLocationCoordinate2DMake(lat, lon)];
    [marker setRotation:[[dictionary objectForKey:@"rotation"] floatValue]];
    
    return marker;
}


@end
