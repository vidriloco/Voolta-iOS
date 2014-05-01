//
//  BrochureElement.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/16/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrochureElement : NSObject

@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSDictionary* valueAsDictionary;
@property (nonatomic, strong) NSString* valueAsString;

+ (BrochureElement*) initWithDictionary:(NSDictionary*)dictionary;

- (BOOL) isPlain;
- (BOOL) isParagraph;
- (BOOL) isLegend;

- (NSString*) legendTitle;
- (NSString*) legendImageName;
- (NSString*) legendDetails;


@end
