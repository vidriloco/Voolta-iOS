//
//  LegendElementView.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/16/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "LegendElementView.h"

@implementation LegendElementView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) stylize
{
    [_containerView.layer setCornerRadius:5];
    [_containerView setAlpha:0.05];
    
    [_leftMainTitleLabel setTextColor:[UIColor grayColor]];
    [_leftMainTitleLabel setFont:[LookAndFeel defaultFontBoldWithSize:17]];
    
    [_rightMainTitleLabel setTextColor:[UIColor grayColor]];
    [_rightMainTitleLabel setFont:[LookAndFeel defaultFontBoldWithSize:17]];
    
    [_subtitleLabel setTextColor:[UIColor grayColor]];
    [_subtitleLabel setFont:[LookAndFeel defaultFontBookWithSize:15]];

    [_descriptionLabel setTextColor:[UIColor grayColor]];
    [_descriptionLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];

}

- (void) toggleSide:(UISide)side
{
    if (side == UIRightSide) {
        [_rightMainTitleLabel setHidden:NO];
        [_rightLegendImageView setHidden:NO];
        [_leftMainTitleLabel setHidden:YES];
        [_leftLegendImageView setHidden:YES];
    } else if (side == UILeftSide) {
        [_rightMainTitleLabel setHidden:YES];
        [_rightLegendImageView setHidden:YES];
        [_leftMainTitleLabel setHidden:NO];
        [_leftLegendImageView setHidden:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
