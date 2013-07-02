//
//  WebViewController_iPhone.m
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewController_iPhone.h"
#import "TextViewPopover_iPhone.h"
#import "CGlobal.h"
#import "CustomScrollView.h"
#import "DownloadController.h"
#import "HighLightWebView.h"

#define kOptionButtonUnSelectedKey 100
#define kOptionButtonSelectedKey 101

@implementation WebViewController_iPhone
@synthesize m_ariticleData;
@synthesize aricleToCView;
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
	RELEASE(aricleToCView);
    [m_webView release];
    RELEASE(m_pdfPath);
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
    
	hideMenuOption=FALSE;
    m_pdfPath = [[NSString  alloc] init];
	addNotesView_iPhone=[[AddNotesView_iPhone alloc]initWithFrame:CGRectMake(30, -400.0,230,  199)];
	addNotesView_iPhone.callerDelegate_iphone =self;
	[self.view addSubview:addNotesView_iPhone];
	
	NSString * lastCss=[[NSUserDefaults standardUserDefaults]objectForKey:@"LastCss"];
	if (lastCss==nil) {
		[[NSUserDefaults standardUserDefaults]setObject:@"5" forKey:@"LastCss"];
	}
	optionImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"TableSectionBar.png"]];
	optionImageView.hidden=TRUE;
	optionImageView.frame =CGRectMake(0, 44, 320, 44);
    
	bacKImageView=[[UIImageView alloc]init];

	bacKImageView.image = [UIImage imageNamed:@"iPhone_WhiteTextBox.png"];
    bacKImageView.frame=CGRectMake(5, 44, 310, 420);
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

	searchBar.tag=100;
	m_webView =[[HighLightWebView alloc] init];
	m_webView.delegate=self;
	m_webView.scalesPageToFit=YES;
	m_webView.backgroundColor=[UIColor clearColor];
	[self.view addSubview:m_webView];
	[self.view bringSubviewToFront:m_activity];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageLoginButton) name:@"changeImageLoginButton" object:nil];

	
    m_BackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:m_webView action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = nil;
	
	menuOBJ = [[MenuOptionView alloc] initWithFrame:CGRectMake(0, 40, 1024, 68.0) Buttons:nil];
	menuOBJ.hidden=TRUE;
	menuOBJ.backgroundColor = [UIColor whiteColor];
	menuOBJ.delegate = (id)self;
	
	
	
	[self.view addSubview:menuOBJ];
	[self setNavigationBarOnThisView];
	
	if (textType == PdfText) {
		[self openPDFfile:m_articleDataHolder];
		
	}
	else if(textType == FullText){
		[ self openHTMLfile:m_articleDataHolder];
	}
	else if(textType == AbstractText){
		
		[self openAbstrauct:m_articleDataHolder];
		
		
	}
	
    m_shareView = [[TextViewPopover_iPhone alloc] initWithFrame:CGRectMake(185, 72,125, 51)];
    m_shareView.delegate = (id)self;
    m_shareView.hidden = TRUE;
    [self.view addSubview:m_shareView];  
    
	optionButton.tag = kOptionButtonUnSelectedKey;
	
       
}




