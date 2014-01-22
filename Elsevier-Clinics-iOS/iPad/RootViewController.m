//
//  RootViewController.m
//  Clinics
//
//  Created by Kiwitech on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "CGlobal.h"
#import "LoginViewController.h"

#import "LoadingViewlogin.h"
#import "DownloadController.h"
#import "ListBackIssueController.h"
@implementation RootViewController

@synthesize m_clinicListVC;
@synthesize m_clinicDetailVC;


@synthesize m_settingListVC;
@synthesize m_settingDetailVC;

@synthesize bookMarkDetailsView;
@synthesize bookMarksListView;

@synthesize m_NotesListView;
@synthesize m_NotesDetailsView;

@synthesize aboutListView;
@synthesize homeEditor;
//*************** change view frame **********//
- (void) didRotate:(NSNotification *)notification
{	
    //******************* Add List View **********************//

    NSLog(@"RootViewdidRotate");
    if ([CGlobal isOrientationLandscape])
	{
		
		if (m_clinicListVC) {
		self.m_clinicListVC.view.hidden=FALSE;
    
		self.m_clinicListVC.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
	
		self.m_clinicListVC.h_Tabbar.frame=CGRectMake(0, 699,320 ,49);	
		
			
		}
		if(m_settingListVC){
		self.m_settingListVC.view.hidden=FALSE;

			if (self.m_settingListVC.m_tblCategory) {
			
				self.m_settingListVC.m_tblCategory.frame=CGRectMake(0, 44,m_settingListVC.view.frame.size.width ,650);
			}
		
		self.m_settingListVC.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
		}
        
		if (bookMarksListView){
		self.bookMarksListView.view.frame=CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
		self.bookMarksListView.m_scrollView.frame=CGRectMake(0, 44, 320, 655);
		self.bookMarksListView.h_Tabbar.frame=CGRectMake(0, 699,320 ,49);
		}
		if (m_NotesListView){
			self.m_NotesListView.view.frame=CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
			self.m_NotesListView.m_scrollView.frame=CGRectMake(0, 44, 320, 655);
			self.m_NotesListView.h_Tabbar.frame=CGRectMake(0, 699,320 ,49);
		}
		 //******************* Add Detail View **********************//
		if (m_clinicDetailVC) {
		self.m_clinicDetailVC.view.frame = CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1));
		}
		if(m_settingListVC){
        self.m_settingDetailVC.view.frame = CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1));
		}
		
		if(homeEditor){
			self.homeEditor.view.frame = CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1));
		}
			if (aboutListView) {
			
			if (self.aboutListView.tabbar) {
				self.aboutListView.tabbar.frame	=CGRectMake(0, 699,320 ,49);
				self.aboutListView.shareTableView.frame=CGRectMake(0, 44,aboutListView.view.frame.size.width ,800);
			}
			
			self.aboutListView.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
			self.aboutListView.view.hidden=FALSE;	
		}
		if (bookMarkDetailsView){
			bookMarksListView.view.hidden=FALSE;	
		self.bookMarkDetailsView.view.frame=CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1));
		}
		if (m_NotesDetailsView){
			m_NotesListView.view.hidden=FALSE;	
			self.m_NotesDetailsView.view.frame=CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1));
			
		}
    }
    else
    {   if(m_clinicListVC){
		self.m_clinicListVC.view.hidden=TRUE;
        self.m_clinicListVC.view.frame = CGRectMake(0 , 0, 0, 0.0);
     	}
		if(m_settingListVC){
        self.m_settingListVC.view.frame = CGRectMake(0 , 0, 0, 0.0);
		}
		
		if (bookMarksListView) {
		self.bookMarksListView.view.frame=CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH,kLIST_VC_SIZE_HEIGHT);
		bookMarksListView.view.hidden=TRUE;				
		}
		if (m_NotesListView) {
			self.m_NotesListView.view.frame=CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH,kLIST_VC_SIZE_HEIGHT);
			m_NotesListView.view.hidden=TRUE;				
		}
		 //******************* Add Detail View **********************//
		if (m_clinicDetailVC) {
		self.m_clinicDetailVC.view.frame = CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
		}
		if(m_settingListVC){
			m_settingListVC.view.hidden=TRUE;
        self.m_settingDetailVC.view.frame = CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
		}
		if(homeEditor){
			homeEditor.view.hidden=FALSE;
			self.homeEditor.view.frame = CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
		}
		if (aboutListView) {
			self.aboutListView.view.hidden=TRUE;
		}
		if (bookMarkDetailsView) 
		self.bookMarkDetailsView.view.frame= CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
       
		if (m_NotesDetailsView) {
			self.m_NotesDetailsView.view.frame=CGRectMake(0 , 0, kDETAIL_VC_SIZE_WIDTH,kDETAIL_VC_SIZE_HEIGHT);
		}
    }
        
   
}

