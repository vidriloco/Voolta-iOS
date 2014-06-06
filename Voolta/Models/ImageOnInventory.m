//
//  ImageOnInventory.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/20/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "ImageOnInventory.h"

@interface ImageOnInventory ()

- (void) setUpdateDate:(NSString*)dateString;
- (NSDateFormatter*) generateFormatter;

@end

@implementation ImageOnInventory

+ (id) initWithDictionary:(NSDictionary *)dictionary
{
    ImageOnInventory *inventoredImage = [ImageOnInventory newRecord];
    [inventoredImage setRemoteId:[dictionary objectForKey:@"id"]];
    [inventoredImage updateFieldsFromDictionary:dictionary];
    return inventoredImage;
}

- (void) setUpdateDate:(NSString *)dateString
{
    [self setUpdatedAt:[[self generateFormatter] dateFromString:dateString]];
}

- (NSDateFormatter*) generateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    return dateFormatter;
}

- (BOOL) shouldUpdateBasedOnDateString:(NSString *)dateString
{
    return [self.updatedAt compare:[[self generateFormatter] dateFromString:dateString]] == NSOrderedAscending;
}

- (void) updateFieldsFromDictionary:(NSDictionary *)dictionary
{
    [self setUrl:[dictionary objectForKey:@"url"]];
    [self setUpdateDate:[dictionary objectForKey:@"updated_at"]];
    if ([dictionary objectForKey:@"attribution_url"] != [NSNull null]) {
        [self setAttributionURL:[dictionary objectForKey:@"attribution_url"]];
    }
    
    if ([dictionary objectForKey:@"attribution_info"] != [NSNull null]) {
        [self setAttributionInfo:[dictionary objectForKey:@"attribution_info"]];
    }
}

@end
