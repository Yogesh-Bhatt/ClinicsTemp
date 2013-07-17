//
//  WebViewController.m
//  Clinics
//
//  Created by Ashish Awasthi on 05/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "CGlobal.h"
#import "CustomScrollView.h"
#import "TextViewPopOver.h"
#import "DownloadController.h"
#import "HighLightWebView.h"

#define kSearchButtonUnSelectedKey 100
#define kSearchButtonSelectedKey  101

@implementation WebViewController
@synthesize m_ariticleData;

@synthesize m_articleDataHolder;
@synthesize textType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    RELEASE(m_articleDataHolder);
    if([m_webView isLoading]){
        [m_webView stopLoading];
        m_webView.delegate = nil;
    }
    [m_webView release];
    RELEASE(sectionValueStr);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    iBookPdfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iBookPdfBtn setImage:[UIImage imageNamed:@"addPdfIbook.png"] forState:UIControlStateNormal];
    [iBookPdfBtn addTarget:self action:@selector(tabOnAddIBookButton:) forControlEvents:UIControlEventTouchUpInside];
    iBookPdfBtn.hidden = TRUE;
    iBookPdfBtn.frame  =  CGRectMake(610,6, 67, 30);
    [self.view addSubview:iBookPdfBtn];
    
	hideMenuOption=FALSE;
	addNotesView=[[AddNotesView alloc]initWithFrame:CGRectMake(100.0, -400.0,378.0 , 325.0)];
	[addNotesView setCallerDelegate:self];
	[self.view addSubview:addNotesView];
	
	NSString *lastCss =[[NSUserDefaults standardUserDefaults]objectForKey:@"LastCss"];
	if (lastCss == nil) {
		[[NSUserDefaults standardUserDefaults]setObject:@"5" forKey:@"LastCss"];
	}
	optionImageView.hidden = TRUE;
	searchButton.tag = kSearchButtonUnSelectedKey;
	m_lblTitle.frame=CGRectMake(0, 0, 768, 44);
	optionImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"TableSectionBar.png"]];
	bacKImageView=[[UIImageView alloc]init];
	if ([CGlobal isOrientationLandscape]) {
		bacKImageView.image = [UIImage imageNamed:@"article_bg-L.png"];
			
	}
	else {
		
		bacKImageView.image = [UIImage imageNamed:@"issue_bg.png"];

	}
	[self.view addSubview:bacKImageView];
	[bacKImageView release];

	for (UIView *subview in searchBar.subviews) {
		if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
			[subview removeFromSuperview];
			searchBar.backgroundColor=[UIColor clearColor];
			break;
		}
	}
	
	
	 aritcleInfoID= m_articleDataHolder.sArticleInfoId;
	
	m_lblTitle.textAlignment=UITextAlignmentCenter;;
    m_lblTitle.text = @"Article Details";
	searchBar.tag=100;
	m_webView =[[HighLightWebView alloc] init];
	m_webView.delegate=self;
	m_webView.scalesPageToFit=YES;
	m_webView.backgroundColor=[UIColor clearColor];
	[self.view addSubview:m_webView];
	[self.view bringSubviewToFront:m_activity];
	
	m_btnSearch.tag  = kSearchButtonUnSelectedKey;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageLoginButton) name:@"changeImageLoginButton" object:nil];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	appDelegate.authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",appDelegate.seletedClinicID]];
	if(appDelegate.authentication == isOne)
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
	else 
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogin.png"] forState:UIControlStateNormal];

    m_BackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:m_webView action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = nil;
	
	menuOBJ = [[MenuOptionView alloc] initWithFrame:CGRectMake(0, 40, 1024, 68.0) Buttons:nil];
	menuOBJ.hidden=TRUE;
	menuOBJ.backgroundColor = [UIColor whiteColor];
	menuOBJ.delegate = (id)self;
	
	
	sliderView=[[CustomSliderView alloc]initWithFrame:CGRectMake(743,200 ,142.0 , 1024)];
	sliderView.hidden=TRUE;
	
	sliderView.callerDelegate = (id)self;
	sliderView.userInteractionEnabled = YES;
	
	[self.view addSubview:sliderView];
	[self.view addSubview:menuOBJ];
   
	if (textType == PdfText) {
		[self openPDFfile:m_articleDataHolder];
		
	}
	else if(textType == FullText){
		[ self openHTMLfile:m_articleDataHolder];
	}
	else if(textType == AbstractText){
		
		[self openAbstrauct:m_articleDataHolder];
				
		
	}

    sectionValueStr =  [[NSString alloc] init];
}


