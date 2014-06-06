//
//  MainCardButton.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/3/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"

@interface MainCardButton : UIButton

@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *legendLabel;

- (void) stylizeView;

@end