-(void)setNavigationBarOnThisView{
	
	UIImageView  *m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(0, 0, 320, 44);
	m_imgView.image=[UIImage imageNamed:@"iPhone_NavBar.png"];
	[self.view addSubview:m_imgView];
	[m_imgView release];
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	
	UILabel *m_lblTitle=[[UILabel alloc] init];
	m_lblTitle.frame=CGRectMake(0, 0, 312, 44);
	m_lblTitle.backgroundColor=[UIColor clearColor];
	m_lblTitle.font = [UIFont boldSystemFontOfSize:16.0];
	m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentCenter;
	m_lblTitle.text =@"Article Details";
	[self.view addSubview:m_lblTitle];
	[m_lblTitle release];
	
	
	UIButton *crossButton=[UIButton buttonWithType:UIButtonTypeCustom];
	crossButton.frame=CGRectMake(5, 10, 45, 25);
	[crossButton setBackgroundImage:[UIImage imageNamed:@"iPhone_Close_btn.png"] forState:UIControlStateNormal];
	[crossButton addTarget:self action:@selector(backToTocView:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:crossButton];
	
	loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.frame=CGRectMake(270, 10, 45, 25);
	appDelegate.wewView_iPhone=self;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	appDelegate.authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",appDelegate.seletedClinicID]];

	if(appDelegate.authentication == isOne){
		[loginButton setImage:[UIImage imageNamed:@"iPhone_Logout_btn.png"] forState:UIControlStateNormal];
    }
	else {
		[loginButton setImage:[UIImage imageNamed:@"iPhone_Login_btn.png"] forState:UIControlStateNormal];
    }
	
	[loginButton addTarget:self action:@selector(clickOnLoginButton:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:loginButton];
	
	optionButton=[UIButton buttonWithType:UIButtonTypeCustom];
	optionButton.frame=CGRectMake(216, 10, 48, 25);
	optionButton.tag = kOptionButtonUnSelectedKey;
	[optionButton setBackgroundImage:[UIImage imageNamed:@"iPhone_Option_btn.png"] forState:UIControlStateNormal];
	[optionButton addTarget:self action:@selector(clickOnOptionButton:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:optionButton];
	
	
	tocButton=[UIButton buttonWithType:UIButtonTypeCustom];
	tocButton.frame=CGRectMake(57, 10, 37, 25);
	[tocButton setBackgroundImage:[UIImage imageNamed:@"iPhone_TocList_btn.png"] forState:UIControlStateNormal];
	[tocButton addTarget:self action:@selector(showPopOver:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:tocButton];
    
    iBookPdfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iBookPdfBtn setImage:[UIImage imageNamed:@"addiBookPdf.png"] forState:UIControlStateNormal];
    [iBookPdfBtn addTarget:self action:@selector(tabOnAddIBookButton:) forControlEvents:UIControlEventTouchUpInside];
    iBookPdfBtn.hidden = TRUE;
    iBookPdfBtn.frame  =  CGRectMake(215, 10, 49, 25);
    [self.view addSubview:iBookPdfBtn];

}
-(void)showWebViewSeletedOption {
	UIMenuController *thisMenuController = [UIMenuController sharedMenuController];
	UIMenuItem *thirdMenu = [[[UIMenuItem alloc] initWithTitle:@"Add Note" action:@selector(highlightNotes)] autorelease];
	[thisMenuController setMenuItems:[NSArray arrayWithObjects:thirdMenu, nil]];
	
}

-(void)viewWillAppear:(BOOL)animated{
	ClinicsAppDelegate  *appDelegate=[UIApplication sharedApplication].delegate;
	appDelegate.webViewController=self;
	[self showWebViewSeletedOption];
}

-(void)viewWillDisappear:(BOOL)animated{
	ClinicsAppDelegate  *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.aritcleListView = TRUE;
	appDelegate.openHTMLADDNoteOpenView = FALSE;
	[[UIMenuController sharedMenuController] setMenuItems:nil];
	appDelegate.webViewController=nil;
}

-(void)openHTMLfile:(ArticleDataHolder *)articleDataHolder{
	
      iBookPdfBtn.hidden = TRUE;
	if (imageWebView) {
		[self clickOncancelButton];
	}
	
	optionButton.hidden=FALSE;
	
		//  Check Size WebView
		if (optionButton.tag == kOptionButtonSelectedKey) {
			bacKImageView.frame = CGRectMake(5, 90, 310, 420);
			m_webView.frame=CGRectMake(10, 95, 300, 370);
			
		}else {
			bacKImageView.frame = CGRectMake(5, 100, 310, 350);
			m_webView.frame=CGRectMake(10, 105, 300, 340);
		}
		m_webView.hidden=FALSE;
		menuOBJ.hidden=FALSE;
	
		
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
    if (articleDataHolder1.nBookmark == 1){
		[bookmarksBtn setImage:[UIImage imageNamed:@"iPhone_BookmarksYellow.png"] forState:UIControlStateNormal];
	}// BtnBookmark.png
    else  {
		[bookmarksBtn setImage:[UIImage imageNamed:@"iPhone_BookmarksGray.png"] forState:UIControlStateNormal];
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
    
    if(IS_WIDESCREEN){
        
        bacKImageView.frame = CGRectMake(5, 110, 310, 430);
        m_webView.frame=CGRectMake(10, 115, 300, 420);
        
    }
}


-(void)openPDFfile:(ArticleDataHolder *)articleDataHolder{
    
    
	  m_shareView.hidden = TRUE;
     iBookPdfBtn.hidden = FALSE;
	if (imageWebView) {
		[self clickOncancelButton];
	}
	
	optionButton.hidden=TRUE;
	optionImageView.hidden=TRUE;
	optionButton.tag = kOptionButtonUnSelectedKey;
	
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

	
	pdfhomeview=[[PDFHomeView alloc]init];
    pdfhomeview.frame=CGRectMake(10, 50, 300, 420);
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
	optionButton.hidden=FALSE;
	textType = AbstractText;
	resizeButton.tag=100;
	m_webView.hidden=FALSE;
	menuOBJ.hidden=TRUE;

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
    if (articleDataHolder1.nBookmark == 1){
		[bookmarksBtn setImage:[UIImage imageNamed:@"iPhone_BookmarksYellow.png"] forState:UIControlStateNormal];
	}// BtnBookmark.png
    else  {
		[bookmarksBtn setImage:[UIImage imageNamed:@"iPhone_BookmarksGray.png"] forState:UIControlStateNormal];
	}
	if (articleDataHolder1) {
		[articleDataHolder1 release];
		articleDataHolder1 =nil;
	}
	
	
	
		if (optionButton.tag == kOptionButtonSelectedKey) {
			bacKImageView.frame = CGRectMake(5, 90, 310, 420);
			m_webView.frame=CGRectMake(10, 95, 300, 370);
			
		}else {
			bacKImageView.frame = CGRectMake(5, 49, 310,420);
			m_webView.frame=CGRectMake(10, 55, 300, 390);	
		}
		
		
		

	
	//NSFileManager *fileManager=[NSFileManager defaultManager];
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
    
    
    if(IS_WIDESCREEN){
        bacKImageView.frame = CGRectMake(5, 49, 310, 470);
        m_webView.frame=CGRectMake(10, 55, 300, 450);
    }

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

	return NO;
}



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
	// finished loading, hide the activity indicator
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
    m_shareView.hidden = TRUE;
	searchBar.hidden=FALSE;
	DatabaseConnection *database = [DatabaseConnection sharedController];
    ArticleDataHolder *articleDataHolder = [[database loadArticleInfo:articleID] retain]; 
    if (articleDataHolder.nBookmark == 1){
		[bookmarksBtn setImage:[UIImage imageNamed:@"iPhone_BookmarksYellow.png"] forState:UIControlStateNormal];
	}// BtnBookmark.png
    else  {
		[bookmarksBtn setImage:[UIImage imageNamed:@"iPhone_BookmarksGray.png"] forState:UIControlStateNormal];
	}// Add Bookmark
    [articleDataHolder release];
	optionButton=(UIButton *)sender;
    NSLog(@"%@",m_webView);
    
	if (optionButton.tag == kOptionButtonUnSelectedKey) {
		//menuOBJ.hidden=TRUE;
        optionButton.tag = kOptionButtonSelectedKey;
		CGRect view1Frame = optionImageView.frame;
        view1Frame.origin.y = 45;
        optionImageView.frame = view1Frame;
		bacKImageView.frame = CGRectMake(5, 90, 310, 420);
        m_webView.frame=CGRectMake(10, 95, 300, 360);
        
        if(IS_WIDESCREEN){
          
            bacKImageView.frame = CGRectMake(5, 90, 310, 450);
			m_webView.frame=CGRectMake(10, 95, 300, 420);
        
        }
		
        optionImageView.hidden=FALSE;
        
        if(textType == FullText){
            
            CGRect view1Frame = optionImageView.frame;
            view1Frame.origin.y = 110;
            optionImageView.frame = view1Frame;
            bacKImageView.frame = CGRectMake(5, 165, 310, 285);
            m_webView.frame=CGRectMake(10, 170, 300, 275);
            
            if(IS_WIDESCREEN){
                
                bacKImageView.frame = CGRectMake(5, 160, 310, 380);
                m_webView.frame=CGRectMake(10, 165, 300, 370);
                
            }
            
        }
		
	}
	else {
        
		[searchBar  resignFirstResponder];
		//menuOBJ.hidden=FALSE;
        bacKImageView.frame = CGRectMake(5, 49, 310, 420);
        m_webView.frame=CGRectMake(10, 55, 300, 390);
        
		if(IS_WIDESCREEN){
            
            bacKImageView.frame = CGRectMake(5, 49, 310, 470);
			m_webView.frame=CGRectMake(10, 55, 300, 450);
        
        }
		
        optionImageView.hidden=TRUE;
		optionButton.tag = kOptionButtonUnSelectedKey;
        
        
        if(textType == FullText){
            CGRect view1Frame = optionImageView.frame;
            view1Frame.origin.y = 110;
            optionImageView.frame = view1Frame;
            
            bacKImageView.frame = CGRectMake(5, 110, 310, 350);
			m_webView.frame=CGRectMake(10,115,300,340);
            
            if(IS_WIDESCREEN){
                
                bacKImageView.frame = CGRectMake(5, 110, 310, 430);
                m_webView.frame=CGRectMake(10, 115, 300, 420);
                
            }

            
        }


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
				[addNotesView_iPhone setSelectionInnerHtmlString:highLightObj.selectedText];
				[addNotesView_iPhone showText:highLightObj.selectedText];
				[addNotesView_iPhone showUserNote:highLightObj.myNotes];
				[addNotesView_iPhone setNoteId:[highLightcomponents objectAtIndex:1]];
				[addNotesView_iPhone.m_saveBtn setHidden:TRUE];
				[addNotesView_iPhone.editButton setHidden:FALSE];
				[addNotesView_iPhone.deleteBtn setHidden:FALSE];
				addNotesView_iPhone.frame=CGRectMake((self.view.frame.size.width-addNotesView_iPhone.frame.size.width)/2, -400.0, addNotesView_iPhone.frame.size.width, addNotesView_iPhone.frame.size.height);
				
				[UIView beginAnimations:@"animationStart" context:nil];
				[UIView setAnimationDuration:0.5];
				
				addNotesView_iPhone.frame=CGRectMake((self.view.frame.size.width-addNotesView_iPhone.frame.size.width)/2, 10.0, addNotesView_iPhone.frame.size.width, addNotesView_iPhone.frame.size.height);
				[UIView commitAnimations];
				[self.view bringSubviewToFront:addNotesView_iPhone];
				
			}
		}
		
		// this condition check only for mail to *************************
		
		NSString *requestString = [[request URL] absoluteString];
		NSArray *components = [requestString componentsSeparatedByString:@":"];
		if ([[components objectAtIndex:0] isEqual:@"mailto"]) 
		{
			if ([CGlobal isMailAccountSet])
			{
				MFMailComposeViewController  *controller = [[MFMailComposeViewController alloc] init];
				controller.mailComposeDelegate = self;
				//[controller setSubject:m_wordDataHolder.sWord];
				//[controller setMessageBody:m_sHtmlData isHTML:YES];
				
				NSArray *arrTo = [NSArray arrayWithObjects:[components objectAtIndex:1] ,nil];
				[controller setToRecipients:arrTo];
				
				[self presentModalViewController:controller animated:YES];
				[controller release];	
			} 
			return 0;
		}
		// this condition check only for mail to *************************
		
        // this check only for click on imqge
		
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
						[self checkAndPushToImageThumbsForImageName:fileName];
						
                    }
                    
					// //NSLog(@"%@",fileName);
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
                else if([[urlCoponents objectAtIndex:0]isEqualToString:@"http:"])
                {
					// [self pushToWebView];
                    return  FALSE;
                }
				
				
                else
                {							
					return  TRUE;
                }
			}
			
			
			
		}
	}
	return YES;
}

