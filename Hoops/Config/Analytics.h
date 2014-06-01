//
//  Analytics.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 6/1/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"

@interface Analytics : NSObject

+ (void) registerActionWithString:(NSString*)string withProperties:(NSDictionary*)properties;
+ (void) incrementBy:(int)number property:(NSString*)property;


@end
