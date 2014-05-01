//
//  TripKeyDetailsView.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/15/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface TripKeyDetailsView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *leftIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *leftLabel;

@property (nonatomic, weak) IBOutlet UIImageView *rightIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *rightLabel;

- (void) stylize;

@end
