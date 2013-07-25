
//
//  ClinicDetailViewController.m
//  Clinics
//
//  Created by Ashish Awasthi on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClinicDetailViewController.h"
#import "CGlobal.h"
#import "TableSectionView.h"
#import "ClinicListViewController.h"
#import "ClinicDetailPrefaceCellView.h"
#import "ArticleCellView.h"
#import "ArticleDataHolder.h"
#import "WebViewController.h"
#import "RootViewController.h"
#import "DownloadController.h"
#import "ListBackIssueController.h"
#import "ZipArchive.h"
#import "DownloadedArticleViewCell.h"

@implementation ClinicDetailViewController
@synthesize m_clinicDataHolder;
@synthesize m_issueDataHolder;
@synthesize m_parentRootVC;
@synthesize categoryName;
@synthesize m_popoverController;
@synthesize authentication,m_tblClinicDetail;

//*************** change view frame **********//
- (void) didRotate:(id)sender
{
    
    [downloadPopOverController dismissPopoverAnimated:YES];
    
    //NSLog(@"ClinicDeatildidRotate");
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[[UIApplication sharedApplication] delegate];
    DatabaseConnection *database = [DatabaseConnection sharedController];
    
    authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d", appDelegate.seletedClinicID]];
    
    if ([CGlobal isOrientationLandscape]) {
        backLoding.frame=CGRectMake(0, 0, 1024, 768);
        [LodingHomeView  inSideIpadLandScape];
        m_imgView.frame=CGRectMake(0, 0, 704, 44);
        m_imgView.image=[UIImage imageNamed:@"704.png"];
        
        CGRect rect = downloadPopOverBtn.frame;
        rect.origin.x = 650;
        
        downloadPopOverBtn.frame = rect;
        
    }else {
        backLoding.frame=CGRectMake(0,0,768,1024);
        [LodingHomeView  inSideIpadPortrait];
        m_imgView.frame=CGRectMake(0, 0, 768, 44);
        m_imgView.image=[UIImage imageNamed:@"768.png"];
        
        CGRect rect = downloadPopOverBtn.frame;
        rect.origin.x = 710;
        
        downloadPopOverBtn.frame = rect;
        
        
    }
    DownloadController *downloadController=[DownloadController sharedController];
    [downloadController ChangeFramewhenRootateDwonloadingStart];
    
    
    if(appDelegate.login == TRUE)
        [m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
    else
        [m_btnLogin setImage:[UIImage imageNamed:@"BtnLogin.png"] forState:UIControlStateNormal];
    
    
    
    if (listBackIssue) {
        [listBackIssue changePositionDoneButton];
    }
    
    
    //******************* Add Clinic Detail View **********************//
    if ([CGlobal isOrientationLandscape]){
        m_addclinicsBtn.frame=CGRectMake((self.view.frame.size.width - 300), 7.0, 75.0,30.0);
        m_btnLogin.frame = CGRectMake((self.view.frame.size.width - 200.0), 7.0, 60.0,30.0);
        [self hidePopOverButton];
    }
    else{
        m_addclinicsBtn.frame=CGRectMake((self.view.frame.size.width - 240), 7.0, 75.0,30.0);
        m_btnLogin.frame = CGRectMake((self.view.frame.size.width - 140), 7.0, 60.0,30.0);
        [self showPopOverButton];
    }
    
    //************* Set table frame height ****************//
    CGRect rcFrame = m_tblClinicDetail.frame;
    if ([CGlobal isOrientationLandscape])
    {
        rcFrame.size.width = 705.0;
        rcFrame.size.height = 704.0;
    }
    else
    {
        rcFrame.size.width = 768.0;
        rcFrame.size.height = 958;
    }
    [self changeSizeNavigationBarTitle];
    m_tblClinicDetail.frame = rcFrame;
    [m_tblClinicDetail reloadData];
    
    [self dismissPopoover];
    
    [self changeXPosAddClinicsButton];
    
}
// use flag this methed use issueID in true case is listview and falase case in backissue
-(void)loadDataFromServerISuuseData:(BOOL)flag{
    
	if (flag == TRUE) {
		IssueID=[self.m_issueDataHolder.sIssueID intValue];
	}
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
	IssueDataHolder *issueDataHolder = [database loadIssueInfo:[NSString stringWithFormat:@"%d",IssueID]];
	if (issueDataHolder.download==0)
	{
        if ([CGlobal checkNetworkReachabilityWithAlert]) {
            [database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblissue set download=1 where issueid=%d",IssueID]];
            self.view.window.userInteractionEnabled = NO;
            ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
            RootViewController  *rootView=(RootViewController*)appDelegate.rootViewController;
            backLoding=[[UIView alloc] init];
            backLoding.backgroundColor=[UIColor blackColor];
            backLoding.alpha=0.60;
            [rootView.view addSubview:backLoding];
            
            if ([CGlobal isOrientationPortrait]) {
                backLoding.frame=CGRectMake(rootView.view.frame.origin.x, rootView.view.frame.origin.y, rootView.view.frame.size.width, rootView.view.frame.size.height);
                [LodingHomeView displayLoadingIndicator:backLoding :UIInterfaceOrientationPortrait];
            }
            else {
                backLoding.frame=CGRectMake(rootView.view.frame.origin.x, rootView.view.frame.origin.y, rootView.view.frame.size.width, rootView.view.frame.size.height);
                [LodingHomeView displayLoadingIndicator:backLoding :UIInterfaceOrientationLandscapeRight];
                
            }
            
            [LodingHomeView chagengeMessageLoadingView:dwonloadArticle];
            
            [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(loadDataFromServer) userInfo:nil repeats:NO];
        }
		else {
            
			m_tblClinicDetail.delegate=nil;
			m_tblClinicDetail.dataSource=nil;
			[CGlobal showMessage:@"Network connection not available" msg:@"A network connection was not detected. Please connect to the network and try again."];
            
		}
        
	}
	else {
		m_tblClinicDetail.delegate=self;
		m_tblClinicDetail.dataSource=self;
		[self setClinicDetailView];
	}
    
    [self setLoginButtonHidden];
}




-(void)loadDataFromServer{
	self.view.window.userInteractionEnabled = YES;
	[LodingHomeView removeLoadingIndicator];
	[backLoding removeFromSuperview];
	[backLoding release];
	backLoding=nil;
	NSMutableDictionary *dict =  (NSMutableDictionary *)[[CGlobal jsonParsorSecond:[NSString stringWithFormat:@"%d",IssueID]] retain];
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
	
    appDelegate.seletedClinicID=self.m_issueDataHolder.nClinicID ;
	
	if(appDelegate.login == TRUE)
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
	else
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogin.png"] forState:UIControlStateNormal];
	
    //******************* Add Clinic Detail View **********************//
    if ([CGlobal isOrientationLandscape]){
        m_addclinicsBtn.frame=CGRectMake((self.view.frame.size.width - 300), 7.0, 75.0,30.0);
        m_btnLogin.frame = CGRectMake((self.view.frame.size.width - 200.0), 7.0, 60.0,30.0);
        [self hidePopOverButton];
        
    }
    else{
        m_addclinicsBtn.frame=CGRectMake((self.view.frame.size.width - 240), 7.0, 75.0,30.0);
        m_btnLogin.frame = CGRectMake((self.view.frame.size.width - 140), 7.0, 60.0,30.0);
        [self showPopOverButton];
    }
    
    
	bacKIssueflag=TRUE;
	if ([categoryName length]>0) {
		m_lblTitle.text=categoryName;
	}
	
    DatabaseConnection *database = [DatabaseConnection sharedController];
    
    //******** Load Article Data *************//
	
	if (m_arrArticles) {
		[m_arrArticles removeAllObjects];
		m_arrArticles = nil;
	}
    m_arrArticles = [[database loadArticleData:[NSString stringWithFormat:@"%d",IssueID]] retain];
	authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d", appDelegate.seletedClinicID]];
	
    reloadArticleType = reloadClinics;
    
	appDelegate.seletedIssuneID=[NSString stringWithFormat:@"%d",IssueID];
    [m_tblClinicDetail reloadData];
    
    [self changeSizeNavigationBarTitle];
    [self setLoginButtonHidden];
}

-(void)articleInpressClecnicDetails
{    // *****************login condition*****************
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	if(appDelegate.login==TRUE)
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
	else
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogin.png"] forState:UIControlStateNormal];
	bacKIssueflag=TRUE;
	
    DatabaseConnection *database = [DatabaseConnection sharedController];
    //******** Load Article Data *************//
    m_arrArticles = [[database loadIsuureData:self.m_issueDataHolder.nClinicID] retain];
    if (tabOnArticleinPress) {
        if ([m_arrArticles count]<=0) {
            UIAlertView   *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:KAlertMessageArticleInPressKey delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            RELEASE(alert);
            tabOnArticleinPress = FALSE;
        }
    }
    
	// *****************use forAuthecation*****************
	authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d", appDelegate.seletedClinicID]];
	
    reloadArticleType = reloadClinics;
    
    [m_tblClinicDetail reloadData];
    
    
}

-(void)loadLatestDownloadedArticles{
    
    reloadArticleType = reloadDownloadedArticles;
    DatabaseConnection *database = [DatabaseConnection sharedController];
    [m_arrArticles removeAllObjects];
    m_arrArticles = nil;
    m_lblTitle.text = @"Downloaded Articles";
    
    m_arrArticles = [[database loadArticleDataWith:@"select ArticleId, IssueId, ArticleTitle, Abstract, ArticlehtmlFileName, LastModified, Author, ArticleType, IsArticleInPress, Bookmark, Read, PdfFileName, PageRange, keywords, ReleaseDate, ArticleInfoId, Doi_Link from tblArticle where downloadRank > 0 order by downloadRank desc limit 50"] retain];
    [m_tblClinicDetail reloadData];
    
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
    
    NSLog(@"ClinicDeatilViewControllerDealloc");
    
    RELEASE(downloadDetailviewController);
    RELEASE(downloadPopOverController);
	[listBackIssue release];
	listBackIssue=nil;
    RELEASE(m_arrArticles);
    [self dismissPopoover];
    RELEASE (m_popoverController);
    RELEASE(m_issueDataHolder);
    RELEASE(m_clinicDataHolder);
    
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
	
    reloadArticleType = reloadClinics;
    // Do any additional setup after loading the view from its nib
    
    m_addclinicsBtn.hidden=FALSE;
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.CheckedClinic=0;
	m_lblTitle.text=appDelegate.firstCategoryName;
    
	
	if ([CGlobal isOrientationLandscape]) {
		m_btnLogin.frame = CGRectMake((self.view.frame.size.width - 140.0), 7.0, 75.0,30.0);
		m_addclinicsBtn.frame=CGRectMake((self.view.frame.size.width - 240), 7.0, 60.0,30.0);
		m_imgView.frame=CGRectMake(0, 0, 704, 44);
		m_imgView.image=[UIImage imageNamed:@"704.png"];
		[self hidePopOverButton];
	}else {
		m_imgView.frame=CGRectMake(0, 0, 768, 44);
		m_imgView.image=[UIImage imageNamed:@"768.png"];
		m_addclinicsBtn.frame=CGRectMake((self.view.frame.size.width - 180.0), 7.0, 75.0,30.0);
		m_btnLogin.frame=CGRectMake(680.0, 7.0, 60.0,30.0);
		
	}
    [self changeSizeNavigationBarTitle];
	m_lblTitle.textAlignment=UITextAlignmentCenter;
	m_lblTitle.frame= CGRectMake(0.0, 0.0, 600, 44.0);
    m_arrArticles = [[NSMutableArray alloc] init];
	m_tblClinicDetail.dataSource = self;
    m_tblClinicDetail.delegate = self;
	
	appDelegate.clinicDetailsView=self;
	
    if (m_popoverController != nil)
        [m_popoverController dismissPopoverAnimated:YES];
    //*************** Getting Device orientation ************/////////////
    // ************************Change Image login Button************************
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageLoginButton) name:@"changeImageLoginButton" object:nil];
    
    UIImage *img = [UIImage imageNamed:@"icon_download.png"];
    
    downloadPopOverBtn=[UIButton buttonWithType:UIButtonTypeCustom];
	downloadPopOverBtn.frame=CGRectMake(640, 7, img.size.width, img.size.height);
    downloadPopOverBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[downloadPopOverBtn setBackgroundImage:[UIImage imageNamed:@"icon_download.png"] forState:UIControlStateNormal];
	[downloadPopOverBtn addTarget:self action:@selector(downloadPopOver:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:downloadPopOverBtn];
    
    // start listening for download completion
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clinicPurchased)
                                                 name:@"ClinicPurchased"
                                               object:nil];
    
}

