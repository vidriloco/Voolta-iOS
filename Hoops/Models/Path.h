//
//  Path.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/25/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface Path : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) float thickness;

@property (nonatomic, strong) GMSMutablePath *coordinateList;


+ (Path*) initWithDictionary:(NSDictionary*)dictionary;
+ (int) count;
+ (NSArray*) all;

@end
