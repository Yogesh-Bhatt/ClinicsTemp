//
//  HighLightWebView.m
//  TestHighLight
//
//  Created by Ashish Awasthi on 19/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HighLightWebView.h"


@implementation HighLightWebView

// *************** here Search text highlight In webview *********************

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str {
	
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SearchWebView" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    NSString *startSearch = [NSString stringWithFormat:@"MyApp_HighlightAllOccurencesOfString('%@')",str];
	
    [self stringByEvaluatingJavaScriptFromString:startSearch];
    NSString *result = [self stringByEvaluatingJavaScriptFromString:@"MyApp_SearchResultCount"];
	
	//NSLog(@"Result Count : %d",[result integerValue]);
    return [result integerValue];   
}

// ***************Here Remove Highlight Text  *********************

- (void)removeAllHighlights {   
    [self stringByEvaluatingJavaScriptFromString:@"MyApp_RemoveAllHighlights()"];
}

@end