-(void)showWebViewSeletedOption {
    
	thisMenuController = [UIMenuController sharedMenuController];
	UIMenuItem *thirdMenu = [[[UIMenuItem alloc] initWithTitle:@"Add Note" action:@selector(highlightNotes)] autorelease];
	[thisMenuController setMenuItems:[NSArray arrayWithObjects:thirdMenu, nil]];
	[thisMenuController setMenuVisible:NO animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
	
	ClinicsAppDelegate  *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.aritcleListView = TRUE;
	appDelegate.webViewController=self;
	[self showWebViewSeletedOption];
}

-(void)viewWillDisappear:(BOOL)animated{
	ClinicsAppDelegate  *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.openHTMLADDNoteOpenView = FALSE;
		if (sliderView) {
			[sliderView removeFromSuperview];
			[sliderView release];
			sliderView=nil;
		}
 [[UIMenuController sharedMenuController] setMenuItems:nil];
	appDelegate.webViewController=self;
}

-(void)openHTMLfile:(ArticleDataHolder *)articleDataHolder{
	
     iBookPdfBtn.hidden = TRUE;
	if (imageWebView) {
		[self clickOncancelButton];
	}
	
	m_btnSearch.hidden=FALSE;
	if ([CGlobal isOrientationLandscape]) {
		if (m_btnSearch.tag == kSearchButtonSelectedKey) {
			bacKImageView.frame = CGRectMake(0, 155, 1024, 729);
			m_webView.frame=CGRectMake(30, 165, 964, 600);
			
		}else {
			bacKImageView.frame = CGRectMake(0, 49, 1024, 729);
			m_webView.frame=CGRectMake(30, 60, 964, 658);
		}
		m_webView.hidden=FALSE;
		menuOBJ.hidden=FALSE;
		sliderView.hidden=TRUE;
	}
	else {
	
		if (m_btnSearch.tag == kSearchButtonSelectedKey) {
			bacKImageView.frame = CGRectMake(0, 90, 768, 939);
			m_webView.frame=CGRectMake(30, 95, 704, 925);
			
		}else {
			bacKImageView.frame = CGRectMake(0, 49, 768, 939);
			m_webView.frame=CGRectMake(30, 55, 704, 954);	
		}
		
		
		m_webView.hidden=FALSE;
		menuOBJ.hidden=TRUE;
		sliderView.hidden=FALSE;
	}

	if (pdfhomeview) {
		[pdfhomeview removeFromSuperview];
		[pdfhomeview release];
		pdfhomeview=nil;
	}
	
	articleID=0;
	resizeButton.tag=100;
	articleID=  articleDataHolder.nArticleID;
	aritcleInfoID= articleDataHolder.sArticleInfoId;
	doiLinkStr= articleDataHolder.doi_Link;
	DatabaseConnection *database = [DatabaseConnection sharedController];
    ArticleDataHolder *articleDataHolder1 = [[database loadArticleInfo:articleID] retain]; 
    if (articleDataHolder1.nBookmark == isOne){
		[bookmarksBtn setImage:[UIImage imageNamed:@"bookmark_clicked.png"] forState:UIControlStateNormal];
	}// BtnBookmark.png
    else  {
		[bookmarksBtn setImage:[UIImage imageNamed:@"bookmark.png"] forState:UIControlStateNormal];
	}
	
	if (articleDataHolder1) {
		[articleDataHolder1 release];
		articleDataHolder1 =nil;
	}
	
	for(UIView  *View1 in [menuOBJ subviews]){
		if ([View1 isKindOfClass:[CustomScrollView class]]) {
			
			for(UIView  *View2 in [View1 subviews]){
				[View2 removeFromSuperview];
			}
		}
		
	}
	if (articalSectioinDataList) {
		[articalSectioinDataList release];
		articalSectioinDataList=nil;
	}
	articalSectioinDataList = [[database  loadRefeenceInfoHTMl:articleDataHolder.sArticleInfoId] retain];
	[menuOBJ addOptions:articalSectioinDataList];
	[sliderView initSlider:articalSectioinDataList];
	isThisAbstract=FALSE;
	textType = FullText;
	ariticleTitlelbl.text=articleDataHolder.sArticleTitle;

	NSString * lastCss=[[NSUserDefaults standardUserDefaults]objectForKey:@"LastCss"];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];

	NSString *cssPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/style.css",aritcleInfoID,aritcleInfoID]];
     NSString    *newCss = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"style%d",[lastCss intValue]]  ofType: @"css"] encoding:NSUTF8StringEncoding error:nil];
	[newCss writeToFile:cssPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	NSString *htmlFilePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/main.html",aritcleInfoID,aritcleInfoID]];
	NSURL *url = [NSURL fileURLWithPath:htmlFilePath];
	[m_webView loadRequest:[NSURLRequest requestWithURL:url]];
	firstHeadingId = nil;
}


-(void)openPDFfile:(ArticleDataHolder *)articleDataHolder{
	
    iBookPdfBtn.hidden = FALSE;
	if (imageWebView) {
		[self clickOncancelButton];
	}
	
	m_btnSearch.hidden=TRUE;
	optionImageView.hidden=TRUE;
	m_btnSearch.tag = kSearchButtonUnSelectedKey;
	
	ariticleTitlelbl.text=articleDataHolder.sArticleTitle;
	doiLinkStr= articleDataHolder.doi_Link;
	textType = PdfText;
	
	if (pdfhomeview) {
		[pdfhomeview removeFromSuperview];
		[pdfhomeview release];
		pdfhomeview=nil;
	}

	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *htmlFilePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/main.pdf",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
	m_webView.hidden=YES;
	menuOBJ.hidden=TRUE;
	sliderView.hidden=TRUE;

	pdfhomeview=[[PDFHomeView alloc]init];
	
	if (self.interfaceOrientation==UIInterfaceOrientationPortrait||self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown)
	{
		pdfhomeview.frame=CGRectMake(20, 50, 728, 930);
	}
	else {
		pdfhomeview.frame=CGRectMake(50, 50, 924, 700);
	}
	 m_pdfPath = [htmlFilePath copy];
	pdfhomeview.backgroundColor = [UIColor clearColor];
	[pdfhomeview loadPdfForFileName:(ArticleData*)htmlFilePath];
	[self.view addSubview:pdfhomeview];
}

