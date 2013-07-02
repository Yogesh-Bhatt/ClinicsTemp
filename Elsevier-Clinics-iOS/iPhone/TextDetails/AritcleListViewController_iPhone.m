//
//  AritcleListViewController_iPhone.m
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AritcleListViewController_iPhone.h"
#import "DatabaseConnection.h"
#import "IssueDataHolder.h"
#import "DownloadData.h"
#import "DownloadController.h"
#import "LoadingHomeView_iPhone.h"

@implementation AritcleListViewController_iPhone
@synthesize  articleInfoArr;
@synthesize webViewController_iPhone ;
@synthesize allReadyLogin;
@synthesize backLoding;

- (void)viewDidLoad {
    [super viewDidLoad];
    
	//******** Load Article Data *************//
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate; 
	appDelegate.ariticleListView=self;
	appDelegate.aritcleListView=FALSE;
	// check First Time  ariclein press or ToC 
    NSString  *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"Flag"];
	if ([str intValue] == 100) {
		[self ClickOnAtricleButton:nil];
		
	}
	else {
		[self ClickOnIssueButton:nil];
	}

	[self setNavigationBaronView];
	
}

//************************** Add SubView On ThisView ******************************

-(void)setNavigationBaronView{
	
	UIImageView  *m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(0, 0, 320, 44);
	m_imgView.image=[UIImage imageNamed:@"iPhone_NavBar.png"];
	[self.view addSubview:m_imgView];
	[m_imgView release];
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate; 
    DatabaseConnection *database = [DatabaseConnection sharedController];
    IssueDataHolder   *m_issueData  = [[database loadIssueInfo:appDelegate.seletedIssuneID] retain]; 

   

	UILabel *m_lblTitle=[[UILabel alloc] init];
	m_lblTitle.frame=CGRectMake(0, 0, 260, 44);
	m_lblTitle.backgroundColor=[UIColor clearColor];
	m_lblTitle.font = [UIFont boldSystemFontOfSize:16.0];
	m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentCenter;
	 m_lblTitle.text = [NSString stringWithFormat:@"%@",m_issueData.sIssueTitle ];
    
	[self.view addSubview:m_lblTitle];
	[m_lblTitle release];
	
	 RELEASE(m_issueData);
    
	UIButton *closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.frame=CGRectMake(260, 8, 46, 27);
	[closeButton setBackgroundImage:[UIImage imageNamed:@"iPhone_Close_btn.png"] forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(clickOncloseBuutton:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:closeButton];
	
   }



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

#pragma mark <UITableViewDelegate, UITableViewDataSource> methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;	  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{    
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return 110.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{   
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    
	// *******************Toc IN clinic Table*******************
	if(appDelegate.clinicsDetails==kTAB_CLINICS){
		sectionView = (TableSectionView *)[CGlobal getViewFromXib:@"TableSectionView" classname:[TableSectionView class] owner:self];
		sectionView.m_lblTitle.hidden=TRUE;
		sectionView.ariticleButton.frame=CGRectMake(150, 1,  101, 30);
		sectionView.issueButton.frame=CGRectMake(50, 1,  101, 30);
		[sectionView changeImageOnclickButton:FALSE];
		[sectionView.issueButton addTarget:self action:@selector(ClickOnIssueButton:) forControlEvents:UIControlEventTouchUpInside];
		[sectionView.ariticleButton addTarget:self action:@selector(ClickOnAtricleButton:) forControlEvents:UIControlEventTouchUpInside];
		
		return sectionView;
	}else {
		return nil;
	}
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{	        
    return ([articleInfoArr count] );
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
    NSString *sIdentifier = [NSString stringWithFormat:@"CellIdentifier_%d",indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:sIdentifier];
	
    if (cell == nil)
	{
		AriticleListCell *cell1 = (AriticleListCell *)[CGlobal getViewFromXib:@"AriticleListCell" classname:[AriticleListCell class] owner:self];
		ArticleDataHolder *articleDataHolder1 = (ArticleDataHolder *)[articleInfoArr objectAtIndex:indexPath.row];
		if ([articleDataHolder1.sAbstract length]==0) {
			cell1.m_btnFreeArticle.enabled=FALSE;
		}
		
		cell1.m_btnFreeArticle.tag=indexPath.row;
		cell1.m_PDFBtn.tag=indexPath.row;
		cell1.m_HTMLBtn.tag=indexPath.row;
		[cell1.m_btnFreeArticle addTarget:self action:@selector(ClickOnAbstractButton:) forControlEvents:UIControlEventTouchUpInside];
		[cell1.m_HTMLBtn addTarget:self action:@selector(clickOnFullTextButton:) forControlEvents:UIControlEventTouchUpInside];
		[cell1.m_PDFBtn addTarget:self action:@selector(clickOnPDFButton:) forControlEvents:UIControlEventTouchUpInside];
		cell = (UITableViewCell *)cell1;
		
		
	}
	
	ArticleDataHolder *articleDataHolder1 = (ArticleDataHolder *)[articleInfoArr objectAtIndex:indexPath.row];
	[(AriticleListCell *)cell setData:articleDataHolder1];
	((AriticleListCell *)cell).m_parent = self;
	
	
	return cell;		
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{		
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

}



-(void)ClickOnIssueButton:(id)sender{
	
	if (articleInfoArr) {
		[articleInfoArr release];
		articleInfoArr=nil;
	}
	[[NSUserDefaults standardUserDefaults]setObject:@"101" forKey:@"Flag"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
	//***********************changeImageOnclickButton/***********************
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
    
	// /*********************** Toc IN clinic Table/***********************
	if(appDelegate.clinicsDetails==kTAB_CLINICS)
		articleInfoArr = [[database loadArticleData:appDelegate.seletedIssuneID] retain]; 
    
	///*********************** Toc IN Bookmark Table/***********************
    
	if(appDelegate.clinicsDetails == kTAB_BOOKMARKS)
		articleInfoArr = [[database  retriveBookmarksAricleData:TRUE :appDelegate.seletedIssuneID] retain];
	if(appDelegate.clinicsDetails == kTAB_NOTES)
		articleInfoArr = [[database  retriveNotesAricleData:TRUE :appDelegate.seletedIssuneID] retain];
	
	[atritcleListTableView reloadData];
}


-(void)ClickOnAtricleButton:(id)sender{
    
	if (articleInfoArr) {
		[articleInfoArr release];
		articleInfoArr=nil;
	}
	UIButton  *articleBtn=(UIButton*)sender;
	
	[[NSUserDefaults standardUserDefaults]setObject:@"100" forKey:@"Flag"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	DatabaseConnection *database = [DatabaseConnection sharedController];
    //******** Load Article Data *************//
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	if(appDelegate.clinicsDetails==kTAB_CLINICS){
		if (articleBtn) {// call in button tab button
			[self loadDataAricleINpressFromServer];
		}
        else {
			articleInfoArr = [[database loadIsuureData:appDelegate.seletedClinicID] retain];
		}
	}
	// /***********************Toc IN Bookmark Table/***********************
    
	if(appDelegate.clinicsDetails == kTAB_BOOKMARKS){
		articleInfoArr = [[database  retriveBookmarksAricleData:FALSE :appDelegate.seletedIssuneID] retain];
    }
	if(appDelegate.clinicsDetails == kTAB_NOTES){
		articleInfoArr = [[database  retriveNotesAricleData:FALSE :appDelegate.seletedIssuneID] retain];
    }

	[atritcleListTableView reloadData];

}

-(void)ClickOnAbstractButton:(id)sender{
	pressAbstructBtn=TRUE;
	pressHTMLBtn=FALSE;
	pressPdfBtn=FALSE;
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
 	articleDataHolder = [(ArticleDataHolder *)[articleInfoArr objectAtIndex:buttnTag] retain];
	BOOL success;
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_abs/%@_abs/main_abs.html",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
	success=[fileManager fileExistsAtPath:writableDBPath];
	if (success) {
	
		//********* Save Article is Read ***********//
		DatabaseConnection *database = [DatabaseConnection sharedController];
		[database updateReadInArticleData:articleDataHolder.nArticleID];
		
		//********** Load Data Again ***********//
		
		[self setClinicDetailView];
		
		[webViewController_iPhone openAbstrauct:articleDataHolder];

	}
	else {
		
		articleDataHolder = (ArticleDataHolder *)[articleInfoArr objectAtIndex:btn.tag];
        //************* Dwonload Zip File From Server pdf as well as Full Text **********************
		[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@_abs",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
	}
	[webViewController_iPhone dismissPopoover];
    
	///***********************release aricledata holder/***********************

	if (articleDataHolder) {
		[articleDataHolder release];
		articleDataHolder=nil;
	}
	
}
-(void)clickOnPDFButton:(id)sender{
    
	ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
	pressAbstructBtn=FALSE;
	pressHTMLBtn=FALSE;
	pressPdfBtn=TRUE;
	articleDataHolder = [(ArticleDataHolder *)[articleInfoArr objectAtIndex:buttnTag] retain];
	
	BOOL success;
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/main.pdf",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
	success=[fileManager fileExistsAtPath:writableDBPath];
	if(success){

		//********* Save Article is Read ***********//
		[database updateReadInArticleData:articleDataHolder.nArticleID];
		[self setClinicDetailView];
		[webViewController_iPhone openPDFfile:articleDataHolder];

	}
	else {

		appDelegate.authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",appDelegate.seletedClinicID]];
		if (appDelegate.authentication == isOne) {
   //************* Dwonload Zip File From Server pdf as well as Full Text **********************
			[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
		}else {
	
				appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
				appDelegate.clickONFullTextOrPdf=TRUE;
				[appDelegate clickOnLoginButton:nil];
				appDelegate.clickONFullTextOrPdf=FALSE;

		}
	}

	[webViewController_iPhone dismissPopoover];

}
-(void)clickOnFullTextButton:(id)sender{

	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	pressAbstructBtn=FALSE;
	pressHTMLBtn=TRUE;
	pressPdfBtn=FALSE;
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
	
	articleDataHolder = [(ArticleDataHolder *)[articleInfoArr objectAtIndex:buttnTag] retain];
	
	BOOL success;
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/main.html",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
	success=[fileManager fileExistsAtPath:writableDBPath];
	if(success){

		//					
		
		//********* Save Article is Read ***********//
		
		[database updateReadInArticleData:articleDataHolder.nArticleID];
		
		//********** Load Data Again ***********//
		
		[self setClinicDetailView];
		
		[webViewController_iPhone openHTMLfile:articleDataHolder];

	}
	else {
		appDelegate.authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",appDelegate.seletedClinicID]];
		if (appDelegate.authentication == isOne) {
	
   //************* Dwonload Zip File From Server pdf as well as Full Text **********************
			[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
		}else {
	
				appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
				appDelegate.clickONFullTextOrPdf=TRUE;
				[appDelegate clickOnLoginButton:nil];
				appDelegate.clickONFullTextOrPdf=FALSE;
			}

		}

	[webViewController_iPhone dismissPopoover];

}
-(void)completeDwonloadFullTextAndPdfReloadONWebView{
	
	if (articleDataHolder) {
		[articleDataHolder release];
		articleDataHolder=nil;
	}	    
	articleDataHolder = [(ArticleDataHolder *)[articleInfoArr objectAtIndex:buttnTag] retain];
	
	//********* Save Article is Read ***********//
	DatabaseConnection *database = [DatabaseConnection sharedController];
	[database updateReadInArticleData:articleDataHolder.nArticleID];
	
	//********** Load Data Again ***********//
	
	
	[self setClinicDetailView];
	
	if (pressAbstructBtn==TRUE) {
		[webViewController_iPhone openAbstrauct:articleDataHolder];
	}
	
	if (pressHTMLBtn==TRUE){
		[webViewController_iPhone openHTMLfile:articleDataHolder];
	}
	if (pressPdfBtn==TRUE) {
		[webViewController_iPhone openPDFfile:articleDataHolder];
	}

}

//************* Dwonload Zip File From Server pdf as well as Full Text **********************
-(void)downloadFileFromServer:(NSString *)choiceString{
	
	if ([articleInfoArr count]>0) {
		DownloadController *downloadController=[DownloadController sharedController];
        [downloadController setSender:self];
		[downloadController addLoaderForView];
		[downloadController createDownloadQueForQueData:choiceString];
	}	
	
}

- (void)setClinicDetailView
{
	
	if (articleInfoArr) {
		[articleInfoArr release];
		articleInfoArr=nil;
	}
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate; 
    DatabaseConnection *database = [DatabaseConnection sharedController];
    //******** Load Article Data *************//
    articleInfoArr = [[database loadArticleData:appDelegate.seletedIssuneID] retain]; 
	[atritcleListTableView reloadData];
	
	
}

-(void)articleInpressClecnicDetails
{
	DatabaseConnection *database = [DatabaseConnection sharedController];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	articleInfoArr = [[database loadIsuureData:appDelegate.seletedClinicID] retain]; 
    [atritcleListTableView reloadData];
    
    if ([articleInfoArr count]<=0) {
        UIAlertView   *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:KAlertMessageArticleInPressKey delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        RELEASE(alert);
    }

}

///***********************Aricle INpress Download/***********************

-(void)loadDataAricleINpressFromServer{
	
	backLoding=[[UIView alloc] init];
	backLoding.backgroundColor=[UIColor blackColor];
	backLoding.alpha=0.60;
	[self.view addSubview:backLoding];
	
	if ([CGlobal isOrientationPortrait]) {
		backLoding.frame=CGRectMake(0, 0,320,480);
		[LoadingHomeView_iPhone displayLoadingIndicator:backLoding :UIInterfaceOrientationPortrait];
	}
	else {
		backLoding.frame=CGRectMake(0, 0,320,480);
		[LoadingHomeView_iPhone displayLoadingIndicator:backLoding :UIInterfaceOrientationLandscapeRight];
		
	}
	[LodingHomeView chagengeMessageLoadingView:dwonloadArticleInPress];
    
	[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(saveDataInTableArticleInprees) userInfo:nil repeats:NO];
	
}

-(void)saveDataInTableArticleInprees{
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	self.view.window.userInteractionEnabled = YES;
	[LoadingHomeView_iPhone removeLoadingIndicator];
	[backLoding removeFromSuperview];
	[backLoding release];
	backLoding=nil;
	
	NSMutableDictionary *dict = (NSMutableDictionary *) [[CGlobal jsonParsorAricleInpress:appDelegate.seletedClinicID ]retain];
	if ([dict count]>0) {
		[CGlobal loadArticleDataFromServer:dict];
		[CGlobal loadReferenceDataFromServer:dict];
		NSString  *date = [dict objectForKey:@"date"];
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblarticle SET downloadDate = '%@' where ClinicID = %d",date,appDelegate.seletedClinicID]];
		[self articleInpressClecnicDetails];
	}
	RELEASE(dict);
}

// ******************Go in Article ListView***************************

-(void)clickOncloseBuutton:(id)sender{
	ClinicsAppDelegate  *appDelegate =[UIApplication sharedApplication].delegate;
	[appDelegate.wewView_iPhone hidAndShowBookmarksButton];
	[appDelegate.navigationController dismissModalViewControllerAnimated:YES];
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	if (articleDataHolder) {
		[articleDataHolder release];
		articleDataHolder=nil;
	}
}


@end
