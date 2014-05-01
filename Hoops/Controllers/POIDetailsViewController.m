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
    
    _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_poi.mainPic]];
    [_headImageView setClipsToBounds:YES];
    [_headImageView setFrame:CGRectMake(0, 0, kCardWidth, _headImageView.frame.size.height)];
    [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:_headImageView];
}



@end
