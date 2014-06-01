//
//  POIDetailsManager.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/6/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "POIDetailsManager.h"
#import "TripViewController.h"

@interface POIDetailsManager ()

@property (nonatomic, strong) TripViewController *associatedController;
@property (nonatomic, strong) POIDetailsView *currentDetailsView;
@property (nonatomic, strong) Poi* activePoi;

@end

@implementation POIDetailsManager

static POIDetailsManager *local;

+ (POIDetailsManager*) current
{
    return local;
}

+ (POIDetailsManager*) newWithController:(TripViewController*) controller
{
    local = [[POIDetailsManager alloc] init];
    local.associatedController = controller;
    return local;
}

- (void) showDetailsViewForPoi:(Poi*)poi
{
    [_associatedController toggleMapControlsOff:YES];
    [_associatedController toggleMapCompass];
    _currentDetailsView =  [[POIDetailsView alloc] initWithPoi:poi];
    
    [_associatedController.view addSubview:_currentDetailsView];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDetailsView)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [[_currentDetailsView backgroundView]  addGestureRecognizer:tapRecognizer];
    _activePoi = poi;
    
    [Analytics registerActionWithString:@"POI details show"
                         withProperties:@{@"poi": [_activePoi theTitle], @"date": [NSDate date] }];
}

- (void) hideDetailsView
{
    [Analytics registerActionWithString:@"POI details hide"
                         withProperties:@{@"poi": [_activePoi theTitle], @"date": [NSDate date] }];
    if (_currentDetailsView != nil) {
        [_currentDetailsView removeFromSuperview];
        _currentDetailsView = nil;
    }
    [_associatedController toggleMapControlsOff:NO];
    [_associatedController toggleMapCompass];
    _activePoi = nil;
}

- (void) openLinkForSlideElementAtIndex:(NSUInteger)index
{
    SlideElement *slideElement = [[_activePoi slideElements] objectAtIndex:index];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:slideElement.url]];
    [Analytics registerActionWithString:@"Open POI url"
                         withProperties:@{@"poi": [_activePoi theTitle], @"date": [NSDate date] }];
}

@end
