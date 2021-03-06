//
//  DataStoreDelegate.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/16/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataStoreDelegate <NSObject>

@required
- (void) startedFetchingTrip;
- (void) startedLoadingTrip;
- (void) finishedFetchingTrip;
- (void) failedFetchingTrip;
- (void) reloadMainView;
- (void) finishedFetchingEmptyTrips;

@optional
- (void) imageLoadingPhaseCompleted;
- (void) prunePhaseCompleted;



@end