-(void)openAbstrauct:(ArticleDataHolder *)articleDataHolder{
    
	 iBookPdfBtn.hidden = TRUE;
	if (imageWebView) {
		[self clickOncancelButton];
	}
	isThisAbstract=TRUE;
	m_btnSearch.hidden=FALSE;
	textType = AbstractText;
	resizeButton.tag=100;
	m_webView.hidden=FALSE;
	menuOBJ.hidden=TRUE;
	sliderView.hidden=TRUE;
	if (pdfhomeview) {
		[pdfhomeview removeFromSuperview];
		[pdfhomeview release];
		pdfhomeview=nil;
	}
	articleID=  articleDataHolder.nArticleID;
	aritcleInfoID= articleDataHolder.sArticleInfoId;
	doiLinkStr= articleDataHolder.doi_Link;
	DatabaseConnection *database = [DatabaseConnection sharedController];
    ArticleDataHolder *articleDataHolder1 = [[database loadArticleInfo:articleID] retain]; 
    if (articleDataHolder1.nBookmark == isOne){
		[bookmarksBtn setImage:[UIImage imageNamed:@"bookmark_clicked.png"] forState:UIControlStateNormal];
	}
    else  {
		[bookmarksBtn setImage:[UIImage imageNamed:@"bookmark.png"] forState:UIControlStateNormal];
	}
	if (articleDataHolder1) {
		[articleDataHolder1 release];
		articleDataHolder1 =nil;
	}
	
	if ([CGlobal isOrientationLandscape]) {
		if (m_btnSearch.tag == kSearchButtonSelectedKey) {
			CGRect view1Frame = optionImageView.frame;
		    view1Frame.origin.y = 49;
			optionImageView.frame = view1Frame;
			bacKImageView.frame = CGRectMake(0,90, 1024, 729);
			m_webView.frame=CGRectMake(30, 95, 964, 600);

		}else {
			bacKImageView.frame = CGRectMake(0, 49, 1024, 729);
			m_webView.frame=CGRectMake(30, 60, 964, 658);
		}

		
	}
	else {
		if (m_btnSearch.tag == kSearchButtonSelectedKey) {
			bacKImageView.frame = CGRectMake(0, 90, 768, 939);
			m_webView.frame=CGRectMake(30, 95, 704, 925);

		}else {
			bacKImageView.frame = CGRectMake(0, 49, 768, 939);
			m_webView.frame=CGRectMake(30, 55, 704, 954);	
		}

	}

	NSString * lastCss=[[NSUserDefaults standardUserDefaults]objectForKey:@"LastCss"];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *htmlFilePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_abs/%@_abs/main_abs.html",aritcleInfoID,aritcleInfoID]];
	NSString *cssPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_abs/%@_abs/style.css",aritcleInfoID,aritcleInfoID]];
	NSString    *newCss = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"style%d",[lastCss intValue]]  ofType: @"css"] encoding:NSUTF8StringEncoding error:nil];
	[newCss writeToFile:cssPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	NSURL *url = [NSURL fileURLWithPath:htmlFilePath];
	[m_webView loadRequest:[NSURLRequest requestWithURL:url]];
    firstHeadingId = nil;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
	m_webView.delegate=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    [self handleIosVersionOrieantion];
    
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;{
    [self handleIosVersionOrieantion];
}

-(void)handleIosVersionOrieantion{
    
    
    
    
    [self dismissPopooverTeXtIncrease];
    
	DownloadController *downloadController=[DownloadController sharedController];
	[downloadController ChangeFramewhenRootateDwonloadingStart];
	if ([CGlobal isOrientationLandscape]) {
        iBookPdfBtn.frame  =  CGRectMake(870,6, 67, 30);
		if (articleListView)
            articleListView.backLoding.frame=CGRectMake(0, 0, 1024, 768);
		
		m_imgView.frame=CGRectMake(0, 0, 1024, 44);
		m_imgView.image=[UIImage imageNamed:@"768.png"];
	}else {
        iBookPdfBtn.frame  =  CGRectMake(610,6, 67, 30);
		if (articleListView)
            articleListView.backLoding.frame=CGRectMake(0, 0, 768, 1024);
		articleListView.backLoding.frame=CGRectMake(0, 0, 768, 1024);
		m_imgView.frame=CGRectMake(0, 0, 768, 44);
		m_imgView.image=[UIImage imageNamed:@"768.png"];
	}
	
	if ([CGlobal isOrientationLandscape]){
		m_lblTitle.frame=CGRectMake(0, 0, 1024, 44);
		if (m_btnSearch.tag == kSearchButtonSelectedKey) {
			CGRect view1Frame = optionImageView.frame;
		    view1Frame.origin.y = 105;
			optionImageView.frame = view1Frame;
			bacKImageView.frame = CGRectMake(0, 155, 1024, 590);
			m_webView.frame=CGRectMake(30, 165, 964, 560);
			
			if(textType == AbstractText){
				
				CGRect view1Frame = optionImageView.frame;
				view1Frame.origin.y = 45;
				optionImageView.frame = view1Frame;
				bacKImageView.frame = CGRectMake(0, 90, 1024, 630);
				m_webView.frame=CGRectMake(30, 95, 964, 620);
				
            }
            
			
        } // end searbar
        else {
            bacKImageView.frame = CGRectMake(0, 105, 1024, 630);
            m_webView.frame=CGRectMake(30, 130, 964, 600);
            if(textType == PdfText){
                
				bacKImageView.frame = CGRectMake(0, 45, 1024, 729);
				m_webView.frame=CGRectMake(30, 60, 964, 600);
				
            }
            
            if(textType == AbstractText){
                bacKImageView.frame = CGRectMake(0, 49, 1024, 690);
                m_webView.frame=CGRectMake(30, 60, 964, 660);
                
            }
            
        }
		
		
		if (imageWebView) {
            imageWebView.frame = CGRectMake(0 ,45,1024 ,730);
            [croosBtn setFrame:CGRectMake(990, 0, 28, 28)];
		}
		if(sliderView){
            sliderView.hidden=TRUE;
        }
		if(textType == FullText)
            menuOBJ.hidden=FALSE;
		else
            menuOBJ.hidden=TRUE;
        
		pdfhomeview.frame=CGRectMake(50, 50, 924, 700);
        
    }  //*************** end landscape condition***************
	
	
	else{
		m_lblTitle.frame=CGRectMake(0, 0, 768, 44);
		if (m_btnSearch.tag == kSearchButtonSelectedKey) {
			CGRect view1Frame = optionImageView.frame;
			view1Frame.origin.y = 45;
			optionImageView.frame = view1Frame;
			bacKImageView.frame = CGRectMake(0, 90, 768, 900);
			m_webView.frame=CGRectMake(30, 95, 704, 890);
			
        }
        else {
            bacKImageView.frame = CGRectMake(0, 49, 768, 939);
            m_webView.frame=CGRectMake(30, 65, 704, 910);
			
        } // *************** end search bar***************
		
		
		if (imageWebView) {
            imageWebView.frame = CGRectMake(0 ,45,768 ,1024);
            [croosBtn setFrame:CGRectMake(740, 0, 28, 28)];
        }
		if(sliderView){
            menuOBJ.hidden=TRUE;
			if(textType == AbstractText)
                sliderView.hidden=TRUE;
            else
				sliderView.hidden=TRUE;
            
        }
		
		if(textType == FullText)
			sliderView.hidden=FALSE;
		else
			sliderView.hidden=TRUE;
		pdfhomeview.frame=CGRectMake(20, 50, 728, 930);
    }//*************** end landscape portratie***************
    
	[m_webView reload];
    
	[pdfhomeview changePdfOrientation:self.interfaceOrientation];
	
	[self dismissPopOver];
    [self jumpToSection:sectionValueStr];
    [self changeAddViewKeybordComeLandScape];
}

// ios 6  Orieation methods.........

-(BOOL)shouldAutorotate
{
    // //NSLog(@" %@ of class   %@ ", NSStringFromSelector(_cmd), self);
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations

{
    [self handleIosVersionOrieantion];
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // //NSLog(@" %@ of class   %@ ", NSStringFromSelector(_cmd), self);
    // [self handleIosVersionOrieantion];
    return [self preferredInterfaceOrientationForPresentation];
}
// ios 6  Orieation methods.........


- (void) backButtonPressed:(id) sender
{
    if ([m_webView canGoBack])
    {
        [m_webView goBack];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark --
#pragma mark <UIWebViewDelegate> Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// starting the load, show the activity indicator
	if([m_activity isAnimating] == NO)
	{
		[m_activity startAnimating];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// *************** finished loading, hide the activity indicator*************** 
	if([m_activity isAnimating])
	{
		[m_activity stopAnimating];	
	}
    
    if ([m_webView canGoBack])
    {
        self.navigationItem.leftBarButtonItem = m_BackButton;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
	
    NSString *path = [[NSBundle mainBundle] pathForResource:@"search" ofType:@"html"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	[m_webView stringByEvaluatingJavaScriptFromString:jsCode];
    [m_webView stringByEvaluatingJavaScriptFromString:@"ResetNoteImage()"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator
	if([m_activity isAnimating])
	{
		[m_activity stopAnimating];	
	}
}


-(void)clickOnOptionButton:(id)sender{
    
	[self hidAndShowBookmarksButton];
	searchBar.hidden=FALSE;
	DatabaseConnection *database = [DatabaseConnection sharedController];
    ArticleDataHolder *articleDataHolder = [[database loadArticleInfo:articleID] retain]; 
    if (articleDataHolder.nBookmark == 1){
		[bookmarksBtn setImage:[UIImage imageNamed:@"bookmark_clicked.png"] forState:UIControlStateNormal];
        	}// 
    else  {
		[bookmarksBtn setImage:[UIImage imageNamed:@"bookmark.png"] forState:UIControlStateNormal];
	}// *************** Add Bookmark*************** 
    [articleDataHolder release];
	m_btnSearch=(UIButton *)sender;
	if (m_btnSearch.tag == kSearchButtonUnSelectedKey) {
	if ([CGlobal isOrientationLandscape]){
		m_btnSearch.tag = kSearchButtonSelectedKey;
		CGRect view1Frame = optionImageView.frame;
		view1Frame.origin.y = 105;
		 optionImageView.frame = view1Frame;
		bacKImageView.frame = CGRectMake(0, 155, 1024, 590);
		m_webView.frame=CGRectMake(30, 165, 964, 570);
		if(textType == AbstractText){
			
			CGRect view1Frame = optionImageView.frame;
			view1Frame.origin.y = 45;
			optionImageView.frame = view1Frame;
			bacKImageView.frame = CGRectMake(0, 90, 1024, 640);
			m_webView.frame=CGRectMake(30, 95, 964, 630);
			
		}
		
		
	}
	else{
		m_btnSearch.tag = kSearchButtonSelectedKey;
		CGRect view1Frame = optionImageView.frame;
		view1Frame.origin.y = 45;
		optionImageView.frame = view1Frame;
		bacKImageView.frame = CGRectMake(0, 90, 768, 900);
		m_webView.frame=CGRectMake(30, 95, 704, 890);
		
	}
		
		optionImageView.hidden=FALSE;
		
	}
	else {
		[searchBar  resignFirstResponder];
		if ([CGlobal isOrientationLandscape]){
			bacKImageView.frame = CGRectMake(0, 105, 1024, 620);
			m_webView.frame=CGRectMake(30, 130, 964, 590);
			if (textType == AbstractText) {
				bacKImageView.frame = CGRectMake(0, 49, 1024, 690);
				m_webView.frame=CGRectMake(30, 60, 964, 670);
			 }
		  }
		else{
			menuOBJ.hidden=TRUE;
		    bacKImageView.frame = CGRectMake(0, 49, 768, 939);
			m_webView.frame=CGRectMake(30, 65, 704, 900);
		}
		optionImageView.hidden=TRUE;
		m_btnSearch.tag = kSearchButtonUnSelectedKey;
	}

}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1
{
	hideMenuOption = TRUE;
     
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
	hideMenuOption = FALSE;
	return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar1{
    
	hideMenuOption=FALSE;
	[searchBar1 resignFirstResponder];
	searchBar1.text=nil;
	[m_webView removeAllHighlights];
	
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1{
	hideMenuOption = TRUE;
	if(searchBar1.text)
		[m_webView highlightAllOccurencesOfString:searchBar1.text];	
    [searchBar1 resignFirstResponder];

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	
	if(navigationType ==UIWebViewNavigationTypeLinkClicked)
	{
		//NSLog(@"%@",[request.URL absoluteString]);
		
		 
		NSArray *urlCoponents=[[request.URL absoluteString] componentsSeparatedByString:@"/"];
		NSArray *highLightcomponents=[[urlCoponents lastObject] componentsSeparatedByString:@":"];
		if ([highLightcomponents count]>1) {
			//NSLog(@"%@",[highLightcomponents objectAtIndex:1]);
			DatabaseConnection *database = [DatabaseConnection sharedController];
			HighlightObject *highLightObj=[database selectHighlightText:[NSString stringWithFormat:@"select * from tblNotes where noteID ='%@'",[highLightcomponents objectAtIndex:1]]];
			
			if (highLightObj.selectedText) {
				[addNotesView setSelectionInnerHtmlString:highLightObj.selectedText];
				[addNotesView showText:highLightObj.selectedText];
				[addNotesView showUserNote:highLightObj.myNotes];
				[addNotesView setNoteId:[highLightcomponents objectAtIndex:1]];
				[addNotesView.saveBtn1 setHidden:TRUE];
				[addNotesView.editButton setHidden:FALSE];
				[addNotesView.deleteBtn setHidden:FALSE];
				addNotesView.frame=CGRectMake((self.view.frame.size.width-addNotesView.frame.size.width)/2, -400.0, addNotesView.frame.size.width, addNotesView.frame.size.height);
				
				[UIView beginAnimations:@"animationStart" context:nil];
				[UIView setAnimationDuration:0.5];
				
				addNotesView.frame=CGRectMake((self.view.frame.size.width-addNotesView.frame.size.width)/2, 50.0, addNotesView.frame.size.width, addNotesView.frame.size.height);
				[UIView commitAnimations];
				[self.view bringSubviewToFront:addNotesView];
				
			}
		}
		
		     //***************  this condition check only for mail to *************************
		
		       NSString *requestString = [[request URL] absoluteString];
		        NSArray *components = [requestString componentsSeparatedByString:@":"];
		        if ([[components objectAtIndex:0] isEqual:@"mailto"]) 
		        {
		            if ([CGlobal isMailAccountSet])
		            {
		                MFMailComposeViewController  *controller = [[MFMailComposeViewController alloc] init];
		                controller.mailComposeDelegate = self;
		                		                
                  NSArray *arrTo = [NSArray arrayWithObjects:[components objectAtIndex:1] ,nil];
				     [controller setToRecipients:arrTo];
		                
		                [self presentModalViewController:controller animated:YES];
		                [controller release];	
		            } 
					return 0;
		        }
		  //***************  this condition check only for mail to *************************
		
        // *************** this check only for click on imqge*************** 
		
		NSArray *urlCoponents1=[[request.URL absoluteString] componentsSeparatedByString:@"/"];
		if([urlCoponents1 count]>0)
		{
			NSArray *fileComponets=[[urlCoponents lastObject] componentsSeparatedByString:@"."];
			
			if([fileComponets count]>1)
			{
                if ([[fileComponets lastObject]isEqualToString:@"jpg"]) 
                {
                    NSArray *imageComponet=[[urlCoponents lastObject]componentsSeparatedByString:@"_"];
                    if ([imageComponet count]>1) 
                    {
						NSString *fileName= [NSString stringWithFormat:@"%@_lrg",[imageComponet objectAtIndex:0]];
                        fileName=[fileName stringByAppendingFormat:@".jpg"];
                        // ****************** Show Image Maxima Size ******************************
                      [self checkAndPushToImageThumbsForImageName:fileName];
						
                    }
 
                    return FALSE;
				}
                else if([[fileComponets lastObject]isEqualToString:@"gif"]) 
                {
                    NSArray *imageComponet=[[urlCoponents lastObject]componentsSeparatedByString:@"_"];
                    NSString *fileName = nil;
                    if ([imageComponet count]>1) 
                    {
                        fileName=[imageComponet objectAtIndex:0];
                        fileName=[fileName stringByAppendingFormat:@".gif"];
                    }  
                    // ****************** Show Image Maxima Size ******************************
                    
                    [self checkAndPushToImageThumbsForImageName:fileName];
                    return FALSE;
                }
        }

  }
	}
return YES;
}

#pragma mark --
#pragma mark <MFMailComposeViewControllerDelegate> Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self becomeFirstResponder];
	[self  dismissModalViewControllerAnimated:YES];
    if(result == MFMailComposeResultSent)
    {
        [CGlobal showMessage:@"" msg:@"Mail message has been sent."];
    }
    else if (result == MFMailComposeResultSaved)
    {
        [CGlobal showMessage:@"" msg:@"Mail message has been saved."];
    }
}

// ************************Change Image login Button************************
-(void)changeImageLoginButton{
	[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
}

// ******************* set Image Maxmia Size********************************

-(void)checkAndPushToImageThumbsForImageName:(NSString *)ImageName{

	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *htmlFilePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/image/%@",aritcleInfoID,aritcleInfoID,ImageName]];
	NSURL *url = [NSURL fileURLWithPath:htmlFilePath];
	NSString  *htmlStr=[NSString stringWithFormat:@"<img src = '%@'>",htmlFilePath];
		
	imageWebView=[[UIWebView alloc] init];
	imageWebView.frame=CGRectMake(0, 49, 768, 975);
	[imageWebView loadHTMLString:htmlStr baseURL:url];
	imageWebView.scalesPageToFit = YES;
	[self.view addSubview:imageWebView];
	
	croosBtn =[UIButton buttonWithType:UIButtonTypeCustom];
	[croosBtn setImage:[UIImage imageNamed:@"Loadingcancel.png"] forState:UIControlStateNormal];
	[imageWebView addSubview:croosBtn];
	[croosBtn addTarget:self action:@selector(clickOncancelButton) forControlEvents:UIControlEventTouchUpInside];
    if ([CGlobal isOrientationLandscape]){
		imageWebView.frame = CGRectMake(0 ,45,1024 ,730);
		[croosBtn setFrame:CGRectMake(990, 0, 28, 28)];
        }
	else {
		imageWebView.frame = CGRectMake(0 ,45,768 ,975);
		[croosBtn setFrame:CGRectMake(740, 0, 28, 28)];
	}

	
}


-(void)clickOncancelButton{
	
	[croosBtn removeFromSuperview];
	[imageWebView removeFromSuperview];	
	[imageWebView release];
	imageWebView=nil;
	
}

// *****************jump To next Scetion Heading *****************

-(void)jumpToSectionTag:(NSString*)tagValue
{
	if(m_webView)	{
        
		[self jumpToSection:tagValue];
	}
	
}

// *****************jump To next Scetion Heading *****************

-(void)jumpToSection:(NSString*)sectionTagValue
{
    
    if ([firstHeadingId isEqualToString:sectionTagValue]) {
       // **************** scroll To Top position *********************** 
        [self scrollToTop];
    }
    else{
   
	if(sectionTagValue)
	{
        if ([sectionTagValue isEqualToString:@"lv_0004"]){
            firstHeadingId = sectionTagValue;
        }
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait|| self.interfaceOrientation== UIInterfaceOrientationPortraitUpsideDown) {
            [m_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var theElement=document.getElementById('%@');var selectedPosX=0;var selectedPosY=0;while(theElement!=null){selectedPosX+=theElement.offsetLeft;selectedPosY+=theElement.offsetTop;theElement=theElement.offsetParent;}window.scrollTo(selectedPosX,selectedPosY);",sectionTagValue]];
            
        }else {
        
            [m_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var theElement=document.getElementById('%@');var selectedPosX=0;var selectedPosY=0;while(theElement!=null){selectedPosX+=theElement.offsetLeft;selectedPosY+=theElement.offsetTop;theElement=theElement.offsetParent;}window.scrollTo(selectedPosX,selectedPosY-15);", sectionTagValue]];            
        }        

        }
  
    }
    sectionValueStr = [sectionTagValue copy];
}

-(void)scrollToTop{
    
for (UIView *subview in m_webView.subviews)
{
    if ([subview isKindOfClass:[UIScrollView class]])
        [(UIScrollView*)subview setContentOffset:CGPointZero animated:NO];
}

}

-(IBAction)clickOnResizeButton:(id)sender{
    
	UIButton  *btn = (UIButton *)sender;
    
    TextViewPopOver   *shareView = [[TextViewPopOver alloc] init];
    shareView.delegate = (id)self;
    
     m_TextIncreasePopOver = [[UIPopoverController alloc] initWithContentViewController:shareView];
    [m_TextIncreasePopOver setPopoverContentSize:CGSizeMake(180, 40)];
    if ([CGlobal isOrientationPortrait])
        [m_TextIncreasePopOver presentPopoverFromRect:CGRectMake(btn.frame.origin.x-50, btn.frame.origin.y+30 ,180, 40) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    else
        [m_TextIncreasePopOver presentPopoverFromRect:CGRectMake(btn.frame.origin.x-50, btn.frame.origin.y+100 ,180, 40) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}


// *********************************** Increase & decrease Text ***********************************

-(void)increaseSize:(BOOL)flag{
    
	NSError		*err;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	NSString *cssPath;
	
	if (isThisAbstract) {
		cssPath= [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_abs/%@_abs/style.css",aritcleInfoID,aritcleInfoID]];
		
	}
	else {
		cssPath= [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/style.css",aritcleInfoID,aritcleInfoID]];
		
	}	
	NSString *cssData=[NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:&err];
	NSInteger cssVerionNumber=[[cssData substringWithRange:NSMakeRange(2, 1)]intValue];
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cssVerionNumber] forKey:@"LastCss"];
    if (flag) {
        
        if(cssVerionNumber>0 && cssVerionNumber<6)
        {
            switch (cssVerionNumber) {
                case 1:
                {
                    
                    NSString    *newCss = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"style1" ofType: @"css"] encoding:NSUTF8StringEncoding error:&err];
                    [newCss writeToFile:cssPath atomically:YES encoding:NSUTF8StringEncoding error:&err];
                    
                }
                    break;
                case 2:
                {
                    
                    NSString    *newCss = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"style2" ofType: @"css"] encoding:NSUTF8StringEncoding error:&err];
                    [newCss writeToFile:cssPath atomically:YES encoding:NSUTF8StringEncoding error:&err];
                    
                }
                    break;
                case 3:
                {
                    
                    NSString    *newCss = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"style3" ofType: @"css"] encoding:NSUTF8StringEncoding error:&err];
                    [newCss writeToFile:cssPath atomically:YES encoding:NSUTF8StringEncoding error:&err];
                    
                }
                    break;
                case 4:
                {
                    
                    NSString    *newCss = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"style4" ofType: @"css"] encoding:NSUTF8StringEncoding error:&err];
                    [newCss writeToFile:cssPath atomically:YES encoding:NSUTF8StringEncoding error:&err];
                    
                }
                    break;
                case 5:
                {
                   
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"4"] forKey:@"LastCss"];
                    
                    
                }
                    break;
                default:
                    break;
            }
        }
        else {
            NSString    *newCss = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"style1" ofType: @"css"] encoding:NSUTF8StringEncoding error:&err];
            [newCss writeToFile:cssPath atomically:YES encoding:NSUTF8StringEncoding error:&err];
        }
        
	}
	else {
		
		NSError		*err;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
		NSString *cssPath;
		if (isThisAbstract) {		
			cssPath= [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_abs/%@_abs/style.css",aritcleInfoID,aritcleInfoID]];
		}
		else {
			cssPath= [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/style.css",aritcleInfoID,aritcleInfoID]];
		}
		
		NSString *cssData=[NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:&err];
		NSInteger cssVerionNumber=[[cssData substringWithRange:NSMakeRange(2, 1)]intValue];
		
		if(cssVerionNumber>=0 && cssVerionNumber<6)
		{
			
			switch (cssVerionNumber) {
                case 0:
                   
                    break;
                    
				case 1:
				{
					[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"5"] forKey:@"LastCss"];
                    
				}
					break;


				case 3:
				{
					NSString    *newCss = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"style1" ofType: @"css"] encoding:NSUTF8StringEncoding error:&err];
					[newCss writeToFile:cssPath atomically:YES encoding:NSUTF8StringEncoding error:&err];
					
				}
					break;
				case 4:
				{ 
					NSString    *newCss = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"style2" ofType: @"css"] encoding:NSUTF8StringEncoding error:&err];
					[newCss writeToFile:cssPath atomically:YES encoding:NSUTF8StringEncoding error:&err];
					
				}
					break;
				case 5:
				{
					NSString    *newCss = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"style3" ofType: @"css"] encoding:NSUTF8StringEncoding error:&err];
					[newCss writeToFile:cssPath atomically:YES encoding:NSUTF8StringEncoding error:&err];
					
				}
					break;
				default:
					break;
			}
		}
		
	}
	
    
    resizeButton.userInteractionEnabled=FALSE;
	[NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(loadWebView) userInfo:nil repeats:NO];
}


