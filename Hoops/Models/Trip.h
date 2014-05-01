//
//  Trip.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/23/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Path.h"
#import "Poi.h"
#import "DirectionMarker.h"
#import "BrochureElement.h"

@interface Trip : NSObject

@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) float cost;
@property (nonatomic, assign) BOOL isAvailable;

@property (nonatomic, strong) NSString *detailsPic;
@property (nonatomic, strong) NSString *mainPic;
@property (nonatomic, strong) NSString *background;

@property (nonatomic, assign) int startZoom;

@property (nonatomic, assign) CLLocationCoordinate2D originCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D endCoordinate;

@property (nonatomic, strong) NSArray *paths;
@property (nonatomic, strong) NSDictionary *pois;
@property (nonatomic, strong) NSArray *allPois;
@property (nonatomic, strong) NSArray *directionMarkers;

@property (nonatomic, strong) NSString *introEs;
@property (nonatomic, strong) NSString *introEn;

@property (nonatomic, strong) NSString *complexity;
@property (nonatomic, strong) NSString *distance;

@property (nonatomic, strong) NSArray* brochureList;

+ (Trip*) initWithDictionary:(NSDictionary*)dictionary;
+ (int) count;
+ (NSArray*) all;
+ (NSArray*) loadAll;

- (BOOL) isLandingView;

@end
