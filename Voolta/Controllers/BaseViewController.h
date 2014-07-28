//
//  BaseViewController.h
//  Voolta
//
//  Created by Alejandro Cruz on 7/28/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripShowcaseViewController.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) TripShowcaseViewController *showcaseViewController;

+ (void) initializeBase;
+ (id) instance;
+ (void) reloadAndPresentViewController;

@end
