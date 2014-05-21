//
//  AppDelegate.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/22/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripShowcaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "DataStore.h"
#import <iActiveRecord/ActiveRecord.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
