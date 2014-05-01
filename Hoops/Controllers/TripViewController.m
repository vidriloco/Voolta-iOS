//
//  TripViewController.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/24/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "TripViewController.h"
#import "TripShowcaseViewController.h"

@interface TripViewController ()
- (void) dismissController;

- (void) onLogoClicked;
- (void) onLeftButtonClicked;
- (void) onRightButtonClicked;

- (void) loadBottomControls;
- (void) loadTopControls;

- (void) loadMenuControlsView;
- (void) drawTripMarkers;

- (void) switchCameraFollowPositionMode;
- (void) presentCustomPopupViewController:(UIViewController*)controller;

typedef NS_ENUM(NSInteger, FollowMode) {FollowLocation, FollowHeading, FollowNone};
typedef NS_ENUM(NSInteger, MapControlsMode) {ControlsShown, ControlsHidden};

@property (nonatomic, assign) MapControlsMode currentMapControlsMode;

@property (nonatomic, assign) FollowMode currentFollowMode;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *lastLocation;

// Top controls
@property (nonatomic, strong) UIButton *centerTopButton;
@property (nonatomic, strong) UIButton *closeButton;

// Bottom controls
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *centerBottomButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) GMSMarker *markerCenter;

@property (nonatomic, assign) int currentPoiIndex;

@end

@implementation TripViewController

- (id) initWithTrip:(Trip *)trip
{
    self = [super init];
    if (self) {
        self.currentTrip = trip;
        self.currentFollowMode = FollowNone;
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentTrip.originCoordinate.latitude
                                                            longitude:self.currentTrip.originCoordinate.longitude
                                                                 zoom:self.currentTrip.startZoom];

    // Loading map
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [_mapView setDelegate:self];
    self.view = _mapView;

    _markerCenter = [[GMSMarker alloc] init];
    [_markerCenter setIcon: [UIImage imageNamed:@"my-location.png"]];
    
    // Loading location manager
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [self.locationManager startUpdatingHeading];
    [self.locationManager startUpdatingLocation];
    
    // Loading trip paths
    for(Path *path in self.currentTrip.paths) {
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path.coordinateList];
        polyline.strokeColor = [UIColor colorWithHexString:path.color];
        polyline.strokeWidth = path.thickness;
        polyline.geodesic = YES;
        [polyline setMap:_mapView];
    }
    
    [self loadTopControls];
    [self loadBottomControls];
    [self drawTripMarkers];
    [self centerMapOnTripStart];

}



- (void) loadTopControls
{
    _centerTopButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width/2-25, 30, 50, 50)];
    [_centerTopButton setBackgroundImage:[UIImage imageNamed:@"logo-map.png"] forState:UIControlStateNormal];
    [_centerTopButton setAlpha:0];
    [self.view addSubview:_centerTopButton];
    [_centerTopButton addTarget:self action:@selector(onLogoClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:1 animations:^{
        [_centerTopButton setAlpha:0.6];
    }];
}

- (void) loadBottomControls
{
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width-55, [App viewBounds].size.height-55, 45, 45)];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"compass-disabled-icon.png"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(switchCameraFollowPositionMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightButton];
    
    _centerBottomButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width/2-25, [App viewBounds].size.height-70, 50, 50)];
    [_centerBottomButton setBackgroundImage:[UIImage imageNamed:@"panflet-icon.png"] forState:UIControlStateNormal];
    [_centerBottomButton setAlpha:0];
    [self.view addSubview:_centerBottomButton];
    [_centerBottomButton addTarget:self action:@selector(onLeftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:1 animations:^{
        [_centerBottomButton setAlpha:0.6];
    }];
    
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake([App viewBounds].size.width/2-25, [App viewBounds].size.height-90, 50, 50)];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"close-icon.png"] forState:UIControlStateNormal];
    [_closeButton setAlpha:0.5];
    [_closeButton setHidden:YES];
    [_closeButton addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_closeButton];
}

- (void) loadMenuControlsView
{
    _menuView = [[UIView alloc] initWithFrame:CGRectMake(30, [App viewBounds].size.height-80, [App viewBounds].size.width-60, 60)];
    [_menuView setBackgroundColor:[UIColor whiteColor]];
    [_menuView.layer setShadowOpacity:0.4];
    [_menuView.layer setShadowRadius:3];
    [_menuView.layer setShadowOffset:CGSizeMake(-1, 2)];
    [_menuView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_menuView.layer setCornerRadius:3];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, _menuView.frame.size.width-20, 30)];
    [label setText:_currentTrip.title];
    [label setMinimumScaleFactor:0.7f];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setFont:[LookAndFeel defaultFontBoldWithSize:16]];
    [_menuView addSubview:label];
    
    UIButton *nextIcon = [[UIButton alloc] initWithFrame:CGRectMake(_menuView.frame.size.width-7, 0, 7, _menuView.frame.size.height)];
    [nextIcon setBackgroundColor:[LookAndFeel blueColor]];
    [_menuView addSubview:nextIcon];
    
    UIButton *prevIcon = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 7, _menuView.frame.size.height)];
    [prevIcon setBackgroundColor:[LookAndFeel orangeColor]];
    [_menuView addSubview:prevIcon];
    
    [_menuView.layer setMasksToBounds:YES];
    
    [self.view addSubview:_menuView];
    
}

