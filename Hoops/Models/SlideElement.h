//
//  SlideElement.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/7/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideElement : NSObject

#define kTopRightAlignment       @"TR"
#define kBottomLeftAlignment     @"BL"

typedef NS_ENUM(NSUInteger, SlideContentAlignment)
{
    SlideAlignRightTop = 0,
    SlideAlignBottomLeft
};

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, assign) BOOL contrasted;
@property (nonatomic, assign) BOOL isMainSlide;
@property (nonatomic, assign) SlideContentAlignment contentAlignment;


- (id) initWithDictionary:(NSDictionary*)dictionary;

@end
