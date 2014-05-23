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

+ (void) fetchImage:(NSString*)imageURL withResponseBlock:(void(^)(UIImage* image))block;
+ (void) storeImage:(UIImage*)image withFilename:(NSString*)filename;
+ (NSString*) filePathForImage:(NSString*)imageNamed;
+ (void) removeImageWithFilename:(NSString*)filename;
+ (void) removeFilesForTripWithId:(long)remoteId;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
