//
//  HighLightWebView.h
//  TestHighLight
//
//  Created by Ashish Awasthi on 19/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HighLightWebView : UIWebView {

}
- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;

@end
