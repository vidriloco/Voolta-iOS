//
//  ContentBuilderDelegate.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/12/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ContentBuilderDelegate <NSObject>

- (void) contentBuilderFinishedAddingElementToView;
- (void) drawNextContentElement;

@optional
- (void) userTappedOnTripStart;
- (void) userTappedOnTripEnd;

@end