- (void) addViewController:(NSNotification *)notification
{  // this is use for Clinics
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.secetionOpenOrClose=0;
    if (appDelegate.h_TabBarPrevTag == kTAB_CLINICS)
    {
        
        [self.m_clinicListVC.view removeFromSuperview];
        [self.m_clinicDetailVC.view removeFromSuperview];
		[self.m_clinicListVC release];
		self.m_clinicListVC=nil;
        
        
    }
    else if (appDelegate.h_TabBarPrevTag == kTAB_EXTRAS)
    {
        [self.m_settingListVC.view removeFromSuperview];
        [self.m_settingDetailVC.view removeFromSuperview];
	}
    else if (appDelegate.h_TabBarPrevTag == kTAB_BOOKMARKS)
    {
        [self.bookMarksListView.view removeFromSuperview];
        [self.bookMarkDetailsView.view removeFromSuperview];
		[self.bookMarksListView release];
		self.bookMarksListView=nil;
	}
    
	else if (appDelegate.h_TabBarPrevTag == kTAB_NOTES)
    {
        [self.m_NotesListView.view removeFromSuperview];
        [self.m_NotesDetailsView.view removeFromSuperview];
	} 
    else if(appDelegate.h_TabBarPrevTag==kTAB_AboutApp){
		[self.aboutListView.view removeFromSuperview];
		[aboutListView release];
		aboutListView =nil;
		[self.homeEditor.view removeFromSuperview];
	}

    
    if (appDelegate.m_nCurrentTabTag == kTAB_CLINICS)
    {

        //******************* Add clinicList View **********************//
        if (self.m_clinicListVC == nil)
            self.m_clinicListVC = [[ClinicListViewController alloc] initWithNibName:@"ClinicListViewController" bundle:nil];
        self.m_clinicListVC.isShowPopOverView = NO;
        self.m_clinicListVC.m_parentRootVC = self;
        
        if ([CGlobal isOrientationLandscape]){
            self.m_clinicListVC.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
		}
        else{
            self.m_clinicListVC.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
		}
       
        
         [self.view addSubview:self.m_clinicListVC.view];
		
        //******************* Add Clinic Detail View **********************//
        if (self.m_clinicDetailVC == nil)
                m_clinicDetailVC = [[ClinicDetailViewController alloc] initWithNibName:@"ClinicDetailViewController" bundle:nil];
        self.m_clinicDetailVC.m_parentRootVC = self;

        if ([CGlobal isOrientationLandscape])
            self.m_clinicDetailVC.view.frame = CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1 ));
        else
            self.m_clinicDetailVC.view.frame = CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
		
        [self.view addSubview:self.m_clinicDetailVC.view];
        [self.m_clinicListVC initClinicListView];
        
		NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
	if ([loginId intValue]==100)
			[self.m_clinicDetailVC  firstCategoryAndFirstCategory:FALSE];
		else 
			[self.m_clinicDetailVC  firstCategoryAndFirstCategory:TRUE];
		
        
        //Calling previous clicked clicked state
        
        //[self.m_clinicListVC resetClinicState];

    }
    else if (appDelegate.m_nCurrentTabTag == kTAB_AboutApp)
    {
        //******************* Add SettingList View **********************//
		
		appDelegate.previousTag=1;
		appDelegate.nextTag=1;
        if (self.aboutListView == nil)
            self.aboutListView = [[AboutAppListViewController alloc] initWithNibName:@"AboutAppListViewController" bundle:nil];
        
        if ([CGlobal isOrientationLandscape]){
            self.aboutListView.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
			self.aboutListView.tabbar.frame	=CGRectMake(0, 699,320 ,49);
		}
        else{
            self.aboutListView.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
		}
		[aboutListView defaultSelectedAbouttheApp];
       [self.view addSubview:self.aboutListView.view];
		homeEditor=[[HomeEditorView alloc] init];
		if ([CGlobal isOrientationLandscape]) {
		homeEditor.view.frame=CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1 ));
		}else {
		homeEditor.view.frame=CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
		}

		homeEditor.view.frame=CGRectMake(320, 0, 768,768);
		homeEditor.viewType=0;
		[self.view addSubview:homeEditor.view];
		[homeEditor ClickOnAboutOption:0];
		
       
    }
	
	else if (appDelegate.m_nCurrentTabTag == kTAB_BOOKMARKS)
    {
        //******************* Add Bookmarks List View **********************//
        if (self.bookMarksListView == nil)
           self.bookMarksListView = [[BookMarkListViewController_iPad alloc] initWithNibName:@"BookMarkListViewController_iPad" bundle:nil];
       
       if ([CGlobal isOrientationLandscape])
           self.bookMarksListView.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
        else
           self.bookMarksListView.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
    
		[self.view addSubview:self.bookMarksListView.view];
		
        //******************* Add Bookmarks List View **********************//
        if (self.bookMarkDetailsView == nil)
            bookMarkDetailsView = [[BookMarksDetailsViewController_iPad alloc] initWithNibName:@"BookMarksDetailsViewController_iPad" bundle:nil];
        
        self.bookMarkDetailsView.m_parentRootVC = self;
		
        if ([CGlobal isOrientationLandscape])
            self.bookMarkDetailsView.view.frame = CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1 ));
        else
            self.bookMarkDetailsView.view.frame = CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
        
		NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
		if ([loginId intValue]==100)
			[self.bookMarkDetailsView  firstCategoryAndFirstCategory:FALSE];
		else 
			[self.bookMarkDetailsView  firstCategoryAndFirstCategory:TRUE];
		
        [self.view addSubview:self.bookMarkDetailsView.view];
        
        [self.bookMarksListView initClinicListView];
    }
	
	else if (appDelegate.m_nCurrentTabTag == kTAB_NOTES)
    {
        //******************* Add Bookmarks List View **********************//
        if (self.m_NotesListView == nil)
			self.m_NotesListView = [[NotesListViewController_iPad alloc] initWithNibName:@"NotesListViewController_iPad" bundle:nil];
		
		if ([CGlobal isOrientationLandscape])
			self.m_NotesListView.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
        else
			self.m_NotesListView.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
        
		
		
		[self.view addSubview:self.m_NotesListView.view];
		
        //******************* Add Bookmarks List View **********************//
        if (self.m_NotesDetailsView == nil)
            m_NotesDetailsView = [[NotesDetailsViewController_iPad alloc] initWithNibName:@"NotesDetailsViewController_iPad" bundle:nil];
        
        self.m_NotesDetailsView.m_parentRootVC = self;
		
        if ([CGlobal isOrientationLandscape])
            self.m_NotesDetailsView.view.frame = CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1 ));
        else
            self.m_NotesDetailsView.view.frame = CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
        
		NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
		if ([loginId intValue]==100)
			[self.m_NotesDetailsView  firstCategoryAndFirstCategory:FALSE];
		else 
			[self.m_NotesDetailsView  firstCategoryAndFirstCategory:TRUE];
		
        [self.view addSubview:self.m_NotesDetailsView.view];
        [self.m_NotesListView initClinicListView];
    }
	
	else if (appDelegate.m_nCurrentTabTag == kTAB_EXTRAS)
    {
        //******************* Add SettingList View **********************//
		
		appDelegate.previousTag=1;
		appDelegate.nextTag=1;
        if (self.m_settingListVC == nil)
            self.m_settingListVC = [[SettingListViewContoller alloc] initWithNibName:@"SettingListViewContoller" bundle:nil];
        
        if ([CGlobal isOrientationLandscape]){
            self.m_settingListVC.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
			//self.m_settingListVC.tabbar.frame	=CGRectMake(0, 699,320 ,49);
		}
        else{
            self.m_settingListVC.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
		}
		
		[self.m_settingDetailVC loadData];
		[self.view addSubview:self.m_settingListVC.view];
		
        
        //******************* Add Setting Detail View **********************//
        if (self.m_settingDetailVC == nil)
            m_settingDetailVC = [[SettingDetailViewController alloc] initWithNibName:@"SettingDetailViewController" bundle:nil];
        
        self.m_settingDetailVC.m_parentRootVC = self;
		
        if ([CGlobal isOrientationLandscape])
            self.m_settingDetailVC.view.frame = CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1+20 ));
        else
            self.m_settingDetailVC.view.frame = CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
		
        [self.view addSubview:self.m_settingDetailVC.view];
		[self.m_settingDetailVC loadData];
    }
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	m_imgView.hidden=TRUE;
	m_btnPopOver.hidden=TRUE;
	m_btnLogin.hidden=TRUE;
	[[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    //*************** Add VC according to tab clicked  ************//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addViewController:) name:@"Tab Button Pressed" object:nil];
    
    //************ Initially Clinic Tab is Selected ****************//
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    
   NSString    *firstLunchStr =  [[PersistenceDataStore sharedManager] getDatawithKey:KFirstLunchSettingKey];
    
	if ([firstLunchStr caseInsensitiveCompare:KFirstLunchKey] == NSOrderedSame) {
		
		appDelegate.m_nCurrentTabTag = kTAB_EXTRAS;
	}
	else {
		appDelegate.m_nCurrentTabTag = kTAB_CLINICS;
	}

    [self addViewController:nil];
    /* comment this code because u wanna download update issue in backgournd ******************
    NSString  *firstTimeCome = [[NSUserDefaults standardUserDefaults] objectForKey:@"Instruction"];
    
    if ([firstTimeCome isEqualToString:@"True"]) {
          [self loadOnlyUpadteIssueFromServer];
    }*/
  
    
    
}
/*
-(void)loadOnlyUpadteIssueFromServer{
   
    
    self.view.window.userInteractionEnabled = NO;
    backLoding=[[UIView alloc] init];
    backLoding.backgroundColor=[UIColor blackColor];
    backLoding.alpha=0.60;
    [self.view addSubview:backLoding];
   
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(saveOnlyUpadateIssue) userInfo:nil repeats:NO];
}



-(void)saveOnlyUpadateIssue{
    
	DatabaseConnection *database = [DatabaseConnection sharedController];
    NSMutableArray  *arr=[database selectCheckedClinicArr];
    ***************************************** here Dwonload update issue ********************
	NSMutableDictionary *dict =  (NSMutableDictionary *)[[CGlobal dwoloadAllSeletedClinicsUpdateIssue:arr] retain];
	if ([dict count]>0) {
		[CGlobal loadIssueDataFromServer:dict];
		
	}
	RELEASE(dict);



NSString *remeberUserNameAndPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"Rember"];
NSString  *isItLogin = [[NSUserDefaults standardUserDefaults] objectForKey:KisItLoginKey];

  if ([remeberUserNameAndPassword intValue] == 1 && [isItLogin isEqualToString:@"YES"]) {
    [self checkUserChangesUserNameOrPassword:YES withView:self.view withOrienation:self.interfaceOrientation];
   }else{
       self.view.window.userInteractionEnabled = YES;
       [LodingHomeView removeLoadingIndicator];
       [backLoding removeFromSuperview];
       RELEASE(backLoding);
   }
}
*/

-(void)saveUpdateIssue:(NSDictionary  *)updateIssueDict{
    
    if ([updateIssueDict count]>0) {
        
		[CGlobal loadIssueDataFromServer:updateIssueDict];
        NSString *remeberUserNameAndPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"Rember"];
        NSString  *isItLogin = [[NSUserDefaults standardUserDefaults] objectForKey:KisItLoginKey];
        
        if ([remeberUserNameAndPassword intValue] == 1 && [isItLogin isEqualToString:@"YES"]) {
            [self checkUserChangesUserNameOrPassword:YES withView:self.view withOrienation:self.interfaceOrientation];
        }
	}
}
//************************ Here Logic check if changes username or password Open******************

