#import "BookMarksDetailsViewController_iPhone.h"
#import "RootViewController.h"
#import "ClinicListViewController.h"
#import "BookMarkListViewController_iPad.h"
#import "NotesListViewController_iPad.h"
#import "DownloadController.h"
#import "ClinicDetailHeaderCellView_iPhone.h"
#import "ArticleCellView_iPhone.h"
#import "WebViewController.h"

@implementation BookMarksDetailsViewController_iPhone
@synthesize m_clinicDataHolder;
@synthesize m_issueDataHolder;

@synthesize categoryName;
@synthesize m_popoverController;

//*************** change view frame **********//

- (void)setClinicDetailView
{
	
	self.h_Tabbar.selectedItem = [self.h_Tabbar.items objectAtIndex:1];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	 // check login
	DatabaseConnection *database = [DatabaseConnection sharedController];
	appDelegate.authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",appDelegate.seletedClinicID]];
	
	if ([categoryName length]>0) {
		m_lblTitle.text=categoryName;
	}

	if ([m_arrArticles count]>0) {
		[m_arrArticles removeAllObjects];
		[m_arrArticles release];
		m_arrArticles=nil;
	}
    m_arrArticles = [[database  retriveBookmarksAricleData:TRUE :self.m_issueDataHolder.sIssueID] retain]; 
	
	appDelegate.seletedIssuneID=self.m_issueDataHolder.sIssueID;
	if ([m_arrArticles count]<=0){
		m_lblTitle.text=@"No Bookmarks";
		self.m_issueDataHolder=nil;
	}
	[m_tblClinicDetail reloadData];
	
	[self setLoginButtonHidden];
    
	
}

// *****************************Check In Book ariticle Avilable Or If *****************************

-(void)popToLastView{
    
	// check in Article in press or or ToC
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	
	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
	if ([loginId intValue] == 101) {
		[ self setClinicDetailView];
		if ([m_arrArticles count]<=0) {
			BookMarkListViewController_iPad  *bookmarkslistView=(BookMarkListViewController_iPad *)appDelegate.m_rootViewController.bookMarksListView;
			[bookmarkslistView  initClinicListView];
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
    
	//h_Tabbar.frame=CGRectMake(0, 412, 320, 49);
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.CheckedClinic = 0;

	[self setNavigationBaronView];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageLoginButton) name:@"changeImageLoginButton" object:nil];
    
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
	
	NSMutableArray *arrClinics = [[database retriveBookmarsClincsData:TRUE :appDelegate.firstCategoryID] retain]; 
	if (self.m_issueDataHolder) {
		self.m_issueDataHolder=nil;
		
	}
	
	if ([arrClinics count] > 0)
	{  
		ClinicsDataHolder *clinicDataHolder = (ClinicsDataHolder *)[arrClinics objectAtIndex:0];
		self.m_clinicDataHolder = clinicDataHolder;
		if ([clinicDataHolder.arrIssue count] > 0)
		{
			self.m_issueDataHolder = [(IssueDataHolder *)[clinicDataHolder.arrIssue objectAtIndex:0] retain];
		}
	}
	
	if (toc) {
		[self setClinicDetailView];
		
	}	
	RELEASE(arrClinics);
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
				
                ArticleCellView_iPhone *aritcleCell = (ArticleCellView_iPhone *)[CGlobal getViewFromXib:@"ArticleCellView_iPhone" classname:[ArticleCellView_iPhone class] owner:self];
				ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:indexPath.row-1];
				if ([articleDataHolder.sAbstract length]==0) {
					aritcleCell.m_btnFreeArticle.enabled=FALSE;
				}
				
				aritcleCell.m_btnFreeArticle.tag=indexPath.row;
				aritcleCell.m_PDFBtn.tag=indexPath.row;
				aritcleCell.m_HTMLBtn.tag=indexPath.row;
				[aritcleCell.m_btnFreeArticle addTarget:self action:@selector(ClickOnAbstractButton:) forControlEvents:UIControlEventTouchUpInside];
				[aritcleCell.m_HTMLBtn addTarget:self action:@selector(clickOnFullTextButton:) forControlEvents:UIControlEventTouchUpInside];
				[aritcleCell.m_PDFBtn addTarget:self action:@selector(clickOnPDFButton:) forControlEvents:UIControlEventTouchUpInside];
				cell = aritcleCell;
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
				//*****************************load Image from document directary if Exists***************************
				((ClinicDetailHeaderCellView *)cell).m_imgView.image= [UIImage imageWithContentsOfFile:writableDBPath];
			}else {
				if (self.m_issueDataHolder.cover_Img!=nil) {
					// *****************************load image from server*****************************
					UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
					activity.frame = CGRectMake(10, 30, 40, 40);
					[activity startAnimating];
					[((ClinicDetailHeaderCellView *)cell).m_imgView addSubview:activity];
					NSDictionary* imageDatadict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:((ClinicDetailHeaderCellView *)cell).m_imgView,activity,self.m_issueDataHolder.cover_Img,nil] forKeys:[NSArray arrayWithObjects:@"thumb",@"activity",@"imgStr",nil]];
					[NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:imageDatadict];
					[activity release];
					[imageDatadict release];
				}
				
			}
			// *****************************change date formate month*****************************
            
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
			((ClinicDetailHeaderCellView *)cell).m_lblConsultingEditor.text = self.m_clinicDataHolder.sConsultingEditor;
			if (self.m_issueDataHolder.sIssueTitle<=0) {
				[self.navigationController popViewControllerAnimated:YES];
				
			  	
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
    
	// ***************************** chage login button if you have Auttencation  of this clinics*****************************
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


#pragma mark --
#pragma mark UIPooverController Functions

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
        viewController.textType = AbstractText ;
				
     [appDelegate.navigationController pushViewController:viewController animated:YES];
     [viewController release];
				
	}
	else {
		ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
        //************* Dwonload Zip File From Server pdf as well as Full Text **********************
		[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@_abs",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
	}

}

