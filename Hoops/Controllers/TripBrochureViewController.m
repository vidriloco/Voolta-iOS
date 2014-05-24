//
//  TripBrochureViewController.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/10/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "TripBrochureViewController.h"
#import "TripViewController.h"

@interface TripBrochureViewController ()

@property (nonatomic, assign) float lastScrollPositionY;
@property (nonatomic, strong) UIButton *centerBottomButton;
@property (nonatomic, strong) NSArray *sectionsOnTable;
@property (nonatomic, strong) ContentBuilder *contentBuilder;
@property (nonatomic, strong) UIView *container;

- (void) buildTitleElementView;
- (void) buildPhotoElementView;
- (void) buildBrochureElementsDefinedByTrip;

- (void) dismissViewController;

- (void) drawNextContentElement;

@end

@implementation TripBrochureViewController

static TripBrochureViewController* instance;

+ (TripBrochureViewController*) instance
{
    return instance;
}

+ (id) buildNew {
    instance = [[TripBrochureViewController alloc] init];
    return instance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setClipsToBounds:YES];
    
    _lastScrollPositionY = 0;

    [self buildPhotoElementView];
    [self buildBrochureElementsDefinedByTrip];
    [self buildTitleElementView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        [_centerBottomButton setAlpha:1];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma Other decorators

- (void) buildTitleElementView
{
    // The title on the pleca element which is visible at a certain Y scroll-offset
    _titleContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopYOffset, [App viewBounds].size.width, 60)];
    [_titleContainerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, [App viewBounds].size.width-40, 40)];
    [titleLabel setText:_currentTrip.title];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setFont:[LookAndFeel defaultFontBoldWithSize:19]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setMinimumScaleFactor:0.5];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_titleContainerView addSubview:titleLabel];
    
    // The hidden-pleca view which gets visible past a defined Y scroll-offset
    UIView *plecaView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleContainerView.frame.size.height-0.5, [App viewBounds].size.width, 0.5)];
    [plecaView setBackgroundColor:[LookAndFeel orangeColor]];
    [plecaView setAlpha:0.4];
    [_titleContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_titleContainerView.layer setShadowOffset:CGSizeMake(1, 2)];
    [_titleContainerView.layer setShadowOpacity:0.1];
    
    [_titleContainerView addSubview:plecaView];
    [_titleContainerView setHidden:YES];
    
    // The control container view with the top bottom for returning to the previous view-controller (the map)
    UIView *controlContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [App viewBounds].size.width, kTopYOffset)];
    [controlContainerView setBackgroundColor:[UIColor whiteColor]];
    
    _centerBottomButton = [[UIButton alloc] initWithFrame:CGRectMake(controlContainerView.frame.size.width/2-25, 30, 50, 50)];
    [_centerBottomButton setBackgroundImage:[UIImage imageNamed:@"logo-map.png"] forState:UIControlStateNormal];
    [_centerBottomButton setAlpha:0];
    [_centerBottomButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [controlContainerView addSubview:_centerBottomButton];
    
    [self.view addSubview:_titleContainerView];
    [self.view addSubview:controlContainerView];
}

