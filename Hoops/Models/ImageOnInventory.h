//
//  ImageOnInventory.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/20/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iActiveRecord/ActiveRecord.h>

@interface ImageOnInventory : ActiveRecord

@property (nonatomic, strong) NSNumber *remoteId;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *attributionURL;
@property (nonatomic, strong) NSString *attributionInfo;
@property (nonatomic, strong) NSDate *lastSeenAlive;

+ (id) initWithDictionary:(NSDictionary*) dictionary;
- (BOOL) shouldUpdateBasedOnDateString:(NSString*)dateString;
- (void) updateFieldsFromDictionary:(NSDictionary*)dictionary;
@end
