//
//  TripShowcaseViewController.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/26/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "TripShowcaseViewController.h"

@interface TripShowcaseViewController ()
    @property (nonatomic, strong) NSArray *items;
    @property (nonatomic, assign) Trip *currentItem;

- (void) jumpToFirstPage;
- (void) jumpToLandingPage;
@end

@implementation TripShowcaseViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.items = [Trip loadAll];
    }
    return self;
}


- (void)dealloc
{
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //configure carousel
    _carousel.type = iCarouselTypeCoverFlow2;
    _carousel.pagingEnabled = YES;
    
    // Add gestures for logo-icon
    [self.logoView setHidden:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToLandingPage)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.logoView setUserInteractionEnabled:YES];
    [self.logoView addGestureRecognizer:tapGesture];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void) jumpToFirstPage
{
    [self.carousel setCurrentItemIndex:1];
}

- (void) jumpToLandingPage
{
    [self.carousel setCurrentItemIndex:0];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    Trip *trip = [_items objectAtIndex:(int) index];
    if ([trip isLandingView]) {
        LandingView *landingView = [[[NSBundle mainBundle] loadNibNamed:@"LandingView" owner:self options:nil] objectAtIndex:0];
        [landingView stylizeView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToFirstPage)];
        [tapGesture setNumberOfTapsRequired:1];
        [landingView.nextIconView addGestureRecognizer:tapGesture];
        [landingView.nextIconView setUserInteractionEnabled:YES];
        
        return landingView;
    } else {
        TripCardView *cardView = [[[NSBundle mainBundle] loadNibNamed:@"TripCardView" owner:self options:nil] objectAtIndex:0];
        
        [[cardView mainImage] setImage:[UIImage imageNamed:trip.mainPic]];
        [[cardView tripNameLabel] setText:trip.title];
        [[cardView tripComplexityLabel] setText:NSLocalizedString([trip complexity], nil)];
        [[cardView tripDistanceLabel] setText:[trip distance]];

        [cardView stylize];

        // Show sponsored pois (can be any of listed or unlisted)
        [cardView buildPoiFragmentsFor:trip.allPois];
        
        if ([trip isAvailable]) {
            [[cardView ribbonImage] setImage:[UIImage imageNamed:@"new-ribbon.png"]];
        } else {
            [[cardView ribbonImage] setImage:[UIImage imageNamed:@"soon-ribbon.png"]];
        }
        
        return cardView;
    }
}

- (void) carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    Trip *trip = [_items objectAtIndex:(int) index];
    
    if ([trip isAvailable] && ![trip isLandingView]) {
        TripViewController *tripController = [[TripViewController alloc] initWithTrip:trip];
        
        [UIView
         animateWithDuration:0.3
         animations:^{
             CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);;
             [carousel currentItemView].transform = transform;
             [self.view setAlpha:0];
         } completion:^(BOOL finished) {
             [self presentViewController:tripController animated:NO completion:nil];
         }];
    }

}

- (void) carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    // Hide landing view when user is not on it
    if ([carousel currentItemIndex] == 1) {
        [UIView animateWithDuration:1 animations:^{
            [[carousel itemViewAtIndex:0] setAlpha:0];
        } completion:nil];
    } else if([carousel currentItemIndex] == 0) {
        [UIView animateWithDuration:1 animations:^{
            [[carousel currentItemView] setAlpha:1];
        } completion:nil];
    }
    
    // Hide top logo when user is on landing page
    if ([carousel currentItemIndex] == 0) {
        [self.logoView setHidden:YES];
    } else {
        [self.logoView setHidden:NO];
    }
    
    Trip *trip = [_items objectAtIndex:(int) [carousel currentItemIndex]];
    
    if (self.currentItem == trip) {
        return;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.background setAlpha:0.4];
    } completion:^(BOOL finished) {
        @synchronized(self.background) {
            [self.background setImage:[UIImage imageNamed:trip.background]];
        }
        [UIView animateWithDuration:1 animations:^{
            [self.background setAlpha:1];
        } completion:nil];
    }];
    
    self.currentItem = trip;
}


- (void) carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    Trip *trip = [_items objectAtIndex:(int) [carousel currentItemIndex]];
    [self.background setImage:[UIImage imageNamed:trip.background]];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.5f;
    }
    return value;
}


@end
