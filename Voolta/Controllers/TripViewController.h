//
//  TripViewController.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/24/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UIColor-Expanded.h"
#import "App.h"
#import "TripSelectedDelegate.h"
#import "DirectionMarker.h"
#import <CoreLocation/CoreLocation.h>
#import "TripPoisDelegate.h"
#import "TripBrochureViewController.h"
#import "TripPoisDelegate.h"

#import "POIDetailsManager.h"
#import "POIDetailsView.h"

#define defaultZoomInLevel      17
#define defaultZoomOutLevel     15

@class TripShowcaseViewController;

@interface TripViewController : UIViewController <GMSMapViewDelegate, TripSelectedDelegate, CLLocationManagerDelegate, TripPoisDelegate>

@property (nonatomic, strong) Trip *currentTrip;

+ (TripViewController*) current;

+ (id) newWithTrip:(Trip*)trip;
- (void) toggleMapControlsOff:(BOOL)state;
- (void) toggleMapCompass;

@end
