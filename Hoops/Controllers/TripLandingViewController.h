//
//  TripLandingViewController.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/2/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "UIViewController+CardSized.h"
#import "LookAndFeel.h"
#import "MainCardButton.h"
#import "TripSelectedDelegate.h"
#import "Trip.h"

@interface TripLandingViewController : UIViewController

- (id) initWithTripSelectedDelegate:(id<TripSelectedDelegate>)delegate;

@end
