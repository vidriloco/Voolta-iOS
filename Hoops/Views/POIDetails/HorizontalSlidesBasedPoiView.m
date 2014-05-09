//
//  HorizontalSlidesBasedPoiView.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/7/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "HorizontalSlidesBasedPoiView.h"
#import "POIDetailsView.h"

@interface HorizontalSlidesBasedPoiView ()

- (void) drawMainSlideWithTitle:(NSString*)title
                   withSubtitle:(NSString*)subtitle
                  withIconName:(NSString*)iconName
        withContrastViewEnabled:(BOOL)contrasted
              andBackgroundView:(UIView*)view;

- (void) drawSlideForSlideElement:(SlideElement*)element andBackgroundView:(UIView *)view atIndex:(NSUInteger)index;
- (void) tappedSlideTitle:(id)sender;

@end

@implementation HorizontalSlidesBasedPoiView

- (id)initWithContainerView:(UIView *)view
{
    self = [super initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        [_scrollView setBounces:NO];
        [_scrollView setScrollEnabled:YES];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView.layer setCornerRadius:kCornerRadius];
        [_scrollView.layer setMasksToBounds:YES];
        [_scrollView setDelegate:self];
        
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width/2-100/2, self.frame.size.height-35, 100, 20)];
        [_pageControl setNumberOfPages:3];
        [_pageControl setPageIndicatorTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
        [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void) drawSlidesForPoi:(Poi *)poi
{
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width*poi.slideElements.count, self.frame.size.height)];
    [poi.slideElements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        float xPos = self.frame.size.width*idx;
        
        SlideElement *element = obj;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                                  CGRectMake(xPos, 0, self.frame.size.width, self.frame.size.height)];
        
        if ([element isMainSlide]) {
            [imageView setImage:[UIImage imageNamed:poi.mainPic]];
            [self drawMainSlideWithTitle:poi.theTitle
                            withSubtitle:poi.theSubtitle
                            withIconName:poi.iconName
                 withContrastViewEnabled:[element contrasted]
                       andBackgroundView:imageView];
        } else {
            [imageView setImage:[UIImage imageNamed:element.image]];
            [self drawSlideForSlideElement:element
                         andBackgroundView:imageView
                                   atIndex:idx];
        }
        
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_scrollView addSubview:imageView];
        [imageView.layer setMasksToBounds:YES];
    }];

}


- (void) drawSlideForSlideElement:(SlideElement*)element andBackgroundView:(UIView *)view atIndex:(NSUInteger)index
{
    UILabel *titleLabel;
    UILabel *subtitleLabel;
    UIView *contrastingView;
    
    if (element.contentAlignment == SlideAlignBottomLeft) {
        contrastingView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-105, self.frame.size.width, 55)];

        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height-110, self.frame.size.width-40, 40)];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height-90, self.frame.size.width-40, 40)];
        [subtitleLabel setTextAlignment:NSTextAlignmentLeft];
    } else {
        contrastingView = [[UIView alloc] initWithFrame:CGRectMake(0, 23, self.frame.size.width, 55)];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width-40, 40)];
        [titleLabel setTextAlignment:NSTextAlignmentRight];
        
        subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, self.frame.size.width-40, 40)];
        [subtitleLabel setTextAlignment:NSTextAlignmentRight];
    }
    
    if ([element contrasted]) {
        [contrastingView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tappedSlideTitle:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [contrastingView addGestureRecognizer:tapGestureRecognizer];
    [contrastingView setUserInteractionEnabled:YES];
    [contrastingView setTag:index];
    [view setUserInteractionEnabled:YES];
    [view addSubview:contrastingView];
    
    [titleLabel setMinimumScaleFactor:0.5];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [titleLabel setFont:[LookAndFeel defaultFontBoldWithSize:15]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:element.title];
    titleLabel.layer.shadowOffset = CGSizeMake(3, 3);
    titleLabel.layer.shadowRadius = 3;
    titleLabel.layer.shadowOpacity = 0.4;
    titleLabel.layer.shouldRasterize = YES;
    [view addSubview:titleLabel];
    
    [subtitleLabel setMinimumScaleFactor:0.3];
    [subtitleLabel setFont:[LookAndFeel defaultFontBookWithSize:13]];
    [subtitleLabel setTextColor:[UIColor whiteColor]];
    [subtitleLabel setText:element.subtitle];
    subtitleLabel.layer.shadowOffset = CGSizeMake(3, 3);
    subtitleLabel.layer.shadowRadius = 3;
    subtitleLabel.layer.shadowOpacity = 0.4;
    subtitleLabel.layer.shouldRasterize = YES;
    [view addSubview:subtitleLabel];
}


- (void) drawMainSlideWithTitle:(NSString*)title
                   withSubtitle:(NSString*)subtitle
                   withIconName:(NSString *)iconName
        withContrastViewEnabled:(BOOL)contrasted
              andBackgroundView:(UIView *)view
{
    if (contrasted) {
        UIView *topGradient = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-90, self.frame.size.width, 50)];
        //[topGradient setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient-bg.png"]]];
        [topGradient setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
        [view addSubview:topGradient];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackground:)];
    [tapGesture setNumberOfTapsRequired:1];
    [view addGestureRecognizer:tapGesture];
    [view setUserInteractionEnabled:YES];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height-95, self.frame.size.width-40, 40)];
    [titleLabel setMinimumScaleFactor:0.5];
    [titleLabel setFont:[LookAndFeel defaultFontBoldWithSize:19]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.layer.shadowOffset = CGSizeMake(3, 3);
    titleLabel.layer.shadowRadius = 3;
    titleLabel.layer.shadowOpacity = 0.4;
    titleLabel.layer.shouldRasterize = YES;
    [view addSubview:titleLabel];
    
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height-75, self.frame.size.width-40, 40)];
    [subtitleLabel setMinimumScaleFactor:0.3];
    [subtitleLabel setFont:[LookAndFeel defaultFontLightWithSize:15]];
    [subtitleLabel setTextColor:[UIColor whiteColor]];
    [subtitleLabel setText:subtitle];
    [subtitleLabel setTextAlignment:NSTextAlignmentCenter];
    subtitleLabel.layer.shadowOffset = CGSizeMake(3, 3);
    subtitleLabel.layer.shadowRadius = 3;
    subtitleLabel.layer.shadowOpacity = 0.4;
    subtitleLabel.layer.shouldRasterize = YES;
    [view addSubview:subtitleLabel];
    
    UIImageView *poiIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    [poiIcon setTag:99];
    [poiIcon setFrame:CGRectMake(self.frame.size.width/2-80/2, self.frame.size.height-170, 80, 80)];
    [view addSubview:poiIcon];
}

- (void) tappedSlideTitle:(id)sender
{
    [[POIDetailsManager current] openLinkForSlideElementAtIndex:[[sender view] tag]];
}

- (void) tappedBackground:(id) sender
{
    UIView * view = [[sender view] viewWithTag:99];
    [UIView animateWithDuration:0.3 animations:^{
        if ([view alpha] == 1) {
            [view setAlpha:0];
        } else {
            [view setAlpha:1];
        }
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
}

@end