-(void)checkUserChangesUserNameOrPassword:(BOOL)flag 
                                withView :(UIView *)view
                           withOrienation:(UIInterfaceOrientation )interfaceOrientation {
    
    if ([CGlobal checkNetworkReachabilityWithAlert]) {
        NSString *userNameStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN"];
        NSString *passwordStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
        
        NSURL *url = [NSURL URLWithString:[SERVERBASEURL stringByAppendingString:@"/v1/auth/user"]]; 
        
        NSString *encrptUserNameStr = [userNameStr AES256EncryptWithKey:SYMMETRICKEY];
        
        NSString *encrptPasswordStr = [passwordStr AES256EncryptWithKey:SYMMETRICKEY];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request addRequestHeader:@"consumerid" value:CONSUMERID];
        [request addRequestHeader:@"appid" value:@"TheClinics"];
        [request addRequestHeader:@"name" value:encrptUserNameStr];
        [request addRequestHeader:@"cred" value:encrptPasswordStr];
        
        [request setDelegate:self];
        [request startAsynchronous]; 
        
    }
    
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.view.window.userInteractionEnabled = YES;
    [LodingHomeView removeLoadingIndicator];
    [backLoding removeFromSuperview];
    RELEASE(backLoding);
    
    //NSString *responseString = [request responseString];
	
    int statusCode = [request responseStatusCode];
    
    if (statusCode != 200) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"Rember"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:KisItLoginKey];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LOGIN"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PASSWORD"];
        DatabaseConnection *database = [DatabaseConnection sharedController];
        NSString   *queryStr = [NSString stringWithFormat:@"UPDATE tblClinic SET Authencation = 0"];
        [database updateAuthecationInClinicTable:queryStr];
        [m_clinicDetailVC  showLoginButton:NO];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    int statusCode = [request responseStatusCode];
    
    if (statusCode != 200) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"Rember"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:KisItLoginKey];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LOGIN"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PASSWORD"];
        DatabaseConnection *database = [DatabaseConnection sharedController];
        NSString   *queryStr = [NSString stringWithFormat:@"UPDATE tblClinic SET Authencation = 0"];
        [database updateAuthecationInClinicTable:queryStr];
        [m_clinicDetailVC  showLoginButton:NO];
    }
    self.view.window.userInteractionEnabled = YES;
    [LodingHomeView removeLoadingIndicator];
    [backLoding removeFromSuperview];
    RELEASE(backLoding);
}

