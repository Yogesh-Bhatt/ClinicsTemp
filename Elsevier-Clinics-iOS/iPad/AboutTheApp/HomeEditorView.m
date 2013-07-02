//
//  HomeEditorView.m
//  Elsevier
//
//  Created by Ashish Awasthi on 20/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeEditorView.h"
#import "ViewWebPage.h"
#import "PopWebView.h"
#import "CGlobal.h"
#import "SettingDetailViewController.h"
#import "SharePopOverView.h"
#import "FeedbackView.h"

@implementation HomeEditorView
@synthesize viewType;

-(void)viewDidLoad {   
    
     ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.homeEditorView = self;
	m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(-1, 0, 322, 44);
	m_imgView.image=[UIImage imageNamed:@"WelcomeUser.png"];
	[self.view addSubview:m_imgView];
	
	m_lblTitle=[[UILabel alloc] init];
	m_lblTitle.frame=CGRectMake(0, 0, 320, 44);
	m_lblTitle.backgroundColor=[UIColor clearColor];
	m_lblTitle.font = [UIFont boldSystemFontOfSize:20.0];
    m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentCenter;
	[self.view addSubview:m_lblTitle];
	[m_lblTitle release];
	
	if ([CGlobal isOrientationLandscape]) {
		m_lblTitle.frame=CGRectMake(2, 0, 704, 44);
		m_imgView.frame=CGRectMake(2, 0, 704, 44);
		m_imgView.image=[UIImage imageNamed:@"704.png"];
	}else {
		m_lblTitle.frame=CGRectMake(2, 0, 768, 44);
		m_imgView.frame=CGRectMake(2, 0, 768, 44);
		m_imgView.image=[UIImage imageNamed:@"768.png"];
	}
	
	
    imgBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgportrait.png"]];
    imgBackground.tag = 222;
    imgBackground.frame=CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:imgBackground];	


    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(40, 100, 688, 1024- 170)];
    myWebView.tag = 111;
	[self.view addSubview:myWebView];
	myWebView.userInteractionEnabled = YES;

	UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.tag = 333;
    [btnClose setImage:[UIImage imageNamed:@"BtnHome.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnCloseClicked:) forControlEvents:UIControlEventTouchUpInside];
     btnClose.frame = CGRectMake(640, 7, 60, 30);
    [self.view addSubview:btnClose];
	UIButton *btnPopOver = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPopOver.tag = 444;
    [btnPopOver setImage:[UIImage imageNamed:@"BtnPopOver.png"] forState:UIControlStateNormal];
    [btnPopOver addTarget:self action:@selector(showPopOver) forControlEvents:UIControlEventTouchUpInside];
	btnPopOver.frame = CGRectMake(20, 7, 60, 30);
    [self.view addSubview:btnPopOver];
	[self ClickOnAboutOption:0];
		
}

-(void)ClickOnAboutOption:(NSInteger)indexpath{
	
	
	 if (indexpath==0) {
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForAuxiliaryExecutable:@"Aboutus.html"]]]];        
		m_lblTitle.text = @"About The Clinics";
		
	} 
	else if(indexpath == 1) {
       m_lblTitle.text= @"Terms and Conditions";
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"terms.html"]]]];        
        
    }
	
   [self changeOrientaionISHomeEditorView]; 
	
}

-(void)showFeedbackView{
    
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    FeedbackView   *feedback=[[FeedbackView alloc] initWithNibName:@"FeedbackView" bundle:nil];
	feedback.viewType=FeedbackMailView;
	[self  presentModalViewController:feedback animated:YES];
	[feedback release];
}

- (id)initWithViewtype:(DetailTypeView)viewType {
    
	self = [super init];
    if (self) {
       }
    return self;
}




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	if(navigationType ==UIWebViewNavigationTypeLinkClicked)
	{
		NSArray *urlCoponents=[[request.URL absoluteString] componentsSeparatedByString:@"/"];
		RELEASE(webURL);
        webURL = [[NSString stringWithFormat:@"%@",[request.URL absoluteString]] retain];
        
		if([[urlCoponents objectAtIndex:0]isEqualToString:@"http:"]) {
            
            [self pushToWebView];
            return  FALSE;
        }
    }            
    return TRUE;
}

