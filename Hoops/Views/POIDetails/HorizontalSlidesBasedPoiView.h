//
//  HorizontalSlidesBasedPoiView.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/7/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideElement.h"
#import "Poi.h"
#import "POIDetailsManager.h"

@class POIDetailsView;

@interface HorizontalSlidesBasedPoiView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

- (id) initWithContainerView:(UIView*) view;
- (void) drawSlidesForPoi:(Poi*) poi;

@end
