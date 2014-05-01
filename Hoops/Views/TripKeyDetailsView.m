//
//  TripKeyDetailsView.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/15/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "TripKeyDetailsView.h"

@implementation TripKeyDetailsView

- (void) stylize
{
    [_leftLabel setTextColor:[UIColor whiteColor]];
    [_leftLabel setFont:[LookAndFeel defaultFontBookWithSize:15]];
    [[_leftLabel layer] setShadowOffset:CGSizeMake(3, 4)];
    [[_leftLabel layer] setShadowOpacity:0.8];
    [[_leftLabel layer] setShadowColor:[UIColor blackColor].CGColor];
    
    [_rightLabel setTextColor:[UIColor whiteColor]];
    [_rightLabel setFont:[LookAndFeel defaultFontBookWithSize:15]];
    [[_rightLabel layer] setShadowOffset:CGSizeMake(3, 4)];
    [[_rightLabel layer] setShadowOpacity:0.8];
    [[_rightLabel layer] setShadowColor:[UIColor blackColor].CGColor];
}

@end
