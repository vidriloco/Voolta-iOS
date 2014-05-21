//
//  BrochurePictureView.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/13/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"
#import "OperationHelpers.h"

#define kImageHeight        250
#define kCaptionTopMargin   0
#define kSidesMargin 30

@interface BrochurePictureView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *captionLabel;

- (id) initWithFrame:(CGRect)frame withFullWidthStatus:(BOOL)status withImageNamed:(NSString*)imageName andCaption:(NSString*)caption;
- (id) initWithFrame:(CGRect)frame withFullWidthStatus:(BOOL)status withImageNamed:(NSString*)imageName;

@end
