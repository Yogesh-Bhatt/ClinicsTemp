
//
//  ClinicsDetailsView_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "ClinicsDetailsView_iPhone.h"
#import "CGlobal.h"
#import "TableSectionView.h"
#import "ClinicListViewController.h"
#import "ClinicDetailPrefaceCellView.h"
#import "ArticleCellView_iPhone.h"
#import "ArticleDataHolder.h"
#import "WebViewController_iPhone.h"
#import "RootViewController_iPhone.h"
#import "DownloadController.h"
#import "LoadingHomeView_iPhone.h"

@implementation ClinicsDetailsView_iPhone
@synthesize m_clinicDataHolder;
@synthesize m_issueDataHolder;
@synthesize categoryName;
@synthesize m_popoverController;
@synthesize authentication;

//*************** change view frame **********//

// use flag this methed use issueID in true case is listview and falase case in backissue

-(void)loadDataFromServerISuuseData:(BOOL)flag{
    
	if (flag == TRUE) {
		m_issueId=[self.m_issueDataHolder.sIssueID intValue];
	}
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
	IssueDataHolder *issueDataHolder = [database loadIssueInfo:[NSString stringWithFormat:@"%d",m_issueId]];
	if (issueDataHolder.download==0)
	{
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblissue set download=1 where issueid=%d",m_issueId]];
		self.view.window.userInteractionEnabled = NO;
		
		backLoding=[[UIView alloc] init];
		backLoding.backgroundColor=[UIColor blackColor];
		backLoding.alpha=0.60;
		[self.view addSubview:backLoding];
		backLoding.frame=CGRectMake(0,0,320,480);
		[LoadingHomeView_iPhone displayLoadingIndicator:backLoding :UIInterfaceOrientationPortrait];
        
		[LodingHomeView chagengeMessageLoadingView:dwonloadArticle];
		
		
		[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(loadDataFromServer) userInfo:nil repeats:NO];
	}
	else {
		[self setClinicDetailView];
	}
	
}

-(void)loadDataFromServer{
    
	self.view.window.userInteractionEnabled = YES;
	[LoadingHomeView_iPhone removeLoadingIndicator];
	[backLoding removeFromSuperview];
	[backLoding release];
	backLoding=nil;
	NSMutableDictionary *dict =  (NSMutableDictionary *)[[CGlobal jsonParsorSecond:[NSString stringWithFormat:@"%d",m_issueId]] retain];
	if ([dict count]>0) {
		[CGlobal loadArticleDataFromServer:dict];
		[CGlobal loadReferenceDataFromServer:dict];
		[self setClinicDetailView];
	}
	RELEASE(dict);
}

- (void)setClinicDetailView
{
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    DatabaseConnection *database = [DatabaseConnection sharedController];
	appDelegate.seletedClinicID=self.m_issueDataHolder.nClinicID ;
	
	appDelegate.authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",appDelegate.seletedClinicID]];
	bacKIssueflag=TRUE;
	if ([categoryName length]>0) {
		m_lblTitle.text=categoryName;
	}
	
    //******** Load Article Data *************//
	
	if (m_arrArticles) {
		[m_arrArticles removeAllObjects];
		m_arrArticles = nil;
	}
    m_arrArticles = [[database loadArticleData:[NSString stringWithFormat:@"%d",m_issueId]] retain];
	appDelegate.seletedIssuneID = [NSString stringWithFormat:@"%d",m_issueId];
	[m_tblClinicDetail reloadData];
	
    [self setLoginButtonHidden];
}



