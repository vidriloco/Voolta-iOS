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
    self.nextIconView.alpha = 0.8;
}

@end
