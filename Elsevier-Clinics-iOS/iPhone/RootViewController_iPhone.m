//
//  RootViewController_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController_iPhone.h"
#import "BookMarkListViewController_iPhone.h"
#import "LoadingHomeView_iPhone.h"

#import "ClinicsAppDelegate.h"
#import "ClinicsDetailsView_iPhone.h"

@implementation RootViewController_iPhone
@synthesize settingList_iPhone;
@synthesize clinicListView;
@synthesize abouttheAppView_iPhone;
@synthesize bookmarks_iPhone;
@synthesize noteLists_iPhone;
@synthesize m_clinicDetail_iPhone;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationController.navigationBar setHidden:TRUE];
	//************ Initially Clinic Tab is Selected ****************//
    
    
    m_clinicDetail_iPhone = [[ClinicsDetailsView_iPhone alloc] init];
    
	ClinicsAppDelegate  *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;

	appDelegate.rootView_iPhone=self;
    
    NSString    *firstLunchStr =  [[PersistenceDataStore sharedManager] getDatawithKey:KFirstLunchSettingKey];
    
	if ([firstLunchStr caseInsensitiveCompare:KFirstLunchKey] == NSOrderedSame) {
		
		appDelegate.m_nCurrentTabTag = kTAB_EXTRAS;
	}
	else {
		appDelegate.m_nCurrentTabTag = kTAB_CLINICS;
	}
    
    [self addViewController];
   

    [appDelegate downLoadUpdateIssueInBackgound];
  
}


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
    [LoadingHomeView_iPhone removeLoadingIndicator];
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
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.view.window.userInteractionEnabled = YES;
    [LoadingHomeView_iPhone removeLoadingIndicator];
    [backLoding removeFromSuperview];
    RELEASE(backLoding);
}

//************************ Here Logic check if changes username or password close******************

-(void)viewWillAppear:(BOOL)animated{
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	BookMarkListViewController_iPhone  *bookmarksList=(BookMarkListViewController_iPhone *)appDelegate.rootView_iPhone.bookmarks_iPhone;
	if (appDelegate.clinicsDetails == kTAB_BOOKMARKS) {
		[bookmarksList  popToLastView];
	}
	if (appDelegate.clinicsDetails == kTAB_NOTES) {
		NotesListViewController_iPhone  *m_NotesDetailsView=(NotesListViewController_iPhone *)appDelegate.rootView_iPhone.noteLists_iPhone;
		[m_NotesDetailsView  initClinicListView];
	}
}

// *********************** this is use for Clinics ***************************

- (void) addViewController{

	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.secetionOpenOrClose=0;
    
    if (appDelegate.h_TabBarPrevTag == kTAB_CLINICS)
    {
		if (self.clinicListView) {
			[appDelegate.navigationController popViewControllerAnimated:NO];
			[self.clinicListView.view removeFromSuperview];
			[self.clinicListView release];
			self.clinicListView=nil;
		}
	
     }
	
	else if (appDelegate.h_TabBarPrevTag == kTAB_BOOKMARKS)
    {
		if (self.bookmarks_iPhone) {
			[appDelegate.navigationController popViewControllerAnimated:NO];
			[self.bookmarks_iPhone.view removeFromSuperview];
		}
    }
	
	else if (appDelegate.h_TabBarPrevTag == kTAB_NOTES)
    {
		if (self.noteLists_iPhone) {
			[appDelegate.navigationController popViewControllerAnimated:NO];
			[self.noteLists_iPhone.view removeFromSuperview];
		}
    }
    else if (appDelegate.h_TabBarPrevTag == kTAB_EXTRAS)
    {
		if (self.settingList_iPhone) {
			[self.settingList_iPhone.view removeFromSuperview];
		}
	
	
    }
	else if (appDelegate.h_TabBarPrevTag == kTAB_AboutApp)
    {
		[appDelegate.navigationController popViewControllerAnimated:NO];
		if (self.abouttheAppView_iPhone) {
			[self.abouttheAppView_iPhone.view removeFromSuperview];
		}
		
		
    }
	
    if (appDelegate.m_nCurrentTabTag == kTAB_CLINICS)
    {
        //******************* Add clinicList View **********************//
        if(IS_WIDESCREEN){
            
            if (self.clinicListView == nil)
                self.clinicListView = [[ClinicsListView_iPhone alloc] initWithNibName:@"ClinicsListView_iPhone" bundle:nil];
            [self.view addSubview:self.clinicListView.view];
             [self.clinicListView initClinicListView];
        }else{
            if (self.clinicListView == nil)
                self.clinicListView = [[ClinicsListView_iPhone alloc] initWithNibName:@"ClinicsListView_iPhone" bundle:nil];
            [self.view addSubview:self.clinicListView.view];
            [self.clinicListView initClinicListView];
            
		}
    }
	
	else if (appDelegate.m_nCurrentTabTag == kTAB_BOOKMARKS)
	{
		//******************* Add SettingList View **********************//
	if (self.bookmarks_iPhone == nil)
			self.bookmarks_iPhone = [[BookMarkListViewController_iPhone alloc] initWithNibName:@"BookMarkListViewController_iPhone" bundle:nil];
		[self.view addSubview:self.bookmarks_iPhone.view];
		[self.bookmarks_iPhone initClinicListView];
	}
	else if (appDelegate.m_nCurrentTabTag == kTAB_NOTES)
	{
		//******************* Add SettingList View **********************//

		if (self.noteLists_iPhone == nil)
			self.noteLists_iPhone = [[NotesListViewController_iPhone alloc] initWithNibName:@"NotesListViewController_iPhone" bundle:nil];

		[self.view addSubview:self.noteLists_iPhone.view];
		[self.noteLists_iPhone initClinicListView];
		
	}

  else if (appDelegate.m_nCurrentTabTag == kTAB_EXTRAS)
   {
	//******************* Add SettingList View **********************//

	if (self.settingList_iPhone == nil)
	self.settingList_iPhone = [[SettingListViewController_iPhone alloc] initWithNibName:@"SettingListViewController_iPhone" bundle:nil];

	[self.view addSubview:self.settingList_iPhone.view];
	
	}
	
  else if (appDelegate.m_nCurrentTabTag == kTAB_AboutApp)
  {
	  //******************* Add SettingList View **********************//

	  if (self.abouttheAppView_iPhone == nil)
		  self.abouttheAppView_iPhone = [[AboutAppListViewController_iPhone alloc] initWithNibName:@"AboutAppListViewController_iPhone" bundle:nil];

	  [self.view addSubview:self.abouttheAppView_iPhone.view];
	  
  }

}

-(void)addSettingViewOnRootView{
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	NSMutableDictionary  *clinicDict=[database selectCheckedClinicDict];
	appDelegate.lastSelectedClinicList=clinicDict;
	
	
    if (appDelegate.h_TabBarPrevTag == kTAB_CLINICS)
    {
		if (self.settingList_iPhone) {
			[self.settingList_iPhone.view removeFromSuperview];
		}
		
    }
	appDelegate.previousTag=1;
	appDelegate.nextTag=1;
	if (self.settingList_iPhone == nil)
		self.settingList_iPhone = [[SettingListViewController_iPhone alloc] initWithNibName:@"SettingListViewController_iPhone" bundle:nil];
	
	[self.view addSubview:self.settingList_iPhone.view];

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
	if (self.settingList_iPhone) {
		[self.settingList_iPhone release];
	}
	if (abouttheAppView_iPhone) {
		[abouttheAppView_iPhone release];
	}
}



@end