- (void) buildPhotoElementView
{
    // The route main pic
    _mainImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:[_currentTrip mainPic]]]];
    [_mainImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_mainImageView setClipsToBounds:YES];
    [_mainImageView setFrame:CGRectMake(0, kTopYOffset, [App viewBounds].size.width, 280)];
    [self.view addSubview:_mainImageView];
    
    // The route title infront of the image view
    UILabel *tripNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, _mainImageView.frame.size.height/2-50, [App viewBounds].size.width-60, 100)];
    [tripNameLabel setTextColor:[UIColor whiteColor]];
    [tripNameLabel setFont:[LookAndFeel defaultFontBoldWithSize:23]];
    [[tripNameLabel layer] setShadowOffset:CGSizeMake(3, 4)];
    [[tripNameLabel layer] setShadowOpacity:0.8];
    [[tripNameLabel layer] setShadowColor:[UIColor blackColor].CGColor];
    [tripNameLabel setNumberOfLines:2];
    [tripNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [tripNameLabel setText:_currentTrip.title];
    [tripNameLabel setTextAlignment:NSTextAlignmentCenter];
    [_mainImageView addSubview:tripNameLabel];
    
    // This element contains the basic information about a route such as distance and complexity
    TripKeyDetailsView *tripDetails = [[[NSBundle mainBundle]
                                        loadNibNamed:@"TripKeyDetailsView" owner:self options:nil] objectAtIndex:0];
    [tripDetails setFrame:CGRectMake([App viewBounds].size.width/2-tripDetails.frame.size.width/2+10, tripNameLabel.frame.origin.y+tripNameLabel.frame.size.height-10, tripDetails.frame.size.width, tripDetails.frame.size.height)];
    [tripDetails stylize];
    
    [[tripDetails leftLabel] setText:_currentTrip.distance];
    [[tripDetails rightLabel] setText:NSLocalizedString(_currentTrip.complexity, nil)];
    
    [_mainImageView addSubview:tripDetails];
}

- (void) buildBrochureElementsDefinedByTrip
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopYOffset, [App viewBounds].size.width, [App viewBounds].size.height-kTopYOffset)];
    [_scrollView setContentInset:UIEdgeInsetsMake(_mainImageView.frame.size.height, 0, 0, 0)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    
    // The container of all the elements defined by trip
    _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [App viewBounds].size.width, 0)];
    [_container setBackgroundColor:[UIColor whiteColor]];

    CGPoint offset = CGPointMake(0, 20);
    _contentBuilder = [[ContentBuilder alloc] initWithDelegate:self withOffset:offset];
    
    [self drawNextContentElement];

    [_scrollView addSubview:_container];
    [_scrollView setDelegate:self];
    
    [self.view addSubview:_scrollView];
}

- (void) userTappedOnTripStart
{
    [(TripViewController*) self.presentingViewController centerMapOnTripStart];
    [self dismissViewController];
}

- (void) userTappedOnTripEnd {
    [(TripViewController*) self.presentingViewController centerMapOnTripFinal];
    [self dismissViewController];
}

- (void) contentBuilderFinishedAddingElementToView
{
    [self drawNextContentElement];
}

- (void) drawNextContentElement {
    if ([_currentTrip.brochureList count] == 0) {
        return;
    }
    
    if (_contentBuilder.contentElementIdx > [_currentTrip.brochureList count]-1) {
        [_container setFrame:CGRectMake(_container.frame.origin.x,
                                        _container.frame.origin.y,
                                        _container.frame.size.width,
                                        _contentBuilder.lastOffset.y)];
        [_scrollView setContentSize:CGSizeMake([App viewBounds].size.width, _contentBuilder.lastOffset.y)];
    } else {
        BrochureElement *element = [_currentTrip.brochureList objectAtIndex:_contentBuilder.contentElementIdx];
        
        if ([element isPOITable]) {
            CGPoint lastPoint = [_contentBuilder lastOffset];
            UILabel *blockSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, lastPoint.y-20, [App viewBounds].size.width-40, 70)];
            [blockSectionLabel setFont:[LookAndFeel defaultFontBoldWithSize:15]];
            [blockSectionLabel setTextColor:[UIColor grayColor]];
            [blockSectionLabel setText:NSLocalizedString(@"trip_pois", nil)];
            [_container addSubview:blockSectionLabel];
            
            // Building the POI table list
            _sectionsOnTable = [[_currentTrip categorizedPois] allKeys];
            
            float tableHeight = [_currentTrip numberOfPOIsListed] * kTableRowHeight;
            tableHeight+= [[_currentTrip.categorizedPois allKeys] count] * kTableSectionHeight;
            UITableView *blockTableView = [[UITableView alloc] initWithFrame:
                                           CGRectMake(30,
                                                      blockSectionLabel.frame.origin.y+blockSectionLabel.frame.size.height+10,
                                                      [App viewBounds].size.width-60, tableHeight)];
            
            [blockTableView setSeparatorColor:[UIColor clearColor]];
            [blockTableView setDelegate:self];
            [blockTableView setDataSource:self];
            [blockTableView setBounces:NO];
            [blockTableView setScrollEnabled:YES];
            [blockTableView setSeparatorInset:UIEdgeInsetsZero];
            
            [blockTableView registerNib:[UINib nibWithNibName:@"POITableHeaderView" bundle:nil]
     forHeaderFooterViewReuseIdentifier:kHeaderIdentifier];
            [blockTableView registerNib:[UINib nibWithNibName:@"POITableViewCell" bundle:nil]
                 forCellReuseIdentifier:kCellViewIdentifier];
            
            [_container addSubview:blockTableView];
            [_contentBuilder setLastOffset:CGPointMake(_contentBuilder.lastOffset.x, blockTableView.frame.size.height+blockTableView.frame.origin.y)];
            [_contentBuilder setContentElementIdx:_contentBuilder.contentElementIdx+1];
            [self contentBuilderFinishedAddingElementToView];
        } else {
            [_contentBuilder buildContentForElement:element onContainer:_container];
        }
    }
}