// ******************* load link On webView*************************

- (void) loadWebView {
	[m_webView reload];
	resizeButton.userInteractionEnabled=TRUE;
}


#pragma mark --
#pragma mark UIPooverController Functions

- (void) dismissPopoover
{
	if(m_popoverController != nil)
	{
		if([m_popoverController isPopoverVisible])
			[m_popoverController dismissPopoverAnimated:YES];
		RELEASE(m_popoverController);
	}
}

- (void)dismissPopooverTeXtIncrease
{
	if(m_TextIncreasePopOver != nil)
	{
		if([m_TextIncreasePopOver isPopoverVisible])
			[m_TextIncreasePopOver dismissPopoverAnimated:YES];
		RELEASE(m_TextIncreasePopOver);
	}
}

- (void)showPopOver:(id)sender
{
	UIButton  *btn=(UIButton *)sender;
    [self dismissPopoover];
	
	articleListView = [[AritcleListViewController alloc] initWithNibName:@"AritcleListViewController" bundle:nil];
	articleListView.webViewController=self;
	UIImage *Image=m_btnLogin.currentImage;
	if (Image == [UIImage imageNamed:@"BtnLogout.png"]) {
		articleListView.allReadyLogin = TRUE;
	}
	else {
		articleListView.allReadyLogin=FALSE;
	}

	articleListView.articleInfoArr=m_ariticleData;
    
	UINavigationController   *navgaitionController=[[UINavigationController alloc] initWithRootViewController:articleListView];
	m_popoverController = [[UIPopoverController alloc] initWithContentViewController:navgaitionController];
    [m_popoverController setPopoverContentSize:CGSizeMake(320.0, 768.0)];
    [m_popoverController presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	[navgaitionController release];
	[articleListView release];
	articleListView=nil;
	
}

-(IBAction)clickONSearchButton:(id)sender{
	
	if (searchButton.tag == kSearchButtonUnSelectedKey) {
		searchBar.hidden=FALSE;
		searchButton.tag = kSearchButtonSelectedKey;
	}
	else {
		[searchBar resignFirstResponder];
		searchBar.hidden=TRUE;
		searchButton.tag = kSearchButtonUnSelectedKey;
	}

	
}
#pragma mark Add Bookmark

- (IBAction)bookmarkButtonPressed:(id)sender
{
	
    DatabaseConnection *database = [DatabaseConnection sharedController];
    ArticleDataHolder *articleDataHolder = [[database loadArticleInfo:articleID] retain]; 
    NSInteger  clinicID = 0;
	NSInteger  CategoryID =0;
	clinicID=[database    selectClinicIDFromIssueTable:[NSString stringWithFormat:@"select clinicid from tblissue where issueid=%@",articleDataHolder.sIssueID]];
	CategoryID=[database  selectClinicIDFromIssueTable:[NSString stringWithFormat:@"select categoryID from tblclinic where clinicId=%d",clinicID]];
    if (articleDataHolder.nBookmark == isOne){
		[bookmarksBtn setImage:[UIImage imageNamed:@"bookmark.png"] forState:UIControlStateNormal];
        [database   updateBookmarkInArticleData:[NSString stringWithFormat:@"UPDATE tblArticle SET Bookmark = 0,CategoryID = 0 ,clinicID = 0 where ArticleId = %d",articleDataHolder.nArticleID]]; 
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Bookmark deleted successfully." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
	}// *************** Remove Bookmark*************** 
    else  {
      [database   updateBookmarkInArticleData:[NSString stringWithFormat:@"UPDATE tblArticle SET Bookmark = 1,CategoryID = %d ,clinicID = %d where ArticleId = %d",CategoryID,clinicID,articleDataHolder.nArticleID]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Article has been added to Bookmarks." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
		[bookmarksBtn setImage:[UIImage imageNamed:@"bookmark_clicked.png"] forState:UIControlStateNormal];
	}//***************  Add Bookmark*************** 
    [articleDataHolder release];
	
}

#pragma mark Add Notes

-(void)highlightNotes
{
	
	
	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
	if ([loginId intValue] == ishundred){
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notes" message:@"Notes can only be created in the full Toc article." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //alert.tag = -17897;
		[alert show];
		[alert release];
		return;
	}
		
	if (isThisAbstract) {
		UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"Notes" message:@"Notes can be created only in full article." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Full-Text",nil]autorelease];
        alert.tag = -17897;
		[alert show];
		return;
	}
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"search" ofType:@"html"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	
	jsCode = [jsCode stringByAppendingString:[NSString stringWithFormat:@"highlightsText()"]];
	
	NSString *selectionString = (NSString*)[m_webView stringByEvaluatingJavaScriptFromString:jsCode];
    
	NSString *filePath = [self getFilePathNameForArticleId:aritcleInfoID andFileName:@"main.html"];
	
	
	NSArray *selectionComponents = [selectionString componentsSeparatedByString:@"<noteseparator>"];
	NSString *idstring;
	NSString *highlightText;
	
    if ([selectionComponents count]>2) {
		selectionString=[selectionComponents objectAtIndex:0];
		idstring=[selectionComponents objectAtIndex:1];
		highlightText=[selectionComponents objectAtIndex:2];
		
		[addNotesView showText:highlightText];
		[addNotesView showUserNote:@""];
		[addNotesView setNoteId:idstring];
		[addNotesView setFilePath:filePath];
		[addNotesView setArticleId:articleID];
		[addNotesView setSelectionInnerHtmlString:selectionString];
		[addNotesView setHighlightedText:highlightText];
		addNotesView.frame=CGRectMake((self.view.frame.size.width-addNotesView.frame.size.width)/2, -400.0, addNotesView.frame.size.width, addNotesView.frame.size.height);
		[addNotesView.saveBtn1 setHidden:FALSE];
		[addNotesView.deleteBtn setHidden:TRUE];
		[addNotesView.editButton setHidden:TRUE];
        
		[UIView beginAnimations:@"animationStart" context:nil];
		[UIView setAnimationDuration:0.5];
		
		addNotesView.frame=CGRectMake((self.view.frame.size.width-addNotesView.frame.size.width)/2, 50.0, addNotesView.frame.size.width, addNotesView.frame.size.height);
		[UIView commitAnimations];		
	}	
    [self.view bringSubviewToFront:addNotesView];
}

#pragma mark -
#pragma mark RETREIVE_FILE_NAME 

-(NSString*)getFilePathNameForArticleId:(NSString*)articleId andFileName:(NSString*)fileName
{

	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSMutableString *documentsDirectory=[[[NSMutableString alloc]initWithString:[paths objectAtIndex:0]]autorelease];
	documentsDirectory=(NSMutableString*)[documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/%@",aritcleInfoID,aritcleInfoID,fileName]];
	if(![fileManager fileExistsAtPath:documentsDirectory])
		return nil;

	return documentsDirectory;
}



#pragma mark  -
#pragma mark  Handling_NotesRelatedActivity

-(void)deleteNoteForId:(NSString*)noteId
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"search" ofType:@"html"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	
	NSString *deleteJs=[jsCode stringByAppendingString:[NSString stringWithFormat:@"deletetagValue('%@')",noteId]];
	
	
	
	[m_webView stringByEvaluatingJavaScriptFromString:deleteJs];
	
	NSString *getInnerHtmljs=[jsCode stringByAppendingString:[NSString stringWithFormat:@"getInnerHtml()"]];
	
	NSString *selectionString=(NSString*)[m_webView stringByEvaluatingJavaScriptFromString:getInnerHtmljs];
	
	
	NSString *filePath=[self getFilePathNameForArticleId:aritcleInfoID andFileName:@"main.html"];
	
	NSArray *htmlComponenets= [[NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil] componentsSeparatedByString:@"<body"];
	
	NSString *headerComponet = nil;
	NSString *bodyComponent = nil;
	NSString *footerComponent = nil;
	
	if ([htmlComponenets count]>0) {
		headerComponet=[htmlComponenets objectAtIndex:0];
		
		
		if ([htmlComponenets count]>1) {
			NSArray *bodyStyleComp=[[htmlComponenets objectAtIndex:1] componentsSeparatedByString:@">"];
			if ([bodyStyleComp count]>0) {
				bodyComponent=[bodyStyleComp objectAtIndex:0];
			}
		}
	}
	
	NSArray *htmlFooterComponents=[[NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil] componentsSeparatedByString:@"</body"];
	if ([htmlFooterComponents count]>1) {
		footerComponent=[htmlFooterComponents objectAtIndex:1];
	}
	
	
	NSError *error;
	
	NSString *finalHTML = nil;
    finalHTML=[headerComponet stringByAppendingFormat:@"<body %@>",bodyComponent];
	finalHTML=[finalHTML stringByAppendingString:selectionString];
	finalHTML=[finalHTML stringByAppendingFormat:@"</body %@",footerComponent];
	
	[finalHTML writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:&error];
}

-(void)reloadWebView
{
	[m_webView reload];
}

// ***************  This Code Use only Add Notes From asbstruct//////////////////////////////////////////

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == -17897) {
		if (buttonIndex == isOne) {
			
			BOOL success;
			NSFileManager *fileManager=[NSFileManager defaultManager];
			NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
			NSString *documentsDirectory=[paths objectAtIndex:0];
			NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:aritcleInfoID];
			success=[fileManager fileExistsAtPath:writableDBPath];
			if(success){
				[self loadHtmlFileAddNotes];
			}
			else {
				ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
				appDelegate.openHTMLADDNoteOpenView=TRUE;
				
				UIImage *Image=m_btnLogin.currentImage;
				if (Image==[UIImage imageNamed:@"BtnLogout.png"]) {
					[self downloadAritcleShowFullText];
				}else{
				
					
					ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
						
					     appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,aritcleInfoID];
						appDelegate.clickONFullTextOrPdf=TRUE;
						[appDelegate clickOnLoginButton:nil];
					  appDelegate.clickONFullTextOrPdf=FALSE;
				
		
				}
				
			}
		}
	}	
}
 
