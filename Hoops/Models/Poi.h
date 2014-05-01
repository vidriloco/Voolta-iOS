//
//  Poi.h
//  Hoops
//
//  Created by Alejandro Cruz on 3/29/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface Poi : GMSMarker

@property (nonatomic, assign) BOOL sponsored;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *mainTitle;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *mainPic;

+ (Poi*) initWithDictionary:(NSDictionary*)dictionary;

- (BOOL) isAPlaceToEat;
- (BOOL) isAPlaceToInteract;
- (BOOL) isAPlaceToSee;
- (BOOL) isAPlaceToFeel;
- (BOOL) isAPlaceToExplore;
- (BOOL) isAServiceStation;
- (BOOL) isABikeSchool;
- (BOOL) isABikeLending;

- (NSString*) subtitle;
- (NSString*) associatedIconName;
@end
