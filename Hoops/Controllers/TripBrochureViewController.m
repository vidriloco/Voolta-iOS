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


- (void) buildTitleElementView;
- (void) buildPhotoElementView;
- (void) buildBrochureElementsDefinedByTrip;

- (void) dismissViewControllerToTripStart;
- (void) dismissViewControllerToTripEnd;

- (void) dismissViewController;

- (CGPoint) drawRouteControlsOnContainer:(UIView*)container
                      startingAtPosition:(CGPoint) position;

- (CGPoint) drawParagraphOnContainer:(UIView*)container
                  startingAtPosition:(CGPoint) position
                 withBrochureElement:(BrochureElement*)element;

- (CGPoint) drawLegendElementOnContainer:(UIView*)container
                      startingAtPosition:(CGPoint) position
                     withBrochureElement:(BrochureElement*)element
                         withRightSideOn:(BOOL)rightSideOn;

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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*_placesTableView.frame = (CGRect){
        _placesTableView.frame.origin,
        _placesTableView.contentSize
    };
    
    _tableHeightConstraint.constant = [_currentTrip pois].count*63;
    [_placesTableView needsUpdateConstraints];*/
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
    _mainImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_currentTrip mainPic]]];
    [_mainImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_mainImageView setClipsToBounds:YES];
    [_mainImageView setFrame:CGRectMake(0, kTopYOffset, [App viewBounds].size.width, 280)];
    [self.view addSubview:_mainImageView];
    
    // The route title infront of the image view
    UILabel *tripNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, _mainImageView.frame.size.height/2-20, [App viewBounds].size.width-60, 40)];
    [tripNameLabel setTextColor:[UIColor whiteColor]];
    [tripNameLabel setFont:[LookAndFeel defaultFontBoldWithSize:23]];
    [[tripNameLabel layer] setShadowOffset:CGSizeMake(3, 4)];
    [[tripNameLabel layer] setShadowOpacity:0.8];
    [[tripNameLabel layer] setShadowColor:[UIColor blackColor].CGColor];
    [tripNameLabel setText:_currentTrip.title];
    [tripNameLabel setTextAlignment:NSTextAlignmentCenter];
    [_mainImageView addSubview:tripNameLabel];
    
    // This element contains the basic information about a route such as distance and complexity
    TripKeyDetailsView *tripDetails = [[[NSBundle mainBundle]
                                        loadNibNamed:@"TripKeyDetailsView" owner:self options:nil] objectAtIndex:0];
    [tripDetails setFrame:CGRectMake([App viewBounds].size.width/2-tripDetails.frame.size.width/2, tripNameLabel.frame.origin.y+tripNameLabel.frame.size.height-10, tripDetails.frame.size.width, tripDetails.frame.size.height)];
    [tripDetails stylize];
    
    [[tripDetails leftLabel] setText:_currentTrip.distance];
    [[tripDetails rightLabel] setText:NSLocalizedString(_currentTrip.complexity, nil)];
    
    [_mainImageView addSubview:tripDetails];
}

