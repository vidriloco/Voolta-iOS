//
//  TripBrochureViewController.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/10/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"
#import "App.h"
#import "POIOnCardView.h"
#import "Trip.h"
#import "Poi.h"
#import "TripKeyDetailsView.h"
#import "MainCardButton.h"
#import "LegendElementView.h"

#define kTopYOffset         90
#define kRowHeight          63
#define kBottomMargin       30

@class TripViewController;

@interface TripBrochureViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) Trip *currentTrip;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIView *titleContainerView;

+ (TripBrochureViewController*) instance;
+ (id) buildNew;

@end
