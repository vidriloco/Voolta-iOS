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
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        _mainView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_mainView.bounds].CGPath;
        _mainView.layer.masksToBounds = NO;
        _mainView.layer.shadowOffset = CGSizeMake(3, 3);
        _mainView.layer.shadowRadius = 3;
        _mainView.layer.shadowOpacity = 0.2;
        _mainView.layer.shouldRasterize = YES;
        _mainView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        [_mainView.layer setCornerRadius:kCornerRadius];
        
        _backgroundView = [[UIView alloc] initWithFrame:[App viewBounds]];
        [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        [self addSubview:_backgroundView];
        [self addSubview:_mainView];
        [self setUserInteractionEnabled:YES];
        
        UIImageView *dismissImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close-icon.png"]];
        [dismissImage setFrame:CGRectMake([App viewBounds].size.width/2-dismissImage.frame.size.width/2, [App viewBounds].size.height-dismissImage.frame.size.height-20, dismissImage.frame.size.width, dismissImage.frame.size.height)];
        [self addSubview:dismissImage];
        
        [self loadDetailsForPoi:poi];
        
    }
    return self;
}

- (void) loadDetailsForPoi:(Poi *)poi
{
    if ([poi isSlideBased]) {
        HorizontalSlidesBasedPoiView *horizontalSlide = [[HorizontalSlidesBasedPoiView alloc] initWithContainerView:_mainView];

        [horizontalSlide drawSlidesForPoi:poi];
        [_mainView addSubview:horizontalSlide];
    } else {
        StandardPoiView *poiView = [[[NSBundle mainBundle] loadNibNamed:@"StandardPoiView" owner:self options:nil] objectAtIndex:0];
        [poiView setContentElements:poi.brochureElements];
        [poiView stylize];
        [_mainView addSubview:poiView];

        [[poiView mainImageView] setImage:[UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:poi.mainPic]]];
        [[poiView iconView] setImage:[UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:poi.kindImage]]];
        [[poiView titleLabel] setText:poi.theTitle];
        [[poiView subtitleLabel] setText:
         [[poi.localizedCategory stringByAppendingString:@" - "] stringByAppendingString:poi.subtitle]];
        
        [[poiView categoryImageView] setImage:[UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:poi.categoryImage]]];
        [poiView drawNextContentElement];
        
    }

}



@end
