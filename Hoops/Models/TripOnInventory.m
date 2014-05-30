//
//  TripOnInventory.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/15/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "TripOnInventory.h"

@interface TripOnInventory ()

@property (nonatomic, strong) NSNumber *needsUpdate;

@end

@implementation TripOnInventory

+ (id) initWithRemoteId:(NSNumber*)remoteId checksumString:(NSString *)checksum langString:(NSString *)lang andResourceId:(NSString *)resourceId
{
    TripOnInventory *tripInv = [TripOnInventory newRecord];
    tripInv.remoteId = remoteId;
    tripInv.checksum = checksum;
    tripInv.lang = lang;
    tripInv.resourceId = resourceId;
    tripInv.needsUpdate = @0;
    return tripInv;
}

- (void) markForUpdate
{
    self.needsUpdate = @1;
}

- (void) markAsUpdated
{
    self.needsUpdate = @0;
}

- (BOOL) shouldUpdate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = -1;
    NSDate *twoDaysAgo = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    return [self.needsUpdate isEqualToNumber:@1] || [self.updatedAt compare:twoDaysAgo] == NSOrderedAscending;
}


@end