-(void)articleInpressClecnicDetails
{
	bacKIssueflag=TRUE;
    DatabaseConnection *database = [DatabaseConnection sharedController];
    //******** Load Article Data *************//
	m_arrArticles = [[database loadIsuureData:self.m_issueDataHolder.nClinicID] retain];
	
	if ([m_arrArticles  count]>0) {
		[m_tblClinicDetail reloadData];
	}
    
    if (tabOnArticleinPress) {
        if ([m_arrArticles count]<=0) {
            UIAlertView   *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:KAlertMessageArticleInPressKey delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            RELEASE(alert);
        }
    }
    
}


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
	
    if (m_issueDataHolder) {
	    RELEASE(m_issueDataHolder);
    }
    
    if (m_clinicDataHolder) {
	    RELEASE(m_clinicDataHolder);
    }
    
    
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
	
    // Do any additional setup after loading the view from its nib
    
	[self  setNavigationBaronView];
	//h_Tabbar.frame=CGRectMake(0, 412, 320, 49);
    self.h_Tabbar.selectedItem = [self.h_Tabbar.items objectAtIndex:0];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.CheckedClinic=0;
	m_lblTitle.text=appDelegate.firstCategoryName;
	
	appDelegate.clinicsdeatils_iPhone = self;
	
    if (m_popoverController != nil)
        [m_popoverController dismissPopoverAnimated:YES];
    
    UIImage *img = [UIImage imageNamed:@"icon_download.png"];
    
    downloadPopOverBtn=[UIButton buttonWithType:UIButtonTypeCustom];
	downloadPopOverBtn.frame=CGRectMake(290,10, img.size.width-10, 25);
    downloadPopOverBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[downloadPopOverBtn setBackgroundImage:[UIImage imageNamed:@"icon_download.png"] forState:UIControlStateNormal];
	[downloadPopOverBtn addTarget:self action:@selector(downloadPopOver:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:downloadPopOverBtn];
    
    check = FALSE;
    
	
}

-(void)downloadPopOver:(id)sender{
    
    
    //[downloadDetailviewController.view removeFromSuperview];
    
    //downloadDetailviewController.view.hidden = FALSE;
    
    if(check == FALSE){
    downloadDetailviewController = [[DownloadDetailViewController_iPhone alloc]                                                         initWithNibName:@"DownloadDetailViewController_iPhone" bundle:nil];
                                                                                                                                                 
    [downloadDetailviewController refreshTblWith:nil];
    
    
    if (downloadPopOverview)
    {
        [downloadPopOverview removeFromSuperview];
        [downloadPopOverview release];
        downloadPopOverview=nil;
    }
    
    downloadPopOverview = [[UIView alloc] initWithFrame:CGRectMake(113,
                                                                   35,
                                                                   210,
                                                                   390)];
    
    downloadPopOverview.backgroundColor = [UIColor blackColor];
        
    [downloadPopOverview addSubview:downloadDetailviewController.view];
    
    [self.view addSubview:downloadPopOverview];
        check = TRUE;
        
    }
    else{
        if (downloadPopOverview)
        {
            [downloadPopOverview removeFromSuperview];
            [downloadPopOverview release];
            downloadPopOverview=nil;
        }
        check = FALSE;
        
    }
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
	ClinicsAppDelegate   *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.clinicsdeatils_iPhone = nil;
}

