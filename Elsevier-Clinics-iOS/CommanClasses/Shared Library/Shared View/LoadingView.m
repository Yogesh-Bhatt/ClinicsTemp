//
//  LoadingView.m
//  LiveLoop
//
//  Created by Vijay on 15/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//  

#import "LoadingView.h"


@implementation LoadingView

static UIActivityIndicatorView *activityIndicator;
static UIAlertView* alertView;

+(void)displayLoadingIndicator
{
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.hidesWhenStopped = YES;
	alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[alertView addSubview:activityIndicator];
	//NSLog(@"%f,%f---",alertView.frame.size.width,alertView.frame.size.height);
	activityIndicator.frame = CGRectMake(284/2 - 16, 218/4 - 16, 32.0, 32.0);
    [alertView show];
    [activityIndicator startAnimating];
}


+(void)removeLoadingIndicator
{
    //NSLog(@"Remove Alert");
	if (alertView != nil) {
		[alertView dismissWithClickedButtonIndex:0 animated:NO];
		[alertView release];
        alertView = nil;
	}
    
}


@end
