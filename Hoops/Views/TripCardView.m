//
//  TripCardView.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/26/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "TripCardView.h"

@interface TripCardView ()
- (void) cardTapped;
@property (nonatomic, assign) int visibleCardIndex;
@property (nonatomic, strong) NSArray *cards;
@end

@implementation TripCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (void) stylize {
    self.visibleCardIndex = 0;
    
    [self.layer setShadowOpacity:0.4];
    [self.layer setShadowRadius:3];
    [self.layer setShadowOffset:CGSizeMake(-1, 2)];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.subpanel.layer setCornerRadius:5];
    [self.subpanel setClipsToBounds:YES];
    [self.subpanel.layer setMasksToBounds:YES];
    [self.poisAlongRouteLabel setFont:[LookAndFeel defaultFontBoldWithSize:10]];
    
    [_tripNameLabel setTextColor:[UIColor whiteColor]];
    [_tripNameLabel setFont:[LookAndFeel defaultFontBoldWithSize:20]];
    [[_tripNameLabel layer] setShadowOffset:CGSizeMake(3, 4)];
    [[_tripNameLabel layer] setShadowOpacity:0.8];
    [[_tripNameLabel layer] setShadowColor:[UIColor blackColor].CGColor];
    [_tripNameLabel setMinimumScaleFactor:0.8];
    
    [_tripDistanceLabel setTextColor:[UIColor whiteColor]];
    [_tripDistanceLabel setFont:[LookAndFeel defaultFontBookWithSize:15]];
    [[_tripDistanceLabel layer] setShadowOffset:CGSizeMake(3, 4)];
    [[_tripDistanceLabel layer] setShadowOpacity:0.8];
    [[_tripDistanceLabel layer] setShadowColor:[UIColor blackColor].CGColor];
    
    [_tripComplexityLabel setTextColor:[UIColor whiteColor]];
    [_tripComplexityLabel setFont:[LookAndFeel defaultFontBookWithSize:15]];
    [[_tripComplexityLabel layer] setShadowOffset:CGSizeMake(3, 4)];
    [[_tripComplexityLabel layer] setShadowOpacity:0.8];
    [[_tripComplexityLabel layer] setShadowColor:[UIColor blackColor].CGColor];
    
    [_tripDetailsTextView setTextColor:[UIColor grayColor]];
    [_tripDetailsTextView setFont:[LookAndFeel defaultFontLightWithSize:13]];
}

- (void) cardTapped {
    [UIView animateWithDuration:0.5 animations:^{
        [[self.cards objectAtIndex:self.visibleCardIndex] setAlpha:0.2];
    } completion:^(BOOL finished) {
        [[self.cards objectAtIndex:self.visibleCardIndex] setHidden:YES];
        [[self.cards objectAtIndex:self.visibleCardIndex] setAlpha:1];
        if (self.visibleCardIndex == self.cards.count-1) {
            self.visibleCardIndex = 0;
        } else {
            self.visibleCardIndex += 1;
        }
        
        [[self.cards objectAtIndex:self.visibleCardIndex] setAlpha:0];
        [[self.cards objectAtIndex:self.visibleCardIndex] setHidden:NO];
        [UIView animateWithDuration:0.4 animations:^{
            [[self.cards objectAtIndex:self.visibleCardIndex] setAlpha:1];
        }];
    }];
    
}

- (void) buildPoiFragmentsFor:(NSArray *)pois
{
    NSMutableArray *tmpCardsHolder = [NSMutableArray array];
    for (Poi *poi in pois) {
        if ([poi sponsored]) {
            POIOnCardView *card = [[[NSBundle mainBundle] loadNibNamed:@"POIOnCardView" owner:self options:nil] objectAtIndex:0];
            
            [[card titleLabel] setText:poi.theTitle];
            [[card subtitleLabel] setText:poi.subtitle];
            [[card titleLabel] setFont:[LookAndFeel defaultFontBoldWithSize:12]];
            [[card subtitleLabel] setFont:[LookAndFeel defaultFontBookWithSize:9]];
            
            [[card iconView] setImage:poi.icon];
            
            [card setFrame:CGRectMake(0, self.subpanel.frame.size.height-card.frame.size.height, card.frame.size.width, card.frame.size.height)];
            [tmpCardsHolder addObject:card];
            
            [self.subpanel addSubview:card];
            [card setHidden:YES];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped)];
            [tapGesture setNumberOfTapsRequired:1];
            [card addGestureRecognizer:tapGesture];
        }
    }
    self.cards = tmpCardsHolder;
    
    if ([self.cards count] > 0) {
        [[self.cards objectAtIndex:0] setHidden:NO];
    }

}

@end
