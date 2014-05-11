//
//  POITableViewCell.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/2/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface POITableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, weak) IBOutlet UIImageView *imageBackground;
@property (nonatomic, weak) IBOutlet UIView *containingView;


- (void) stylize;

@end
