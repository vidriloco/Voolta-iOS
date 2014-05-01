//
//  Path.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/25/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "Path.h"

@implementation Path

static NSArray* list;
+ (Path*) initWithDictionary:(NSDictionary*)dictionary
{
    Path *path = [[Path alloc] init];
    
    path.name = [dictionary objectForKey:@"name"];
    path.details = [dictionary objectForKey:@"details"];
    path.color = [dictionary objectForKey:@"color"];
    path.thickness = [[dictionary objectForKey:@"thickness"] floatValue];
    
    NSString *stringPath = [dictionary objectForKey:@"path"];
    for (NSString *pair in [stringPath componentsSeparatedByString:@","]) {
        NSArray *coordinate = [[pair stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@" "];
        [path.coordinateList addLatitude:[[coordinate objectAtIndex:1] floatValue] longitude:[[coordinate objectAtIndex:0] floatValue]];
    }
    
    return path;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.coordinateList = [GMSMutablePath path];
    }
    return self;
}

+ (int) count
{
    return [list count];
}

+ (NSArray*) all
{
    return list;
}


@end
