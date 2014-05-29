//
//  TripOnInventory.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/15/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iActiveRecord/ActiveRecord.h>

@interface TripOnInventory : ActiveRecord

@property (nonatomic, strong) NSNumber *remoteId;
@property (nonatomic, strong) NSString *checksum;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *tripData;
@property (nonatomic, strong) NSString *resourceId;

+ (id) initWithRemoteId:(NSNumber*)remoteId checksumString:(NSString*)checksum langString:(NSString*)lang andResourceId:(NSString*)resourceId;
- (void) markForUpdate;
- (void) markAsUpdated;
- (BOOL) shouldUpdate;
@end