#pragma mark --
#pragma mark <MFMailComposeViewControllerDelegate> Methods



// ****************** Show Image Maxima Size ******************************

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
   
		imageWebView.frame = CGRectMake(0 ,45,320 ,420);
		[croosBtn setFrame:CGRectMake(270, 0, 28, 28)];
	
	
	
	
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
        
        [self scrollToTop];
    }
    else{
	if(sectionTagValue)
	{
        if ([sectionTagValue isEqualToString:@"lv_0004"]){
            firstHeadingId = sectionTagValue;
        }
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait|| self.interfaceOrientation== UIInterfaceOrientationPortraitUpsideDown) {
            [m_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var theElement=document.getElementById('%@');var selectedPosX=0;var selectedPosY=0;while(theElement!=null){selectedPosX+=theElement.offsetLeft;selectedPosY+=theElement.offsetTop;theElement=theElement.offsetParent;}window.scrollTo(selectedPosX,selectedPosY);", sectionTagValue]];
            
        }else {
            [m_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var theElement=document.getElementById('%@');var selectedPosX=0;var selectedPosY=0;while(theElement!=null){selectedPosX+=theElement.offsetLeft;selectedPosY+=theElement.offsetTop;theElement=theElement.offsetParent;}window.scrollTo(selectedPosX,selectedPosY-60);", sectionTagValue]];            
        }        
    }
    }
}

