//
//  App.m
//  Hoops
//
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "App.h"

static NSDictionary* urls;
static int environment;
static int mode;

@implementation App

/*
 *  Retrieves the viewBounds for the current screen
 */
+ (CGRect) viewBounds
{
    return [[UIScreen mainScreen] bounds];
}

/*
 *  Probably will get deprecated soon, useful for development purpouses
 */
+ (CLLocationCoordinate2D) mexicoCityCoordinates
{
    return CLLocationCoordinate2DMake(19.427744, -99.136505);
}

/*
 *  Loads an appropriate URL to the backend server as defined on the urls.plist file
 *  for the currently set application environment
 */
+ (NSString*) backendURL
{
  
    if (environment == kDev) {
        return [urls objectForKey:@"backendURLDev"];
    } else {
        return [urls objectForKey:@"backendURL"];
    }
}

/*
 *  Loads the full URL for the provided resource
 */
+ (NSString*) urlForResource:(NSString *)resource
{
    [self loadURLSet];
    return [[self backendURL] stringByAppendingString:[urls objectForKey:resource]];
}

/*
 *  Loads the full URL for the provided resource with subresource
 */
+ (NSString*) urlForResource:(NSString *)resource withSubresource:(NSString *)subresource
{
    [self loadURLSet];
    return [[self backendURL] stringByAppendingString:[[urls objectForKey:resource] objectForKey:subresource]];
}

/*
 *  Loads the full URL for the provided resource with subresource, replacing the provided symbols with the value provided
 */
+ (NSString*) urlForResource:(NSString *)resource withSubresource:(NSString *)subresource andReplacementSymbol:(NSString *)symbol withReplacementValue:(NSString *)value
{
    return [[self urlForResource:resource withSubresource:subresource] stringByReplacingOccurrencesOfString:symbol withString:value];
}

/*
 *  Loads the application URLs
 */
+ (void) loadURLSet
{
    if(urls == NULL) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:kURLsFile];
        urls = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    }
}

/*
 *  Initializes application with environment
 */
+ (void) initializeAppMode:(int)mode_ withEnv:(int)env {
    environment = env;
    mode = mode_;
}

+ (UIImage*)takeScreenshot:(CALayer*)layer
{
    UIGraphicsBeginImageContextWithOptions([App viewBounds].size, YES, [[UIScreen mainScreen] scale]);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

+ (NSString*) currentLang
{
    return [[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"].firstObject;
}

+ (BOOL) isNetworkReachable
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return (networkStatus != NotReachable);
}

+ (void) initializeUID
{
    if ([App currentUID].length == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUUID UUID] UUIDString] forKey:@"UID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString*) currentUID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"UID"];
}

+ (BOOL) hasShownHowTo
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"shown-how-to"];
}

+ (void) markHowToAsShown
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shown-how-to"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) isLiteModeEnabled
{
    return mode == kLiteMode;
}

+ (BOOL) isStagingModeEnabled
{
    return mode == kStagingMode;
}

@end
