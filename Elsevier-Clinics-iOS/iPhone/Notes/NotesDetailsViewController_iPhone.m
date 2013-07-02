//
//  NotesDetailsViewController_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "NotesDetailsViewController_iPhone.h"
#import "RootViewController_iPhone.h"
#import "DownloadController.h"
#import "ClinicDetailHeaderCellView_iPhone.h"
#import "ArticleCellView_iPhone.h"
#import "WebViewController_iPhone.h"

@implementation NotesDetailsViewController_iPhone
@synthesize m_clinicDataHolder;
@synthesize m_issueDataHolder;
@synthesize categoryName;

//*************** change view frame **********//

- (void)setClinicDetailView
{
	//***************  check in Article in press or or ToC***************
	
	// *************** check login***************
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	appDelegate.authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",appDelegate.seletedClinicID]];
	
	self.h_Tabbar.selectedItem = [self.h_Tabbar.items objectAtIndex:2];
	
	if(appDelegate.login==TRUE)
		[loginButton setImage:[UIImage imageNamed:@"iPhone_Logout_btn.png"] forState:UIControlStateNormal];
	else
		[loginButton setImage:[UIImage imageNamed:@"iPhone_Login_btn.png"] forState:UIControlStateNormal];
	
	if ([categoryName length]>0) {
		m_lblTitle.text=categoryName;
	}
	
    //******** Load Article Data *************//
	if ([m_arrArticles count]>0) {
		[m_arrArticles removeAllObjects];
		[m_arrArticles release];
		m_arrArticles=nil;
	}
    m_arrArticles = [[database  retriveNotesAricleData:TRUE :self.m_issueDataHolder.sIssueID] retain];
	appDelegate.seletedIssuneID=self.m_issueDataHolder.sIssueID;
    
	// ******************** use forAuthecation**************************************************
    
	authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d", appDelegate.seletedClinicID]];
	
	if ([m_arrArticles count]<=0){
		self.m_issueDataHolder=nil;
	}
	
	[m_tblClinicDetail reloadData];
    
    [self setLoginButtonHidden];
	
}

// ************************ Check In Book ariticle Avilable Or If ************************

