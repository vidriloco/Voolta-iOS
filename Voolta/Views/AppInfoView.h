//
//  AppInfoView.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/27/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "LookAndFeel.h"

#define kInfoViewWidth      270
#define kInfoViewHeight     400
#define kInfoViewRadius     7

@interface AppInfoView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *finishButton;


- (id) initSimple;
- (void) buildViewContents;
- (void) show;
- (void) hide;
@end

