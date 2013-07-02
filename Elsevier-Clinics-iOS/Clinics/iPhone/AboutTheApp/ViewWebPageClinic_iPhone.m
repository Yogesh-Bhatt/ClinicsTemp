    //
//  ViewWebPageClinic_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//




#import "ViewWebPageClinic_iPhone.h"
#import <QuartzCore/QuartzCore.h>

UIWebView *webPage;
@implementation ViewWebPageClinic_iPhone


@synthesize doneBtn;
@synthesize url;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {   
        [self NewView:frame];
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    }
    return self;
}


-(void)NewView:(CGRect)frm
{
    
	
	
    doneBtn=[[UIButton  alloc] initWithFrame:CGRectMake(frm.size.width -60, 20, 68, 38)];
    [doneBtn    setImage:[UIImage imageNamed:@"Loadingcancel.png"] forState:UIControlStateNormal];
	
    
    
	
    webPage=[[UIWebView alloc] initWithFrame:CGRectMake(10, 22, frm.size.width -20, frm.size.height -32)];
    webPage.delegate=self;
    [self addSubview:webPage];
	[self addSubview:doneBtn];
	
    actView=[[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width/2) -44, (frm.size.height/2)-26, 60, 40)];
    actView.backgroundColor=[UIColor blackColor];
    actView.layer.cornerRadius=5.0f;
    [webPage addSubview:actView];
    
	
    activityIndct=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndct.frame=CGRectMake(18, 8, 25, 25);
    [actView addSubview:activityIndct];
	
}

-(void) orientationChanged:(UIInterfaceOrientation )orientation
{
	
	
	if ( orientation == UIDeviceOrientationLandscapeLeft || orientation ==UIDeviceOrientationLandscapeRight)
	{
        [self setFrame:CGRectMake(20, 20, 984, 708)];
		// navBar.frame=CGRectMake(10, 10, self.frame.size.width -20, 50);
        doneBtn.frame=CGRectMake(self.frame.size.width -80, 30, 68, 38);
        webPage.frame=CGRectMake(10, 22, self.frame.size.width -20, self.frame.size.height -32);
        actView.frame=CGRectMake((self.frame.size.width/2) -44, (self.frame.size.height/2)-26, 88, 52);
	}
    else
    {
        [self setFrame:CGRectMake(20, 20, 728, 964)];
        //navBar.frame=CGRectMake(10, 10, self.frame.size.width -20, 50);
        doneBtn.frame=CGRectMake(self.frame.size.width -80, 30, 68, 38);
        webPage.frame=CGRectMake(10, 22, self.frame.size.width -20, self.frame.size.height -32);
        actView.frame=CGRectMake((self.frame.size.width/2) -44, (self.frame.size.height/2)-26, 88, 52);
    }
	// [self loadWeb];
}


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
-(void)abouthtml{
	NSString  *url1=[[NSBundle mainBundle]pathForAuxiliaryExecutable:@"legal.html"];
    NSURL *urlToRequest=  [NSURL fileURLWithPath:url1];
    NSURLRequest *request=[NSURLRequest requestWithURL:urlToRequest];
	[webPage loadRequest:request];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc
{
    //[navBar release];
    [actView release];
    [activityIndct release];
    [webPage release];
    [doneBtn release];
    [url release];
    [super dealloc];
}

@end
