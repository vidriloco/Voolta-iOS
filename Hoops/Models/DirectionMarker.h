//
//  DirectionMarker.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/5/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface DirectionMarker : GMSMarker

@property (nonatomic, assign) float angle;

+ (id) initWithDictionary:(NSDictionary*)dictionary;


@end