-(void)setNavigationBaronView{
	
	UIImageView  *m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(0, 0, 320, 44);
	m_imgView.image=[UIImage imageNamed:@"iPhone_NavBar.png"];
	[self.view addSubview:m_imgView];
	[m_imgView release];
	
	m_lblTitle=[[UILabel alloc] init];
	m_lblTitle.frame=CGRectMake(63, 0,195 , 44);
	m_lblTitle.backgroundColor=[UIColor clearColor];
	m_lblTitle.font = [UIFont boldSystemFontOfSize:16.0];
	m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentCenter;
	m_lblTitle.text =@"WELCOME USER";
	[self.view addSubview:m_lblTitle];
	
	
	UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame=CGRectMake(15, 8, 46, 27);
	[backButton setBackgroundImage:[UIImage imageNamed:@"iPhone_Back_btn.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backToListView:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:backButton];
	
	loginButton =[UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.frame=CGRectMake(240, 10, 45, 25);
	[loginButton setBackgroundImage:[UIImage imageNamed:@"iPhone_Login_btn.png"] forState:UIControlStateNormal];
	[loginButton addTarget:self action:@selector(clickOnLoginButton:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:loginButton];
}

-(void)firstCategoryAndFirstCategory:(BOOL)toc{
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	m_lblTitle.text=appDelegate.firstCategoryName;
	m_lblTitle.frame= CGRectMake(0.0, 0.0, 600, 44.0);
    
	NSMutableArray *arrClinics = [[database loadClinicsData:[NSString stringWithFormat:@"Select CategoryID, ClinicID, ClinicTitle, ClinicThumbImageName, ConsultingEditor, Modified, showClinic, authencation  from tblClinic where ClinicID =%d",appDelegate.firstClinicID]] retain];
	
    
    if ([arrClinics count] > 0)
    {
		ClinicsDataHolder *clinicDataHolder = (ClinicsDataHolder *)[arrClinics objectAtIndex:0];
        self.m_clinicDataHolder = clinicDataHolder;
        if ([clinicDataHolder.arrIssue count] > 0)
		{
            self.m_issueDataHolder = [(IssueDataHolder *)[clinicDataHolder.arrIssue objectAtIndex:0] retain];
        }
		else {
			m_issueId = -1;
			self.m_issueDataHolder=nil;
			[self.m_issueDataHolder retain];
		}
        
    }
	else {
		m_issueId=-1;
		self.m_issueDataHolder=nil;
		[self.m_issueDataHolder retain];
	}
	
    [arrClinics release];
    
	if (toc==TRUE) {
		[self setClinicDetailView];
		
	}else {
		[self articleInpressClecnicDetails];
		
	}
	
	m_lblTitle.frame= CGRectMake(0.0, 0.0, 600, 44.0);
	m_lblTitle.text=appDelegate.firstCategoryName;
}


-(void)viewWillAppear:(BOOL)animated{
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	
	appDelegate.clinicsdeatils_iPhone = self;
	appDelegate.ariticleListView=nil;
	
	
	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
    
	//*********************** don't add bookmarks on Articlein press//***********************
    
	if ([loginId intValue] == ishundred) {
		[self articleInpressClecnicDetails];
	}
	else {
		[self setClinicDetailView];
	}
	
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return NO;
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
    switch (indexPath.row)
    {
        case 0:
            return 100.0;
            break;
            
        default:
            return 80.0;
            break;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	sectionView = (TableSectionView_iPhone *)[CGlobal getViewFromXib:@"TableSectionView_iPhone" classname:[TableSectionView_iPhone class] owner:self];
    sectionView.m_lblTitle.text = self.m_clinicDataHolder.sClinicTitle;
	sectionView.m_lblTitle.hidden=TRUE;
	sectionView.seletedBtn.hidden=TRUE;
	[sectionView changeImageOnclickButton:FALSE];
	[sectionView.issueButton addTarget:self action:@selector(ClickOnIssueButton:) forControlEvents:UIControlEventTouchUpInside];
	[sectionView.ariticleButton addTarget:self action:@selector(ClickOnAtricleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([m_arrArticles count] + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:sIdentifier];
	
    if (cell == nil)
	{
        switch (indexPath.row)
        {
            case 0:
            {
                ClinicDetailHeaderCellView_iPhone *cellTemp = (ClinicDetailHeaderCellView_iPhone *)[CGlobal getViewFromXib:@"ClinicDetailHeaderCellView_iPhone" classname:[ClinicDetailHeaderCellView_iPhone class] owner:self];
                
                /*
                 ****** This Condition Add Only Hide Issue Image If user want to see only article in Press************
                 
                 if([m_arrArticles count] == 0){
                 
                 ((ClinicDetailHeaderCellView *)cell).m_imgView.hidden = YES;
                 
                 
                 }
                 ****** This Condition Add Only Hide Issue Image If user want to see only article in Press************
                 */
                
                cellTemp.callerDelegate = self;
                
                if(aritcleInPressFlag == FALSE)
                    cellTemp.m_downloadBtn.hidden = FALSE;
                
                
                //****** This Condition Add Only Hide Issue Image If user want to see only article in Press************
                
                
                
                if([m_arrArticles count]>0){
                    ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:0];
                    if (articleDataHolder.nIsArticleInPress == 1) {
                        ((ClinicDetailHeaderCellView *)cellTemp).m_imgView.hidden = YES;
                    }else{
                        ((ClinicDetailHeaderCellView *)cellTemp).m_imgView.hidden = NO;
                    }
                }
                cell = cellTemp;
                
            }      break;
                
            default:{
				
                ArticleCellView_iPhone *cell1 = (ArticleCellView_iPhone *)[CGlobal getViewFromXib:@"ArticleCellView_iPhone" classname:[ArticleCellView_iPhone class] owner:self];
				ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:indexPath.row-1];
				if ([articleDataHolder.sAbstract length]==0) {
					cell1.m_btnFreeArticle.enabled=FALSE;
				}
				
				cell1.m_btnFreeArticle.tag=indexPath.row;
				cell1.m_PDFBtn.tag=indexPath.row;
				cell1.m_HTMLBtn.tag=indexPath.row;
				[cell1.m_btnFreeArticle addTarget:self action:@selector(ClickOnAbstractButton:) forControlEvents:UIControlEventTouchUpInside];
				[cell1.m_HTMLBtn addTarget:self action:@selector(clickOnFullTextButton:) forControlEvents:UIControlEventTouchUpInside];
				[cell1.m_PDFBtn addTarget:self action:@selector(clickOnPDFButton:) forControlEvents:UIControlEventTouchUpInside];
				cell = cell1;
				break;
			}
        }
	}
    
    switch (indexPath.row)
    {
        case 0:
        {
            //check file present or not
			
			BOOL success;
			NSFileManager *fileManager=[NSFileManager defaultManager];
			NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
			NSString *documentsDirectory=[paths objectAtIndex:0];
			NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.m_issueDataHolder.cover_Img]];
			success=[fileManager fileExistsAtPath:writableDBPath];
			if(success){
				((ClinicDetailHeaderCellView *)cell).m_imgView.image= [UIImage imageWithContentsOfFile:writableDBPath];
			}else {
				if (self.m_issueDataHolder.cover_Img!=nil) {
					
					UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
					activity.frame = CGRectMake(5, 20, 25, 25);
					[activity startAnimating];
					[((ClinicDetailHeaderCellView *)cell).m_imgView addSubview:activity];
					NSDictionary* dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:((ClinicDetailHeaderCellView *)cell).m_imgView,activity,self.m_issueDataHolder.cover_Img,nil] forKeys:[NSArray arrayWithObjects:@"thumb",@"activity",@"imgStr",nil]];
					[NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:dict];
					[activity release];
					[dict release];
				}
				
			}
            
            ((ClinicDetailHeaderCellView *)cell).m_lblClinicTitle.text = self.m_clinicDataHolder.sClinicTitle;
			NSString  *strDate= self.m_issueDataHolder.sReleaseDate;
			
			NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
			[dateForm setDateFormat:@"yyyy-MM-dd"];
			NSDate *newDate = [dateForm dateFromString:strDate];
			[dateForm setDateFormat:@"MMM YYYY"];
			NSString *newDateStr = [dateForm stringFromDate:newDate];
			
			[dateForm release];
            
			
            ((ClinicDetailHeaderCellView_iPhone *)cell).m_lblDate.text = newDateStr;
            ((ClinicDetailHeaderCellView_iPhone *)cell).m_lblIssueTitle.text = self.m_issueDataHolder.sIssueTitle;
			((ClinicDetailHeaderCellView_iPhone *)cell).m_lblConsultingEditor.text = self.m_clinicDataHolder.sConsultingEditor;
			if (self.m_issueDataHolder.sIssueTitle<=0) {
				((ClinicDetailHeaderCellView_iPhone *)cell).m_lblClinicTitle.text=@"This Clinic does not have nay issues on the server.";
			  	
			}
			
        }
            break;
			
        default:
        {
            ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(indexPath.row - 1)];
            [(ArticleCellView_iPhone *)cell setData:articleDataHolder];
            ((ArticleCellView_iPhone *)cell).m_parent = self;
        }
            break;
    }
    
	// //*********************** chage login button if you have Auttencation  of this clinics//***********************
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	
	if (appDelegate.authentication == 1 ) {
		appDelegate.login = TRUE;
		[loginButton setImage:[UIImage imageNamed:@"iPhone_Logout_btn.png"] forState:UIControlStateNormal];
		
    }
    else {
        [loginButton setImage:[UIImage imageNamed:@"iPhone_Login_btn.png"] forState:UIControlStateNormal];
		appDelegate.login = FALSE;
    }
	
    return cell;
}


