//
//  OperationHelpers.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/18/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class Trip;
@interface OperationHelpers : NSObject

+ (NSOperationQueue*) operationQueue;
+ (void) fetchImage:(NSString*)imageURL withResponseBlock:(void(^)(UIImage* image))block;
+ (void) storeImage:(UIImage*)image withFilename:(NSString*)filename withResponseBlock:(void (^)(void))block;
+ (NSString*) filePathForImage:(NSString*)imageNamed;
+ (void) removeImageWithFilename:(NSString*)filename;
+ (void) removeFilesForTripWithResourceId:(NSString*)resourceId;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
