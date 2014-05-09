//
//  POIDetailsView.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/6/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "Poi.h"
#import "LookAndFeel.h"
#import "HorizontalSlidesBasedPoiView.h"

#define kCardWidth      280
#define kCardHeight     340
#define kCornerRadius   7

@interface POIDetailsView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;

- (id) initWithPoi:(Poi*)poi;

@end
