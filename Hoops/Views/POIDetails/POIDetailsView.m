//
//  POIDetailsView.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/6/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "POIDetailsView.h"

@interface POIDetailsView ()

- (void) loadDetailsForPoi:(Poi*) poi;
- (void) applyCustomStyleToMainView;

@end

@implementation POIDetailsView

- (id)initWithPoi:(id)poi
{
    self = [super initWithFrame:[App viewBounds]];
    
    if (self) {
        CGRect frame = CGRectMake([App viewBounds].size.width/2-kCardWidth/2,
                                  [App viewBounds].size.height/2-kCardHeight/2,
                                  kCardWidth,
                                  kCardHeight);
        
        _mainView = [[UIView alloc] initWithFrame:frame];
        _backgroundView = [[UIView alloc] initWithFrame:[App viewBounds]];
        [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        [self addSubview:_backgroundView];
        [self addSubview:_mainView];
        [self setUserInteractionEnabled:YES];
        
        
        float bottomLine = [App viewBounds].size.height-70;
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            bottomLine -= 20;
        }
        
        UIImage *closeButtonImg = [UIImage imageNamed:@"close-icon.png"];
        
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width/2-closeButtonImg.size.width/2
                                                                  , bottomLine, closeButtonImg.size.width, closeButtonImg.size.height)];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"close-icon.png"] forState:UIControlStateNormal];
        [self addSubview:_closeButton];
        
        [self loadDetailsForPoi:poi];
        
    }
    return self;
}

- (void) loadDetailsForPoi:(Poi *)poi
{
    if ([poi isSlideUIBased]) {
        HorizontalSlidesBasedPoiView *horizontalSlide = [[HorizontalSlidesBasedPoiView alloc] initWithContainerView:_mainView];

        [horizontalSlide drawSlidesForPoi:poi];
        [_mainView addSubview:horizontalSlide];
        [self applyCustomStyleToMainView];

    } else if([poi isMiniUIBased]) {
        MiniPOIDetailsView *miniPOIDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"MiniPOIDetailsView" owner:self options:nil] objectAtIndex:0];
        [_mainView setBackgroundColor:[UIColor clearColor]];
        [miniPOIDetailsView stylize];

        [[miniPOIDetailsView titleLabel] setText:poi.theTitle];
        [[miniPOIDetailsView kindImageView] setImage:[UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:poi.kindImage]]];
        [[miniPOIDetailsView categoryImageView] setImage:[UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:poi.categoryImage]]];
        
        [_mainView addSubview:miniPOIDetailsView];
        [ContentBuilder setText:poi.details withNSAlignment:NSTextAlignmentJustified onLabel:[miniPOIDetailsView detailsLabel]];

    } else {
        
        StandardPoiView *poiView = [[[NSBundle mainBundle] loadNibNamed:@"StandardPoiView" owner:self options:nil] objectAtIndex:0];
        [poiView setContentElements:poi.brochureElements];
        [poiView stylize];
        [_mainView addSubview:poiView];

        [[poiView mainImageView] setImage:[UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:poi.mainPic]]];
        [[poiView iconView] setImage:[UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:poi.kindImage]]];
        [[poiView titleLabel] setText:poi.theTitle];
        [[poiView subtitleLabel] setText:
         [[poi.categoryKeyword stringByAppendingString:@" - "] stringByAppendingString:poi.subtitle]];
        [[poiView categoryImageView] setImage:[UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:poi.categoryImage]]];
        [poiView drawNextContentElement];
        [self applyCustomStyleToMainView];
    }

}

- (void) applyCustomStyleToMainView
{
    [_mainView setBackgroundColor:[UIColor whiteColor]];
    _mainView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_mainView.bounds].CGPath;
    _mainView.layer.masksToBounds = NO;
    _mainView.layer.shadowOffset = CGSizeMake(3, 3);
    _mainView.layer.shadowRadius = 3;
    _mainView.layer.shadowOpacity = 0.2;
    _mainView.layer.shouldRasterize = YES;
    _mainView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    [_mainView.layer setCornerRadius:kCornerRadius];
}


@end
