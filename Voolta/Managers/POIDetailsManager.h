//
//  POIDetailsManager.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/6/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poi.h"
#import "POIDetailsView.h"

@class TripViewController;
@interface POIDetailsManager : NSObject

+ (POIDetailsManager*) current;
+ (POIDetailsManager*) newWithController:(TripViewController*) controller;
- (void) showDetailsViewForPoi:(Poi*)poi;
- (void) hideDetailsView;

- (void) openLinkForSlideElementAtIndex:(NSUInteger)index;

@end
