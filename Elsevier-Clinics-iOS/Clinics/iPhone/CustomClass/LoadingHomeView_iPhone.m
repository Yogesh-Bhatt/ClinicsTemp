    //
//  LoadingHomeView_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingHomeView_iPhone.h"


@implementation LoadingHomeView_iPhone

static UIActivityIndicatorView *loadingIndicator;
static UIView *panelView;
UILabel *titleLabel;

+(void)displayLoadingIndicator:(UIView *)parentView :(UIInterfaceOrientation)toOrentation
{
	//parentView.backgroundColor = [UIColor greenColor];
    [CGlobal setFrameWith:parentView];
    
	panelView = [[UIView alloc] initWithFrame:CGRectMake(0, 190, 320, 100)];
	panelView.backgroundColor = [UIColor clearColor];
	
	if(loadingIndicator == nil){
		loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		
	}
	
	loadingIndicator.frame = CGRectMake((panelView.frame.size.width/2)-25, 40, 25, 25);
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 60.0)];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.numberOfLines = 2;
	titleLabel.text=nil;
	titleLabel.text=@"";
    
	
    titleLabel.text=@"Loading.....";
    
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:12];
	titleLabel.backgroundColor = [UIColor clearColor];
	[panelView addSubview:titleLabel];
	
	[panelView addSubview:loadingIndicator];
	[parentView addSubview:panelView];
	[loadingIndicator startAnimating];
}

+(void)chagengeMessageLoadingView:(ComeFromLoadingView)viewType{
    
    if (titleLabel) {
    switch (viewType) {
            
        case addClinics:
            
            titleLabel.text=@"Saving your followed Clinics...";
            break;
        case dwonloadissue:
            
            titleLabel.text = @"Loading....";
            break;
            
        case dwonloadupdateissue:
            
            titleLabel.text = @"Loading....";
            break;
            
        case dwonloadArticle:
            titleLabel.text = @"Loading....";
            break;
        case dwonloadArticleInPress:
            titleLabel.text = @"Loading....";
            break;
        case dwonloadAbstruct:
            
            titleLabel.text = @"Loading abstracts...";
            break;
            
            
        default:
            break;
    }
    
}
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
	
	if (titleLabel) {
		[titleLabel removeFromSuperview];
		[titleLabel release];
		titleLabel=nil;
	}
	if (panelView) {
		[panelView removeFromSuperview];
		[panelView release];
		panelView = nil;
	}
}



@end
