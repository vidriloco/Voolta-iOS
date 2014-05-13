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
    
    [_categoryImageView setAlpha:0.1];
    [_categoryImageView setContentMode:UIViewContentModeScaleAspectFill];

    CGPoint point = CGPointMake(0, _mainImageView.frame.size.height+_mainImageView.frame.origin.y+20);
    _contentBuilder = [[ContentBuilder alloc] initWithDelegate:self withOffset:point];
}

- (void) contentBuilderFinishedAddingElementToView
{
    [self drawNextContentElement];
}

- (void) drawNextContentElement {
    if (_contentBuilder.contentElementIdx > [_contentElements count]-1) {
        [_scrollView setContentSize:CGSizeMake(self.frame.size.width, _contentBuilder.lastOffset.y)];
    } else {
        BrochureElement *element = [_contentElements objectAtIndex:_contentBuilder.contentElementIdx];
        [_contentBuilder buildContentForElement:element onContainer:_scrollView];
    }
}

@end
