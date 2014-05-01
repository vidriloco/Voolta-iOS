//
//  TripSelectedDelegate.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/4/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Trip.h"

@protocol TripSelectedDelegate <NSObject>

- (void) centerMapOnTripStart;
- (void) centerMapOnTripFinal;
- (Trip*) currentTrip;

@end
