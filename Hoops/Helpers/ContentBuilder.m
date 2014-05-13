//
//  ContentBuilder.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/12/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "ContentBuilder.h"

@interface ContentBuilder ()

@property (nonatomic, assign) BOOL  switchLegendSide;
@end

@implementation ContentBuilder

- (id) initWithDelegate:(id<ContentBuilderDelegate>)delegate withOffset:(CGPoint)offset
{
    self = [super init];
    if (self) {
        self.builderDelegate = delegate;
        _lastOffset = offset;
        _contentElementIdx = 0;
    }
    return self;
}

- (void) buildContentForElement:(BrochureElement *)element onContainer:(UIView *)container
{
    if ([element isParagraph]) {
        [self drawParagraphOnContainer:container withBrochureElement:element];
    } else if ([element isPlain]) {
        [self drawRouteControlsOnContainer:container];
    } else if ([element isLegend]) {
        [self drawLegendElementOnContainer:container withBrochureElement:element];
    } else if ([element isWeb]) {
        [self drawWebViewElementOnContainer:container withHTMLFile:element.webFilename];
    }
}

- (void) drawRouteControlsOnContainer:(UIView*)container {
    MainCardButton *leftCardButton = [[[NSBundle mainBundle]
                                       loadNibNamed:@"MainCardButton" owner:self options:nil] objectAtIndex:0];
    [leftCardButton setFrame:CGRectMake(kSidesMargin, _lastOffset.y, leftCardButton.frame.size.width, leftCardButton.frame.size.height)];
    
    [leftCardButton addTarget:_builderDelegate action:@selector(userTappedOnTripStart) forControlEvents:UIControlEventTouchUpInside];
    [[leftCardButton legendLabel] setText:NSLocalizedString(@"route_start", nil)];
    [[leftCardButton iconView] setImage:[UIImage imageNamed:@"flag-start-icon.png"]];
    [leftCardButton stylizeView];
    [container addSubview:leftCardButton];
    
    MainCardButton *rightCardButton = [[[NSBundle mainBundle]
                                        loadNibNamed:@"MainCardButton" owner:self options:nil] objectAtIndex:0];
    [rightCardButton setFrame:CGRectMake(container.frame.size.width-rightCardButton.frame.size.width-kSidesMargin, _lastOffset.y, rightCardButton.frame.size.width, rightCardButton.frame.size.height)];
    
    [rightCardButton addTarget:_builderDelegate action:@selector(userTappedOnTripEnd) forControlEvents:UIControlEventTouchUpInside];
    [[rightCardButton legendLabel] setText:NSLocalizedString(@"route_end", nil)];
    [[rightCardButton iconView] setImage:[UIImage imageNamed:@"flag-end-icon.png"]];
    [rightCardButton stylizeView];
    [container addSubview:rightCardButton];
    _lastOffset = CGPointMake(0, rightCardButton.frame.origin.y+rightCardButton.frame.size.height);
    _contentElementIdx ++;
    [_builderDelegate contentBuilderFinishedAddingElementToView];
}

- (void) drawParagraphOnContainer:(UIView*)container
              withBrochureElement:(BrochureElement *)element{
    
    UITextView *blockIntroTextView = [[UITextView alloc] initWithFrame:CGRectMake(kSidesMargin, 10+_lastOffset.y,
                                                                                  container.frame.size.width-(kSidesMargin*2), 110)];
    [blockIntroTextView setFont:[LookAndFeel defaultFontLightWithSize:15]];
    [blockIntroTextView setEditable:NO];
    [blockIntroTextView setBackgroundColor:[UIColor clearColor]];
    [blockIntroTextView setOpaque:NO];
    [self setText:element.paragraphContent withNSAlignment:NSTextAlignmentJustified onLabel:blockIntroTextView];
    [blockIntroTextView setScrollEnabled:NO];
    [container addSubview:blockIntroTextView];
    _lastOffset = CGPointMake(0, blockIntroTextView.frame.origin.y+blockIntroTextView.frame.size.height);
    _contentElementIdx ++;
    [_builderDelegate contentBuilderFinishedAddingElementToView];
    
}

- (void) drawLegendElementOnContainer:(UIView*)container
                  withBrochureElement:(BrochureElement *)element {
    LegendElementView *legendElementView = [[[NSBundle mainBundle]
                                             loadNibNamed:@"LegendElementView" owner:self options:nil] objectAtIndex:0];
    [[legendElementView subtitleLabel] setText:element.legendSubtitle];
    [[legendElementView descriptionLabel] setText:element.legendDetails];
    if (_switchLegendSide) {
        [[legendElementView rightMainTitleLabel] setText:element.legendTitle];
        [[legendElementView rightLegendImageView] setImage:[UIImage imageNamed:element.legendImageName]];
        [legendElementView toggleSide:UIRightSide];
    } else {
        [[legendElementView leftMainTitleLabel] setText:element.legendTitle];
        [[legendElementView leftLegendImageView] setImage:[UIImage imageNamed:element.legendImageName]];
        [legendElementView toggleSide:UILeftSide];
    }
    
    [legendElementView stylize];
    [legendElementView setFrame:CGRectMake(12, _lastOffset.y, legendElementView.frame.size.width, legendElementView.frame.size.height)];
    [container addSubview:legendElementView];
    
    _lastOffset = CGPointMake(0, legendElementView.frame.size.height+legendElementView.frame.origin.y);
    _switchLegendSide = !_switchLegendSide;
    _contentElementIdx ++;
    [_builderDelegate contentBuilderFinishedAddingElementToView];
}

- (void) drawWebViewElementOnContainer:(UIView *)container withHTMLFile:(NSString *)fileName
{
    float startingHeight = 200;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(kSidesMargin, _lastOffset.y, container.frame.size.width-(kSidesMargin*2), startingHeight)];
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    [webView setUserInteractionEnabled:NO];
    [webView setDelegate:self];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:baseURL];
    [container addSubview:webView];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{    
    float viewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    [webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, viewHeight)];
    [UIView animateWithDuration:0.5 animations:^{
        [webView setAlpha:1];
    }];
    
    _contentElementIdx ++;
    _lastOffset = CGPointMake(0, viewHeight+_lastOffset.y);
    [_builderDelegate contentBuilderFinishedAddingElementToView];
}

- (void) setText:(NSString *)text withNSAlignment:(NSTextAlignment)alignment onLabel:(id)label
{
    //  paragraphSetting
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.paragraphSpacing = 8.f;
    paragraphStyle.alignment = alignment;
    
    UIColor *color = [UIColor grayColor];
    
    NSDictionary *attributeDic = @{ NSFontAttributeName:[LookAndFeel defaultFontBookWithSize:15],
                                    NSForegroundColorAttributeName:color,
                                    NSParagraphStyleAttributeName:paragraphStyle};
    
    NSAttributedString *repString = [[NSAttributedString alloc] initWithString:text attributes:attributeDic];
    [label setAttributedText:repString];

}


@end