//************************ Here Logic check if changes username or password close******************

-(void)viewWillAppear:(BOOL)animated{
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.rootViewController=self;
	appDelegate.ariticleListView=nil;
	
	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
	if (appDelegate.clinicsDetails == kTAB_CLINICS) {
        if(reloadArticleType == reloadClinics){
	if ([loginId intValue] == 100) {
		
		[m_clinicDetailVC articleInpressClecnicDetails];
	}
	else {
		
		[m_clinicDetailVC setClinicDetailView];
	}
        }else{
            
            [m_clinicDetailVC loadLatestDownloadedArticles];
        }
	}
	if (appDelegate.clinicsDetails == kTAB_BOOKMARKS) {
		[bookMarkDetailsView  popToLastView];
	}
	if (appDelegate.clinicsDetails == kTAB_NOTES) {
		[m_NotesDetailsView  popToLastView];
	}
    
    if (self.m_clinicListVC){
    if ([CGlobal isOrientationLandscape])
        self.m_clinicListVC.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
    else
        self.m_clinicListVC.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
    }

    if ([CGlobal isOrientationLandscape])
        self.m_NotesListView.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
    else
        self.m_NotesListView.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
    
    if ([CGlobal isOrientationLandscape])
        self.bookMarksListView.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
    else
        self.bookMarksListView.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
	// view Not requied
}

