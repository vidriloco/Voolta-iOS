//
//  LegendElementView.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/16/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface LegendElementView : UIView

@property (nonatomic, weak) IBOutlet UILabel *leftMainTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *leftLegendImageView;
@property (nonatomic, weak) IBOutlet UILabel *rightMainTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *rightLegendImageView;

@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIView *containerView;


typedef NS_ENUM(NSInteger, UISide)
{
    UIRightSide, UILeftSide
};

- (void) stylize;
- (void) toggleSide:(UISide)side;

@end