// **************** scroll To Top position ***********************

-(void)scrollToTop{
    
    for (UIView *subview in m_webView.subviews)
    {
        if ([subview isKindOfClass:[UIScrollView class]])
            [(UIScrollView*)subview setContentOffset:CGPointZero animated:NO];
    }
    
}

-(IBAction)clickOnResizeButton:(id)sender{
	
	UIButton  *btn=(UIButton *)sender;
  
    if (btn.tag == 100) {
        m_shareView.hidden = FALSE;
        btn.tag= 101;
    }else{
         btn.tag= 100;
     m_shareView.hidden = TRUE;
    }
    
   
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
#pragma mark Button Event
-(void)backToTocView:(id)sender{
    
	ClinicsAppDelegate  *appDelegate=[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
   	if(appDelegate.clinicsDetails==kTAB_BOOKMARKS){
	NSInteger  bookmark=[database retriveCategoryAllclinicSelected:[NSString stringWithFormat:@"SELECT Bookmark FROM tblArticle where issueid = '%@'",appDelegate.seletedIssuneID]];
	if (bookmark == isOne) 
		[self.navigationController popViewControllerAnimated:YES];
		else 
		[self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:0] animated:YES];	
	}
		
	else if(appDelegate.clinicsDetails==kTAB_NOTES){
		NSInteger  note=[database retriveCategoryAllclinicSelected:[NSString stringWithFormat:@"SELECT Bookmark FROM tblArticle where issueid = '%@'",appDelegate.seletedIssuneID]];
		if (note == isOne) 
			[self.navigationController popViewControllerAnimated:YES];
		else 
			[self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:0] animated:YES];	
	  }	
	else if(appDelegate.clinicsDetails==kTAB_CLINICS){
		  [self.navigationController popViewControllerAnimated:YES];
	  }

	
}