-(void)viewWillDisappear:(BOOL)animated{
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.rootViewController=nil;

	
}

-(void)removeClinicDetailsViewFromRootView:(NSInteger )SeletedTag{
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
 	 if (m_clinicListVC) {
		[self.m_clinicListVC.view removeFromSuperview];
		[self.m_clinicListVC release];
		self.m_clinicListVC=nil;
	  }
	
	[self.m_clinicDetailVC.view removeFromSuperview];
	
	if (bookMarksListView) {
		[self.bookMarksListView.view removeFromSuperview];
		[self.bookMarksListView release];
		 self.bookMarksListView=nil;
	}
	
	[self.bookMarkDetailsView.view removeFromSuperview];

	
	if (m_NotesListView) {
		[self.m_NotesListView.view removeFromSuperview];
		[self.m_NotesListView release];
		self.m_NotesListView=nil;
	}
	
	[self.m_NotesDetailsView.view removeFromSuperview];
	
	
	 if(SeletedTag==1) {
		
		//******************* Add Bookmarks List View **********************//
        if (self.m_clinicListVC == nil)
			self.m_clinicListVC = [[ClinicListViewController alloc] initWithNibName:@"ClinicListViewController" bundle:nil];
		
		if ([CGlobal isOrientationLandscape])
			self.m_clinicListVC.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
        else
			self.m_clinicListVC.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
		[self.view addSubview:self.m_clinicListVC.view];
		
        //******************* Add Bookmarks List View **********************//
        if (self.m_clinicDetailVC  ==  nil)
            m_clinicDetailVC = [[ClinicDetailViewController alloc] initWithNibName:@"ClinicDetailViewController" bundle:nil];
        
        self.m_clinicDetailVC.m_parentRootVC = self;
		
        if ([CGlobal isOrientationLandscape])
            self.m_clinicDetailVC.view.frame = CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1 ));
        else
            self.m_clinicDetailVC.view.frame = CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
        
        [self.view addSubview:self.m_clinicDetailVC.view];
		
         [self.m_clinicListVC initClinicListView];
	}
	
	
	else if(SeletedTag == 2) {
		
		//******************* Add Bookmarks List View **********************//
        if (self.bookMarksListView == nil)
			self.bookMarksListView = [[BookMarkListViewController_iPad alloc] initWithNibName:@"BookMarkListViewController_iPad" bundle:nil];
		
		if ([CGlobal isOrientationLandscape])
			self.bookMarksListView.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
        else
			self.bookMarksListView.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
       
		[self.view addSubview:self.bookMarksListView.view];
		
        //******************* Add Bookmarks List View **********************//
        if (self.bookMarkDetailsView == nil)
            bookMarkDetailsView = [[BookMarksDetailsViewController_iPad alloc] initWithNibName:@"BookMarksDetailsViewController_iPad" bundle:nil];
        
        self.bookMarkDetailsView.m_parentRootVC = self;
		
        if ([CGlobal isOrientationLandscape])
            self.bookMarkDetailsView.view.frame = CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1 ));
        else
            self.bookMarkDetailsView.view.frame = CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
        
        [self.view addSubview:self.bookMarkDetailsView.view];
        
        [self.bookMarksListView initClinicListView];
		
	}


	
	else if(SeletedTag==3) {
		//******************* Add Notes List View **********************//
        if (self.m_NotesListView == nil)
			self.m_NotesListView = [[NotesListViewController_iPad alloc] initWithNibName:@"NotesListViewController_iPad" bundle:nil];
		
		if ([CGlobal isOrientationLandscape])
			self.m_NotesListView.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
        else
			self.m_NotesListView.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
		
		[self.view addSubview:self.m_NotesListView.view];
        //******************* Add NotesDetails  View **********************//
        if (self.m_NotesDetailsView == nil)
            m_NotesDetailsView = [[NotesDetailsViewController_iPad alloc] initWithNibName:@"NotesDetailsViewController_iPad" bundle:nil];
        
          self.m_NotesDetailsView.m_parentRootVC = self;
		
        if ([CGlobal isOrientationLandscape])
            self.m_NotesDetailsView.view.frame = CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1 ));
        else
            self.m_NotesDetailsView.view.frame = CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
        
        [self.view addSubview:self.m_NotesDetailsView.view];
        
		[self.m_NotesListView initClinicListView];
	}
	
	
	
	//******************* Add SettingList View **********************//
	
	if (SeletedTag==5) {
		appDelegate.previousTag=1;
		appDelegate.nextTag=1;
		if (self.aboutListView == nil)
            self.aboutListView = [[AboutAppListViewController alloc] initWithNibName:@"AboutAppListViewController" bundle:nil];
        
        if ([CGlobal isOrientationLandscape]){
            self.aboutListView.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);
			self.aboutListView.tabbar.frame	=CGRectMake(0, 699,320 ,49);
		}
        else{
            self.aboutListView.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
		}
		[aboutListView defaultSelectedAbouttheApp];
		[self.view addSubview:self.aboutListView.view];
        
		homeEditor=[[HomeEditorView alloc] init];
		if ([CGlobal isOrientationLandscape]) {
			homeEditor.view.frame=CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1 ));
		}else {
			homeEditor.view.frame=CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
		}
		
		homeEditor.view.frame=CGRectMake(320, 0, 768,768);
		homeEditor.viewType=0;
		[self.view addSubview:homeEditor.view];
		[homeEditor ClickOnAboutOption:0];
		
		
	}

}

