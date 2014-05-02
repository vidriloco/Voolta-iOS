//
//  POITableHeaderView.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/2/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface POITableHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) IBOutlet UILabel *sectionLabel;
@property (nonatomic, weak) IBOutlet UIView *content;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (void) stylize;

@end
