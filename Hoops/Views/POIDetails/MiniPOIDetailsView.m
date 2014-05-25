//
//  MiniPOIDetailsView.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/25/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "MiniPOIDetailsView.h"
#import "POIDetailsView.h"

@implementation MiniPOIDetailsView

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
    [_titleLabel setFont:[LookAndFeel defaultFontBoldWithSize:20]];
    [_detailsLabel setFont:[LookAndFeel defaultFontBookWithSize:17]];
    [_detailsLabel setTextColor:[UIColor grayColor]];
    [_detailsLabel setAdjustsFontSizeToFitWidth:YES];
    [_detailsLabel setMinimumScaleFactor:0.5];
    
    [self setClipsToBounds:YES];
    
    [_containerView setBackgroundColor:[UIColor whiteColor]];
    _containerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_containerView.bounds].CGPath;
    _containerView.layer.masksToBounds = YES;
    _containerView.layer.shadowOffset = CGSizeMake(3, 3);
    _containerView.layer.shadowRadius = 3;
    _containerView.layer.shadowOpacity = 0.2;
    _containerView.layer.shouldRasterize = YES;
    _containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    [_containerView.layer setCornerRadius:kCornerRadius];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.layer setCornerRadius:kCornerRadius];
    [self.layer setMasksToBounds:YES];
}

@end
