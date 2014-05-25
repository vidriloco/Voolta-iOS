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

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailsLabel;
@property (nonatomic, strong) IBOutlet UIImageView *kindImageView;
@property (nonatomic, strong) IBOutlet UIImageView *categoryImageView;
@property (nonatomic, strong) IBOutlet UIView *containerView;

- (void) stylize;

@end
