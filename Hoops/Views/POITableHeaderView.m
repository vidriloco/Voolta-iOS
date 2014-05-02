//
//  POITableHeaderView.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/2/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "POITableHeaderView.h"

@implementation POITableHeaderView

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
    [_sectionLabel setFont:[LookAndFeel defaultFontBookWithSize:14]];
    [_sectionLabel setTextColor:[UIColor grayColor]];
    [_content setAlpha:0.05];
    [self.layer setBorderColor:[[_content backgroundColor] colorWithAlphaComponent:0.3].CGColor];
    [self.layer setBorderWidth:0.2];
    [self.layer setCornerRadius:2];
}

@end