// ************************Change Image login Button************************

-(void)clickOnLoginButton:(id)sender{
	ClinicsAppDelegate   *appDelgate =(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelgate clickOnLoginButton:sender];
}

- (void) dismissPopoover
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

// do work option listView  


- (void)showPopOver:(id)sender
{
	
	aricleToCView =[[AritcleListViewController_iPhone alloc] initWithNibName:@"AritcleListViewController_iPhone" bundle:nil];
	aricleToCView.webViewController_iPhone=self;
	UIImage *Image=loginButton.currentImage;
	if (Image == [UIImage imageNamed:@"iPhone_Logout_btn.png"]) {
		aricleToCView.allReadyLogin=TRUE;
	}
	else {
		aricleToCView.allReadyLogin=FALSE;
	}
	
	aricleToCView.articleInfoArr = m_ariticleData;
	
	[self.navigationController presentModalViewController:aricleToCView animated:YES];

}
-(IBAction)clickONSearchButton:(id)sender{
	
	if (searchButton.tag==100) {
		searchBar.hidden=FALSE;
		searchButton.tag=101;
	}
	else {
		[searchBar resignFirstResponder];
		searchBar.hidden=TRUE;
		searchButton.tag=100;
	}
	
	
}

// ************************Change Image login Button************************

-(void)changeImageLoginButton{
	
	ClinicsAppDelegate   *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	[loginButton setImage:[UIImage imageNamed:@"iPhone_Logout_btn.png"] forState:UIControlStateNormal];
	appDelegate.authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",appDelegate.seletedClinicID]];
	
	
}

