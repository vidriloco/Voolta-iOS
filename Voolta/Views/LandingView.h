//
//  LandingView.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/28/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"
#import "OperationHelpers.h"

#define DegreesToRadians(angle) (angle / 180.0 * M_PI)

@interface LandingView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;

@property (nonatomic, weak) IBOutlet UILabel *legendLabel;
@property (nonatomic, weak) IBOutlet UIButton *nextIconButton;
@property (nonatomic, weak) IBOutlet UIButton *infoIconButton;
@property (nonatomic, weak) IBOutlet UIButton *reloadIconButton;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) IBOutlet UIButton *creditsButton;
@property (nonatomic, assign) BOOL creditsAreVisible;

@property (nonatomic, weak) IBOutlet UIView *personCardView;
@property (nonatomic, weak) IBOutlet UILabel *personCreditTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *personNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *personContactLabel;
@property (nonatomic, weak) IBOutlet UIImageView *personPicView;

- (void) stylizeView;
- (void) finishedLoading;
- (void) restartedLoading;
- (void) toggleCredits;

@end
