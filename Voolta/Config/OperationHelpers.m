//
//  OperationHelpers.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/18/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "OperationHelpers.h"
#import "Trip.h"

@implementation OperationHelpers

static NSOperationQueue *operationQueue;

+ (NSOperationQueue*) operationQueue
{
    if (operationQueue == NULL) {
        operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setName:@"Default operation queue"];
    }
    return operationQueue;
}

+ (void) fetchImage:(NSString *)imageURL withResponseBlock:(void (^)(UIImage *))block
{
    AFHTTPRequestOperationManager *imageFetcherManager = [AFHTTPRequestOperationManager manager];
    AFImageResponseSerializer *imageSerializer = [AFImageResponseSerializer serializer];
    imageFetcherManager.responseSerializer = imageSerializer;
    
    [imageFetcherManager GET:imageURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    /*
    NSURL *url = [NSURL URLWithString:imageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];*/
}

+ (void) storeImage:(UIImage *)image withFilename:(NSString *)filename withResponseBlock:(void (^)(void))block {
    [[OperationHelpers operationQueue] addOperationWithBlock:^{
        NSString *filePath = [self filePathForImage:filename];
        
        //CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
        //NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
        //[data writeToFile:filePath atomically:YES];
        
        if ([[filename componentsSeparatedByString:@"."].lastObject isEqualToString:@"png"]) {
            [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
        } else {
            [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:YES];
        }
        
        if (block != NULL) {
            block();
        }
    }];
}

+ (void) removeImgFiles
{
    NSError *error;
    
    // get the documents folder of your sandbox
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *dirFiles;
    if ((dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error]) == nil) {
        // handle the error
    };
    
    // find the files with the extensions you want
    NSArray *jpgFiles = [dirFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"]];
    NSArray *pngFiles = [dirFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.png'"]];
    
    
    // loop on arrays and delete every file corresponds to specific filename
    for (NSString *fileName in jpgFiles) {
        if (![[NSFileManager defaultManager] removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:fileName] error:&error]) {
            // handle the error
        }
    }
    for (NSString *fileName in pngFiles) {
        if (![[NSFileManager defaultManager] removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:fileName] error:&error]) {
            // handle the error
        }
    }
}

+ (NSString*) filePathForImage:(NSString *)imageNamed
{
    NSString *fileDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@", fileDir, imageNamed];
}

+ (void) removeImageWithFilename:(NSString *)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self filePathForImage:filename] error:nil];
}

+ (void) removeFilesForTripWithResourceId:(NSString *)resourceId
{
    [[OperationHelpers operationQueue] addOperationWithBlock:^{
        NSString *fileDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSDirectoryEnumerator* en = [fileManager enumeratorAtPath:fileDir];
        NSString *pattern = [@"^" stringByAppendingString:[NSString stringWithFormat:kTripPrefix, resourceId, @""]];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSString* file;
        while (file = [en nextObject]) {
            NSRange range = NSMakeRange(0, [file length]);
            if ([[regex matchesInString:file options:0 range:range] count] > 0) {
                [fileManager removeItemAtPath:[fileDir stringByAppendingPathComponent:file] error:nil];
            }
        }
    }];
}

+ (UIImage *) imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
