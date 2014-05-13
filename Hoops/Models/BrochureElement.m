//
//  BrochureElement.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/16/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "BrochureElement.h"

@implementation BrochureElement


+ (BrochureElement*) initWithDictionary:(NSDictionary*)dictionary
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
        [element setPhotoFilename:[dictionary objectForKey:@"filename"]];
        [element setPhotoCaption:[dictionary objectForKey:@"caption"]];
        [element setPhotoIsFullWidth:[[dictionary objectForKey:@"full_width"] boolValue]];
    } else if ([element isWeb]) {
        [element setHtmlString:[dictionary objectForKey:@"html_string"]];
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
