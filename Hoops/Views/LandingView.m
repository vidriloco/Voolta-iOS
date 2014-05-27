//
//  LandingView.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/28/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "LandingView.h"

@implementation LandingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) stylizeView
{
    [self.legendLabel setFont:[LookAndFeel defaultFontLightWithSize:16]];
    [self.nextIconView setHidden:YES];
    [self.infoIconView setHidden:YES];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void) finishedLoading
{
    [self.nextIconView setHidden:NO];
    [self.nextIconView setAlpha:0];
    [self.infoIconView setHidden:NO];
    [self.infoIconView setAlpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [self.nextIconView setAlpha:1];
        [self.activityIndicatorView setAlpha:0];
        [self.infoIconView setAlpha:1];

    } completion:^(BOOL finished) {
        [self.activityIndicatorView setHidden:YES];
    }];
}

@end
