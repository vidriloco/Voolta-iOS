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
}

@end