-(void)downloadPopOver:(id)sender{
    
    
    [downloadDetailviewController.view removeFromSuperview];
    
    downloadDetailviewController.view.hidden = FALSE;
    
    if(downloadPopOverController != nil){
        
        [downloadPopOverController setPopoverContentSize:CGSizeMake(320.0, 768.0)];
        
        if ([CGlobal isOrientationLandscape]) {
            
            [downloadPopOverController presentPopoverFromRect:CGRectMake(500, -740.0 , 320.0, 768.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
            
            
        }else{
            
            [downloadPopOverController presentPopoverFromRect:CGRectMake(550, -740.0 , 320.0, 768.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }else{
        
        [CGlobal showMessage:@"" msg:@"No articles are downloading right now."];
    }
    
}


-(void)firstCategoryAndFirstCategory:(BOOL)toc{
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	
	m_lblTitle.text=appDelegate.firstCategoryName;
    [self changeSizeNavigationBarTitle];
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
			IssueID=-1;
			self.m_issueDataHolder=nil;
			[self.m_issueDataHolder retain];
		}
        
		
        
    }
    else {
        IssueID=-1;
        self.m_issueDataHolder=nil;
        [self.m_issueDataHolder retain];
    }
    
    [arrClinics release];
	if (toc) {
		[self setClinicDetailView];
		
	}else {
		[self articleInpressClecnicDetails];
		
	}
	
    [self changeSizeNavigationBarTitle];
    
	m_lblTitle.text = appDelegate.firstCategoryName;
    
}

-(void)viewWillAppear:(BOOL)animated{
	
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.ariticleListView=nil;
    
    
	if ([CGlobal isOrientationLandscape]){
        m_addclinicsBtn.frame=CGRectMake((self.view.frame.size.width - 300), 7.0, 75.0,30.0);
        m_btnLogin.frame = CGRectMake((self.view.frame.size.width - 200.0), 7.0, 60.0,30.0);
        CGRect rect = downloadPopOverBtn.frame;
        rect.origin.x = 650;
        downloadPopOverBtn.frame = rect;
    }
    else{
        m_addclinicsBtn.frame=CGRectMake((self.view.frame.size.width - 240), 7.0, 75.0,30.0);
        m_btnLogin.frame = CGRectMake((self.view.frame.size.width - 140), 7.0, 60.0,30.0);
        CGRect rect = downloadPopOverBtn.frame;
        rect.origin.x = 710;
        downloadPopOverBtn.frame = rect;
        
    }
    
    //update or auto refresh
    if(reloadArticleType == reloadClinics)
        [appDelegate downLoadUpdateIssueInBackgound];
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
    if(reloadArticleType == reloadClinics){
    switch (indexPath.row)
    {
        case 0:
            return 151.0;
            break;
            
        default:
            return 110.0;
            break;
    }
    }else{
        return 110.0;

    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(reloadArticleType == reloadClinics){
        sectionView = (TableSectionView *)[CGlobal getViewFromXib:@"TableSectionView" classname:[TableSectionView class] owner:self];
        sectionView.m_lblTitle.text = self.m_clinicDataHolder.sClinicTitle;
        sectionView.m_lblTitle.hidden=TRUE;
        sectionView.seletedBtn.hidden=TRUE;
        [sectionView changeImageOnclickButton:FALSE];
        [sectionView.issueButton addTarget:self action:@selector(ClickOnIssueButton:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView.ariticleButton addTarget:self action:@selector(ClickOnAtricleButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return sectionView;
    }else{
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(reloadArticleType == reloadClinics){
        return ([m_arrArticles count] + 1);
    }else{
        return [m_arrArticles count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:sIdentifier];
    
    if (cell == nil)
	{
        if(reloadArticleType == reloadClinics){
            
            switch (indexPath.row)
            {
                case 0:{
                    
                    ClinicDetailHeaderCellView *cellTemp = [CGlobal getViewFromXib:@"ClinicDetailHeaderCellView" classname:[ClinicDetailHeaderCellView class] owner:self];
                    
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
                }
                    //****** This Condition Add Only Hide Issue Image If user want to see only article in Press************
                    break;
                    
                default:{
                    
                    ArticleCellView *cell1 = (ArticleCellView *)[CGlobal getViewFromXib:@"ArticleCellView" classname:[ArticleCellView class] owner:self];
                    ArticleDataHolder *articleDataHolder = nil;
                    if([m_arrArticles count]>0){
                        articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:indexPath.row-1];
                    }
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
        }else{
            
             /// for downloaded Articles
            
            DownloadedArticleViewCell *cell1 = (DownloadedArticleViewCell *)[CGlobal getViewFromXib:@"DownloadedArticleViewCell" classname:[DownloadedArticleViewCell class] owner:self];
            ArticleDataHolder *articleDataHolder = nil;
            
            if([m_arrArticles count]>0){
                
                articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:indexPath.row];
                
            }
            
            cell1.m_btnDeleteArticle.tag=indexPath.row;
            cell1.m_PDFBtn.tag=indexPath.row;
            cell1.m_HTMLBtn.tag=indexPath.row;
            [cell1.m_btnDeleteArticle addTarget:self action:@selector(ClickOnDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell1.m_HTMLBtn addTarget:self action:@selector(clickOnFullTextButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell1.m_PDFBtn addTarget:self action:@selector(clickOnPDFButton:) forControlEvents:UIControlEventTouchUpInside];
            cell = cell1;
            
        }
	}
    
    if(reloadArticleType == reloadClinics){
        switch (indexPath.row)
        {
            case 0:
            {
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
                        activity.frame = CGRectMake(10, 30, 37, 37);
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
                
                
                ((ClinicDetailHeaderCellView *)cell).m_lblDate.text = newDateStr;
                ((ClinicDetailHeaderCellView *)cell).m_lblIssueTitle.text = self.m_issueDataHolder.sIssueTitle;
                ((ClinicDetailHeaderCellView *)cell).m_lblConsultingEditor.text = self.m_clinicDataHolder.sConsultingEditor;
                if (self.m_issueDataHolder.sIssueTitle<=0) {
                    ((ClinicDetailHeaderCellView *)cell).m_lblClinicTitle.text=@"This Clinics title does not have any issues on the server.";
                    
                }
                
            }
                break;
                
            default:
            {
                ArticleDataHolder *articleDataHolder ;
                if ([m_arrArticles count]>0) {
                    articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(indexPath.row - 1)];
                    [(ArticleCellView *)cell setData:articleDataHolder];
                    ((ArticleCellView *)cell).m_parent = self;
                }
            }
                break;
        }
    }else{
        
        
        /// for downloaded Articles
        ArticleDataHolder *articleDataHolder;
        if ([m_arrArticles count]>0) {
            
            articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(indexPath.row)];
            [(DownloadedArticleViewCell *)cell setData:articleDataHolder];
            ((DownloadedArticleViewCell *)cell).m_parent = self;
            
        }
        
    }
	// ***************** chage login button if you have Auttencation  of this clinics*****************
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    
    
	if (authentication == 1 ) {
		
        appDelegate.login = TRUE;
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
		
	}
	else {
        
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogin.png"] forState:UIControlStateNormal];
		appDelegate.login = FALSE;
	}
    
    return cell;
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

- (void)showPopOver
{
    [self dismissPopoover];
    
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	id viewControlller = nil;
	if(appDelegate.m_nCurrentTabTag == kTAB_CLINICS){
		viewControlller = [[ClinicListViewController alloc] initWithNibName:@"ClinicListViewController" bundle:nil];
		
	}
	else if(appDelegate.m_nCurrentTabTag == kTAB_BOOKMARKS){
        
		viewControlller = [[BookMarkListViewController_iPad alloc] initWithNibName:@"BookMarkListViewController_iPad" bundle:nil];
		
	}
	else if(appDelegate.m_nCurrentTabTag == kTAB_NOTES){
        
		viewControlller = [[NotesListViewController_iPad alloc] initWithNibName:@"NotesListViewController_iPad" bundle:nil];
		
	}
    UINavigationController     *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControlller];
    
    m_popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
	m_popoverController.delegate = self;
    [m_popoverController setPopoverContentSize:CGSizeMake(320.0, 768.0)];
    [m_popoverController presentPopoverFromRect:CGRectMake(-100.0, -740.0 , 320.0, 768.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	[viewControlller initClinicListView];
	[viewControlller setFrameM_ScrollView];
    
    RELEASE(viewControlller);
    RELEASE(navigationController);
    
}

-(void)ClickOnIssueButton:(id)sender{
    
	aritcleInPressFlag=FALSE;
	if (m_arrArticles) {
		[m_arrArticles release];
		m_arrArticles=nil;
	}
	[[NSUserDefaults standardUserDefaults]setObject:@"101" forKey:@"Flag"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
	DatabaseConnection *database = [DatabaseConnection sharedController];
    m_arrArticles = [[database loadArticleData:self.m_issueDataHolder.sIssueID] retain];
    
    reloadArticleType = reloadClinics;
    
    [m_tblClinicDetail reloadData];
}


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
    reloadArticleType = reloadClinics;
	[m_tblClinicDetail reloadData];
	
}

-(void)loadDataAricleINpressFromServer{
    
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    // *************** Ariclein press viewControlller***************
    
    appDelegate.seletedClinicID=self.m_issueDataHolder.nClinicID ;
    if (appDelegate.seletedClinicID>0) {
		self.view.window.userInteractionEnabled = NO;
		RootViewController  *rootView=(RootViewController*)appDelegate.rootViewController;
		backLoding=[[UIView alloc] init];
		backLoding.backgroundColor=[UIColor blackColor];
		backLoding.alpha=0.60;
		[rootView.view addSubview:backLoding];
		
		if ([CGlobal isOrientationPortrait]) {
			backLoding.frame=CGRectMake(rootView.view.frame.origin.x, rootView.view.frame.origin.y, rootView.view.frame.size.width, rootView.view.frame.size.height);
			[LodingHomeView displayLoadingIndicator:backLoding :UIInterfaceOrientationPortrait];
		}
		else {
			backLoding.frame=CGRectMake(rootView.view.frame.origin.x, rootView.view.frame.origin.y, rootView.view.frame.size.width, rootView.view.frame.size.height);
			[LodingHomeView displayLoadingIndicator:backLoding :UIInterfaceOrientationLandscapeRight];
			
		}
		[LodingHomeView chagengeMessageLoadingView:dwonloadArticleInPress];
        
		[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(saveDataInTableArticleInprees) userInfo:nil repeats:NO];
    }
	
}
-(void)saveDataInTableArticleInprees{
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
	self.view.window.userInteractionEnabled = YES;
	[LodingHomeView removeLoadingIndicator];
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


-(void)ClickOnAbstractButton:(id)sender{
    
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
        
        //********* Save Article is Read ***********//
        DatabaseConnection *database = [DatabaseConnection sharedController];
        [database updateReadInArticleData:articleDataHolder.nArticleID];
        
        WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        viewController.m_articleDataHolder = articleDataHolder;
        viewController.m_ariticleData=m_arrArticles;
        viewController.textType = AbstractText;
        
        [((RootViewController *)self.m_parentRootVC).navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
        
        
	}
	else {
		ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
        //************* Dwonload Zip File From Server pdf as well as Full Text **********************
        
		[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@_abs",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
	}
    
}

-(void)ClickOnDeleteButton:(id)sender{
    
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
    
	ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag)];
	// ***************check file present or not ***************
	BOOL success;
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",articleDataHolder.sArticleInfoId]];
	success=[fileManager fileExistsAtPath:writableDBPath];
	if(success){
        
        NSError *error = nil;
        [fileManager removeItemAtPath:writableDBPath error:&error];
        
        if(error != nil){
        
            NSLog(@"Error occured");
            
        }
    }

    NSString *sql = [NSString stringWithFormat:@"UPDATE tblarticle SET downloadRank = 0 where ArticleInfoId = '%@'",articleDataHolder.sArticleInfoId];
    NSLog(@"SQl %@",sql);
    
    DatabaseConnection *database = [DatabaseConnection sharedController];
   
    BOOL check =  [database updateArticleDownloaded:[NSString stringWithFormat:@"UPDATE tblArticle SET downloadRank = 0 where ArticleInfoId ='%@'",articleDataHolder.sArticleInfoId]];
    
    if(check){
        
        NSLog(@"True");
        [self loadLatestDownloadedArticles];
        
    }else{
        
         NSLog(@"False");
    
    }
    
}


-(void)clickOnPDFButton:(id)sender{
    
    ClinicsAppDelegate   *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
	afterDwonLoading=FALSE;
	UIImage *Image=m_btnLogin.currentImage;
    
	ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
	// ***************check file present or not ***************
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
        
        WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        viewController.textType = PdfText;
        viewController.m_articleDataHolder = articleDataHolder;
        viewController.m_ariticleData=m_arrArticles;
        [((RootViewController *)self.m_parentRootVC).navigationController pushViewController:viewController animated:YES];
        [viewController release];
		
    }
	else {
		//*************** check on login or logout***************
		if (Image==[UIImage imageNamed:@"BtnLogout.png"]) {
			//***************all ready login direct dwon load***************
            //************* Dwonload Zip File From Server pdf as well as Full Text **********************
			[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
			
		}
		else {
            appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
            appDelegate.clickONFullTextOrPdf=TRUE;
            [appDelegate clickOnLoginButton:sender];
            appDelegate.clickONFullTextOrPdf = FALSE;
			
		}
        
		
	}
    
	
}
-(void)clickOnFullTextButton:(id)sender{
	
    
	afterDwonLoading=TRUE;
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
	
    ArticleDataHolder *articleDataHolder;
    
    if(reloadArticleType == reloadClinics)
        articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
    else
        articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag)];
    
	UIImage *Image=m_btnLogin.currentImage;
	
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/main.html",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
    success=[fileManager fileExistsAtPath:writableDBPath];
    //NSLog(@"%@",writableDBPath);
    
    ////////////////////////////////////////if this article is in downloading process//////////////////////////////////////
    
    BOOL checkMatch = FALSE;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
    checkMatch = [self currentUrlIsLoading:strUrl];
    
    if(checkMatch){
        
        [CGlobal showMessage:@"" msg:@"This article is downloading."];
        return;
    }
    
    
    ////////////////////////////////////////if this article is in downloading process//////////////////////////////////////
    
    
    if(success) {
        //********* Save Article is Read ***********//
        DatabaseConnection *database = [DatabaseConnection sharedController];
        [database updateReadInArticleData:articleDataHolder.nArticleID];
        
        //********** Load Data Again ***********//
        
        WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        viewController.m_articleDataHolder = articleDataHolder;
        viewController.textType = FullText;
        viewController.m_ariticleData=m_arrArticles;
        [((RootViewController *)self.m_parentRootVC).navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
        
    }
	else {
        
		if (Image==[UIImage imageNamed:@"BtnLogout.png"]) {
            //************* Dwonload Zip File From Server pdf as well as Full Text **********************
			[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
		}
		else {
			
            ClinicsAppDelegate   *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
            appDelegate.clickONFullTextOrPdf=TRUE;
            [appDelegate clickOnLoginButton:sender];
            appDelegate.clickONFullTextOrPdf=FALSE;
            
		}
        
	}
	
	
}
-(void)completeDwonloadFullTextAndPdf{
	
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
    //***************ClickInAbstractButton***************
    
    WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    viewController.m_articleDataHolder = articleDataHolder;
    viewController.m_ariticleData=m_arrArticles;
    if (afterDwonLoading) {
        viewController.textType = FullText;
    }
    else {
        viewController.textType = PdfText ;
    }
    if (ClickInAbstractButton==TRUE){
        viewController.textType = AbstractText;
    }
    
    
    [((RootViewController *)self.m_parentRootVC).navigationController pushViewController:viewController animated:YES];
    ClickInAbstractButton=FALSE;
    [viewController release];
    viewController=nil;
    
    
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

-(void)changeImageLoginButton{
	
	[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
    DatabaseConnection *database = [DatabaseConnection sharedController];
    ClinicsAppDelegate   *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    
    authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d", appDelegate.seletedClinicID]];
    
}


-(void)filpScrennShowBackIssue:(NSInteger )clinicID{
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate.rootViewController hideClinicsListViewController];
	[self dismissPopoover];
	if (bacKIssueflag==TRUE) {
		bacKIssueflag=FALSE;
		if (listBackIssue) {
			[listBackIssue.view removeFromSuperview];
			[listBackIssue release];
			listBackIssue=nil;
		}
		
        listBackIssue=[[ListBackIssueController alloc] init];
        [listBackIssue loadDataInTableView:clinicID];
        listBackIssue.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[self view] cache:YES];
        [self.view addSubview:listBackIssue.view];
        [UIView commitAnimations];
	}
	else {
		bacKIssueflag=TRUE;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[self view] cache:YES];
		[UIView commitAnimations];
        
	}
    
    
}


-(void)reloadBackIssueIndetaialsView:(NSString *)IssueID1{
    
	IssueID=[IssueID1 intValue];
	if (m_issueDataHolder) {
		[m_issueDataHolder release];
		m_issueDataHolder=nil;
	}
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
	m_issueDataHolder=	[[database loadIssueInfo:[NSString stringWithFormat:@"%d",IssueID]] retain];
    [self  loadDataFromServerISuuseData:FALSE];
	
	
}

//************************ here Load Image From Server***********************

- (void)loadImage:(NSDictionary*)dictData {
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSLog(@"%@",dictData);
    NSString *temStr = [dictData objectForKey:@"imgStr"];
    NSString *imageStr = IssueImageUrl;
    
    imageStr = [imageStr stringByAppendingString:temStr];
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageStr]];
	
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:temStr];
	
	
	[imageData writeToFile:[NSString stringWithFormat:@"%@",writableDBPath] atomically:YES];
	
    UIImage *img= [UIImage imageWithData:imageData];
	UIImageView *thumbImg = [dictData objectForKey:@"thumb"];
    
    if (img) {
        
		thumbImg.image=img;
        UIActivityIndicatorView *activityInd = [dictData objectForKey:@"activity"];
        [activityInd removeFromSuperview];
		
	}
    [imageData release];
    
    [pool drain];
}

// *********************** change Top Label Size  when Rotate Divice *******************

-(void)changeSizeNavigationBarTitle{
    
    if ([CGlobal isOrientationLandscape])
        m_lblTitle.frame= CGRectMake(0, 0.0, 530, 44.0);
    else
        m_lblTitle.frame= CGRectMake(80, 0.0, 515, 44.0);
}

-(void)setLoginButtonHidden{
    
    NSString  *isItLogin = [[NSUserDefaults standardUserDefaults] objectForKey:KisItLoginKey];
    
    if ([isItLogin isEqualToString:@"YES"]) {
        if (authentication == 1) {
            [m_btnLogin setHidden:NO];
        }else{
            [m_btnLogin setHidden:YES];
            
        }
    }
    [self changeXPosAddClinicsButton];
}


-(void)changeXPosAddClinicsButton{
    
    NSString  *isItLogin = [[NSUserDefaults standardUserDefaults] objectForKey:KisItLoginKey];
    
    if ([isItLogin isEqualToString:@"YES"] && m_btnLogin.hidden == YES) {
        
        if ([CGlobal isOrientationLandscape]) {
            m_addclinicsBtn.frame = CGRectMake(610 , 7.0, 75.0,30.0);
        }else{
            m_addclinicsBtn.frame =  CGRectMake(670, 7.0, 75.0,30.0);
        }
    }
    
}

-(void)showLoginButton:(BOOL)flag{
    
    if (!flag) {
        
        if ([CGlobal isOrientationLandscape]){
            m_addclinicsBtn.frame = CGRectMake((self.view.frame.size.width - 240), 7.0, 75.0,30.0);
        }
        else{
            m_addclinicsBtn.frame=CGRectMake((self.view.frame.size.width - 180), 7.0, 75.0,30.0);
        }
        
    }
    [m_btnLogin setHidden:flag];
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

-(void)addArticlesInDownloadQueue:(NSArray *)a_articleArr{
    
    
    if(m_downloadQueueArr){
        
        [m_downloadQueueArr release];
        m_downloadQueueArr = nil;
    }
    
    m_downloadQueueArr = [[NSMutableArray alloc] init];
    
    
    for(int i = 0 ;i<[a_articleArr count];i++){
        
        ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[a_articleArr objectAtIndex:i];
        
        BOOL success;
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/main.html",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
        success=[fileManager fileExistsAtPath:writableDBPath];
        
        
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
        BOOL checkMatch = FALSE;
        checkMatch = [self currentUrlIsLoading:strUrl];
        
        if(!success && checkMatch == FALSE){
            
            [m_downloadQueueArr addObject:articleDataHolder];
            
        }
        
    }
    
    
    if([m_downloadQueueArr count] ==0){
        
        [CGlobal showMessage:@"" msg:@"All articles of this issue have been downloaded or in process."];
        return;
    }
    
    
    ///////////////////////////////Checking Clinic is purchased or not//////////////////////////////
    ClinicsAppDelegate   *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"m_numberOfDownload %d == appDelegate.seletedClinicID %d",m_numberOfDownload,appDelegate.seletedClinicID);
    
    
    if([m_downloadQueueArr count] >0){
        
        
        ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_downloadQueueArr objectAtIndex:0];
        
        BOOL check = [appDelegate isSubscriptionActive:appDelegate.seletedClinicID];
        
        NSString  *isItLogin = [[NSUserDefaults standardUserDefaults] objectForKey:KisItLoginKey];
        
        UIImage *Image = m_btnLogin.currentImage;
        
        if(check || Image == [UIImage imageNamed:@"BtnLogout.png"] || [isItLogin isEqualToString:@"YES"]){
            
            [self multipleArticleDownload];
            
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

#pragma mark <clinicDeatilHeaderCellViewDelegate>

-(void)downloadIssue{
    
    if ([CGlobal checkNetworkReachabilityWithAlert]) {
        
        if([m_arrArticles count] == 0){
            
            [CGlobal showMessage:@"" msg:@"There is no article to download."];
            
            return;
            
        }
        [self addArticlesInDownloadQueue:m_arrArticles];
        
    }
    
}

-(void)multipleArticleDownload{
    
    downloadDetailviewController = [[DownloadDetailViewController alloc] init];
    [downloadDetailviewController refreshTblWith:m_downloadQueueArr];
    [self.view addSubview:downloadDetailviewController.view];
    downloadDetailviewController.view.hidden = TRUE;
    
    
    downloadPopOverController = [[UIPopoverController alloc] initWithContentViewController:downloadDetailviewController];
    downloadPopOverController.delegate = self;
    [downloadPopOverController setPopoverContentSize:CGSizeMake(320,768)];
    
    m_numberOfDownload = [m_downloadQueueArr count];
    
}

-(void)clinicPurchased{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"ClinicPurchased"
                                                  object:nil];
    
    [self multipleArticleDownload];
    
    [CGlobal showMessage:@"" msg:@"Downloading start."];
    
}


@end
