//
//  PopWebView.m
//  Elsevier
//
//  Created by Ashish Awasthi on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PopWebView.h"


@implementation PopWebView
@synthesize closeButton,webView,webURL;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(IBAction)onClickCloseButton:(UIButton*)button {

	if(self.webView) {
		[self.webView stopLoading];
		self.webView.delegate = nil;
	}
	[self removeFromSuperview];
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[activityIndicator stopAnimating];
}


-(void)onChangingDeviceOrientation {
	self.autoresizingMask = UIViewAutoresizingNone;
	[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"TermsBakcground.png"]]];

	webView.autoresizingMask = UIViewAutoresizingNone;
	closeButton.autoresizingMask = UIViewAutoresizingNone;
	webView.frame = CGRectMake(20, 45, self.frame.size.width-40, self.frame.size.height - 90);
	closeButton.frame = CGRectMake(webView.frame.origin.x+webView.frame.size.width-63, 4, 63, 36);
	[self.webView reload];
}

- (void)dealloc {
  if(self.webView){
		[self.webView stopLoading];
		self.webView.delegate = nil;
	}
	self.closeButton = nil;
	self.webView = nil;
	self.webURL = nil;
    [super dealloc];
}


@end
