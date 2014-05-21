//
//  BrochureElement.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/16/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "BrochureElement.h"
#import "Trip.h"

@implementation BrochureElement


+ (BrochureElement*) initWithDictionary:(NSDictionary*)dictionary andTripId:(long)tripId
{
    BrochureElement *element = [[BrochureElement alloc] init];
    [element setType:[dictionary objectForKey:@"type"]];
    
    if ([element isParagraph]) {
        [element setParagraphContent:[dictionary objectForKey:@"content"]];
    } else if ([element isLegend]) {
        [element setLegendTitle:[dictionary objectForKey:@"title"]];
        [element setLegendSubtitle:[dictionary objectForKey:@"subtitle"]];
        [element setLegendDetails:[dictionary objectForKey:@"details"]];
        [element setLegendImageName:[dictionary objectForKey:@"icon"]];
    } else if ([element isPhoto]) {
        NSString *filename = [NSString stringWithFormat:kTripPrefix, tripId, [[dictionary objectForKey:@"url"] componentsSeparatedByString:@"/"].lastObject];

        [element setPhotoFilename:filename];
        [OperationHelpers fetchImage:[dictionary objectForKey:@"url"] withResponseBlock:^(UIImage *image) {
            [OperationHelpers storeImage:image withFilename:[element photoFilename]];
        }];
        
        [element setPhotoCaption:[dictionary objectForKey:@"caption"]];
        [element setPhotoIsFullWidth:[[dictionary objectForKey:@"full_width"] boolValue]];
    } else if ([element isWeb]) {
        NSError* error = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource: @"html_view" ofType: @"html"];
        NSString *res = [NSString stringWithContentsOfFile: path encoding:NSUTF8StringEncoding error: &error];
        res = [res stringByReplacingOccurrencesOfString:@"<%CONTENT%>" withString:[dictionary objectForKey:@"html_string"]];
        [element setHtmlString:res];
    } else if ([element isPOITable]) {
        [element setTableName:[dictionary objectForKey:@"table_title"]];
    } 
    
    return element;
}

- (BOOL) isPhoto
{
    return [_type isEqualToString:@"photograph"];
}

- (BOOL) isLegend
{
    return [_type isEqualToString:@"legend"];
}

- (BOOL) isParagraph
{
    return [_type isEqualToString:@"paragraph"];
}

- (BOOL) isPlain
{
    return [_type isEqualToString:@"route_controls"];
}

- (BOOL) isWeb
{
    return [_type isEqualToString:@"webview"];
}

- (BOOL) isPOITable
{
    return [_type isEqualToString:@"poi_table"];
}

- (BOOL) photoHasCaption
{
    return [_photoCaption length] > 0;
}

@end
