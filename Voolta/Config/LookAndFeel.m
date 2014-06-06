//
//  LookAndFeel.m
//  Wikicleta
//
//  Created by Spalatinje on 8/28/13.
//  Copyright (c) 2013 Wikicleta. All rights reserved.
//

#import "LookAndFeel.h"

@implementation LookAndFeel

/*
 *  The default Wikicleta blue color
 */
+ (UIColor*) blueColor
{
    return [UIColor colorWithHexString:@"008dff"];
}

/*
 *  The default Wikicleta orange color
 */
+ (UIColor*) orangeColor
{
    return [UIColor colorWithHexString:@"fb4e15"];
}

/*
 *  A lighter variation of the Wikicleta blue color
 */
+ (UIColor*) lightBlueColor
{
    return [UIColor colorWithHexString:@"0399FF"];
}

/*
 *  A variation of the Hoops blue color
 */
+ (UIColor*) middleBlueColor
{
    return [UIColor colorWithHexString:@"00aeef"];
}

+ (UIColor*) highlightColor
{
    return [[UIColor colorWithHexString:@"c2dcff"] colorWithAlphaComponent:0.4];
}

/*
 *  A green color definition
 */
+ (UIColor*) greenColor
{
    return [UIColor colorWithHexString:@"22B204"];
}

/*
 *  A white color definition
 */
+ (UIColor*) whiteColor
{
    return [UIColor whiteColor];
}

/*
 *  Default typography for Wikicleta on light with the size given
 */
+ (UIFont*) defaultFontLightWithSize:(int)size
{
    return [UIFont fontWithName:@"OpenSans-Light" size:size];
}

/*
 *  Default typography for Wikicleta on bold with the size given
 */
+ (UIFont*) defaultFontBoldWithSize:(int)size
{
    return [UIFont fontWithName:@"OpenSans-Bold" size:size];
}

/*
 *  Default typography for Wikicleta on book with the size given
 */
+ (UIFont*) defaultFontBookWithSize:(int)size
{
    return [UIFont fontWithName:@"OpenSans" size:size];
}

/*
 *  Will decorate the provided UILabel with the string value defined for the localizable string on Localizable.strings with a default styling as view title
 */
+ (void) decorateUILabelAsMainViewTitle:(UILabel*) titleLabel withLocalizedString:(NSString *)localizedString
{
    if (localizedString != nil) {
        [titleLabel setText:NSLocalizedString(localizedString, nil)];
    }
    [titleLabel setFont:[LookAndFeel defaultFontBookWithSize:titleFontSize]];
    [titleLabel setTextColor:[LookAndFeel orangeColor]];
}

/*
 *  Will decorate the provided UILabel with the string value defined for the localizable string on Localizable.strings with a default styling as main title
 */
+ (void) decorateUILabelAsMainViewSubtitle:(UILabel*) subtitleLabel withLocalizedString:(NSString *)localizedString
{
    if (localizedString != nil) {
        [subtitleLabel setText:NSLocalizedString(localizedString, nil)];
    }
    [subtitleLabel setFont:[LookAndFeel defaultFontLightWithSize:subtitleFontSize]];
    [subtitleLabel setTextColor:[LookAndFeel blueColor]];
}

/*
 *  Will decorate the provided UILabel with the string value defined for the localizable string on Localizable.strings with a default styling
 */
+ (void) decorateUILabelAsCommon:(UILabel*) label withLocalizedString:(NSString*)localizedString
{
    if (localizedString != nil) {
        [label setText:NSLocalizedString(localizedString, nil)];
    }
    [label setFont:[LookAndFeel defaultFontBookWithSize:normalFontSize]];
    [label setTextColor:[LookAndFeel blueColor]];
}

/*
 *  Will decorate the provided UITextField with the string value defined for the localizable string on Localizable.strings as placeholder
 */
+ (void) decorateUITextField:(UITextField*)textField withLocalizedPlaceholder:(NSString *)localizedPlaceholder
{
    if (localizedPlaceholder != nil) {
        [textField setPlaceholder:NSLocalizedString(localizedPlaceholder, nil)];
    }
    [textField setFont:[LookAndFeel defaultFontLightWithSize:formFontSize]];
}

/*
 *  Will decorate the provided UITextView with the string value defined for the localizable string on Localizable.strings as placeholder
 */
+ (void) decorateUITextView:(UITextView*)textView withLocalizedPlaceholder:(NSString *)localizedPlaceholder
{
    if (localizedPlaceholder != nil) {
        [textView setText:NSLocalizedString(localizedPlaceholder, nil)];
    }
    [textView setFont:[LookAndFeel defaultFontLightWithSize:formFontSize]];
}


@end
