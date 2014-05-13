//
//  BrochureElement.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 4/16/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrochureElement : NSObject

@property (nonatomic, strong) NSString*     type;

// Fields for paragraph elements
@property (nonatomic, strong) NSString*     paragraphContent;

// Fields for photo elements
@property (nonatomic, strong) NSString*     photoCaption;
@property (nonatomic, strong) NSString*     photoFilename;
@property (nonatomic, assign) BOOL          photoIsFullWidth;

// Fields for legend elements
@property (nonatomic, strong) NSString*     legendTitle;
@property (nonatomic, strong) NSString*     legendSubtitle;
@property (nonatomic, strong) NSString*     legendImageName;
@property (nonatomic, strong) NSString*     legendDetails;

// Fields for web elements
@property (nonatomic, strong) NSString*     webFilename;

// Fields for table elements
@property (nonatomic, strong) NSString*     tableName;


+ (BrochureElement*) initWithDictionary:(NSDictionary*)dictionary;

- (BOOL) isPhoto;
- (BOOL) isPlain;
- (BOOL) isParagraph;
- (BOOL) isLegend;
- (BOOL) isWeb;
- (BOOL) isPOITable;


@end
