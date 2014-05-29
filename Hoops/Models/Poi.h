//
//  Poi.h
//  Hoops
//
//  Created by Alejandro Cruz on 3/29/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SlideElement.h"
#import "App.h"
#import "BrochureElement.h"

#define kPoiPrefix @"trip_%ld_poi_%@"

@interface Poi : GMSMarker

@property (nonatomic, assign) BOOL sponsored;

@property (nonatomic, assign) long remoteId;

@property (nonatomic, strong) NSString *mode;

@property (nonatomic, strong) NSString *kindKeyword;
@property (nonatomic, strong) NSString *kindCode;
@property (nonatomic, strong) NSString *kindImage;

@property (nonatomic, strong) NSString *categoryKeyword;
@property (nonatomic, strong) NSString *categoryCode;
@property (nonatomic, strong) NSString *categoryImage;

@property (nonatomic, strong) NSString *theTitle;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *mainPic;

@property (nonatomic, strong) NSArray *slideElements;

@property (nonatomic, strong) NSArray *brochureElements;

+ (Poi*) initWithDictionary:(NSDictionary*)dictionary andTripId:(long)tripId;

- (NSString*) subtitle;

- (BOOL) isSlideUIBased;
- (BOOL) isMiniUIBased;
- (BOOL) isNormalUIBased;
@end
