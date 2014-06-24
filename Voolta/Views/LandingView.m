//
//  LandingView.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/28/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "LandingView.h"

@interface LandingView ()

@end

@implementation LandingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) stylizeView
{
    [self.legendLabel setFont:[LookAndFeel defaultFontLightWithSize:16]];
    [self.nextIconButton setHidden:YES];
    [self.infoIconButton setHidden:NO];
    [self.creditsButton setHidden:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.legendLabel setText:NSLocalizedString(@"app_tag_line", nil)];
    [self.logoImageView setAlpha:0];

    [self.personCardView setFrame:CGRectMake(0, self.iconImageView.frame.origin.y+self.iconImageView.frame.size.height, self.personCardView.frame.size.width, self.personCardView.frame.size.height)];
    [self.personCardView setHidden:YES];
    [self addSubview:self.personCardView];
    
    [self.personContactLabel setFont:[LookAndFeel defaultFontLightWithSize:13]];
    [self.personContactLabel setTextColor:[UIColor whiteColor]];

    [self.personNameLabel setFont:[LookAndFeel defaultFontBookWithSize:16]];
    [self.personNameLabel setTextColor:[UIColor whiteColor]];
    
    [self.personCreditTitleLabel setFont:[LookAndFeel defaultFontBoldWithSize:8]];
    [self.personCreditTitleLabel setTextColor:[UIColor whiteColor]];
    [self.personCreditTitleLabel setText:[NSLocalizedString(@"landing_credits_title", nil) uppercaseString]];

}

- (void) finishedLoading
{
    [self.nextIconButton setHidden:NO];
    [self.nextIconButton setAlpha:0];
    [self.creditsButton setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        [self.nextIconButton setAlpha:1];
        [self.activityIndicatorView setAlpha:0];

    } completion:^(BOOL finished) {
        [self.activityIndicatorView setHidden:YES];
    }];
}

- (void) toggleCredits
{
    if (_creditsAreVisible) {

        [UIView animateWithDuration:0.5 animations:^{
            [self.legendLabel setAlpha:1];
            [self.nextIconButton setAlpha:1];
            
            [self.creditsButton setFrame:CGRectMake(self.creditsButton.frame.origin.x,
                                                    self.creditsButton.frame.origin.y+100,
                                                    self.creditsButton.frame.size.width,
                                                    self.creditsButton.frame.size.height)];

        } completion:^(BOOL finished) {

        }];
        
        CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        fullRotation.fromValue = [NSNumber numberWithFloat:DegreesToRadians(180)];
        fullRotation.toValue = [NSNumber numberWithFloat:0];
        fullRotation.duration = 0.3;
        fullRotation.removedOnCompletion = NO;
        fullRotation.fillMode = kCAFillModeForwards;
        fullRotation.additive = YES;
        [self.creditsButton.layer addAnimation:fullRotation forKey:@"rotate"];
        
        CABasicAnimation* expand = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        expand.toValue = [NSNumber numberWithDouble:1];
        expand.duration = 0.5;
        expand.removedOnCompletion = NO;
        expand.fillMode = kCAFillModeForwards;
        expand.delegate = self;
        [[self.iconImageView layer] addAnimation:expand forKey:@"expand"];

    } else {
        [UIView animateWithDuration:0.5 animations:^{
            [self.nextIconButton setAlpha:0];
            [self.legendLabel setAlpha:0];
            [self.creditsButton setFrame:CGRectMake(self.creditsButton.frame.origin.x,
                                                    self.creditsButton.frame.origin.y-100,
                                                    self.creditsButton.frame.size.width,
                                                    self.creditsButton.frame.size.height)];

        } completion:^(BOOL finished) {

        }];
        
        CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        fullRotation.fromValue = [NSNumber numberWithFloat:0];
        fullRotation.toValue = [NSNumber numberWithFloat:DegreesToRadians(180)];
        fullRotation.duration = 0.3;
        fullRotation.fillMode = kCAFillModeForwards;
        fullRotation.removedOnCompletion = NO;
        fullRotation.additive = YES;
        [self.creditsButton.layer addAnimation:fullRotation forKey:@"rotate"];
        
        CABasicAnimation* shrink = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shrink.toValue = [NSNumber numberWithDouble:0.5];
        shrink.duration = 0.5;
        shrink.removedOnCompletion = NO;
        shrink.fillMode = kCAFillModeForwards;
        shrink.delegate = self;
        [[self.iconImageView layer] addAnimation:shrink forKey:@"shrink"];
    }
    _creditsAreVisible = !_creditsAreVisible;

}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // After shrinking, hide the main logo and show the mini logo
    if (anim == [[self.iconImageView layer] animationForKey:@"shrink"]) {
        [self.iconImageView setHidden:YES];
        [self.personCardView setHidden:NO];

        [UIView animateWithDuration:0.4 delay:0.2 options:0 animations:^{
            [self.logoImageView setAlpha:1];
        } completion:nil];
    } 
}

- (void) animationDidStart:(CAAnimation *)anim
{
    // Before expanding, show the main logo and hide the mini-logo
    if (anim == [[self.iconImageView layer] animationForKey:@"expand"]) {
        [self.personCardView setHidden:YES];

        [self.iconImageView setHidden:NO];
        [self.logoImageView setAlpha:0];
    }
}

@end
