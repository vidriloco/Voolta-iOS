//
//  App.h
//  Contains global-specific methods which are used throughout the application
//
//  Hoops
//
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"

#define kURLsFile   @"urls.plist"

// Environments for the app
#define kDev        0
#define kProd       1

// Modes for lite and pro versions of the app
#define kLiteMode       10
#define kProMode        20

#define kStagingMode    30


#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface App : NSObject

+ (void) initializeAppMode:(int)mode withEnv:(int)env;
+ (CGRect) viewBounds;
+ (CLLocationCoordinate2D) mexicoCityCoordinates;

+ (NSString*) backendURL;
+ (NSString*) urlForResource:(NSString *)resource;
+ (NSString*) urlForResource:(NSString *)resource withSubresource:(NSString *)subresource;
+ (NSString*) urlForResource:(NSString *)resource withSubresource:(NSString *)subresource andReplacementSymbol:(NSString *)symbol withReplacementValue:(NSString *)value;

+ (void) loadURLSet;
+ (UIImage*)takeScreenshot:(CALayer*)layer;
+ (NSString*) currentLang;

+ (BOOL) isNetworkReachable;

+ (NSString*) currentUID;
+ (void) initializeUID;

+ (BOOL) hasShownHowTo;
+ (void) markHowToAsShown;
+ (BOOL) isLiteModeEnabled;
+ (BOOL) isStagingModeEnabled;

@end