-(void)downloadAritcleShowFullText{
	if (imageWebView) {
		[self clickOncancelButton];
	}
    //************* Dwonload Zip File From Server pdf as well as Full Text **********************
	[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,aritcleInfoID]];
}

-(void)loadHtmlFileAddNotes{
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.openHTMLADDNoteOpenView=FALSE;
	if ([CGlobal isOrientationLandscape]) {
		//  *************** Check Size WebView*************** 
		if (m_btnSearch.tag == kSearchButtonSelectedKey) {
			bacKImageView.frame = CGRectMake(0, 155, 1024, 729);
			m_webView.frame=CGRectMake(30, 165, 964, 600);
			
		}else {
			bacKImageView.frame = CGRectMake(0, 49, 1024, 729);
			m_webView.frame=CGRectMake(30, 60, 964, 658);
		}
		m_webView.hidden=FALSE;
		menuOBJ.hidden=FALSE;
		sliderView.hidden=TRUE;
	}
	else {
		//  *************** Check Size WebView*************** 
		if (m_btnSearch.tag == kSearchButtonSelectedKey) {
			bacKImageView.frame = CGRectMake(0, 90, 768, 939);
			m_webView.frame=CGRectMake(30, 95, 704, 925);
			
		}else {
			bacKImageView.frame = CGRectMake(0, 49, 768, 939);
			m_webView.frame=CGRectMake(30, 55, 704, 954);	
		}
		
		
		m_webView.hidden=FALSE;
		menuOBJ.hidden=TRUE;
		sliderView.hidden=FALSE;
	}
	
	if (pdfhomeview) {
		[pdfhomeview removeFromSuperview];
		[pdfhomeview release];
		pdfhomeview=nil;
	}
	
	resizeButton.tag = 100;
	DatabaseConnection *database = [DatabaseConnection sharedController];
    ArticleDataHolder *articleDataHolder1 = [[database loadArticleInfo:articleID] retain]; 
    if (articleDataHolder1.nBookmark == isOne){
		[bookmarksBtn setImage:[UIImage imageNamed:@"bookmark_clicked.png"] forState:UIControlStateNormal];
	}
    else  {
		[bookmarksBtn setImage:[UIImage imageNamed:@"bookmark.png"] forState:UIControlStateNormal];
	}
	if (articleDataHolder1) {
		[articleDataHolder1 release];
		articleDataHolder1=nil;
	}
	for(UIView  *View1 in [menuOBJ subviews]){
		if ([View1 isKindOfClass:[CustomScrollView class]]) {
			
			for(UIView  *View2 in [View1 subviews]){
				[View2 removeFromSuperview];
			}
		}
		
 
	}
	if (articalSectioinDataList) {
		[articalSectioinDataList release];
		articalSectioinDataList=nil;
	}
	articalSectioinDataList = [[database  loadRefeenceInfoHTMl:aritcleInfoID] retain];
	[menuOBJ addOptions:articalSectioinDataList];
	[sliderView initSlider:articalSectioinDataList];
	isThisAbstract=FALSE;
	textType = FullText;

	NSString * lastCss=[[NSUserDefaults standardUserDefaults]objectForKey:@"LastCss"];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	
	NSString *cssPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/style.css",aritcleInfoID,aritcleInfoID]];
	NSString    *newCss = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"style%d",[lastCss intValue]]  ofType: @"css"] encoding:NSUTF8StringEncoding error:nil];
	[newCss writeToFile:cssPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	NSString *htmlFilePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/main.html",aritcleInfoID,aritcleInfoID]];
	NSURL *url = [NSURL fileURLWithPath:htmlFilePath];
	[m_webView loadRequest:[NSURLRequest requestWithURL:url]];
    firstHeadingId = nil;
	
}

