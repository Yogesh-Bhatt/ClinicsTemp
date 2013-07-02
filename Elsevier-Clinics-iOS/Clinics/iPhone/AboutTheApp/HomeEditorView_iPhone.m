    //
//  HomeEditorView_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeEditorView_iPhone.h"
#import "PopWebView.h"
#import "CGlobal.h"
#import "SettingDetailViewController.h"
#import "ClinicsAppDelegate.h"

@interface  HomeEditorView_iPhone (PrivateMethod) 
-(void)setNavigationBaronView;
@end

@implementation HomeEditorView_iPhone
@synthesize viewType;


-(void)viewDidLoad {  
	
	tabbarView=[[SettingViewTabBar_iPhone alloc] init];
	[self.view  addSubview:tabbarView.view];
	tabbarView.tabbar.frame=CGRectMake(0, 392, 320, 49);
	[self setNavigationBaronView];
    imgBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgportrait.png"]];
    imgBackground.tag = 222;
    CGRect rect = CGRectMake(0.0, 44, self.view.frame.size.width, self.view.frame.size.height-90);
    
    if(IS_WIDESCREEN){
        
        rect = CGRectMake(0.0, 44, self.view.frame.size.width, 512);
        
    }
    imgBackground.frame = rect;
    [self.view addSubview:imgBackground];	
	tabbarView.tabbar.selectedItem =[tabbarView.tabbar.items objectAtIndex:0];
    
    
    rect = CGRectMake(10, 55, 300, 356);
    
    if(IS_WIDESCREEN){
        
        rect = CGRectMake(0.0, 44, self.view.frame.size.width, 510);
        
    }
    myWebView = [[UIWebView alloc] initWithFrame:rect];
    myWebView.tag = 111;
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.delegate = self;
	[self.view addSubview:myWebView];
	myWebView.userInteractionEnabled = YES;

}


//************************************ Here add SubView On This View ************************

-(void)setNavigationBaronView{
	
	UIImageView  *m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(0, 0, 320, 44);
	m_imgView.image=[UIImage imageNamed:@"iPhone_NavBar.png"];
	[self.view addSubview:m_imgView];
	[m_imgView release];
	
   	m_lblTitle=[[UILabel alloc] init];
	m_lblTitle.frame=CGRectMake(0, 0, 320, 44);
	m_lblTitle.backgroundColor=[UIColor clearColor];
	m_lblTitle.font = [UIFont boldSystemFontOfSize:16.0];
	m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentCenter;
	m_lblTitle.text =@"About the app";
	[self.view addSubview:m_lblTitle];
	
	btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.tag = 333;
    [btnClose setImage:[UIImage imageNamed:@"iPhone_Home_btn.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(GoToHomeView:) forControlEvents:UIControlEventTouchUpInside];
	btnClose.frame = CGRectMake(260, 8, 46, 27);
    [self.view addSubview:btnClose];
	
    homeButton=[UIButton buttonWithType:UIButtonTypeCustom];
	homeButton.frame=CGRectMake(15, 8, 46, 27);
	[homeButton setBackgroundImage:[UIImage imageNamed:@"iPhone_Back_btn.png"] forState:UIControlStateNormal];
	[homeButton addTarget:self action:@selector(GoAtAboutUs:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:homeButton];
	
	
}

//************************************ Here We Select About us Option ************************

-(void)ClickOnAboutOption:(NSInteger)indexpath{
	
	if (indexpath==0) {
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"aboutUs_iPhone" ofType:@"html"]isDirectory:NO]]];        
		m_lblTitle.text = @"About The Clinics";
		
	} 
	else if(indexpath == 1) {
		m_lblTitle.text= @"Terms and Conditions";
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"]isDirectory:NO]]];        
        
    }
		
}
- (id)initWithViewtype:(DetailTypeView)viewType {
    
	self = [super init];
    if (self) {
	}
    return self;
}


