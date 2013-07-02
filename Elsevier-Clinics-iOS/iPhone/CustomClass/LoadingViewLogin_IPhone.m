    //
//  LoadingViewLogin_IPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingViewLogin_IPhone.h"
#import <QuartzCore/QuartzCore.h>
@implementation LoadingViewLogin_IPhone
static UIActivityIndicatorView *loadingIndicator;
static UIView *panelView;
UILabel *titleLabel;

+(void)displayLoadingIndicator:(UIView *)parentView :(UIInterfaceOrientation)toOrentation
{
	
	if (!panelView) {
		panelView = [[UIView alloc] initWithFrame:CGRectMake(210, 242, 40, 30)];
	}
	panelView.backgroundColor = [UIColor blackColor];
	panelView.layer.cornerRadius=5.0f;
	
	if(loadingIndicator == nil){
		loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		
	}
	
	loadingIndicator.frame = CGRectMake(7, 4, 25, 25);

	[panelView addSubview:loadingIndicator];
	
    [parentView addSubview:panelView];
	[loadingIndicator startAnimating];
}

+(void)setTitle:(NSString*)title {
	//titleLabel.text = title;
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


@end