-(void)popToLastView{
	// check in Article in press or or ToC
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	
    if(appDelegate.login==TRUE)
		[loginButton setImage:[UIImage imageNamed:@"iPhone_Logout_btn.png"] forState:UIControlStateNormal];
	else
		[loginButton setImage:[UIImage imageNamed:@"iPhone_Login_btn.png"] forState:UIControlStateNormal];
	
	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
	if ([loginId intValue]==101) {
		[ self setClinicDetailView];
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
    RELEASE(m_arrArticles);
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
	
    // Do any additional setup after loading the view from its nib
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	
	appDelegate.CheckedClinic=0;
	m_lblTitle.text=appDelegate.firstCategoryName;
	//h_Tabbar.frame=CGRectMake(0, 412, 320, 49);
	[self setNavigationBaronView];
	
	if(appDelegate.login==TRUE)
		[loginButton setImage:[UIImage imageNamed:@"iPhone_Logout_btn.png"] forState:UIControlStateNormal];
	else
		[loginButton setImage:[UIImage imageNamed:@"iPhone_Login_btn.png"] forState:UIControlStateNormal];
	
	
    m_arrArticles = [[NSMutableArray alloc] init];
	m_tblClinicDetail.dataSource = self;
    m_tblClinicDetail.delegate = self;
    
    
    [CGlobal setFrameWith:self.view];
}

-(void)setNavigationBaronView{
	
	UIImageView  *m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(0, 0, 320, 44);
	m_imgView.image=[UIImage imageNamed:@"iPhone_NavBar.png"];
	[self.view addSubview:m_imgView];
	[m_imgView release];
	
	m_lblTitle=[[UILabel alloc] init];
	m_lblTitle.frame=CGRectMake(62, 0, 190, 44);
	m_lblTitle.backgroundColor=[UIColor clearColor];
	m_lblTitle.font = [UIFont boldSystemFontOfSize:16.0];
	m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentCenter;
	m_lblTitle.text =@"Bookmarks Details";
	[self.view addSubview:m_lblTitle];
	
	UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame=CGRectMake(15, 8, 46, 27);
	[backButton setBackgroundImage:[UIImage imageNamed:@"iPhone_Back_btn.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backToListView:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:backButton];
	
	loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.frame=CGRectMake(260, 10, 45, 25);
	[loginButton setBackgroundImage:[UIImage imageNamed:@"iPhone_Login_btn.png"] forState:UIControlStateNormal];
	[loginButton addTarget:self action:@selector(clickOnLoginButton:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:loginButton];
}

-(void)firstCategoryAndFirstCategory:(BOOL)toc{
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	m_lblTitle.text=appDelegate.firstCategoryName;
	
	// check in Article in press or or ToC
    
	if(appDelegate.login==TRUE)
		[loginButton setImage:[UIImage imageNamed:@"iPhone_Logout_btn.png"] forState:UIControlStateNormal];
	else
		[loginButton setImage:[UIImage imageNamed:@"iPhone_Login_btn.png"] forState:UIControlStateNormal];
	
	
	NSMutableArray *arrClinics = [[database retriveBookmarsClincsData:FALSE :appDelegate.firstCategoryID] retain];
	if (self.m_issueDataHolder) {
		self.m_issueDataHolder=nil;
	}
	if ([arrClinics count] > 0)
	{
		ClinicsDataHolder *clinicDataHolder = (ClinicsDataHolder *)[arrClinics objectAtIndex:0];
		//NSLog(@"clinicDataHolder %@",clinicDataHolder.sClinicTitle);
		self.m_clinicDataHolder = clinicDataHolder;
		if ([clinicDataHolder.arrIssue count] > 0)
		{
			
			self.m_issueDataHolder = [(IssueDataHolder *)[clinicDataHolder.arrIssue objectAtIndex:0] retain];
			
		}
	}
	
	if (toc) {
		[self setClinicDetailView];
	}
	if (arrClinics) {
		[arrClinics release];
		arrClinics=nil;
	}
	
}


-(void)viewWillAppear:(BOOL)animated{
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.ariticleListView=nil;
	[self setClinicDetailView];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([m_arrArticles count] + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sIdentifier = [NSString stringWithFormat:@"CellIdentifier_%d",indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:sIdentifier];
	
    if (cell == nil)
	{
        switch (indexPath.row)
        {
            case 0:
                cell = (ClinicDetailHeaderCellView_iPhone *)[CGlobal getViewFromXib:@"ClinicDetailHeaderCellView_iPhone" classname:[ClinicDetailHeaderCellView_iPhone class] owner:self];
				
                break;
                
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
			BOOL success;
			NSFileManager *fileManager=[NSFileManager defaultManager];
			NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
			NSString *documentsDirectory=[paths objectAtIndex:0];
			NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.m_issueDataHolder.cover_Img]];
			success=[fileManager fileExistsAtPath:writableDBPath];
			if(success){
				// *****************************load Image from document directary if exixts  ***********************
				((ClinicDetailHeaderCellView_iPhone *)cell).m_imgView.image= [UIImage imageWithContentsOfFile:writableDBPath];
			}else {
				if (self.m_issueDataHolder.cover_Img!=nil) {
					// *****************************load Issue image from server************************
					UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
					activity.frame = CGRectMake(10, 30, 40, 40);
					[activity startAnimating];
					[((ClinicDetailHeaderCellView_iPhone *)cell).m_imgView addSubview:activity];
					NSDictionary* dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:((ClinicDetailHeaderCellView *)cell).m_imgView,activity,self.m_issueDataHolder.cover_Img,nil] forKeys:[NSArray arrayWithObjects:@"thumb",@"activity",@"imgStr",nil]];
					[NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:dict];
					[activity release];
					[dict release];
				}
				
			}
            
			NSString  *strDate= self.m_issueDataHolder.sReleaseDate;
			NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
			[dateForm setDateFormat:@"yyyy-MM-dd"];
			NSDate *newDate = [dateForm dateFromString:strDate];
			[dateForm setDateFormat:@"MMM YYYY"];
			NSString *newDateStr = [dateForm stringFromDate:newDate];
			
			[dateForm release];
			
            ((ClinicDetailHeaderCellView_iPhone *)cell).m_lblClinicTitle.text = self.m_clinicDataHolder.sClinicTitle;
            ((ClinicDetailHeaderCellView_iPhone *)cell).m_lblDate.text = newDateStr;
            ((ClinicDetailHeaderCellView_iPhone *)cell).m_lblIssueTitle.text = self.m_issueDataHolder.sIssueTitle;
			((ClinicDetailHeaderCellView_iPhone *)cell).m_lblConsultingEditor.text = self.m_clinicDataHolder.sConsultingEditor;
            
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
    
	//  ***************************** chage login button if you have Auttencation  of this clinics *******************
    
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

//************************ here Show Abstruct ***********************

-(void)ClickOnAbstractButton:(id)sender{
    
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
	ClickInAbstractButton=TRUE;
	ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
	ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
	
	BOOL success;
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_abs/%@_abs/main_abs.html",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
	success=[fileManager fileExistsAtPath:writableDBPath];
	if (success) {
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
//************************ here Show pdf ***********************

-(void)clickOnPDFButton:(id)sender{
    
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
	afterDwonLoading=FALSE;
	UIImage *Image=loginButton.currentImage;
	ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
	ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
	
	
	BOOL success;
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/main.pdf",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
	success=[fileManager fileExistsAtPath:writableDBPath];
	if(success){
        
        WebViewController_iPhone *viewController = [[WebViewController_iPhone alloc] initWithNibName:@"WebViewController_iPhone" bundle:nil];
        viewController.m_articleDataHolder = articleDataHolder;
        viewController.m_ariticleData=m_arrArticles;
        viewController.textType = PdfText;
        [appDelegate.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
	}else {
		if (Image==[UIImage imageNamed:@"iPhone_Logout_btn.png"]) {
            //************* Dwonload Zip File From Server pdf as well as Full Text **********************
			[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
		}else {
            ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
            appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
            appDelegate.clickONFullTextOrPdf=TRUE;
            [appDelegate clickOnLoginButton:sender];
            appDelegate.clickONFullTextOrPdf=FALSE;
		}
		
	}
	
}
//************************ here Show HTML ***********************

-(void)clickOnFullTextButton:(id)sender{
    
	afterDwonLoading=TRUE;
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
    
	ClinicsAppDelegate   *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	
	ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
	UIImage *Image=loginButton.currentImage;
	
	
	BOOL success;
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/main.html",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
	success=[fileManager fileExistsAtPath:writableDBPath];
    if(success){
        //********* Save Article is Read ***********//
        
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
		}else {
            
            appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
            appDelegate.clickONFullTextOrPdf=TRUE;
            [appDelegate clickOnLoginButton:sender];
            appDelegate.clickONFullTextOrPdf=FALSE;
            
		}
		
	}
    
}

-(void)completeDwonloadFullTextAndPdf{
    
	ClinicsAppDelegate   *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	
    ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:buttnTag-1];
    //********* Save Article is Read ***********//
    DatabaseConnection *database = [DatabaseConnection sharedController];
    [database updateReadInArticleData:articleDataHolder.nArticleID];
    
    //********** Load Data Again ***********//
    
    WebViewController_iPhone *viewController = [[WebViewController_iPhone alloc] initWithNibName:@"WebViewController_iPhone" bundle:nil];
    viewController.m_articleDataHolder = articleDataHolder;
    viewController.m_ariticleData=m_arrArticles;
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

// ************************Change Image login Button************************

-(void)changeImageLoginButton{
	
	ClinicsAppDelegate   *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	[loginButton setImage:[UIImage imageNamed:@"iPhone_Logout_btn.png"] forState:UIControlStateNormal];
	appDelegate.authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",appDelegate.seletedClinicID]];
	
}

//************************ here Load Image From Server***********************

- (void)loadImage:(NSDictionary*)dictData {
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSString *coverImageName = [dictData objectForKey:@"imgStr"];
    NSString *imageStr = IssueImageUrl;
    
    imageStr = [imageStr stringByAppendingString:coverImageName];
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageStr]];
    UIImage *img= [UIImage imageWithData:imageData];
	UIImageView *thumbImg = [dictData objectForKey:@"thumb"];
    //********************* Cache Image cache Directory**********************
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:coverImageName];
	[imageData writeToFile:[NSString stringWithFormat:@"%@",writableDBPath] atomically:YES];
    if (img) {
		thumbImg.image=img;
        UIActivityIndicatorView *activityInd = [dictData objectForKey:@"activity"];
        [activityInd removeFromSuperview];
		
	}
	
    [imageData release];
    [pool drain];
}

//******************* pop To LastView ************************************

-(void)backToListView:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
	
}

-(void)clickOnLoginButton:(id)sender{
	ClinicsAppDelegate  *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
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

@end