-(void)hideClinicsListViewController{
	if ([CGlobal isOrientationPortrait])
	self.m_clinicListVC.view.hidden=TRUE;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	[self handleIosVersionOrieantion];
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;{
    [self handleIosVersionOrieantion];
}

-(void)handleIosVersionOrieantion{
    
    
    UIInterfaceOrientation  interfaceOrientation = [UIApplication  sharedApplication].statusBarOrientation;
    
    if (backLoding) {
        if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            backLoding.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            
            
        }
        else {
            backLoding.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            
            
        }
        [LodingHomeView displayLoadingIndicator:backLoding :interfaceOrientation];
        
    }
    [LodingHomeView chagengeMessageLoadingView:dwonloadupdateissue];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate	changeOrientatioLoginview] ;
	
    if([self isKindOfClass:[BookMarkListViewController_iPad class]] || [self isKindOfClass:[BookMarkListViewController_iPad class]]){
		[self  didRotate:nil];
    }
    [self didRotate:nil];
    if(homeEditor) {
        [homeEditor changeOrientaionISHomeEditorView];
    }
    
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

-(void)rotateDiviceInSettingTabBarClick{
	
	
	if (aboutListView) {
		[aboutListView.view removeFromSuperview];
		[aboutListView release];
		aboutListView=nil;
		
	}
	if (m_clinicListVC) {
		[self.m_clinicListVC.view removeFromSuperview];
		[self.m_clinicListVC release];
		self.m_clinicListVC=nil;
	}
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.secetionOpenOrClose=0;

	if (appDelegate.nextTag==1) {
		if (self.m_settingListVC == nil)
			self.m_settingListVC = [[SettingListViewContoller alloc] initWithNibName:@"SettingListViewContoller" bundle:nil];
		
		if ([CGlobal isOrientationLandscape]){
			self.m_settingListVC.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);

	       }
		else{
			self.m_settingListVC.view.hidden=TRUE;
		}
		
		[self.view addSubview:self.m_settingListVC.view];
	}
	
	else if(appDelegate.nextTag==3) {
		if (self.aboutListView == nil)
			self.aboutListView = [[AboutAppListViewController alloc] initWithNibName:@"AboutAppListViewController" bundle:nil];
		if ([CGlobal isOrientationLandscape]){
			self.aboutListView.view.frame = CGRectMake(0 , 0, 320, 748);
			self.aboutListView.tabbar.frame	=CGRectMake(0, 699,320 ,49);
		}
		else{
			self.aboutListView.view.hidden=TRUE;
		}
		
		[self.view addSubview:self.aboutListView.view];
	}


}

