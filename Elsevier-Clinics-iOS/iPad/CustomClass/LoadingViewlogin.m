//
//  LoadingView.m
//  LiveLoop
//
//  Created by Ashish Awasthi on 15/12/09.
//  Copyright 2009 Kiwitech. All rights reserved.
//  

#import "LoadingViewlogin.h"

@implementation LoadingViewlogin

static UIActivityIndicatorView *loadingIndicator;
static UIView *panelView;
UILabel *titleLabel;

+(void)displayLoadingIndicator:(UIView *)parentView :(UIInterfaceOrientation)toOrentation
{
	
	if (!panelView) {
		panelView = [[UIView alloc] initWithFrame:CGRectMake(230, 700, 300, 100)];
	}
	panelView.backgroundColor = [UIColor clearColor];

	if(loadingIndicator == nil){
		loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		
	}
	
	loadingIndicator.frame = CGRectMake(30, 35, 37, 37);
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 200.0, 60.0)];
	titleLabel.textAlignment=UITextAlignmentLeft;
	titleLabel.numberOfLines = 1;
	titleLabel.text = @"Loading.....";
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:28];
	titleLabel.backgroundColor = [UIColor clearColor];
	[panelView addSubview:titleLabel];
	[titleLabel release];
	[panelView addSubview:loadingIndicator];
	if ([CGlobal isOrientationLandscape])
    {
		[self inSideIpadLandScape];
	}
    else
    {  
		[self inSideIpadPortrait];
	}
    [parentView addSubview:panelView];
	[loadingIndicator startAnimating];
}

+(void)setTitle:(NSString*)title {
	titleLabel.text = title;
}

+(void)removeLoadingIndicator
{
	if(loadingIndicator != nil){
		[loadingIndicator removeFromSuperview];
		[loadingIndicator stopAnimating];
		[loadingIndicator release];
		loadingIndicator = nil;
	}
	if (panelView) {
		[panelView removeFromSuperview];
		[panelView release];
		panelView = nil;
	}
}

+(void)inSideIpadPortrait
{
	panelView.frame = CGRectMake(360, 430, 300, 100);
	
}


+(void)inSideIpadLandScape
{
	panelView.frame = CGRectMake(470, 305, 400, 100);
	
}


@end
