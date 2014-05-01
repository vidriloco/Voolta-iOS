//
//  POIDetailsViewController.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/8/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CardSized.h"
#import "LookAndFeel.h"
#import "MainCardButton.h"
#import "Poi.h"

@interface POIDetailsViewController : UIViewController

@property (nonatomic, strong) Poi *poi;

- (id) initWithTripPoi:(Poi*)poi;

@end