-(void)addSettingViewOnRootView{
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	NSMutableDictionary  *clinicDict=[database selectCheckedClinicDict];
	appDelegate.lastSelectedClinicList=clinicDict;
	
	
    if (appDelegate.h_TabBarPrevTag == kTAB_CLINICS)
    {
        [self.m_clinicListVC.view removeFromSuperview];
        [self.m_clinicDetailVC.view removeFromSuperview];
		[self.m_clinicListVC release];
		self.m_clinicListVC=nil;
		
    }
    else if (appDelegate.h_TabBarPrevTag == kTAB_EXTRAS)
    {
        [self.m_settingListVC.view removeFromSuperview];
        [self.m_settingDetailVC.view removeFromSuperview];
	}
    else if (appDelegate.h_TabBarPrevTag == kTAB_BOOKMARKS)
    {
        [self.bookMarksListView.view removeFromSuperview];
        [self.bookMarkDetailsView.view removeFromSuperview];
		[self.bookMarksListView release];
		self.bookMarksListView=nil;
	}
    
	else if (appDelegate.h_TabBarPrevTag == kTAB_NOTES)
    {
        [self.m_NotesListView.view removeFromSuperview];
        [self.m_NotesDetailsView.view removeFromSuperview];
	} 
	
	appDelegate.previousTag=1;
	appDelegate.nextTag=1;
	if (self.m_settingListVC == nil)
		self.m_settingListVC = [[SettingListViewContoller alloc] initWithNibName:@"SettingListViewContoller" bundle:nil];
	
	if ([CGlobal isOrientationLandscape]){
		self.m_settingListVC.view.frame = CGRectMake(0 , 0, kLIST_VC_SIZE_WIDTH, kLIST_VC_SIZE_HEIGHT);

	}
	else{
		self.m_settingListVC.view.frame = CGRectMake(0 , 0, 0.0, 0.0);
	}
	
	[self.m_settingDetailVC loadData];

	[self.view addSubview:self.m_settingListVC.view];
	
	//******************* Add Setting Detail View **********************//
	if (self.m_settingDetailVC == nil)
		m_settingDetailVC = [[SettingDetailViewController alloc] initWithNibName:@"SettingDetailViewController" bundle:nil];
	
	self.m_settingDetailVC.m_parentRootVC = self;
	
	if ([CGlobal isOrientationLandscape])
		self.m_settingDetailVC.view.frame = CGRectMake((kLIST_VC_SIZE_WIDTH +1), 0, kDETAIL_VC_SIZE_WIDTH, (kDETAIL_VC_SIZE_HEIGHT -1+20 ));
	else
		self.m_settingDetailVC.view.frame = CGRectMake(0, 0, kDETAIL_VC_SIZE_WIDTH, kDETAIL_VC_SIZE_HEIGHT);
	
	[self.view addSubview:self.m_settingDetailVC.view];
	[self.m_settingDetailVC loadData];
	
	
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	RELEASE(bookMarkDetailsView);
    RELEASE(m_settingDetailVC);
    RELEASE(m_settingListVC);
    RELEASE(m_clinicListVC);
    RELEASE(m_clinicDetailVC);
   if (homeEditor) {
	   [homeEditor release];
	   [aboutListView release];
   }
	if (m_NotesListView) {
		[m_NotesListView release];
		[m_NotesDetailsView release];
		m_NotesListView=nil;
	}
	if (bookMarksListView) {
		RELEASE(bookMarkDetailsView);
		[bookMarksListView release];
		bookMarksListView=nil;
	}
    [super dealloc];
}

@end