- (void) buildBrochureElementsDefinedByTrip
{
    int scrollContentHeight = 0;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopYOffset, [App viewBounds].size.width, [App viewBounds].size.height-kTopYOffset)];
    [_scrollView setContentInset:UIEdgeInsetsMake(_mainImageView.frame.size.height, 0, 0, 0)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    
    // The container of all the elements defined by trip
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [App viewBounds].size.width, 0)];
    [container setBackgroundColor:[UIColor whiteColor]];
    
    // The brochure intro text
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(30, 20, [App viewBounds].size.width-60, 110)];
    [textView setFont:[LookAndFeel defaultFontLightWithSize:15]];
    [textView setTextAlignment:NSTextAlignmentCenter];
    [textView setTextColor:[UIColor grayColor]];
    [textView setText:_currentTrip.introEs];
    [textView setEditable:NO];
    [textView setScrollEnabled:NO];
    [container addSubview:textView];

    // Add route-defined brochure contents
    CGPoint lastPoint = CGPointMake(0, textView.frame.size.height+textView.frame.origin.y);
    for (BrochureElement *element in _currentTrip.brochureList) {
        if ([element isParagraph]) {
            lastPoint = [self drawParagraphOnContainer:container
                                    startingAtPosition:CGPointMake(0, lastPoint.y)
                                   withBrochureElement:element];
        } else if ([element isPlain]) {
            lastPoint = [self drawRouteControlsOnContainer:container
                                        startingAtPosition:CGPointMake(0, lastPoint.y)];
        } else if ([element isLegend]) {
            lastPoint = [self drawLegendElementOnContainer:container startingAtPosition:lastPoint
                                       withBrochureElement:element withRightSideOn:YES];
        }
    }
    
    scrollContentHeight += lastPoint.y;
    
    UILabel *blockSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, lastPoint.y-20, [App viewBounds].size.width-40, 70)];
    [blockSectionLabel setFont:[LookAndFeel defaultFontBoldWithSize:15]];
    [blockSectionLabel setTextColor:[UIColor grayColor]];
    [blockSectionLabel setText:@"Listado de servicios"];
    [container addSubview:blockSectionLabel];
    scrollContentHeight += blockSectionLabel.frame.size.height;

    UITableView *blockTableView = [[UITableView alloc] initWithFrame:
                                   CGRectMake(30,
                                              blockSectionLabel.frame.origin.y+blockSectionLabel.frame.size.height+10,
                                              [App viewBounds].size.width-60,
                                              [[[_currentTrip pois] objectForKey:@"listed"] count]*kRowHeight)];
    [blockTableView.layer setBorderWidth:1];
    [blockTableView.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.1].CGColor];
    [blockTableView.layer setCornerRadius:5];
    [blockTableView setSeparatorColor:[[UIColor grayColor] colorWithAlphaComponent:0.1]];
    [blockTableView setDelegate:self];
    [blockTableView setDataSource:self];
    [blockTableView setSeparatorInset:UIEdgeInsetsZero];
    [container addSubview:blockTableView];
    
    scrollContentHeight += blockTableView.frame.size.height+kBottomMargin;
    
    [container setFrame:CGRectMake(container.frame.origin.x,
                                   container.frame.origin.y,
                                   container.frame.size.width,
                                   scrollContentHeight)];
    [_scrollView setContentSize:CGSizeMake([App viewBounds].size.width, scrollContentHeight)];
    [_scrollView addSubview:container];
    [self.view addSubview:_scrollView];
    [_scrollView setDelegate:self];
}

- (void) dismissViewControllerToTripStart
{
    [(TripViewController*) self.presentingViewController centerMapOnTripStart];
    [self dismissViewController];
}

- (void) dismissViewControllerToTripEnd {
    [(TripViewController*) self.presentingViewController centerMapOnTripFinal];
    [self dismissViewController];
}

#pragma Brochure builders

- (CGPoint) drawRouteControlsOnContainer:(UIView*)container startingAtPosition:(CGPoint)position {
    float horizontalMargin = 40;
    // START: Load route start and route end buttons
    MainCardButton *leftCardButton = [[[NSBundle mainBundle]
                                       loadNibNamed:@"MainCardButton" owner:self options:nil] objectAtIndex:0];
    [leftCardButton setFrame:CGRectMake(horizontalMargin, position.y, leftCardButton.frame.size.width, leftCardButton.frame.size.height)];
    
    [leftCardButton addTarget:self action:@selector(dismissViewControllerToTripStart) forControlEvents:UIControlEventTouchUpInside];
    [[leftCardButton legendLabel] setText:NSLocalizedString(@"route_start", nil)];
    [[leftCardButton iconView] setImage:[UIImage imageNamed:@"flag-start-icon.png"]];
    [leftCardButton stylizeView];
    [container addSubview:leftCardButton];
    
    MainCardButton *rightCardButton = [[[NSBundle mainBundle]
                                        loadNibNamed:@"MainCardButton" owner:self options:nil] objectAtIndex:0];
    [rightCardButton setFrame:CGRectMake([App viewBounds].size.width-rightCardButton.frame.size.width-horizontalMargin, position.y, rightCardButton.frame.size.width, rightCardButton.frame.size.height)];
    
    [rightCardButton addTarget:self action:@selector(dismissViewControllerToTripEnd) forControlEvents:UIControlEventTouchUpInside];
    [[rightCardButton legendLabel] setText:NSLocalizedString(@"route_end", nil)];
    [[rightCardButton iconView] setImage:[UIImage imageNamed:@"flag-end-icon.png"]];
    [rightCardButton stylizeView];
    [container addSubview:rightCardButton];
    // END: Load route start and route end buttons
    return CGPointMake(0, rightCardButton.frame.origin.y+rightCardButton.frame.size.height);
}