//************* Dwonload Zip File From Server pdf as well as Full Text **********************
-(void)downloadFileFromServer:(NSString *)choiceString{
	
	
	DownloadController *downloadController=[DownloadController sharedController];
	[downloadController setSender:self];
	[downloadController addLoaderForView];
	[downloadController createDownloadQueForQueData:choiceString];
	
	
}

// ***************  This Code Use only Add Notes From asbstruct//////////////////////////////////////////
-(void)updateNotesInAtricleTable{
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
    ArticleDataHolder *articleDataHolder = [[database loadArticleInfo:articleID] retain]; 
    NSInteger  clinicID=0;
	NSInteger  CategoryID=0;
	clinicID=[database    selectClinicIDFromIssueTable:[NSString stringWithFormat:@"select clinicid from tblissue where issueid=%@",articleDataHolder.sIssueID]];
	CategoryID=[database  selectClinicIDFromIssueTable:[NSString stringWithFormat:@"select categoryID from tblclinic where clinicId=%d",clinicID]];
    if (articleDataHolder.note == isOne){
		BOOL  noteID = [database checkNoteInNoteTable:[NSString stringWithFormat:@"select noteID from tblnotes where Articleid=%d",articleID]];
		if (noteID == FALSE) {
        [database   updateBookmarkInArticleData:[NSString stringWithFormat:@"UPDATE tblArticle SET Note = 0,CategoryID = %d ,clinicID = %d where ArticleId = %d",CategoryID,clinicID,articleDataHolder.nArticleID]]; 
		
		}
	}//***************  Remove Bookmark*************** 
    else  {
	
		[database   updateBookmarkInArticleData:[NSString stringWithFormat:@"UPDATE tblArticle SET Note = 1,CategoryID = %d ,clinicID = %d where ArticleId = %d",CategoryID,clinicID,articleDataHolder.nArticleID]];
		
		
	}//***************  Add Bookmark*************** 
    [articleDataHolder release];
	
}

