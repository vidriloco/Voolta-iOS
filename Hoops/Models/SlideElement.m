//
//  SlideElement.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/7/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "SlideElement.h"

@implementation SlideElement

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _contrasted = [[dictionary objectForKey:@"contrasted"] boolValue];
        _isMainSlide = [[dictionary objectForKey:@"front"] boolValue];
        
        if (!_isMainSlide) {
            _title = [dictionary objectForKey:@"title"];
            _subtitle = [dictionary objectForKey:@"subtitle"];
            _image = [dictionary objectForKey:@"picture"];
            _url = [dictionary objectForKey:@"url"];

            if ([[dictionary objectForKey:@"alignment"] isEqualToString:kTopRightAlignment]) {
                _contentAlignment = SlideAlignRightTop;
            } else {
                _contentAlignment = SlideAlignBottomLeft;
            }
        }
        
    }
    return self;
}

@end
