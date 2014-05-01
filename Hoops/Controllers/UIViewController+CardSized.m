//
//  UIViewController+CardSized.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/2/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "UIViewController+CardSized.h"

@implementation UIViewController (CardSized)

- (void) resizeMainView
{
    [self.view setFrame:CGRectMake([App viewBounds].size.width/2, [App viewBounds].size.height/2, kCardWidth, kCardHeight)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setClipsToBounds:YES];
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:7];
}

@end