#pragma mark  Add Share Option 

-(IBAction)sharedButtonPress:(id)sender{
	
    UIButton  *btn = (UIButton *)sender;
	SharePopOverView   *shareView = [[SharePopOverView alloc] init];
    shareView.m_doiLink = doiLinkStr;
    shareView.delegate = (id)self;
    
    m_sharepopoverController = [[UIPopoverController alloc] initWithContentViewController:shareView];
    [m_sharepopoverController setPopoverContentSize:CGSizeMake(282, 150)];
    if ([CGlobal isOrientationPortrait]){
    [m_sharepopoverController presentPopoverFromRect:CGRectMake(btn.frame.origin.x-30, btn.frame.origin.y-78 ,282, 150) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    }else{
        
        if(textType == AbstractText){
             [m_sharepopoverController presentPopoverFromRect:CGRectMake(btn.frame.origin.x-30, btn.frame.origin.y-82 ,282, 150) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }else{
              
    [m_sharepopoverController presentPopoverFromRect:CGRectMake(btn.frame.origin.x-30, btn.frame.origin.y-20 ,282, 150) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }
         
    
    RELEASE(shareView);
}

// ************************ UIMenuController Delegate ************************************

- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender {
    if (selector == @selector(highlightNotes)) {
		
		if(hideMenuOption == FALSE)
        return YES;
	}
		// 
		
	return NO;
		// *************** hide menu view*************** 
}

-(void)hidAndShowBookmarksButton{
	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
	//***************  don't add bookmarks on Articlein press*************** 
	if ([loginId intValue] == ishundred) {
		bookmarksBtn.hidden=TRUE;
	}
	else {
		bookmarksBtn.hidden=FALSE;
	}
	
}

-(void)dismissPopOver{
    
    if (m_sharepopoverController) {
        [m_sharepopoverController dismissPopoverAnimated:YES];
        RELEASE(m_sharepopoverController);    
    }
    
}
// ********************** open iBook ********************** 
-(void)tabOnAddIBookButton:(id)sender{
    
    UIButton  *btn = (UIButton *)sender;
    NSURL  *url = [NSURL fileURLWithPath:m_pdfPath];
    docController = [UIDocumentInteractionController interactionControllerWithURL:url];
    
    docController.delegate = self;
    
    [docController retain];
    UIBarButtonItem *barButton = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    BOOL isValid = [docController presentOpenInMenuFromBarButtonItem:barButton animated:YES];

    
    if (!isValid) {
        UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"You do not have ibooks." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        RELEASE(alertView);
    }
    
    
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller{
    docController.delegate = nil;
    RELEASE(docController);
    docController = nil;

}

// ********************************* Change AddNoteView Orireation *************************

-(void)changeAddViewKeybordComeLandScape{
    
    if (addNotesView.frame.origin.y>0) {
    if ([CGlobal isOrientationPortrait])
    addNotesView.frame=CGRectMake((self.view.frame.size.width-addNotesView.frame.size.width)/2, 70.0, addNotesView.frame.size.width, addNotesView.frame.size.height);
    else
    addNotesView.frame=CGRectMake((self.view.frame.size.width-addNotesView.frame.size.width)/2, 50.0, addNotesView.frame.size.width, addNotesView.frame.size.height);   
    }
}


@end
