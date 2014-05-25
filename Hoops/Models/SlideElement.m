//
//  SlideElement.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/7/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "SlideElement.h"

@implementation SlideElement

- (id) initWithDictionary:(NSDictionary *)dictionary withTripId:(long)tripId withPoiId:(long)poiId
{
    self = [super init];
    if (self) {
        _contrasted = [[dictionary objectForKey:@"contrasted"] boolValue];
        _isMainSlide = [[dictionary objectForKey:@"main_slide"] boolValue];
        _order = [[dictionary objectForKey:@"order"] intValue];
        
        if (!_isMainSlide) {
            _title = [dictionary objectForKey:@"title"];
            _subtitle = [dictionary objectForKey:@"subtitle"];
            
            NSString *url = [[dictionary objectForKey:@"image"] objectForKey:@"url"];
            _imageFilename = [NSString stringWithFormat:kSlideElementPrefix, tripId, poiId, [url componentsSeparatedByString:@"/"].lastObject];
            
            [OperationHelpers fetchImage:url withResponseBlock:^(UIImage *image) {
                [OperationHelpers storeImage:image withFilename:_imageFilename];
            }];
            
            _url = [dictionary objectForKey:@"url"];

            if ([[dictionary objectForKey:@"aligned_to_right"] boolValue]) {
                _contentAlignment = SlideAlignRightTop;
            } else {
                _contentAlignment = SlideAlignBottomLeft;
            }
        }
        
    }
    return self;
}

@end