//************************************ Here we Check Link tab On webView ************************

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	if(navigationType ==UIWebViewNavigationTypeLinkClicked)
	{
		NSArray *urlCoponents=[[request.URL absoluteString] componentsSeparatedByString:@"/"];
		RELEASE(webURL);
        webURL = [[NSString stringWithFormat:@"%@",[request.URL absoluteString]] retain];
        
		if([[urlCoponents objectAtIndex:0]isEqualToString:@"http:"]) {
            
            [self pushToWebView:webURL];
            return  FALSE;
        }
    }            
    return TRUE;
}


//************************************ Here Animation Transform if tab any Link in webView ************************

-(void)showDescriptionView
{    	
	btnClose.userInteractionEnabled=FALSE;
	tabbarView.tabbar.userInteractionEnabled=FALSE;
	homeButton.userInteractionEnabled=FALSE;
	webview.transform = CGAffineTransformMakeScale(0.001, 0.001);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4/1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceFirstAnimationStopped)];
	webview.transform = CGAffineTransformMakeScale(1.1, 1.1);
	[UIView commitAnimations];	
	
}


//************************************ Here Animation UIView Animation Start  ************************

- (void)bounceFirstAnimationStopped {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceSecondAnimationStopped)];
	webview.transform = CGAffineTransformMakeScale(0.98, 0.98);
	[UIView commitAnimations];
    
    // ******************* load link On webView*************************
	[webview loadWeb];
}

//************************************ Here Animation Transform if Close ************************

-(void)hideDescriptionView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.1];
	
	webview.transform = CGAffineTransformMakeScale(0.25, 0.25f);
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeSubViewsis)];
	[UIView commitAnimations];	
	
    
}

//************************************ Here Animation UIView Animation Start  ************************

- (void)bounceSecondAnimationStopped {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	webview.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

//************************************ Remove web view After Close ************************

-(void)removeSubViewsis 
{

	btnClose.userInteractionEnabled=TRUE;
	tabbarView.tabbar.userInteractionEnabled=TRUE;
	homeButton.userInteractionEnabled=TRUE;
	
    if (webview)
    {   
		webview.alpha=0.0;
        [webview removeFromSuperview];
		[webview release];
		webview=nil;
		
		
    }
}

#pragma mark--
#pragma mark----Opening Web Page Methods------

//************************************Tab On link WebView Show This View    ************************

-(void)pushToWebView:(NSString *)clickUrl
{
	webview=[[ViewWebPageClinic alloc] initWithFrame:CGRectMake(10, 20, 300,390)];
    webview.backgroundColor=[UIColor darkTextColor];
    [webview.doneBtn addTarget:self action:@selector(hideDescriptionView) forControlEvents:UIControlEventTouchUpInside];
	webview.url=clickUrl;
	[self.view addSubview:webview];
    //***************** bounce View ********************************
    [self showDescriptionView];

}

-(void)removeSubViews 
{
    if(myWebView) {
        [myWebView stopLoading];
        myWebView.delegate = nil;
    }
    
}

//************************************ Go back   ************************

-(void)GoAtAboutUs:(id)sender{
    
	[self.navigationController popViewControllerAnimated:YES];
}

//************************************ tab on Home Button Here Go Home View  ************************

-(void)GoToHomeView:(id)sender
{
	[self.view removeFromSuperview];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.m_nCurrentTabTag = kTAB_CLINICS;
	appDelegate.h_TabBarPrevTag=kTAB_AboutApp;
	[appDelegate.rootView_iPhone  addViewController];
}

- (void)dealloc {
    
	if (tabbarView) {
		RELEASE(tabbarView);
	}
	if (m_lblTitle) {
		RELEASE(m_lblTitle);
		
	}
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(myWebView) {
        [myWebView stopLoading];
         myWebView.delegate = nil;
    }
   	RELEASE(imgBackground);
	RELEASE(webURL);
	RELEASE(webURL);
	RELEASE(myWebView);
	
    [super dealloc];
}


@end