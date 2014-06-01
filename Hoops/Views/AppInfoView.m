//
//  AppInfoView.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/27/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "AppInfoView.h"

@interface AppInfoView ()

- (void) buildSlideWithText:(NSString*)text andAlignmentRule:(NSString*)alignmentRule withIndex:(int)index;
- (void) changePage:(id)sender;

@end

@implementation AppInfoView

- (id) initSimple
{
    self = [super initWithFrame:[App viewBounds]];
    if (self) {
        self.container = [[UIView alloc] initWithFrame:CGRectMake(
                                                                  self.frame.size.width/2-kInfoViewWidth/2,
                                                                  self.frame.size.height/2-kInfoViewHeight/2,
                                                                  kInfoViewWidth, kInfoViewHeight)];
        [self.container setBackgroundColor:[UIColor whiteColor]];
        self.container.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.container.bounds].CGPath;
        self.container.layer.masksToBounds = YES;
        self.container.layer.shadowOffset = CGSizeMake(3, 3);
        self.container.layer.shadowRadius = 3;
        self.container.layer.shadowOpacity = 0.2;
        self.container.layer.shouldRasterize = YES;
        self.container.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        [self.container.layer setCornerRadius:kInfoViewRadius];
        [self buildViewContents];

        [self addSubview:self.container];
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.9]];
        [self setAlpha:0];
        
    }
    return self;
}

- (void) buildSlideWithText:(NSString *)text andAlignmentRule:(NSString *)alignmentRule withIndex:(int)index
{
    UIImageView *infoPageOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[text stringByAppendingString:@".png"]]];
    
    float yPosition = [@"bottom" isEqualToString:alignmentRule] ? self.container.frame.size.height-130 : [@"top" isEqualToString:alignmentRule] ? 60 : 170;
    
    UILabel *infoPageOneLabel = [[UILabel alloc ] initWithFrame:CGRectMake(20, yPosition, self.container.frame.size.width-40, 70)];
    [infoPageOneLabel setText:NSLocalizedString(text, nil)];
    [infoPageOneLabel setTextColor:[UIColor whiteColor]];
    [infoPageOneLabel setNumberOfLines:3];
    [infoPageOneLabel setBackgroundColor:[UIColor clearColor]];

    if (index == 4) {
        [infoPageOneLabel setFrame:CGRectMake(40, yPosition, self.container.frame.size.width-80, 70)];
        [infoPageOneLabel setFont:[LookAndFeel defaultFontBookWithSize:20]];

        
        UIImage *imageNamed = [UIImage imageNamed:@"hoop-mini.png"];
        
        UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(kInfoViewWidth/2-45, kInfoViewHeight/2-15, 90, 90)];
        [startButton setBackgroundImage:imageNamed forState:UIControlStateNormal];
        
        [startButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [infoPageOne addSubview:startButton];
        [infoPageOne setUserInteractionEnabled:YES];
    } else {
        [infoPageOneLabel setFont:[LookAndFeel defaultFontBoldWithSize:16]];
    }
    [infoPageOneLabel setTextAlignment:NSTextAlignmentCenter];
    [infoPageOneLabel setMinimumScaleFactor:0.5];
    [infoPageOneLabel setAdjustsFontSizeToFitWidth:YES];
    [infoPageOne addSubview:infoPageOneLabel];
    
    infoPageOneLabel.layer.shadowOffset = CGSizeMake(3, 3);
    infoPageOneLabel.layer.shadowRadius = 3;
    infoPageOneLabel.layer.shadowOpacity = 0.4;
    infoPageOneLabel.layer.shouldRasterize = YES;
    
    [self.scrollView addSubview:infoPageOne];
    [infoPageOne setFrame:CGRectMake(self.container.frame.size.width*index, 0, kInfoViewWidth, kInfoViewHeight)];
}

- (void) buildViewContents
{
    NSArray *slides = @[
                        @[@"info-page-one", @"bottom"],
                        @[@"info-page-two", @"top"],
                        @[@"info-page-three", @"top"],
                        @[@"info-page-four", @"bottom"],
                        @[@"info-page-five", @"top"]
                      ];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kInfoViewWidth, kInfoViewHeight)];
    [_scrollView setContentSize:CGSizeMake([slides count]*self.container.frame.size.width, self.container.frame.size.height)];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setUserInteractionEnabled:YES];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setBounces:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setDelegate:self];
    
    [self.container addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kInfoViewHeight-40, kInfoViewWidth, 30)];
    [_pageControl setPageIndicatorTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    [_pageControl setNumberOfPages:[slides count]];
    
    [self.container addSubview:_pageControl];
    
    [slides enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *text = [[slides objectAtIndex:idx] objectAtIndex:0];
        NSString *alignmentRule = [[slides objectAtIndex:idx] objectAtIndex:1];
        [self buildSlideWithText:text andAlignmentRule:alignmentRule withIndex:(int) idx];
    }];    
}

- (void) show
{
    NSLog(@"Show");
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:1];
    }];
}

- (void) hide
{
    NSLog(@"TOTOT");
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) changePage:(id)sender
{
    UIPageControl *pager=sender;
    int page = (int) pager.currentPage;
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
}

#pragma scrollview delegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPage = page;
    if (_pageControl.currentPage == 0) {
        [self setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:0.9]];
    } else if (_pageControl.currentPage == 1) {
        [self setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:0.8]];
    } else if (_pageControl.currentPage == 2) {
        [self setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:0.7]];
    } else if (_pageControl.currentPage == 3) {
        [self setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:0.6]];
    } else if (_pageControl.currentPage == 4) {
        [self setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:0.5]];
    } else {
        [self setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:0.4]];
    }
}

@end
