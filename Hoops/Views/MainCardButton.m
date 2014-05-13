//
//  MainCardButton.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/3/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "MainCardButton.h"

@interface MainCardButton ()

- (void) onTap;
- (void) onUntap;

@end

@implementation MainCardButton

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
    [_legendLabel setFont:[LookAndFeel defaultFontBoldWithSize:12]];
    [_legendLabel setTextAlignment:NSTextAlignmentCenter];
    [_legendLabel setMinimumScaleFactor:0.5];
    [_legendLabel setTextColor:[UIColor grayColor]];
    
    [self.layer setCornerRadius:8];
    [self.layer setMasksToBounds:YES];
    [self addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(onUntap) forControlEvents:(UIControlEventTouchUpInside|UIControlEventTouchUpOutside)];
}

- (void) onTap
{

}

- (void) onUntap
{

}

@end
