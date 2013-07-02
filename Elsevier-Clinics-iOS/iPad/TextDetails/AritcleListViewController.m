    //
//  AritcleListViewController.m
//  Clinics
//
//  Created by Ashish Awasthi on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AritcleListViewController.h"
#import "DatabaseConnection.h"
#import "DownloadData.h"
#import "DownloadController.h"
@implementation AritcleListViewController
@synthesize  articleInfoArr;
@synthesize webViewController;
@synthesize allReadyLogin;
@synthesize backLoding;


#pragma View Like Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
	 //******** Load Article Data *************//
    
	ClinicsAppDelegate  *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate; 
	appDelegate.ariticleListView=self;
	appDelegate.aritcleListView=FALSE;
    
	// check First Time  ariclein press or ToC 
    
    NSString  *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"Flag"];
    
    
    DatabaseConnection *database = [DatabaseConnection sharedController];

   IssueDataHolder *m_issueData  = [[database loadIssueInfo:appDelegate.seletedIssuneID] retain];
     self.title = [NSString stringWithFormat:@"%@",m_issueData.sIssueTitle] ;
     RELEASE(m_issueData);
    
	if ([str intValue] == 100) {
		[self ClickOnAtricleButton:nil];
		
	}
	else {
		[self ClickOnIssueButton:nil];
	}

}

-(void)viewWillAppear:(BOOL)animated{
	
}
-(void)viewWillDisappear:(BOOL)animated{
	ClinicsAppDelegate  *appDelegate =[UIApplication sharedApplication].delegate;
	[appDelegate.webViewController hidAndShowBookmarksButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // ****************Overriden to allow any orientation.****************
    return YES;
}

#pragma mark --
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
	if(appDelegate.clinicsDetails==kTAB_CLINICS){
	sectionView = (TableSectionView *)[CGlobal getViewFromXib:@"TableSectionView" classname:[TableSectionView class] owner:self];
	sectionView.m_lblTitle.hidden=TRUE;
     
        [sectionView.issueButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];  
    
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
    
	//*********************changeImageOnclickButton*********************
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
    
	//********************* Toc IN clinic Table*********************
    
	if(appDelegate.clinicsDetails==kTAB_CLINICS)
	articleInfoArr = [[database loadArticleData:appDelegate.seletedIssuneID] retain]; 
	// *********************Toc IN Bookmark Table*********************
    
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
	UIButton  *btn=(UIButton*)sender;
	
	[[NSUserDefaults standardUserDefaults]setObject:@"100" forKey:@"Flag"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	DatabaseConnection *database = [DatabaseConnection sharedController];
    //******** Load Article Data *************//
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    
	if(appDelegate.clinicsDetails==kTAB_CLINICS){
        
		if (btn) {// call in button tab button
		[self loadDataAricleINpressFromServer];
		}else {
			articleInfoArr = [[database loadIsuureData:appDelegate.seletedClinicID] retain];
		}
    }

	// *********************Toc IN Bookmark Table*********************
    
	if(appDelegate.clinicsDetails == kTAB_BOOKMARKS)
		articleInfoArr = [[database  retriveBookmarksAricleData:FALSE :appDelegate.seletedIssuneID] retain];
	if(appDelegate.clinicsDetails == kTAB_NOTES)
		articleInfoArr = [[database  retriveNotesAricleData:FALSE :appDelegate.seletedIssuneID] retain];

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
	
        [webViewController openAbstrauct:articleDataHolder];

	}
	else {
		
		articleDataHolder = (ArticleDataHolder *)[articleInfoArr objectAtIndex:btn.tag];
        //************* Dwonload Zip File From Server pdf as well as Full Text **********************
		[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@_abs",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
	}
	//*********************release aricledata holder*********************
	
	[webViewController dismissPopoover];
	if (articleDataHolder) {
		[articleDataHolder release];
		articleDataHolder=nil;
	}
	
}
-(void)clickOnPDFButton:(id)sender{
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
        DatabaseConnection *database = [DatabaseConnection sharedController];	
        [database updateReadInArticleData:articleDataHolder.nArticleID];

        [self setClinicDetailView];
        [webViewController openPDFfile:articleDataHolder];
	
		}
		else {
            
			if (allReadyLogin) {
			[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
			}else {
				ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
				appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
				
                appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
                appDelegate.clickONFullTextOrPdf=TRUE;
                [appDelegate clickOnLoginButton:sender];
                appDelegate.clickONFullTextOrPdf=FALSE;
		
		  }
		}
	
	[webViewController dismissPopoover];
	
}
-(void)clickOnFullTextButton:(id)sender{

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

            
            //********* Save Article is Read ***********//
            DatabaseConnection *database = [DatabaseConnection sharedController];
            [database updateReadInArticleData:articleDataHolder.nArticleID];
            
            //********** Load Data Again ***********//
            
            [self setClinicDetailView];
			
            [webViewController openHTMLfile:articleDataHolder];

		}
		else {
			if (allReadyLogin) {
        //************* Dwonload Zip File From Server pdf as well as Full Text **********************
			[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
                
			}else {
				
				ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
				appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];

					appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
					appDelegate.clickONFullTextOrPdf=TRUE;
					[appDelegate clickOnLoginButton:sender];
					appDelegate.clickONFullTextOrPdf=FALSE;

			}

		}

	[webViewController dismissPopoover];
	
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
				[webViewController openAbstrauct:articleDataHolder];
			}
			
			if (pressHTMLBtn==TRUE){
				[webViewController openHTMLfile:articleDataHolder];
			}
			if (pressPdfBtn==TRUE) {
				[webViewController openPDFfile:articleDataHolder];
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
    if ([articleInfoArr count]<=0) {
        UIAlertView   *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:KAlertMessageArticleInPressKey delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        RELEASE(alert);
    }

    [atritcleListTableView reloadData];
}

//Aricle INpress Download

-(void)loadDataAricleINpressFromServer{
	
	self.view.window.userInteractionEnabled = NO;
	

	backLoding=[[UIView alloc] init];
	backLoding.backgroundColor=[UIColor blackColor];
	backLoding.alpha=0.60;
	[webViewController.view addSubview:backLoding];
	
	if ([CGlobal isOrientationPortrait]) {
		backLoding.frame=CGRectMake(0, 0,768,1024);
		[LodingHomeView displayLoadingIndicator:backLoding :UIInterfaceOrientationPortrait];
	}
	else {
		backLoding.frame=CGRectMake(0, 0,1024,768);
		[LodingHomeView displayLoadingIndicator:backLoding :UIInterfaceOrientationLandscapeRight];
		
	}
	[LodingHomeView chagengeMessageLoadingView:dwonloadArticleInPress];
	[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(saveDataInTableArticleInprees) userInfo:nil repeats:NO];
	
}

-(void)saveDataInTableArticleInprees{
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	self.view.window.userInteractionEnabled = YES;
	[LodingHomeView removeLoadingIndicator];
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
