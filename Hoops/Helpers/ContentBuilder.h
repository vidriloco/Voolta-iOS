//
//  ContentBuilder.h
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/12/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrochureElement.h"
#import "MainCardButton.h"
#import "LegendElementView.h"
#import "ContentBuilderDelegate.h"
#import "BrochurePictureView.h"

@interface ContentBuilder : NSObject<UIWebViewDelegate>

@property (nonatomic, strong) id<ContentBuilderDelegate> builderDelegate;
@property (nonatomic, assign) CGPoint lastOffset;
@property (nonatomic, assign) int contentElementIdx;

- (id) initWithDelegate:(id<ContentBuilderDelegate>) delegate withOffset:(CGPoint) offset;
- (void) drawRouteControlsOnContainer:(UIView*)container;

- (void) drawParagraphOnContainer:(UIView*)container
              withBrochureElement:(BrochureElement*)element;

- (void) drawLegendElementOnContainer:(UIView*)container
                  withBrochureElement:(BrochureElement*)element;

- (void) drawWebViewElementOnContainer:(UIView*)container
                        withHTMLString:(NSString*)fileName;

- (void) drawImageViewElementOnContainer:(UIView*)container
                     withBrochureElement:(BrochureElement*)element;

- (void) setText:(NSString*)text withNSAlignment:(NSTextAlignment)alignment onLabel:(id)label;

- (void) buildContentForElement:(BrochureElement*)element onContainer:(UIView*)container;

@end
