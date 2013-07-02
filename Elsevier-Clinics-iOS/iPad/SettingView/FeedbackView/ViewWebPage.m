//
//  ViewWebPage.m
//  EWT
//
//  Created by Ashish Awasthi on 28/07/11.
//  Copyright 2011 Kiwitech corp. All rights reserved.
//

#import "ViewWebPage.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"


UIWebView *webPage;
@implementation ViewWebPage
@synthesize doneBtn;
@synthesize url;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {   
        [self newView:frame];
       
    }
    return self;
}


-(void)newView:(CGRect)frm
{
    backGroundView = [[UIView alloc] init];
    [self addSubview:backGroundView];
    
    doneBtn=[[UIButton  alloc] initWithFrame:CGRectMake(frm.size.width -90, 10, 63, 36)];
    [doneBtn    setImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [backGroundView addSubview:navBar];
    [backGroundView addSubview:doneBtn];
    backGroundView.backgroundColor = [UIColor darkTextColor];

    webPage=[[UIWebView alloc] initWithFrame:CGRectMake(10, 50, frm.size.width -20, frm.size.height -60)];
    webPage.delegate=self;
    [backGroundView addSubview:webPage];

    actView=[[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width/2) -44, (frm.size.height/2)-26, 88, 52)];
    actView.backgroundColor=[UIColor blackColor];
    actView.layer.cornerRadius=5.0f;
    [webPage addSubview:actView];
 
    activityIndct=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndct.frame=CGRectMake(22, 4, 44, 44);
    [actView addSubview:activityIndct];
  
}


-(void)networkConnection
{
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
	{
        actView.hidden=YES;
        [activityIndct stopAnimating];
		UIAlertView *baseAlert = [[UIAlertView alloc] 
                                  initWithTitle:@"No Network" 
                                  message:@"A network connection is required. Please verify your network settings and try again." 
                                  delegate:nil cancelButtonTitle:nil 
                                  otherButtonTitles:@"OK", nil];	
        [baseAlert show];
        [baseAlert release];
		
	}
	else 
    {
        actView.hidden=YES;
        [activityIndct  stopAnimating];
		//NSLog(@"Network Working");
	}   
}

-(void) orientationChanged:(UIInterfaceOrientation )orientation
{
    CGRect frame;
    
    if([CGlobal isOrientationPortrait])
    {
        if(isResizeButtonShrink)
            frame = CGRectMake(20, 20, 728, 964);
        else
           frame = CGRectMake(20, 20, 728, 964-90);

        doneBtn.frame=CGRectMake(frame.size.width- 80, 12, 68, 38);
        webPage.frame=CGRectMake(10, 60,frame.size.width -20, frame.size.height - 70);
        actView.frame=CGRectMake((frame.size.width/2) -44, (frame.size.height/2)-26, 88, 52);
    }
    else 
    {
        if(isResizeButtonShrink)
            frame = CGRectMake(20, 20, 984, 700);
        else
            frame = CGRectMake(20, 20, 984, 620);
        
        doneBtn.frame=CGRectMake(frame.size.width -80, 12, 68, 38);
        webPage.frame=CGRectMake(10, 60, frame.size.width - 20, frame.size.height - 70);     
        actView.frame=CGRectMake((frame.size.width/2) - 44, (frame.size.height/2)- 26, 88, 52);
    }
    backGroundView.frame = frame;
    [webPage reload];
    
}


// ******************* load link On webView*************************
-(void)loadWeb
{
    NSURL *urlToRequest=[NSURL URLWithString:url];
    NSURLRequest *request=[NSURLRequest requestWithURL:urlToRequest];
    [webPage loadRequest:request];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    actView.hidden=NO;
    [activityIndct startAnimating];    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    actView.hidden=YES;
    [activityIndct stopAnimating];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    actView.hidden=YES;
    [activityIndct stopAnimating];    
}

- (void)dealloc
{
    [navBar release];
    [actView release];
    [activityIndct release];
    
    if(webPage){
        [webPage stopLoading];
        webPage.delegate = nil;
    }
    RELEASE(webPage);
    RELEASE(backGroundView);
    self.url = nil;
    self.doneBtn = nil;
    [super dealloc];
}

@end
