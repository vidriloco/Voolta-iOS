//
//  TripShowcaseViewController.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/26/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "TripCardView.h"
#import "LandingView.h"
#import "Trip.h"
#import "App.h"
#import "TripViewController.h"
#import "DataStoreDelegate.h"
#import "DataStore.h"
#import "LandingScreen.h"
#import "ContentBuilder.h"
#import "OperationHelpers.h"
#import "AppInfoView.h"

@interface TripShowcaseViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, DataStoreDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, weak) IBOutlet UIImageView *background;
@property (nonatomic, weak) IBOutlet UIImageView *logoView;
@property (nonatomic, weak) IBOutlet UIImageView *betaView;

@end
