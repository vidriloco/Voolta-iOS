//
//  TripLandingViewController.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/2/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "TripLandingViewController.h"

@interface TripLandingViewController ()

@property (nonatomic, assign) id<TripSelectedDelegate> tripSelectedDelegate;

@end

@implementation TripLandingViewController

- (id) initWithTripSelectedDelegate:(id<TripSelectedDelegate>)delegate
{
    self = [super init];
    if (self) {
        [self setTripSelectedDelegate:delegate];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resizeMainView];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:
                                  [UIImage imageNamed:[[_tripSelectedDelegate currentTrip] mainPic]]];
    [headImageView setClipsToBounds:YES];
    [headImageView setFrame:CGRectMake(0, 0, kCardWidth, headImageView.frame.size.height)];
    [headImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:headImageView];
    
    UIView *plecaView = [[UIView alloc] initWithFrame:CGRectMake(0, headImageView.frame.size.height+5, kCardWidth, 0.5)];
    [plecaView setBackgroundColor:[LookAndFeel lightBlueColor]];
    [plecaView setAlpha:0.6];
    [self.view addSubview:plecaView];
    
    MainCardButton *flagStartButton = [[[NSBundle mainBundle] loadNibNamed:@"MainCardButton" owner:self options:nil] objectAtIndex:0];
    [flagStartButton setFrame:CGRectMake(20, plecaView.frame.origin.y+20, flagStartButton.frame.size.width, flagStartButton.frame.size.height)];
    [[flagStartButton legendLabel] setText:@"Ir al inicio"];
    [[flagStartButton legendLabel] setFont:[LookAndFeel defaultFontBoldWithSize:12]];
    [[flagStartButton iconView] setImage:[UIImage imageNamed:@"flag-start-icon.png"]];
    [flagStartButton stylizeView];
    [flagStartButton addTarget:_tripSelectedDelegate action:@selector(centerMapOnTripStart) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:flagStartButton];
    
    MainCardButton *iconListButton = [[[NSBundle mainBundle] loadNibNamed:@"MainCardButton" owner:self options:nil] objectAtIndex:0];
    [iconListButton setFrame:CGRectMake(kCardWidth/2-iconListButton.frame.size.width/2, plecaView.frame.origin.y+20, iconListButton.frame.size.width, iconListButton.frame.size.height)];
    [[iconListButton legendLabel] setText:@"Lugares"];
    [[iconListButton legendLabel] setFont:[LookAndFeel defaultFontBoldWithSize:12]];
    [[iconListButton iconView] setImage:[UIImage imageNamed:@"pois-list-icon.png"]];
    [iconListButton stylizeView];

    [self.view addSubview:iconListButton];
    
    MainCardButton *flagEndButton = [[[NSBundle mainBundle] loadNibNamed:@"MainCardButton" owner:self options:nil] objectAtIndex:0];
    [flagEndButton setFrame:CGRectMake(kCardWidth-20-flagEndButton.frame.size.width, plecaView.frame.origin.y+20, iconListButton.frame.size.width, iconListButton.frame.size.height)];
    [[flagEndButton legendLabel] setText:@"Ir al final"];
    [[flagEndButton legendLabel] setFont:[LookAndFeel defaultFontBoldWithSize:12]];
    [[flagEndButton iconView] setImage:[UIImage imageNamed:@"flag-end-icon.png"]];
    [flagEndButton stylizeView];
    [flagEndButton addTarget:_tripSelectedDelegate action:@selector(centerMapOnTripFinal) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:flagEndButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
