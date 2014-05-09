//
//  POIDetailsViewController.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/8/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "POIDetailsViewController.h"

@interface POIDetailsViewController ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation POIDetailsViewController

- (id) initWithTripPoi:(Poi *)poi
{
    self = [super init];
    
    if (self) {
        [self setPoi:poi];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resizeMainView];
    
    if ([_poi isAMuseum]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [_scrollView setBounces:YES];
        [_scrollView setScrollEnabled:YES];
        [_scrollView setUserInteractionEnabled:YES];
        [_scrollView setShowsHorizontalScrollIndicator:YES];
        
        int xPositionIncrement = self.view.frame.size.width;
        NSArray *items = @[@"peon.jpg", @"radio-pic.jpg"];
        
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx*xPositionIncrement, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [imageView setImage:[UIImage imageNamed:obj]];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [_scrollView addSubview:imageView];
            [imageView.layer setMasksToBounds:YES];
            
        }];
        
        [_scrollView setContentSize:CGSizeMake(8000, self.view.frame.size.height)];
        [_scrollView.layer setMasksToBounds:YES];

        [self.view addSubview:_scrollView];
    } else {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_poi.mainPic]];
        [_headImageView setClipsToBounds:YES];
        [_headImageView setFrame:CGRectMake(0, 0, kCardWidth, _headImageView.frame.size.height)];
        [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.view addSubview:_headImageView];
    }
    [self.view setUserInteractionEnabled:YES];
}



@end
