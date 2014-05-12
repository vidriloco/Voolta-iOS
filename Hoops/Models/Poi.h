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

@interface Poi : GMSMarker

@property (nonatomic, assign) BOOL sponsored;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *theTitle;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *mainPic;
@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSArray *slideElements;

+ (Poi*) initWithDictionary:(NSDictionary*)dictionary;

- (NSString*) subtitle;
- (NSString*) localizedCategory;

- (BOOL) isAPlaceToEat;
- (BOOL) isAPlaceToInteract;
- (BOOL) isAPlaceToSee;
- (BOOL) isAPlaceToFeel;
- (BOOL) isAPlaceToExplore;
- (BOOL) isAServiceStation;
- (BOOL) isABikeSchool;
- (BOOL) isABikeLending;

- (BOOL) isSlideBased;

- (NSString*) iconName;

- (NSString*) associatedIconName;
@end
