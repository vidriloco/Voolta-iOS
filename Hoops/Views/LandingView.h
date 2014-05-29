//
//  LandingView.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/28/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface LandingView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *legendLabel;
@property (nonatomic, weak) IBOutlet UIButton *nextIconView;
@property (nonatomic, weak) IBOutlet UIButton *infoIconView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (void) stylizeView;
- (void) finishedLoading;

@end
