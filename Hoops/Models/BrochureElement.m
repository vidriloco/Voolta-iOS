//
//  BrochureElement.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/16/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "BrochureElement.h"

@implementation BrochureElement


+ (BrochureElement*) initWithDictionary:(NSDictionary*)dictionary
{
    BrochureElement *element = [[BrochureElement alloc] init];
    
    if (element) {
        [element setType:[dictionary objectForKey:@"type"]];
        if ([element isParagraph]) {
            [element setValueAsString:[dictionary objectForKey:@"value"]];
        } else if ([element isLegend]) {
            [element setTitle:[dictionary objectForKey:@"title"]];
            [element setValueAsDictionary:[dictionary objectForKey:@"value"]];
        }
    }
    
    return element;
}

- (BOOL) isLegend
{
    return [_type isEqualToString:@"map_item_description"];
}

- (BOOL) isParagraph
{
    return [_type isEqualToString:@"paragraph"];
}

- (BOOL) isPlain
{
    return [_type isEqualToString:@"route_controls"];
}

- (NSString*) legendTitle {
    if ([self isLegend]) {
        return [_valueAsDictionary objectForKey:@"title"];
    }
    return nil;
}

- (NSString*) legendImageName {
    if ([self isLegend]) {
        return [_valueAsDictionary objectForKey:@"icon"];
    }
    return nil;
}

- (NSString*) legendDetails {
    if ([self isLegend]) {
        return [_valueAsDictionary objectForKey:@"details"];
    }
    return nil;
}

@end
