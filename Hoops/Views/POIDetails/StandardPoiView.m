//
//  StandardPoiView.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/9/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "StandardPoiView.h"
#import "POIDetailsView.h"

@implementation StandardPoiView

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
    [_titleLabel setMinimumScaleFactor:0.5];
    [_titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_titleLabel setFont:[LookAndFeel defaultFontBoldWithSize:18]];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    _titleLabel.layer.shadowOffset = CGSizeMake(3, 3);
    _titleLabel.layer.shadowRadius = 3;
    _titleLabel.layer.shadowOpacity = 0.4;
    _titleLabel.layer.shouldRasterize = YES;
    
    [_subtitleLabel setMinimumScaleFactor:0.3];
    [_subtitleLabel setAdjustsFontSizeToFitWidth:YES];
    [_subtitleLabel setFont:[LookAndFeel defaultFontBookWithSize:14]];
    [_subtitleLabel setTextColor:[UIColor whiteColor]];
    _subtitleLabel.layer.shadowOffset = CGSizeMake(3, 3);
    _subtitleLabel.layer.shadowRadius = 3;
    _subtitleLabel.layer.shadowOpacity = 0.4;
    _subtitleLabel.layer.shouldRasterize = YES;
    
    [self.layer setCornerRadius:kCornerRadius];
    [self.layer setMasksToBounds:YES];
    
    [_mainImageView setClipsToBounds:YES];
    [_mainImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [_textView setFont:[LookAndFeel defaultFontBookWithSize:15]];
    [_textView setTextColor:[UIColor grayColor]];
    
    [_textView setSelectable:NO];
    [_textView setEditable:NO];
    [_textView setScrollEnabled:NO];
    [_textView setMinimumZoomScale:0.5];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [_categoryImageView setAlpha:0.1];
    [_categoryImageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void) setDetailsViewWithText:(NSString *)text
{
    //  paragraphSetting
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.paragraphSpacing = 8.f;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    UIColor *color = [UIColor grayColor];
    
    NSDictionary *attributeDic = @{ NSFontAttributeName:[LookAndFeel defaultFontBookWithSize:15],
                                    NSForegroundColorAttributeName:color,
                                    NSParagraphStyleAttributeName:paragraphStyle};
    
    NSAttributedString *repString = [[NSAttributedString alloc] initWithString:text attributes:attributeDic];
    [_textView setAttributedText:repString];
}

@end