#pragma mark Add Bookmark

- (IBAction)bookmarkButtonPressed:(id)sender
{
	
	

    DatabaseConnection *database = [DatabaseConnection sharedController];
    ArticleDataHolder *articleDataHolder = [[database loadArticleInfo:articleID] retain]; 
    NSInteger  clinicID=0;
	NSInteger  CategoryID=0;
	clinicID=[database    selectClinicIDFromIssueTable:[NSString stringWithFormat:@"select clinicid from tblissue where issueid=%@",articleDataHolder.sIssueID]];
	CategoryID=[database  selectClinicIDFromIssueTable:[NSString stringWithFormat:@"select categoryID from tblclinic where clinicId=%d",clinicID]];
    if (articleDataHolder.nBookmark == 1){
		[bookmarksBtn setImage:[UIImage imageNamed:@"iPhone_BookmarksGray.png"] forState:UIControlStateNormal];
        [database   updateBookmarkInArticleData:[NSString stringWithFormat:@"UPDATE tblArticle SET Bookmark = 0 where ArticleId = %d",articleDataHolder.nArticleID]]; 
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Bookmark deleted successfully." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
	}// Remove Bookmark
    else  {
		[database   updateBookmarkInArticleData:[NSString stringWithFormat:@"UPDATE tblArticle SET Bookmark = 1,CategoryID = %d ,clinicID = %d where ArticleId = %d",CategoryID,clinicID,articleDataHolder.nArticleID]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Article has been added to Bookmarks."
                              
                      delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
		[bookmarksBtn setImage:[UIImage imageNamed:@"iPhone_BookmarksYellow.png"] forState:UIControlStateNormal];
	}// Add Bookmark
    [articleDataHolder release];
	
	
}

#pragma mark Add Notes

-(void)highlightNotes
{
	hideMenuOption=TRUE;
	
	
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
		
		[addNotesView_iPhone showText:highlightText];
		[addNotesView_iPhone showUserNote:@""];
		[addNotesView_iPhone setNoteId:idstring];
		[addNotesView_iPhone setFilePath:filePath];
		[addNotesView_iPhone setArticleId:articleID];
		[addNotesView_iPhone setSelectionInnerHtmlString:selectionString];
		[addNotesView_iPhone setHighlightedText:highlightText];
		addNotesView_iPhone.frame=CGRectMake((self.view.frame.size.width-addNotesView_iPhone.frame.size.width)/2, -400.0, addNotesView_iPhone.frame.size.width, addNotesView_iPhone.frame.size.height);
		[addNotesView_iPhone.m_saveBtn setHidden:FALSE];
		[addNotesView_iPhone.deleteBtn setHidden:TRUE];
		[addNotesView_iPhone.editButton setHidden:TRUE];
        
		[UIView beginAnimations:@"animationStart" context:nil];
		[UIView setAnimationDuration:0.5];
		
		addNotesView_iPhone.frame=CGRectMake((self.view.frame.size.width-addNotesView_iPhone.frame.size.width)/2, 20.0, addNotesView_iPhone.frame.size.width, addNotesView_iPhone.frame.size.height);
		[UIView commitAnimations];		
	}	
    [self.view bringSubviewToFront:addNotesView_iPhone];
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
	hideMenuOption=FALSE;
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
{   hideMenuOption=FALSE;
	[m_webView reload];
}

//  This Code Use only Add Notes From asbstruct//////////////////////////////////////////

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == -17897) {
		if (buttonIndex==1) {
			
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
				appDelegate.openHTMLADDNoteOpenView  = TRUE;
				UIImage *Image=loginButton.currentImage;
				if (Image==[UIImage imageNamed:@"iPhone_Logout_btn.png"]) {
					[self downloadAritcleShowFullText];
				}else{
						
					appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,aritcleInfoID];
					[appDelegate clickOnLoginButton:loginButton];
					
					
					
					
					
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

		//  Check Size WebView
		if (optionButton.tag == kOptionButtonSelectedKey) {
			bacKImageView.frame = CGRectMake(5, 49, 310, 420);
			m_webView.frame=CGRectMake(10, 65, 300, 390);
			
		}else {
			bacKImageView.frame = CGRectMake(5, 90, 310, 420);
			 m_webView.frame=CGRectMake(10, 95, 300, 365);
		}
		m_webView.hidden=FALSE;
		menuOBJ.hidden=FALSE;
		
	if (pdfhomeview) {
		[pdfhomeview removeFromSuperview];
		[pdfhomeview release];
		pdfhomeview=nil;
	}
	
	resizeButton.tag=100;
	DatabaseConnection *database = [DatabaseConnection sharedController];
    ArticleDataHolder *articleDataHolder1 = [[database loadArticleInfo:articleID] retain]; 
    if (articleDataHolder1.nBookmark == 1){
		[bookmarksBtn setImage:[UIImage imageNamed:@"iPhone_BookmarksYellow.png"] forState:UIControlStateNormal];
	}// BtnBookmark.png
    else  {
		[bookmarksBtn setImage:[UIImage imageNamed:@"iPhone_BookmarksGray.png"] forState:UIControlStateNormal];
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
//  This Code Use only Add Notes From asbstruct//////////////////////////////////////////
-(void)updateNotesInAtricleTable{
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
    ArticleDataHolder *articleDataHolder = [[database loadArticleInfo:articleID] retain]; 
    NSInteger  clinicID=0;
	NSInteger  CategoryID=0;
	clinicID=[database    selectClinicIDFromIssueTable:[NSString stringWithFormat:@"select clinicid from tblissue where issueid=%@",articleDataHolder.sIssueID]];
	CategoryID=[database  selectClinicIDFromIssueTable:[NSString stringWithFormat:@"select categoryID from tblclinic where clinicId=%d",clinicID]];
    if (articleDataHolder.note == 1){
		BOOL  noteID = [database checkNoteInNoteTable:[NSString stringWithFormat:@"select noteID from tblnotes where Articleid=%d",articleID]];
		if (noteID == FALSE) {
			[database   updateBookmarkInArticleData:[NSString stringWithFormat:@"UPDATE tblArticle SET Note = 0,CategoryID = %d ,clinicID = %d where ArticleId = %d",CategoryID,clinicID,articleDataHolder.nArticleID]]; 
			
		}
	}// ******************Remove Bookmark******************
    else  {
		
		[database   updateBookmarkInArticleData:[NSString stringWithFormat:@"UPDATE tblArticle SET Note = 1,CategoryID = %d ,clinicID = %d where ArticleId = %d",CategoryID,clinicID,articleDataHolder.nArticleID]];
		
		
	}// ******************Add Bookmark******************
    [articleDataHolder release];
	
}
#pragma mark  Add Share Option 

-(IBAction)sharedButtonPress:(id)sender{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share" message:nil  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Facebook",@"Twitter",@"Email",nil];
	alert.tag=500;
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex1{
	
	if (alertView.tag == isFivehundred) {
		if (buttonIndex1 == isOne) {
			[self facebookButtonPressed:nil];
		}
		else if(buttonIndex1 == isTwo) {
			[self twitterButtonPressed:nil];
		}
		else if(buttonIndex1 == isThere) {
			[self emailButtonPressed:nil];
		}
		
	}
	
	
}


- (IBAction) emailButtonPressed:(id)sender
{
    if ([CGlobal checkNetworkReachabilityWithAlert])
    {
        
        if ([CGlobal isMailAccountSet])
        {
            MFMailComposeViewController  *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
			[controller setMessageBody:[NSString stringWithFormat:@"%@",doiLinkStr] isHTML:NO];
			
			[self presentModalViewController:controller animated:YES];
            
            [controller release];	
        } 
    }
}

- (IBAction) facebookButtonPressed:(id)sender
{
    if ([CGlobal checkNetworkReachabilityWithAlert])
    {
        [FBShareManager sharedManager];
        [FBShareManager sharedManager].delegate = self;
		[FBShareManager sharedManager].msg = doiLinkStr;
        [[FBShareManager sharedManager] publishStreamWithoutDialogBox];
    }
}

- (IBAction)twitterButtonPressed:(id)sender
{
    
	if ([CGlobal checkNetworkReachabilityWithAlert])
    {
    if ([TWTweetComposeViewController canSendTweet]) {
        // Initialize Tweet Compose View Controller
        TWTweetComposeViewController *vc = [[TWTweetComposeViewController alloc] init];
        
        // Settin The Initial Text
        [vc setInitialText:[NSString stringWithFormat:@"%@",doiLinkStr]];
        
        // Setting a Completing Handler
        [vc setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            [self dismissModalViewControllerAnimated:YES];
        }];
        
        // Display Tweet Compose View Controller Modally
        [self presentViewController:vc animated:YES completion:nil];
        
    } else {
        // Show Alert View When The Application Cannot Send Tweets
        NSString *message = @"The application cannot send a tweet at the moment. This is because it cannot reach Twitter or you don't have a Twitter account associated with this device.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
    }
    }
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


#pragma mark --
#pragma mark <TwitterShareManagerDelegate>
-(void)twitterPostDidSuccess{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success"
                                                    message: @"Thank you for sharing."
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}


-(void)twitterPostDidFail{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
                                                    message: @"An error occurred while submitting your post. Please try again later."
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

#pragma mark --
#pragma mark <FBShareManagerDelegate>
-(void)facebookPostDidSuccess{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success"
                                                    message: @"Thank you for sharing."
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}


-(void)facebookPostDidFail{
    
	
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alert"
                                                    message: @"This is already shared."
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
	[alert show];
	[alert release];
}

// ************************ UIMenuController Delegate ************************************

- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender {
    if (selector == @selector(highlightNotes)) {
		
		if(hideMenuOption == FALSE)
		
			return YES;
	}
	// 
	 
	
	return NO;
	// **********************hide menu view **********************
}

-(void)hidAndShowBookmarksButton{
    
	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
	// **********************don't add bookmarks on Articlein press ********************** 
	if ([loginId intValue] == ishundred) {
		bookmarksBtn.hidden=TRUE;
	}
	else {
		bookmarksBtn.hidden=FALSE;
	}
	
}

// ********************** Open iBook ********************** 

-(void)tabOnAddIBookButton:(id)sender{
    
    
    NSURL  *url = [NSURL fileURLWithPath:m_pdfPath];
   docController = [UIDocumentInteractionController interactionControllerWithURL:url];
    docController.delegate = self;
    [docController retain];
    BOOL isValid = [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    
    if (!isValid) {
        UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry !" message:@"You do not have ibooks." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        RELEASE(alertView);
    }

        
   
    

}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller{
    
    docController.delegate = nil;
    [docController release];
    docController = nil;

     
}

@end
