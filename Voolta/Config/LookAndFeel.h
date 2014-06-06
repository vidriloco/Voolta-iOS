//
//  LookAndFeel.h
//  Defines sets of helper methods for
//  colors, typographies and general UI controls customization
//  Wikicleta
//
//  Created by Spalatinje on 8/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor-Expanded.h"

#define titleFontSize       25
#define subtitleFontSize    17
#define formFontSize        16
#define normalFontSize      14

@interface LookAndFeel : NSObject

+ (UIColor*) blueColor;
+ (UIColor*) orangeColor;
+ (UIColor*) lightBlueColor;
+ (UIColor*) middleBlueColor;
+ (UIColor*) highlightColor;

+ (UIColor*) greenColor;
+ (UIColor*) whiteColor;

+ (UIFont*) defaultFontLightWithSize:(int) size;
+ (UIFont*) defaultFontBoldWithSize:(int) size;
+ (UIFont*) defaultFontBookWithSize:(int) size;

+ (void) decorateUILabelAsMainViewTitle:(UILabel*) titleLabel withLocalizedString:(NSString*)localizedString;
+ (void) decorateUILabelAsMainViewSubtitle:(UILabel*) subtitleLabel withLocalizedString:(NSString*)localizedString;
+ (void) decorateUILabelAsCommon:(UILabel*) label withLocalizedString:(NSString*)localizedString;
+ (void) decorateUITextField:(UITextField*)textField withLocalizedPlaceholder:(NSString*)localizedPlaceholder;
+ (void) decorateUITextView:(UITextView*)textView withLocalizedPlaceholder:(NSString*)localizedPlaceholder;

@end