//************************* Dwonload Show Issue ********************

-(void)ClickOnIssueButton:(id)sender{
    
	aritcleInPressFlag=FALSE;
	if (m_arrArticles) {
		[m_arrArticles release];
		m_arrArticles=nil;
	}
	[[NSUserDefaults standardUserDefaults]setObject:@"101" forKey:@"Flag"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
	////***********************changeImageOnclickButton//***********************
	DatabaseConnection *database = [DatabaseConnection sharedController];
	m_arrArticles = [[database loadArticleData:self.m_issueDataHolder.sIssueID] retain];
	[m_tblClinicDetail reloadData];
}



//************************* Dwonload Article  and Save  ********************

-(void)ClickOnAtricleButton:(id)sender{
    
	if (m_arrArticles) {
		[m_arrArticles release];
		m_arrArticles=nil;
	}
	aritcleInPressFlag=TRUE;
    tabOnArticleinPress = TRUE;
	[[NSUserDefaults standardUserDefaults]setObject:@"100" forKey:@"Flag"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self loadDataAricleINpressFromServer];
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
	//******** Load Article Data *************//
	m_arrArticles = [[database loadIsuureData:self.m_issueDataHolder.nClinicID] retain];
	[m_tblClinicDetail reloadData];
	
}


//************************* Dwonload Article in press From server   ********************

-(void)loadDataAricleINpressFromServer{
	
    
	self.view.window.userInteractionEnabled = NO;
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	// use Ariclein press
	appDelegate.seletedClinicID=self.m_issueDataHolder.nClinicID ;
	
	backLoding=[[UIView alloc] init];
	backLoding.backgroundColor=[UIColor blackColor];
	backLoding.alpha=0.60;
	[self.view addSubview:backLoding];
	
	backLoding.frame=CGRectMake(0, 0, 320,480);
	[LoadingHomeView_iPhone displayLoadingIndicator:backLoding :UIInterfaceOrientationPortrait];
	
    
	[LoadingHomeView_iPhone chagengeMessageLoadingView:dwonloadArticleInPress];
	
	[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(saveDataInTableArticleInprees) userInfo:nil repeats:NO];
	
}


//************************* Dwonload Article in press From server and Save  ********************
-(void)saveDataInTableArticleInprees{
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
	self.view.window.userInteractionEnabled = YES;
	[LoadingHomeView_iPhone removeLoadingIndicator];
	[backLoding removeFromSuperview];
	[backLoding release];
	backLoding=nil;
	
	NSMutableDictionary *dict = (NSMutableDictionary *) [[CGlobal jsonParsorAricleInpress:self.m_issueDataHolder.nClinicID ]retain];
    
	if ([dict count]>0) {
		[CGlobal loadArticleDataFromServer:dict];
		[CGlobal loadReferenceDataFromServer:dict];
		NSString  *date = [dict objectForKey:@"date"];
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblarticle SET downloadDate = '%@' where ClinicID = %d",date,self.m_issueDataHolder.nClinicID]];
		[self articleInpressClecnicDetails];
	}
    RELEASE(dict);
}


//************************* abstruct  Text ********************

-(void)ClickOnAbstractButton:(id)sender{
    
	ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
	ClickInAbstractButton=TRUE;
	ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
	
	BOOL success;
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_abs/%@_abs/main_abs.html",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
	success=[fileManager fileExistsAtPath:writableDBPath];
	if (success) {
        
        DatabaseConnection *database = [DatabaseConnection sharedController];
        [database updateReadInArticleData:articleDataHolder.nArticleID];
        
        
        
        WebViewController_iPhone *viewController = [[WebViewController_iPhone alloc] initWithNibName:@"WebViewController_iPhone" bundle:nil];
        viewController.m_articleDataHolder = articleDataHolder;
        viewController.m_ariticleData=m_arrArticles;
        viewController.textType = AbstractText;
        
        [appDelegate.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
		
	}
	else {
		ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
        //************* Dwonload Zip File From Server pdf as well as Full Text **********************
		[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@_abs",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
	}
	
    
}

//*************************See PDF ********************
-(void)clickOnPDFButton:(id)sender{
	ClinicsAppDelegate   *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
	afterDwonLoading=FALSE;
	UIImage *Image=loginButton.currentImage;
	ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
	
	////*********************** check file present or not //***********************
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
        
        WebViewController_iPhone *viewController = [[WebViewController_iPhone alloc] initWithNibName:@"WebViewController_iPhone" bundle:nil];
        viewController.textType = PdfText;
        viewController.m_articleDataHolder = articleDataHolder;
        viewController.m_ariticleData=m_arrArticles;
        
        [appDelegate.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
	}
	else {
		// check on login or logout
		if (Image==[UIImage imageNamed:@"iPhone_Logout_btn.png"]) {
			//all ready login direct dwon load
            //************* Dwonload Zip File From Server pdf as well as Full Text **********************
			[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
			
		}
		else {
            
            appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
            appDelegate.clickONFullTextOrPdf=TRUE;
            [appDelegate clickOnLoginButton:nil];
            appDelegate.clickONFullTextOrPdf=FALSE;
            
		}
		
		
	}
	
	
}

//*************************See Full Text ********************
-(void)clickOnFullTextButton:(id)sender{
	
    ClinicsAppDelegate   *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	afterDwonLoading = TRUE;
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
	ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
	UIImage *Image = loginButton.currentImage;
	
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
        
        
        WebViewController_iPhone *viewController = [[WebViewController_iPhone alloc] initWithNibName:@"WebViewController_iPhone" bundle:nil];
        viewController.m_articleDataHolder = articleDataHolder;
        viewController.textType = FullText;
        viewController.m_ariticleData=m_arrArticles;
        [appDelegate.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
	}
	else {
		if (Image==[UIImage imageNamed:@"iPhone_Logout_btn.png"]) {
            //************* Dwonload Zip File From Server pdf as well as Full Text **********************
			[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
		}
		else {
            
            appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
            appDelegate.clickONFullTextOrPdf=TRUE;
            [appDelegate clickOnLoginButton:nil];
            appDelegate.clickONFullTextOrPdf=FALSE;
			
		}
		
	}
	
	
}
//*************************Complete Dwoloig Full Text  ********************

-(void)completeDwonloadFullTextAndPdf{
	
	
    ClinicsAppDelegate   *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	
    ArticleDataHolder *articleDataHolder = [(ArticleDataHolder *)[m_arrArticles objectAtIndex:buttnTag-1] retain];
    //********* Save Article is Read ***********//
    DatabaseConnection *database = [DatabaseConnection sharedController];
    [database updateReadInArticleData:articleDataHolder.nArticleID];
    
    //********** Load Data Again ***********//
    
    if (aritcleInPressFlag) {
        [self articleInpressClecnicDetails];
    }else {
        [self setClinicDetailView];
    }
    //ClickInAbstractButton
    
    WebViewController_iPhone *viewController = [[WebViewController_iPhone alloc] initWithNibName:@"WebViewController_iPhone" bundle:nil];
    viewController.m_articleDataHolder = articleDataHolder;
    viewController.m_ariticleData = m_arrArticles;
    if (afterDwonLoading) {
        viewController.textType = FullText;
    }
    else {
        viewController.textType = PdfText;
    }
    if (ClickInAbstractButton==TRUE){
        viewController.textType = AbstractText;
    }
    
    
    [appDelegate.navigationController pushViewController:viewController animated:YES];
    ClickInAbstractButton=FALSE;
    [viewController release];
    viewController=nil;
    [articleDataHolder autorelease];
    
}

//************* Dwonload Zip File From Server pdf as well as Full Text **********************

-(void)downloadFileFromServer:(NSString *)choiceString{
	
	if ([m_arrArticles count]>0) {
		
		DownloadController *downloadController=[DownloadController sharedController];
        [downloadController setSender:self];
		[downloadController addLoaderForView];
		[downloadController createDownloadQueForQueData:choiceString];
	}
	
}

//************************* Change Images For login button ********************

-(void)changeImageLoginButton{
    
	ClinicsAppDelegate   *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	[loginButton setImage:[UIImage imageNamed:@"iPhone_Logout_btn.png"] forState:UIControlStateNormal];
	appDelegate.authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",appDelegate.seletedClinicID]];
}

//*************************Flip Page For Issue********************

-(void)reloadBackIssueIndetaialsView:(NSString *)IssueID1{
	m_issueId = [IssueID1 intValue];
	if (m_issueDataHolder) {
		[m_issueDataHolder release];
		m_issueDataHolder=nil;
	}
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
    
	m_issueDataHolder=	[[database loadIssueInfo:[NSString stringWithFormat:@"%d",m_issueId]] retain];
	[self  loadDataFromServerISuuseData:FALSE];
	
	
}

//************************* DwonloadImage From Server ********************

- (void)loadImage:(NSDictionary*)dataDict {
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSString *coverImageName = [dataDict objectForKey:@"imgStr"];
    NSString *imageStr = IssueImageUrl;
    
    imageStr = [imageStr stringByAppendingString:coverImageName];
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageStr]];
	//write Image to sdoument
	//************************* Cache Image s in Cacse CachesDirectory ********************
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:coverImageName];
	
	
	[imageData writeToFile:[NSString stringWithFormat:@"%@",writableDBPath] atomically:YES];
    
    UIImage *img= [UIImage imageWithData:imageData];
	UIImageView *thumbImg = [dataDict objectForKey:@"thumb"];
    
    if (img) {
		thumbImg.image=img;
        UIActivityIndicatorView *activityInd = [dataDict objectForKey:@"activity"];
        [activityInd removeFromSuperview];
		
	}
    [imageData release];
    
    [pool drain];
}

// *************** back TO prev View ******************

-(void)backToListView:(id)sender{
    
	[self.navigationController popViewControllerAnimated:YES];
	
}

//************************* change Image Login ButtonA********************
-(void)clickOnLoginButton:(id)sender{
	
	ClinicsAppDelegate  *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.downLoadUrl=nil;
	[appDelegate clickOnLoginButton:sender];
	
    
}

-(void)setLoginButtonHidden{
    
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString  *isItLogin = [[NSUserDefaults standardUserDefaults] objectForKey:KisItLoginKey];
    
    if ([isItLogin isEqualToString:@"YES"]) {
        if (appDelegate.authentication  == 1) {
            [loginButton setHidden:NO];
        }else{
            [loginButton setHidden:YES];
            
        }
    }
}

#pragma mark <clinicDeatilHeaderCellViewDelegate>

-(void)downloadIssue{
    
    
    if(m_downloadQueueArr){
        
        [m_downloadQueueArr release];
        m_downloadQueueArr = nil;
    }
    
    m_downloadQueueArr = [[NSMutableArray alloc] init];
    
    
    for(int i = 0 ;i<[m_arrArticles count];i++){
        
        ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:i];
        
        BOOL success;
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/main.html",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
        success=[fileManager fileExistsAtPath:writableDBPath];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
        BOOL checkMatch = FALSE;
        checkMatch = [self currentUrlIsLoading:strUrl];
        
        if(!success && checkMatch == FALSE){
            
            [m_downloadQueueArr addObject:articleDataHolder];
            
        }
        
    }
    
    
    downloadDetailviewController = nil;
    if([m_downloadQueueArr count] ==0)
    {
        
        [CGlobal showMessage:@"" msg:@"All current issue's articles have already been downloaded."];
        return;
    }
    
    
    ///////////////////////////////Checking Clinic is purchased or not//////////////////////////////
    ClinicsAppDelegate   *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"m_numberOfDownload %d == appDelegate.seletedClinicID %d",m_numberOfDownload,appDelegate.seletedClinicID);
    
    if([m_downloadQueueArr count] >0){
        
        ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_downloadQueueArr objectAtIndex:0];
        
        BOOL checkPurchase = TRUE;//[appDelegate isSubscriptionActive:appDelegate.seletedClinicID];
        
        if(checkPurchase){
            
            downloadDetailviewController = [[DownloadDetailViewController_iPhone alloc]                                                         initWithNibName:@"DownloadDetailViewController_iPhone"
                                                                                                                                                         bundle:nil];
            [downloadDetailviewController refreshTblWith:m_downloadQueueArr];
            
            
            m_numberOfDownload = [m_downloadQueueArr count];
            
            [CGlobal showMessage:@"" msg:@"Downloading start."];
            
            
        }else{
            
            // start listening for download completion
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(clinicPurchased)
                                                         name:@"ClinicPurchased"
                                                       object:nil];
            
            appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
            
            [appDelegate  purchasedClinicWithID:appDelegate.seletedClinicID];
            
        }
        
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
}

-(BOOL)currentUrlIsLoading:(NSString *)a_url{
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ClinicsAppDelegate *appDel = (ClinicsAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    BOOL checkMatch = FALSE;
    
    for(int i =0 ;i<[appDel.m_downloadedConnectionArr count] ;i++){
        
        NSURLConnection *conn = (NSURLConnection *)[appDel.m_downloadedConnectionArr objectAtIndex:i];
        if([[conn currentRequest].URL.absoluteString isEqualToString:a_url]){
            checkMatch = TRUE;
            NSLog(@"Match Found");
            break;
        }
    }
    
    return checkMatch;
    
    
}



-(void)clinicPurchased{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"ClinicPurchased"
                                                  object:nil];
    
    downloadDetailviewController = [[DownloadDetailViewController_iPhone alloc]                                                         initWithNibName:@"DownloadDetailViewController_iPhone"
                                                                                                                                                 bundle:nil];
    [downloadDetailviewController refreshTblWith:m_downloadQueueArr];
    
    [CGlobal showMessage:@"" msg:@"Downloading start."];
    
    
    m_numberOfDownload = [m_downloadQueueArr count];
    
    
}


@end
