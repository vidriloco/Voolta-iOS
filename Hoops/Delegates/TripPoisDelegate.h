//
//  TripPoisDelegate.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/8/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poi.h"

@protocol TripPoisDelegate <NSObject>

@required
- (Poi*) nextPoi;
- (Poi*) previousPoi;
- (Poi*) currentPoi;

@end
