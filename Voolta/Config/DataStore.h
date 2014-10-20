//
//  DataStore.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/15/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"
#import "SBJson.h"
#import "TripOnInventory.h"
#import "Trip.h"
#import "DataStoreDelegate.h"
#import "OperationHelpers.h"
#import "ImageOnInventory.h"
#import "BaseViewController.h"

@interface DataStore : NSObject

@property (nonatomic, strong) NSMutableArray *trips;
@property (nonatomic, assign) id<DataStoreDelegate> delegate;

+ (id) initializeStoreWithDelegate:(id<DataStoreDelegate>) delegate;
+ (DataStore*) current;
+ (NSArray*) storedTrips;

- (id) initWithDelegate:(id<DataStoreDelegate>) delegate;
- (void) boot;
- (void) updateInventory;
- (void) updateGeneralImages;
- (void) updateTripsInventory;
- (void) resetDB;

@end
