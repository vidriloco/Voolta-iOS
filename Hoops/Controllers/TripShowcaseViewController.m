//
//  TripShowcaseViewController.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/26/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "TripShowcaseViewController.h"

@interface TripShowcaseViewController ()
@property (nonatomic, strong) NSArray* slides;
@property (nonatomic, strong) LandingScreen *landingScreen;
@property (nonatomic, assign) BOOL finishedLoading;

- (void) jumpToFirstPage;
- (void) jumpToLandingPage;
- (void) animateBackgroundTransition;

- (void) showInfoView;

@end

@implementation TripShowcaseViewController


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _landingScreen = [[LandingScreen alloc] init];
        _slides = [NSArray arrayWithObject:_landingScreen];
        
        UIColor *backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
        
        [self.background setBackgroundColor:backgroundColor];
        [self.view setBackgroundColor:backgroundColor];
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
    [_carousel setCenterItemWhenSelected:NO];
    
    // Add gestures for logo-icon
    [self.logoView setHidden:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToLandingPage)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.logoView setUserInteractionEnabled:YES];
    [self.logoView addGestureRecognizer:tapGesture];
    
    if (![App hasShownHowTo]) {
        [App markHowToAsShown];
        [self showInfoView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void) jumpToFirstPage
{
    [self.carousel setCurrentItemIndex:1];
    [self animateBackgroundTransition];
}

- (void) jumpToLandingPage
{
    [self.carousel setCurrentItemIndex:0];
    [self animateBackgroundTransition];
}

- (void) showInfoView
{
    AppInfoView *infoView = [[AppInfoView alloc] initSimple];
    [self.view addSubview:infoView];
    [infoView show];
}

#pragma DataDelegate methods

- (void) finishedFetchingTrip
{
    NSLog(@"Finished with trip");
    NSMutableArray *array = [NSMutableArray arrayWithObject:_landingScreen];
    [array addObjectsFromArray:[DataStore current].trips];
    _slides = array;
    
    NSArray *inventoryList = [[[TripOnInventory lazyFetcher] whereField:@"lang" equalToValue:[App currentLang]] fetchRecords];
    _finishedLoading = [inventoryList count] == [_slides count]-1;
    [self.carousel reloadData];
}

- (void) startedFetchingTrip
{
    NSLog(@"Fetching trip");
}

- (void) startedLoadingTrip
{
    NSLog(@"Loading trip");
}

- (void) prunePhaseCompleted
{
    NSLog(@"PRUNE finished");
}

- (void) imageLoadingPhaseCompleted
{
    NSLog(@"LOADING images done");
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_slides count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if ([[_slides objectAtIndex:(int) index] isKindOfClass:[Trip class]]) {
        Trip *trip = [_slides objectAtIndex:(int) index];

        TripCardView *cardView = [[[NSBundle mainBundle] loadNibNamed:@"TripCardView" owner:self options:nil] objectAtIndex:0];

        [[cardView mainImage] setImage:[UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:trip.mainPic]]];
        [[cardView tripNameLabel] setText:trip.title];
        [[cardView tripComplexityLabel] setText:[trip complexity]];
        [[cardView tripDistanceLabel] setText:[trip distance]];
        [ContentBuilder setText:[trip details] withNSAlignment:NSTextAlignmentJustified onLabel:[cardView tripDetailsTextView]];
        
        [cardView stylize];
        
        // Show sponsored pois (can be any of listed or unlisted)
        [cardView buildPoiFragmentsFor:trip.allPois];
        
        if ([trip isAvailable]) {
            [[cardView ribbonImage] setImage:[UIImage imageNamed:@"new-ribbon.png"]];
        } else {
            [[cardView ribbonImage] setImage:[UIImage imageNamed:@"soon-ribbon.png"]];
        }
        
        return cardView;
    } else {
        LandingView *landingView = [[[NSBundle mainBundle] loadNibNamed:@"LandingView" owner:self options:nil] objectAtIndex:0];
        [landingView stylizeView];
        
        [[landingView nextIconView] addTarget:self action:@selector(jumpToFirstPage) forControlEvents:UIControlEventTouchUpInside];
        [landingView.nextIconView setUserInteractionEnabled:YES];
        
        [[landingView infoIconView] addTarget:self action:@selector(showInfoView) forControlEvents:UIControlEventTouchUpInside];
        [landingView.infoIconView setUserInteractionEnabled:YES];

        if (_finishedLoading) {
            [landingView finishedLoading];
        }
        
        return landingView;
    }
}

- (void) carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    [_carousel setCurrentItemIndex:index];
    if ([[_slides objectAtIndex:(int) index] isKindOfClass:[Trip class]]) {
        Trip *trip = [_slides objectAtIndex:(int) index];
        
        if ([trip isAvailable]) {
            TripViewController *tripController = [TripViewController newWithTrip:trip];
            
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
}


- (void) carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    [self animateBackgroundTransition];
}

- (void) animateBackgroundTransition
{
    id<CarouselProtocol> carouselItem = [_slides objectAtIndex:(int) [_carousel currentItemIndex]];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:carouselItem.background]];
    
    if (image != nil && image != [self.background image]) {
        [self.background setAlpha:0.5];
        [self.background setImage:image];
        
        [UIView animateWithDuration:1 animations:^{
            [self.background setAlpha:1];
        }];
    }
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