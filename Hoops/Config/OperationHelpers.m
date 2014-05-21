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

+ (void) storeImage:(UIImage *)image withFilename:(NSString *)filename
{
    NSString *filePath = [self filePathForImage:filename];
    
    //CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
    //NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
    //[data writeToFile:filePath atomically:YES];
    
    if ([[filename componentsSeparatedByString:@"."].lastObject isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    } else {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:YES];
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

+ (void) removeFilesForTripWithId:(long)remoteId
{
    NSString *fileDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator* en = [fileManager enumeratorAtPath:fileDir];
    NSString *pattern = [@"^" stringByAppendingString:[NSString stringWithFormat:kTripPrefix, remoteId, @""]];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString* file;
    while (file = [en nextObject]) {
        NSRange range = NSMakeRange(0, [file length]);
        if ([[regex matchesInString:file options:0 range:range] count] > 0) {
            [fileManager removeItemAtPath:[fileDir stringByAppendingPathComponent:file] error:nil];
        }
    }
    
}

@end