- (void) switchCameraFollowPositionMode
{
    if (_currentFollowMode == FollowNone) {
        _currentFollowMode = FollowLocation;
        [_locationManager startUpdatingLocation];
        [_locationManager startUpdatingHeading];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"compass-icon.png"] forState:UIControlStateNormal];
    } else if (_currentFollowMode == FollowLocation) {
        _currentFollowMode = FollowHeading;
        [_mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:_lastLocation.coordinate.latitude
                                                                      longitude:_lastLocation.coordinate.longitude
                                                                           zoom:defaultZoomInLevel bearing:0 viewingAngle:45]];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"compass-3d-icon.png"] forState:UIControlStateNormal];
    } else {
        _currentFollowMode = FollowNone;
        [_mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:_lastLocation.coordinate.latitude
                                                                      longitude:_lastLocation.coordinate.longitude
                                                                           zoom:defaultZoomOutLevel bearing:0 viewingAngle:0]];

        [_rightButton setBackgroundImage:[UIImage imageNamed:@"compass-disabled-icon.png"] forState:UIControlStateNormal];
    }
    
    if (_currentFollowMode != FollowNone) {
        [_markerCenter setMap:_mapView];
    } else {
        [_markerCenter setMap:nil];
    }
}

- (void) onLogoClicked
{
    [self dismissController];
}

- (void) onLeftButtonClicked
{
    TripBrochureViewController *brochureViewController = [TripBrochureViewController instance];
    
    if (brochureViewController == nil) {
        brochureViewController = [TripBrochureViewController buildNew];
    }
    
    [brochureViewController setCurrentTrip:_currentTrip];
    [self presentViewController:brochureViewController animated:YES completion:nil];
}

- (void) onRightButtonClicked
{
    
}

- (void) presentCustomPopupViewController:(UIViewController*)controller
{
    [_centerBottomButton setHidden:YES];
    [_rightButton setHidden:YES];
    [_centerTopButton setHidden:YES];
    [_closeButton setHidden:NO];
    
    [self presentPopupViewController:controller
                       animationType:MJPopupViewAnimationSlideBottomBottom dismissed:^{
                           
                           [_centerBottomButton setHidden:NO];
                           [_rightButton setHidden:NO];
                           [_centerTopButton setHidden:NO];
                           [_closeButton setHidden:YES];
    }];
}

- (void) dismissController {
    UIViewController *sourceViewController = self;
    TripShowcaseViewController *destinationViewController = (TripShowcaseViewController*) self.presentingViewController;
    
    // Add view to super view temporarily
    [sourceViewController.view.superview insertSubview:destinationViewController.view atIndex:0];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);;
                         self.view.transform = transform;
                         
                         CGAffineTransform unwindBackControllerTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);;
                         [[destinationViewController carousel] currentItemView].transform = unwindBackControllerTransform;
                         [self.view setAlpha:0];
                         [self.presentingViewController.view setAlpha:1];
                     }
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview]; // remove from temp super view
                         [sourceViewController dismissViewControllerAnimated:NO completion:NULL]; // dismiss VC
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawTripMarkers
{
    // First, draw origin marker
    GMSMarker *startMarker = [[GMSMarker alloc] init];
    startMarker.position = [_currentTrip originCoordinate];
    startMarker.icon = [UIImage imageNamed:@"start_flag-icon.png"];
    [startMarker setMap:_mapView];
    
    for (NSString *key in [_currentTrip.pois allKeys]) {
        for (Poi *poi in [_currentTrip.pois objectForKey:key]) {
            [poi setMap:_mapView];
        }
    }
    
    
    
    // Finally, draw final marker
    GMSMarker *finalMarker = [[GMSMarker alloc] init];
    finalMarker.position = [_currentTrip endCoordinate];
    finalMarker.icon = [UIImage imageNamed:@"final_flag-icon.png"];
    [finalMarker setMap:_mapView];
    
    for (DirectionMarker *directionMarker in _currentTrip.directionMarkers) {
        directionMarker.icon = [UIImage imageNamed:@"direction-marker.png"];
        [directionMarker setMap:_mapView];
    }
}

#pragma GMSMapDelegate

- (void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (_currentMapControlsMode == ControlsShown) {
        _currentMapControlsMode = ControlsHidden;
        [_centerBottomButton setHidden:YES];
        [_centerTopButton setHidden:YES];
    } else {
        _currentMapControlsMode = ControlsShown;
        [_centerBottomButton setHidden:NO];
        [_centerTopButton setHidden:NO];
    }
}

- (BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    for (GMSMarker *currentMarker in _currentTrip.allPois) {
        if (currentMarker == marker) {
            POIDetailsViewController *detailsViewController = [[POIDetailsViewController alloc] initWithTripPoi:(Poi*) currentMarker];
            [self presentCustomPopupViewController:detailsViewController];
        }
    }
    return NO;
}


#pragma TripLocationsDelegate

- (void) centerMapOnTripStart
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        [_mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:[_currentTrip originCoordinate].latitude
                                                                      longitude:[_currentTrip originCoordinate].longitude
                                                                           zoom:defaultZoomInLevel]];
    });
}

- (void) centerMapOnTripFinal
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        [_mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:[_currentTrip endCoordinate].latitude
                                                                      longitude:[_currentTrip endCoordinate].longitude
                                                                           zoom:defaultZoomInLevel]];
    });
}

- (Trip*) currentTrip
{
    return _currentTrip;
}

#pragma LocationDelegate methods

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (_currentFollowMode == FollowHeading) {
        [_mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:_lastLocation.coordinate.latitude
                                                                      longitude:_lastLocation.coordinate.longitude
                                                                           zoom:defaultZoomInLevel bearing:newHeading.trueHeading viewingAngle:45]];
        [_markerCenter setPosition:_lastLocation.coordinate];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _lastLocation = [locations firstObject];
    if (_currentFollowMode == FollowLocation) {
        [_mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:_lastLocation.coordinate.latitude
                                                                      longitude:_lastLocation.coordinate.longitude
                                                                           zoom:defaultZoomOutLevel]];
        [_markerCenter setPosition:_lastLocation.coordinate];
    }
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}

@end
