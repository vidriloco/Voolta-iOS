//
//  MiniPOIDetailsView.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/25/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@class POIDetailsView;
@interface MiniPOIDetailsView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;
@property (nonatomic, weak) IBOutlet UIImageView *kindImageView;
@property (nonatomic, weak) IBOutlet UIImageView *categoryImageView;
@property (nonatomic, weak) IBOutlet UIView *containerView;

- (void) stylize;

@end
