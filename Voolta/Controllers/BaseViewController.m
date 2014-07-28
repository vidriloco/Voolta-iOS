//
//  BaseViewController.m
//  Voolta
//
//  Created by Alejandro Cruz on 7/28/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
- (void) loadShowcaseViewController;
@end

static BaseViewController *localInstance;

@implementation BaseViewController

+ (void) initializeBase
{
    if (localInstance == NULL) {
        localInstance = [[BaseViewController alloc] init];
    }
}

+ (id) instance
{
    [self initializeBase];
    return localInstance;
}

+ (void) reloadAndPresentViewController
{
    [[self instance] loadShowcaseViewController];
}

- (void) loadShowcaseViewController
{
    if (_showcaseViewController != NULL) {
        [_showcaseViewController dismissViewControllerAnimated:NO completion:nil];
    }
    _showcaseViewController = [[TripShowcaseViewController alloc] initWithNibName:nil bundle:nil];
    
    if ([DataStore current] == NULL) {
        [DataStore initializeStoreWithDelegate:_showcaseViewController];
    } else {
        [[DataStore current] setDelegate:_showcaseViewController];
        [[DataStore current] boot];
    }
    
    [self presentViewController:_showcaseViewController animated:NO completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
