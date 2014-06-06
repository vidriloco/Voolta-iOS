//
//  Analytics.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 6/1/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "Analytics.h"

@implementation Analytics

+ (void) registerActionWithString:(NSString*)string withProperties:(NSDictionary*)properties
{
    [[Mixpanel sharedInstance] track:string properties:properties];
    [[Mixpanel sharedInstance].people set:properties];
}

+ (void) incrementBy:(int)number property:(NSString *)property
{
    [[Mixpanel sharedInstance].people increment:property by:@(number)];
}

@end
