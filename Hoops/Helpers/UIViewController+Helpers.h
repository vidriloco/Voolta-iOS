//
//  UIViewController+Helpers.h
//  Wikicleta
//
//  Created by Alejandro Cruz Paz on 12/22/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "LookAndFeel.h"

@interface UIViewController (Helpers)

- (void) loadImageBackgroundNamed:(NSString*)imageName;
- (void) setImageAsBackground:(UIImage*)image;
- (void) loadNavigationBarDefaultStyle;
- (void) loadRightButtonWithString:(NSString*)string andStringSelector:(NSString*)selector;
- (void) loadLeftButtonWithString:(NSString*)string andStringSelector:(NSString*)selector;

- (void) resizeContentScrollToFit:(UIScrollView*)scrollView;
- (void) resizeContentScrollToFit:(UIScrollView*)scrollView withIncrement:(int)increment;

// Validators

- (void) showAlertDialogWith:(NSString *)title andContent:(NSString *)content andTextButton:(NSString*) textButton;

@end