#pragma ScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    float increment = 0;
    if (self.lastScrollPositionY != 0) {
        increment = (self.lastScrollPositionY-scrollView.contentOffset.y)/2;
    }
    
    self.lastScrollPositionY = scrollView.contentOffset.y;
    [_mainImageView setFrame:CGRectMake(0, [_mainImageView frame].origin.y+increment, [_mainImageView frame].size.width, [_mainImageView frame].size.height)];
    [self.view sendSubviewToBack:_mainImageView];
    
    if ((self.lastScrollPositionY > -65 && [_titleContainerView isHidden])) {
        [_titleContainerView setHidden:NO];
    } else if(self.lastScrollPositionY < -65 && ![_titleContainerView isHidden]) {
        [_titleContainerView setHidden:YES];
    }
}

#pragma TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionsOnTable count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Will only show listed POIs on a trip
    NSString *sectionKey = [_sectionsOnTable objectAtIndex:section];
    return [[_currentTrip.categorizedPois objectForKey:sectionKey] count];
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionName = [_sectionsOnTable objectAtIndex:section];
    POITableHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderIdentifier];
    [header stylize];
    
    Poi *poi = [[_currentTrip.categorizedPois objectForKey:sectionName] objectAtIndex:0];
    [[header imageView] setImage:[UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:poi.kindImage]]];
    [[header sectionLabel] setText:sectionName];
    return header;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    POITableViewCell *poiViewCell = [tableView dequeueReusableCellWithIdentifier:kCellViewIdentifier];
    NSString *sectionKey = [_sectionsOnTable objectAtIndex:[indexPath section]];
    
    Poi *poi = [[_currentTrip.categorizedPois objectForKey:sectionKey] objectAtIndex:[indexPath row]];
    
    UIImage *img = [UIImage imageWithContentsOfFile:[OperationHelpers filePathForImage:poi.mainPic]];
    [[poiViewCell imageBackground] setImage:img];
    [[poiViewCell titleLabel] setText:poi.theTitle];
    if ([poi isSlideBased]) {
        [[poiViewCell subtitleLabel] setText:poi.details];
    } else {
        [[poiViewCell subtitleLabel] setText:poi.localizedCategory];
    }
    [poiViewCell stylize];

    return (UITableViewCell*) poiViewCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionKey = [_sectionsOnTable objectAtIndex:[indexPath section]];
    Poi *poi = [[_currentTrip.categorizedPois objectForKey:sectionKey] objectAtIndex:[indexPath row]];
    [(TripViewController*) self.presentingViewController centerMapOnPoi:poi];
    [self dismissViewController];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableRowHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableSectionHeight;
}

@end
