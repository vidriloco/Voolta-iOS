//
//  UIViewController+CardSized.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/2/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"

#define kCardWidth      280
#define kCardHeight     340

@interface UIViewController (CardSized)

- (void) resizeMainView;

@end
