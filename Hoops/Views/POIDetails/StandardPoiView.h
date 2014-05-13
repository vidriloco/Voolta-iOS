//
//  StandardPoiView.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/9/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookAndFeel.h"
#import "ContentBuilder.h"
#import "ContentBuilderDelegate.h"
#import "BrochureElement.h"

@class POIDetailsView;
@interface StandardPoiView : UIView<UIWebViewDelegate, ContentBuilderDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *mainImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UIImageView *categoryImageView;
@property (nonatomic, strong) ContentBuilder* contentBuilder;
@property (nonatomic, strong) NSArray *contentElements;

- (void) stylize;
@end