-(void)clickOnPDFButton:(id)sender{
	
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
	afterDwonLoading=FALSE;
	UIImage *Image=loginButton.currentImage;
	ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
	ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
	
	
	// *****************************Check file exist or Not*****************************
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
			
	}
	else {
		// **********************************Check file login or not **********************************
		if (Image==[UIImage imageNamed:@"iPhone_Logout_btn.png"]) {
			// **********************************login yes**********************************
            //************* Dwonload Zip File From Server pdf as well as Full Text **********************
			[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
			
		}else {
			
            ClinicsAppDelegate   *appDelegate= [UIApplication sharedApplication].delegate;
				appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
				appDelegate.clickONFullTextOrPdf=TRUE;
				[appDelegate clickOnLoginButton:sender];
				appDelegate.clickONFullTextOrPdf=FALSE;
		}

	}

}

-(void)clickOnFullTextButton:(id)sender{
    
	afterDwonLoading=TRUE;
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
	ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
	
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
				viewController.textType = FullText ;
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
				[appDelegate clickOnLoginButton:sender];
				appDelegate.clickONFullTextOrPdf=FALSE;

		}
		
	}
	
}

//************************** dwonloding Complete Then Call This Method********************
-(void)completeDwonloadFullTextAndPdf{
    
	ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
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
    
	ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	[loginButton setImage:[UIImage imageNamed:@"iPhone_Logout_btn.png"] forState:UIControlStateNormal];
	appDelegate.authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",appDelegate.seletedClinicID]];
	
    
}
//************************************** Load ImageFirom Serevr **************************************

- (void)loadImage:(NSDictionary*) dataDict {
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSString *coverImageName = [dataDict objectForKey:@"imgStr"];
    
    NSString *imageStr = IssueImageUrl;
    imageStr = [imageStr stringByAppendingString:coverImageName];
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageStr]];
	
	// **************************************Save image document directory********************************

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

// *************************** back To lastView ***************************

-(void)backToListView:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
	
}

// *************************** ChangeImage Login Button ***************************

-(void)clickOnLoginButton:(id)sender{
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
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
