//
//  TripCardView.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/26/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LookAndFeel.h"
#import "POIOnCardView.h"
#import "Trip.h"

@interface TripCardView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *mainImage;
@property (nonatomic, weak) IBOutlet UIImageView *ribbonImage;
@property (nonatomic, weak) IBOutlet UIView *subpanel;

@property (nonatomic, weak) IBOutlet UILabel *poisAlongRouteLabel;

@property (nonatomic, weak) IBOutlet UILabel *tripNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *tripDistanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *tripComplexityLabel;
@property (nonatomic, weak) IBOutlet UITextView *tripDetailsTextView;


- (void) stylize;
- (void) buildPoiFragmentsFor:(NSArray*)pois;

@end
