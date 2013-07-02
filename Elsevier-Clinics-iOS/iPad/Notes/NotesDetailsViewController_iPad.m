    //
//  NotesDetailsViewController_iPad.m
//  Clinics
//
//  Created by Ashish Awasthi on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NotesDetailsViewController_iPad.h"

#import "BookMarksDetailsViewController_iPad.h"
#import "RootViewController.h"

#import "ClinicListViewController.h"
#import "BookMarkListViewController_iPad.h"
#import "NotesListViewController_iPad.h"
#import "SettingListViewContoller.h"
#import "DownloadController.h"
#import "ClinicDetailHeaderCellView.h"
#import "ArticleCellView.h"
#import "WebViewController.h"

@implementation NotesDetailsViewController_iPad
@synthesize m_clinicDataHolder;
@synthesize m_issueDataHolder;
@synthesize m_parentRootVC;
@synthesize categoryName;
@synthesize m_popoverController;
@synthesize authentication;

//*************** change view frame **********//

- (void) didRotate:(id)sender
{
    
    //NSLog(@"NoteDetaildidRotate");
    if ([CGlobal isOrientationLandscape]) {
		m_btnPopOver.hidden=TRUE;
		m_imgView.frame=CGRectMake(0, 0, 704, 44);
		m_imgView.image=[UIImage imageNamed:@"704.png"];
	}else {
		m_btnPopOver.hidden=FALSE;
		m_imgView.frame=CGRectMake(0, 0, 768, 44);
		m_imgView.image=[UIImage imageNamed:@"768.png"];
	}
	DownloadController *downloadController=[DownloadController sharedController];
	[downloadController ChangeFramewhenRootateDwonloadingStart];
    
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;

    DatabaseConnection *database = [DatabaseConnection sharedController];
    authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d", appDelegate.seletedClinicID]];
    
    if(authentication == 1){
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
    }
	else {
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogin.png"] forState:UIControlStateNormal];
    }
	
	
	//******************* Add Clinic Detail View **********************//
    if ([CGlobal isOrientationLandscape]){
		
		m_btnSearch.frame = CGRectMake((self.view.frame.size.width - 200.0), 7.0, 50.0,30.0);
        m_btnLogin.frame = CGRectMake((self.view.frame.size.width - 140.0), 7.0, 60.0,30.0);
        [self hidePopOverButton];
		
	}
    else{
		
		m_btnSearch.frame = CGRectMake((self.view.frame.size.width - 140.0), 7.0, 50.0,30.0);
        m_btnLogin.frame = CGRectMake((self.view.frame.size.width - 76.0), 7.0, 60.0,30.0);
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
}

- (void)setClinicDetailView
{
	
	// **************optionArr check in Article in press or or ToC**************
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	if(appDelegate.login==TRUE)
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
	else 
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogin.png"] forState:UIControlStateNormal];
	
	if ([categoryName length]>0) {
		m_lblTitle.text=categoryName;
	}
	
    DatabaseConnection *database = [DatabaseConnection sharedController];
    //******** Load Article Data *************//
	if ([m_arrArticles count]>0) {
		[m_arrArticles removeAllObjects];
		[m_arrArticles release];
		m_arrArticles=nil;
	}
    m_arrArticles = [[database  retriveNotesAricleData:TRUE :self.m_issueDataHolder.sIssueID] retain]; 
	appDelegate.seletedIssuneID=self.m_issueDataHolder.sIssueID;
	// use forAuthecation
	authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d", appDelegate.seletedClinicID]];
	
	if ([m_arrArticles count]<=0){
		self.m_issueDataHolder=nil;
	}
	
	[m_tblClinicDetail reloadData];
	
   
        [self setLoginButtonHidden];

	
	
}
// **************Check In Book ariticle Avilable Or If **************

-(void)popToLastView{
	// check in Article in press or or ToC
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	if(appDelegate.login==TRUE)
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
	else 
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogin.png"] forState:UIControlStateNormal];
	
	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
	if ([loginId intValue]==101) {
		[ self setClinicDetailView];
		if ([m_arrArticles count]<=0) {
			
			NotesListViewController_iPad  *notesListView=(NotesListViewController_iPad*)appDelegate.m_rootViewController.m_NotesListView;
			[notesListView  initClinicListView];
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
	
    // Do any additional setup after loading the view from its nib
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.CheckedClinic=0;
	m_lblTitle.text=appDelegate.firstCategoryName;
	[self changeSizeNavigationBarTitle];
	
	if ([CGlobal isOrientationLandscape]) {
		m_btnPopOver.hidden=TRUE;
		m_imgView.frame=CGRectMake(0, 0, 704, 44);
		m_imgView.image=[UIImage imageNamed:@"704.png"];
	}else {
		m_btnPopOver.hidden=FALSE;
		m_imgView.frame=CGRectMake(0, 0, 768, 44);
		m_imgView.image=[UIImage imageNamed:@"768.png"];
		m_btnLogin.frame=CGRectMake(680.0, 7.0, 60.0,30.0);
	}
	m_lblTitle.textAlignment=UITextAlignmentCenter;
    m_arrArticles = [[NSMutableArray alloc] init];
	m_tblClinicDetail.dataSource = self;
    m_tblClinicDetail.delegate = self;
	
	
	
    if (m_popoverController != nil) 
        [m_popoverController dismissPopoverAnimated:YES]; 
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageLoginButton) name:@"changeImageLoginButton" object:nil];
    
	
}
-(void)firstCategoryAndFirstCategory:(BOOL)toc{
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	m_lblTitle.text=appDelegate.firstCategoryName;

	// **************check in Article in press or or ToC**************
    
	if(appDelegate.login==TRUE)
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
	else 
		[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogin.png"] forState:UIControlStateNormal];
	
	
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
            return 151.0;
            break;

        default:
            return 110.0;
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
                cell = (ClinicDetailHeaderCellView *)[CGlobal getViewFromXib:@"ClinicDetailHeaderCellView" classname:[ClinicDetailHeaderCellView class] owner:self];
				
                break;
				
            default:{
				
                ArticleCellView *cell1 = (ArticleCellView *)[CGlobal getViewFromXib:@"ArticleCellView" classname:[ArticleCellView class] owner:self];
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
				//**************load Image from document directary if blong**************
				((ClinicDetailHeaderCellView *)cell).m_imgView.image= [UIImage imageWithContentsOfFile:writableDBPath];
			}else {
				if (self.m_issueDataHolder.cover_Img!=nil) {
					//************** load image from server**************
					UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
					activity.frame = CGRectMake(10, 30, 40, 40);
					[activity startAnimating];
					[((ClinicDetailHeaderCellView *)cell).m_imgView addSubview:activity];
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
			
            ((ClinicDetailHeaderCellView *)cell).m_lblClinicTitle.text = self.m_clinicDataHolder.sClinicTitle;
            ((ClinicDetailHeaderCellView *)cell).m_lblDate.text = newDateStr;
            ((ClinicDetailHeaderCellView *)cell).m_lblIssueTitle.text = self.m_issueDataHolder.sIssueTitle;
			((ClinicDetailHeaderCellView *)cell).m_lblConsultingEditor.text = self.m_clinicDataHolder.sConsultingEditor;
			
			if ([m_arrArticles count] == 0) {
				  m_lblTitle.text=@"No Notes";
               
                ((ClinicDetailHeaderCellView *)cell).m_lblClinicTitle.lineBreakMode = UILineBreakModeWordWrap;
				((ClinicDetailHeaderCellView *)cell).m_lblClinicTitle.frame=CGRectMake(70, 19, 600, 63);
				((ClinicDetailHeaderCellView *)cell).m_lblClinicTitle.text= @"Notes are your own comments that you attach to an article. To add notes, tap and hold anywhere in the full text of an article and choose \"Add Note\".";
		
			}
			
        }
            break;
			       
        default:
        {
            ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(indexPath.row - 1)];
            [(ArticleCellView *)cell setData:articleDataHolder];
            ((ArticleCellView *)cell).m_parent = self;
        }
            break;
    }
    
	// ************** chage login button if you have Auttencation  of this clinics**************
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	if (authentication == 1 ) {
		appDelegate.login =TRUE;
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
	id  viewController=nil;
	if(appDelegate.m_nCurrentTabTag == kTAB_CLINICS){
		viewController = [[ClinicListViewController alloc] initWithNibName:@"ClinicListViewController" bundle:nil];
			}
	else if(appDelegate.m_nCurrentTabTag == kTAB_BOOKMARKS){
		viewController = [[BookMarkListViewController_iPad alloc] initWithNibName:@"BookMarkListViewController_iPad" bundle:nil];
		
	}
	else if(appDelegate.m_nCurrentTabTag == kTAB_NOTES){
		viewController = [[NotesListViewController_iPad alloc] initWithNibName:@"NotesListViewController_iPad" bundle:nil];
		
	}
	
    UINavigationController  *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	m_popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    [m_popoverController setPopoverContentSize:CGSizeMake(320.0, 768.0)];
    [m_popoverController presentPopoverFromRect:CGRectMake(-100.0, -740.0 , 320.0, 768.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	[viewController initClinicListView];
	[viewController setFrameM_ScrollView];
	RELEASE(viewController);
    RELEASE(navigationController);
    
    
	
}


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
		
				WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
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
-(void)clickOnPDFButton:(id)sender{
    
	UIButton  *btn=(UIButton *)sender;
	buttnTag=btn.tag;
	afterDwonLoading=FALSE;
	UIImage *Image=m_btnLogin.currentImage;
	ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
	ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
	
				
		BOOL success;
		
		NSFileManager *fileManager=[NSFileManager defaultManager];
		NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
		NSString *documentsDirectory=[paths objectAtIndex:0];
		NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/main.pdf",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
		success=[fileManager fileExistsAtPath:writableDBPath];
		if(success){
			
					
					WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
					viewController.m_articleDataHolder = articleDataHolder;
					viewController.m_ariticleData=m_arrArticles;
					viewController.textType = PdfText;
					
					[appDelegate.navigationController pushViewController:viewController animated:YES];
					[viewController release];
			
			
		}
		else {
			if (Image==[UIImage imageNamed:@"BtnLogout.png"]) {
                //************* Dwonload Zip File From Server pdf as well as Full Text **********************
				[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
			}else {
				
				    ClinicsAppDelegate   *appDelegate= (ClinicsAppDelegate *
                                                        )[UIApplication sharedApplication].delegate;
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
	ClinicsAppDelegate   *appDelegate = (ClinicsAppDelegate *
                                       )[UIApplication sharedApplication].delegate;
	
	ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:(btn.tag-1)];
	UIImage *Image=m_btnLogin.currentImage;
	
		
		BOOL success;
		
		NSFileManager *fileManager=[NSFileManager defaultManager];
		NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
		NSString *documentsDirectory=[paths objectAtIndex:0];
		NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/main.html",articleDataHolder.sArticleInfoId,articleDataHolder.sArticleInfoId]];
		success=[fileManager fileExistsAtPath:writableDBPath];
		if(success){
			
					WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
					viewController.m_articleDataHolder = articleDataHolder;
					viewController.textType = FullText;
				
					viewController.m_ariticleData=m_arrArticles;
					[appDelegate.navigationController pushViewController:viewController animated:YES];
					[viewController release];
			
		}
		else {
			if (Image==[UIImage imageNamed:@"BtnLogout.png"]) {
                //************* Dwonload Zip File From Server pdf as well as Full Text **********************
			[self downloadFileFromServer:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId]];
			}else {
				ClinicsAppDelegate   *appDelegate=(ClinicsAppDelegate *
                                                   )[UIApplication sharedApplication].delegate;
					appDelegate.downLoadUrl=[NSString stringWithFormat:@"%@%@",dwonlodaUrl,articleDataHolder.sArticleInfoId];
					appDelegate.clickONFullTextOrPdf=TRUE;
					[appDelegate clickOnLoginButton:sender];
					appDelegate.clickONFullTextOrPdf=FALSE;
				

			}

		}
	
	
	
}

-(void)completeDwonloadFullTextAndPdf{
    
	ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
	
			ArticleDataHolder *articleDataHolder = (ArticleDataHolder *)[m_arrArticles objectAtIndex:buttnTag-1];
			//********* Save Article is Read ***********//
    
			DatabaseConnection *database = [DatabaseConnection sharedController];
			[database updateReadInArticleData:articleDataHolder.nArticleID];
			
			WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
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

-(void)changeImageLoginButton{
	
	[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
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
   
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:coverImageName];
	
    [imageData writeToFile:[NSString stringWithFormat:@"%@",writableDBPath] atomically:YES];
	
	// Save image document directory********************************
	
    if (img) {
		thumbImg.image=img;
        UIActivityIndicatorView *activityInd = [dictData objectForKey:@"activity"];
        [activityInd removeFromSuperview];
		
	}
	
    [imageData release];
  
    [pool drain];
}

-(void)changeSizeNavigationBarTitle{
    
    if ([CGlobal isOrientationLandscape]) 
        m_lblTitle.frame= CGRectMake(0, 0.0, 630, 44.0);
    else
        m_lblTitle.frame= CGRectMake(80, 0.0, 605, 44.0);
    
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
    
    if ([m_arrArticles count]<=0) {
        [m_btnLogin setHidden:YES];
    }
}

@end