- (CGPoint) drawParagraphOnContainer:(UIView*)container
                  startingAtPosition:(CGPoint) position
                 withBrochureElement:(BrochureElement *)element{
    
    UITextView *blockIntroTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 10+position.y, [App viewBounds].size.width-60, 110)];
    [blockIntroTextView setFont:[LookAndFeel defaultFontLightWithSize:15]];
    [blockIntroTextView setTextAlignment:NSTextAlignmentCenter];
    [blockIntroTextView setTextColor:[UIColor grayColor]];
    [blockIntroTextView setEditable:NO];
    [blockIntroTextView setText:element.valueAsString];
    [blockIntroTextView setScrollEnabled:NO];
    [container addSubview:blockIntroTextView];
    return CGPointMake(0, blockIntroTextView.frame.origin.y+blockIntroTextView.frame.size.height);
}

- (CGPoint) drawLegendElementOnContainer:(UIView*)container
                      startingAtPosition:(CGPoint) position
                     withBrochureElement:(BrochureElement *)element
                         withRightSideOn:(BOOL)rightSideOn {
    LegendElementView *legendElementView = [[[NSBundle mainBundle]
                                             loadNibNamed:@"LegendElementView" owner:self options:nil] objectAtIndex:0];
    [[legendElementView titleLabel] setText:element.legendTitle];
    [[legendElementView descriptionLabel] setText:element.legendDetails];
    if (rightSideOn) {
        [[legendElementView rightMainTitleLabel] setText:NSLocalizedString(element.title, nil)];
        [[legendElementView rightLegendImageView] setImage:[UIImage imageNamed:element.legendImageName]];
        [legendElementView toggleSide:UIRightSide];
    } else {
        [[legendElementView leftMainTitleLabel] setText:NSLocalizedString(element.title, nil)];
        [[legendElementView leftLegendImageView] setImage:[UIImage imageNamed:element.legendImageName]];
        [legendElementView toggleSide:UILeftSide];
    }
    
    [legendElementView stylize];
    [legendElementView setFrame:CGRectMake(12, position.y, legendElementView.frame.size.width, legendElementView.frame.size.height)];
    [container addSubview:legendElementView];
    
    return CGPointMake(0, legendElementView.frame.size.height+legendElementView.frame.origin.y);
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
    //NSLog([NSString stringWithFormat:@"%f", self.lastScrollPositionY]);
    
    if ((self.lastScrollPositionY > -65 && [_titleContainerView isHidden])) {
        [_titleContainerView setHidden:NO];
    } else if(self.lastScrollPositionY < -65 && ![_titleContainerView isHidden]) {
        [_titleContainerView setHidden:YES];
    }
}

#pragma TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Will only show listed POIs on a trip
    return [[_currentTrip.pois objectForKey:@"listed"] count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"POIOnCardView"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"POICellView"];
    }
    
    POIOnCardView *cardView = [[[NSBundle mainBundle] loadNibNamed:@"POIOnCardView" owner:self options:nil] objectAtIndex:0];
    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cardView.frame.size.width, cardView.frame.size.height)];
    [cardView setFrame:CGRectMake(0, 0, cardView.frame.size.width, cardView.frame.size.height)];
    
    Poi *poi = [[_currentTrip.pois objectForKey:@"listed"] objectAtIndex:index];
    
    
    [[cardView titleLabel] setText:poi.mainTitle];
    [[cardView subtitleLabel] setText:poi.subtitle];
    [[cardView titleLabel] setFont:[LookAndFeel defaultFontBoldWithSize:12]];
    [[cardView subtitleLabel] setFont:[LookAndFeel defaultFontBookWithSize:9]];
    
    [[cardView iconView] setImage:[UIImage imageNamed:poi.associatedIconName]];
    [cell addSubview:cardView];

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

@end
