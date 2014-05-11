//
//  POITableViewCell.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/2/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "POITableViewCell.h"

@implementation POITableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [_containingView.layer setBorderColor:[[LookAndFeel blueColor] colorWithAlphaComponent:0.9].CGColor];
    } else {
        [_containingView.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.9].CGColor];
    }
    // Configure the view for the selected state
}

- (void) stylize
{
    [_containingView setClipsToBounds:YES];
    [_imageBackground setContentMode:UIViewContentModeScaleAspectFill];
    [_containingView.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.9].CGColor];
    [_containingView.layer setBorderWidth:1];
    [_containingView.layer setCornerRadius:2];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [_subtitleLabel setMinimumScaleFactor:0.3];
    [_subtitleLabel setAdjustsFontSizeToFitWidth:YES];
    [_subtitleLabel setFont:[LookAndFeel defaultFontBookWithSize:14]];
    [_subtitleLabel setTextColor:[UIColor whiteColor]];
    _subtitleLabel.layer.shadowOffset = CGSizeMake(3, 3);
    _subtitleLabel.layer.shadowRadius = 3;
    _subtitleLabel.layer.shadowOpacity = 0.4;
    _subtitleLabel.layer.shouldRasterize = YES;
    
    [_titleLabel setMinimumScaleFactor:0.5];
    [_titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_titleLabel setFont:[LookAndFeel defaultFontBoldWithSize:17]];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    _titleLabel.layer.shadowOffset = CGSizeMake(3, 3);
    _titleLabel.layer.shadowRadius = 3;
    _titleLabel.layer.shadowOpacity = 0.4;
    _titleLabel.layer.shouldRasterize = YES;
}

@end