-(void)pushToWebView {
	
	RELEASE(viewWebPage);
	UIViewController* controller = [[UIViewController alloc] initWithNibName:@"PopWebView" bundle:nil];
	viewWebPage = (PopWebView *)[[controller view] retain];
	[controller release];
	
    if([CGlobal isOrientationPortrait]) {
		if(isResizeButtonShrink)
			viewWebPage.frame = CGRectMake(0, 0, 1024, 768);
		else
			viewWebPage.frame = CGRectMake(0, 0, 1024, 768-90);
		    }else {
				if(isResizeButtonShrink)
					viewWebPage.frame = CGRectMake(0, 0, 768, 1024);
				else
					viewWebPage.frame = CGRectMake(0, 0, 768, 1024-90);
				
         }
    
    viewWebPage.webURL = webURL;
	[viewWebPage.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:viewWebPage.webURL]]];
    [self.view  addSubview:viewWebPage];
	[self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
    
}



-(void)removeSubViews 
{
    if(myWebView) {
        [myWebView stopLoading];
        myWebView.delegate = nil;
    }
    
}


-(void)btnCloseClicked:(id)sender
{
	[self.view removeFromSuperview];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.m_nCurrentTabTag = kTAB_CLINICS;
	appDelegate.h_TabBarPrevTag=kTAB_AboutApp;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab Button Pressed" object:self];
	
}

- (void) dismissPopoover
{
    if(m_popoverController != nil)
    {
        if([m_popoverController isPopoverVisible])
        [m_popoverController dismissPopoverAnimated:YES];
        RELEASE(m_popoverController);
    }
    if(m_sharePopOver != nil)
    {
        if([m_sharePopOver isPopoverVisible])
            [m_sharePopOver dismissPopoverAnimated:YES];
        RELEASE(m_sharePopOver);
    }

		
}
	
- (void)showPopOver
	{
		[self dismissPopoover];
	
		AboutAppListViewController *	aboutAppListView = [[AboutAppListViewController alloc] initWithNibName:@"AboutAppListViewController" bundle:nil];
		m_popoverController = [[UIPopoverController alloc] initWithContentViewController:aboutAppListView];
		m_popoverController.delegate = self;
		[m_popoverController setPopoverContentSize:CGSizeMake(320.0, 768.0)];
		[m_popoverController presentPopoverFromRect:CGRectMake(-100.0, -740.0 , 320.0, 768.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		RELEASE(aboutAppListView);
		
	}


-(void)changeOrientaionISHomeEditorView{
    
	[self dismissPopoover];
	
    if ([CGlobal isOrientationPortrait]) {
		self.view.frame = CGRectMake(0, 0, 768, 1024);
		m_lblTitle.frame=CGRectMake(0, 0, 768, 44);
		m_imgView.frame=CGRectMake(0, 0, 768, 44);
		m_imgView.image=[UIImage imageNamed:@"768.png"];
		imgBackground.frame = CGRectMake(2, 44, self.view.frame.size.width, self.view.frame.size.height);
		myWebView.frame = CGRectMake(22,65, 724, 940);
		[self.view viewWithTag:333].frame = CGRectMake(690, 7, 60, 30);	
		[self.view viewWithTag:444].hidden=FALSE;
		imgBackground.image = [UIImage imageNamed:@"bgportrait.png"];
		
		
	}else {
		
		self.view.frame = CGRectMake(320, 0, 704, 706);
		m_lblTitle.frame=CGRectMake(1, 0, 704, 44);
		m_imgView.frame=CGRectMake(1, 0, 704, 44);
		m_imgView.image=[UIImage imageNamed:@"704.png"];
		imgBackground.frame = CGRectMake(1, 44, self.view.frame.size.width, self.view.frame.size.height);
		myWebView.frame = CGRectMake(22,65, 652, 700);
        [self.view viewWithTag:333].frame = CGRectMake(630, 7, 60, 30);	
		[self.view viewWithTag:444].hidden=TRUE;
		imgBackground.image = [UIImage imageNamed:@"bgportrait.png"];
    }

   
}


-(void)showSharePopOver{
    
    SharePopOverView   *shareView = [[SharePopOverView alloc] init];
    shareView.delegate = self;
    m_sharePopOver = [[UIPopoverController alloc] initWithContentViewController:shareView];
    [m_sharePopOver setPopoverContentSize:CGSizeMake(282, 150)];
    if ([CGlobal isOrientationPortrait]) 
        [m_sharePopOver presentPopoverFromRect:CGRectMake(140, 780 ,282, 150) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    else
        [m_sharePopOver presentPopoverFromRect:CGRectMake(-180, 700 ,282, 150) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];    
    
    RELEASE(shareView);
    
}


- (void)dealloc {
  
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(myWebView) {
        [myWebView stopLoading];
        myWebView.delegate = nil;
    }
    [m_imgView release];
   	RELEASE(imgBackground);
	RELEASE(viewWebPage);
	RELEASE(myWebView);
  
  
    [super dealloc];
}


@end
