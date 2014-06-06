//
//  BrochurePictureView.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/13/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "BrochurePictureView.h"

@interface BrochurePictureView ()

- (void) buildImageViewWithName:(NSString*)name;
- (void) buildCaptionLabelWithText:(NSString*)caption;
- (void) adjustFinalSize;

@property (nonatomic, assign) BOOL isImageFullWidth;

@end

@implementation BrochurePictureView

- (id) initWithFrame:(CGRect)frame withFullWidthStatus:(BOOL)status withImageNamed:(NSString *)imageName withHeight:(float)height
{
    self = [super initWithFrame:frame];
    if (self) {
        _height = height;
        [self setIsImageFullWidth:status];
        [self buildImageViewWithName:imageName];
        [self adjustFinalSize];
        [self setClipsToBounds:YES];
        [self.layer setMasksToBounds:YES];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame withFullWidthStatus:(BOOL)status withImageNamed:(NSString *)imageName withHeight:(float)height andCaption:(NSString *)caption
{
    self = [self initWithFrame:frame withFullWidthStatus:status withImageNamed:imageName withHeight:height];
    if (self) {
        [self buildCaptionLabelWithText:caption];
        [self adjustFinalSize];
    }
    return self;
}

- (void) buildCaptionLabelWithText:(NSString *)caption
{
    CGRect newFrame = CGRectMake(kSidesMargin,
                    _imageView.frame.size.height+_imageView.frame.origin.y+kCaptionTopMargin,
                    self.frame.size.width-(kSidesMargin*2),
                    50);
    _captionLabel = [[UILabel alloc] initWithFrame:newFrame];
    [_captionLabel setFont:[LookAndFeel defaultFontBoldWithSize:13]];
    [_captionLabel setTextColor:[UIColor grayColor]];
    [_captionLabel setText:caption];
    [_captionLabel setTextAlignment:NSTextAlignmentRight];
    [_captionLabel setBackgroundColor:[UIColor clearColor]];
    [_captionLabel setAdjustsFontSizeToFitWidth:YES];
    [_captionLabel setMinimumScaleFactor:0.5];
    [self addSubview:_captionLabel];
}

- (void) buildImageViewWithName:(NSString *)name
{
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:name]]];

    if (_isImageFullWidth) {
        [_imageView setFrame:CGRectMake(0, 0, self.frame.size.width, _height)];
    } else {
        [_imageView setFrame:CGRectMake(kSidesMargin, 0, self.frame.size.width-(kSidesMargin*2),  _height)];
    }
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:_imageView];
}

- (void) adjustFinalSize
{    
    if (_isImageFullWidth) {
        [self setFrame:CGRectMake(0, self.frame.origin.y, self.frame.size.width, _height)];
    } else {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _captionLabel.frame.size.height+_height+kCaptionTopMargin)];
    }

}

@end
