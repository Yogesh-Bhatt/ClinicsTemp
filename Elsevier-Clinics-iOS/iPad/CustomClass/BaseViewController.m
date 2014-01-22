//
//  BaseViewController.m
//  WoltersKluwer
//
//  Created by Ashish Awasthi on 07/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

#import "ClinicDetailViewController.h"
#import "SettingDetailViewController.h"
#import "WebViewController.h"
#import "LoginViewController.h"
#import "RootViewController.h"
#import "BookMarksDetailsViewController_iPad.h"
#import "LoginViewController.h"
#import "lodingHomeView.h"

#import "ClinicsAppDelegate.h"


@implementation BaseViewController
@synthesize m_btnSearch;
@synthesize m_btnDone;
@synthesize m_btnPopOver;
@synthesize m_imgView;
@synthesize m_lblTitle;
@synthesize m_Cancel;
@synthesize m_addclinicsBtn;
@synthesize m_btnLogin;

//*************** change view frame **********//
- (void) didRotate:(NSNotification *)notification
{	
  
    //NSLog(@"BaseViewControllerDidRotate");
    
    if ([CGlobal isOrientationPortrait]) {
		if (backLodingview) {
			backLodingview.frame=CGRectMake(0, 0,768,1024);
		}
		[LodingHomeView displayLoadingIndicator:backLodingview :UIInterfaceOrientationPortrait];
	}
		
	else {
		if (backLodingview) {
			backLodingview.frame=CGRectMake(0, 0,1024,768);
		}
		[LodingHomeView displayLoadingIndicator:backLodingview :UIInterfaceOrientationLandscapeRight];
	
	}
	
    if ([self isKindOfClass:[WebViewController class]])
    {
        if(m_btnSearch != nil)
        m_btnSearch.frame = CGRectMake((self.view.frame.size.width - 154.0), 7.0, 60.0,30.0);
        
        if(m_btnLogin != nil)
        m_btnLogin.frame = CGRectMake((self.view.frame.size.width - 70.0), 7.0, 60.0,30.0);
    }
}


- (void)hidePopOverButton
{
	m_btnPopOver.hidden = YES;
}

- (void)showPopOverButton
{
	m_btnPopOver.hidden = NO;
} 


- (void) addWebviewBarButtons
{
	
	if ([CGlobal isOrientationLandscape])
	{
		m_lblTitle.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0);
	}
	else
	{   self.view.frame= CGRectMake(0, 0, 768, 44);
		m_lblTitle.frame = CGRectMake(0.0, 0.0, 768, 44.0);
	}
	
    m_btnClose = [[UIButton alloc]initWithFrame:CGRectMake(20.0, 7.0, 60.0,30.0)];
    [m_btnClose setImage:[UIImage imageNamed:@"BtnClose.png"] forState:UIControlStateNormal];
    [m_btnClose addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_btnClose];
    [m_btnClose release];  
    
    m_btnArticleList = [[UIButton alloc]initWithFrame:CGRectMake(100.0, 7.0, 60.0,32.0)];
    [m_btnArticleList setImage:[UIImage imageNamed:@"BtnPopOver.png"] forState:UIControlStateNormal];
    [m_btnArticleList addTarget:self action:@selector(articleListButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_btnArticleList];
    [m_btnArticleList release];
    
    m_btnSearch = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 154.0), 7.0, 60.0,30.0)];
	m_btnSearch.tag=100;
    [m_btnSearch setImage:[UIImage imageNamed:@"optionbutton.png"] forState:UIControlStateNormal];
    [m_btnSearch addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_btnSearch];
    [m_btnSearch release];
    
    m_btnLogin = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 70.0), 7.0, 60.0,30.0)];
    [m_btnLogin setImage:[UIImage imageNamed:@"BtnLogin.png"] forState:UIControlStateNormal];
    [m_btnLogin addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_btnLogin];
    [m_btnLogin release];
}


- (void)dealloc
{
    //NSLog(@"BaseViewControllerDealloc");
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
    
    
    // Do any additional setup after loading the view from its nib.
   
    //*************** Getting Device orientation ************/////////////
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	m_imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-2, 0.0, 704.0, 44.0)];
	m_imgView.image = [UIImage imageNamed:@"704"];
	[self.view addSubview:m_imgView];
	[m_imgView release];
	m_lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width - 10, 44.0)];
	m_lblTitle.textAlignment = UITextAlignmentCenter;
	m_lblTitle.text = @"";
	m_lblTitle.font = [UIFont boldSystemFontOfSize:20.0];
	m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.backgroundColor = [UIColor clearColor];
	[self.view addSubview:m_lblTitle];
	[m_lblTitle release];   
	
	
	
	if ([self isKindOfClass:[WebViewController class]]) 
    {
        [self addWebviewBarButtons];
    }
    else {
		
		
		m_btnLogin = [[UIButton alloc]initWithFrame:CGRectMake(640.0, 7.0, 60.0,30.0)];
		BOOL  isItRemember = (BOOL )[[NSUserDefaults standardUserDefaults] objectForKey:@"Rember"];
		if (isItRemember) {
			[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogout.png"] forState:UIControlStateNormal];
		}
		else {
			[m_btnLogin setImage:[UIImage imageNamed:@"BtnLogin.png"] forState:UIControlStateNormal];
		}
        [m_btnLogin addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:m_btnLogin];
        [m_btnLogin release];
		
		
		// *******************  button add clinics*******************
		
		m_addclinicsBtn = [[UIButton alloc] initWithFrame:CGRectMake(640.0, 7.0, 75.0,30.0)];
		m_addclinicsBtn.hidden = TRUE;
	    [m_addclinicsBtn setImage:[UIImage imageNamed:@"addclinics.png"] forState:UIControlStateNormal];
        [m_addclinicsBtn addTarget:self action:@selector(clickONAddClinicsButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:m_addclinicsBtn];
		
		
		
		m_btnPopOver = [[UIButton alloc]initWithFrame:CGRectMake(20.0, 7.0, 60.0,32.0)];
        [m_btnPopOver setImage:[UIImage imageNamed:@"BtnPopOver.png"] forState:UIControlStateNormal];
        [m_btnPopOver addTarget:self action:@selector(popOverButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:m_btnPopOver];
        [m_btnPopOver release];
        
		//******************* only Setting View  *******************
		
		if ([self isKindOfClass:[SettingDetailViewController class]]) {
			
		m_Cancel = [[UIButton alloc]initWithFrame:CGRectMake(560.0, 7.0, 60.0,30.0)];
		[m_Cancel setImage:[UIImage imageNamed:@"BtnCancel.png.png"] forState:UIControlStateNormal];
		[m_Cancel addTarget:self action:@selector(cancelButtonTab:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:m_Cancel];
		[m_Cancel release];
		
			m_btnDone = [[UIButton alloc]initWithFrame:CGRectMake(640.0, 7.0, 60.0,30.0)];
			[m_btnDone setImage:[UIImage imageNamed:@"BtnSave.png"] forState:UIControlStateNormal];
			[m_btnDone addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[self.view addSubview:m_btnDone];
			[m_btnDone release];
	  	   
		
		}
		
		}
		
		[super viewDidLoad];		
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
#pragma mark <UIButton Pressed> methods

- (IBAction) backButtonPressed:(id)sender{

     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) doneButtonPressed:(id)sender
{
	if ([self isKindOfClass:[SettingDetailViewController class]]) {
		DatabaseConnection *database = [DatabaseConnection sharedController];
		NSInteger checked=[database selectCheckOrNot:[NSString stringWithFormat:@"Select checked  from tblClinic"]];
		ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
		if (checked == 0) {
			DatabaseConnection *database = [DatabaseConnection sharedController];
			NSMutableArray  *arr = [database selectCheckedClinicArr];
			NSMutableDictionary   *dict = appDelegate.lastSelectedClinicList;
            
            //NSLog(@"lastSelectedClinicList %@",dict);
			BOOL flag=FALSE;
			for (int i=0; i<[arr count]; i++) {
				NSString  *str =[dict objectForKey:[arr objectAtIndex:i]];
				if (str == nil) {
                    //One new clinic is added
					flag=TRUE;
                    break;
				}
			}
			if (flag == TRUE) {
                //*************** Save Your Followed Clinics **********************************
                [self saveYourSettingFollowedClinics];

			}
			else {
				// **********************************Save  you after deselect your last Change.***********************
				if ([arr count]<[dict count]) {
                    
                    [(SettingDetailViewController *)self doneButtonPressed];

				}else {
					[(SettingDetailViewController *)self doneButtonPressed];
				}

				
			}

		}
		else {
			
			UIAlertView   *alertView=[[UIAlertView  alloc] initWithTitle:@"" message:@"Please select at least one clinic."delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
			alertView.tag=-2;
			[alertView show];
			[alertView release];
			
			
		}

	    }
	
   
   }

-(void)saveYourSettingFollowedClinics{
    
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //  **********************************Save Seeting First True**********************************
    
     [[PersistenceDataStore sharedManager] setData:KNextLunchKey withKey:KFirstLunchSettingKey];
    
    //********************************** delete all file document directory   after setting **************************
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    for (NSString *file in [fm contentsOfDirectoryAtPath:documentsDirectory error:&error]) {
      
        if(![file isEqualToString:@"Clinics_DB.sqlite"]){
            BOOL success = TRUE;//[fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory, file] error:&error];
            NSLog(@"rohit removeItemAtPath1");
            if (!success || error) {
                // **********************************it failed.
            }
        }
        
    }		
    RootViewController  *rootView=(RootViewController*)appDelegate.rootViewController;
    backLodingview=[[UIView alloc] init];
    backLodingview.backgroundColor=[UIColor blackColor];
    backLodingview.alpha=0.60;
    [rootView.view addSubview:backLodingview];
    
    
    if ([CGlobal isOrientationPortrait]) {
        backLodingview.frame=CGRectMake(rootView.view.frame.origin.x, rootView.view.frame.origin.y, rootView.view.frame.size.width, rootView.view.frame.size.height);
        [LodingHomeView displayLoadingIndicator:backLodingview :UIInterfaceOrientationPortrait];
    }
    else {
        backLodingview.frame=CGRectMake(rootView.view.frame.origin.x, rootView.view.frame.origin.y, rootView.view.frame.size.width, rootView.view.frame.size.height);
        [LodingHomeView displayLoadingIndicator:backLodingview :UIInterfaceOrientationLandscapeRight];
        
    }
    [LodingHomeView  chagengeMessageLoadingView:addClinics];
    
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(loadDataFromServer) userInfo:nil repeats:NO];

    
}

-(void)loadDataFromServer{
    
	[LodingHomeView removeLoadingIndicator];
	[backLodingview removeFromSuperview];
	[backLodingview release];
	backLodingview=nil;
	NSMutableDictionary *dict = (NSMutableDictionary *)[[CGlobal jsonParsor] retain];
	[CGlobal loadIssueDataFromServer:dict];  
	[(SettingDetailViewController *)self doneButtonPressed];
	RELEASE(dict);
}

-(void)cancelButtonTab:(id)sender{
    
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
     DatabaseConnection *database = [DatabaseConnection sharedController];
    
     NSString  *saveSetting = [[PersistenceDataStore sharedManager] getDatawithKey:KFirstLunchSettingKey];
    
    if ([saveSetting caseInsensitiveCompare:KNextLunchKey] == NSOrderedSame) {
       [(SettingDetailViewController *)self cancelButtonpress:sender]; 
     }
    else{
       
		NSInteger checked=[database selectCheckOrNot:[NSString stringWithFormat:@"Select checked  from tblClinic"]];
        NSString *msgStr;
        
        if(checked == 0){
            DatabaseConnection *database = [DatabaseConnection sharedController];
			NSMutableArray  *arr=[database selectCheckedClinicArr];
			NSMutableDictionary   *dict= appDelegate.lastSelectedClinicList;
			BOOL flag=FALSE;
			for (int i=0; i<[arr count]; i++) {
				NSString  *str =[dict objectForKey:[arr objectAtIndex:i]];
				if (str == nil) {
					flag=TRUE;
				}
			}
			if (flag) {
             msgStr  = @"Save your Settings.";
            }else{
               [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab Button Pressed" object:self]; 
                return ;
            }
           
        }
        else{
            msgStr = @"Please select at least one Clinics title and save your settings." ;
        }
        UIAlertView   *alertView=[[UIAlertView  alloc] initWithTitle:@"" message:msgStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alertView.tag=-2;
        [alertView show];
        [alertView release];

    }
	
 }

- (IBAction) popOverButtonPressed:(id)sender
{
    if ([self isKindOfClass:[ClinicDetailViewController class]]) 
        [(ClinicDetailViewController *)self showPopOver];
    else if ([self isKindOfClass:[SettingDetailViewController class]]) 
        [(SettingDetailViewController *)self showPopOver];
	else if([self isKindOfClass:[BookMarksDetailsViewController_iPad class]]) {
		[(BookMarksDetailsViewController_iPad *)self showPopOver];
	}
    else if([self isKindOfClass:[NotesDetailsViewController_iPad class]]) {
		[(NotesDetailsViewController_iPad *)self showPopOver];
	}
}

- (IBAction) searchButtonPressed:(id)sender
{
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate.webViewController clickOnOptionButton:sender];

}

- (IBAction) loginButtonPressed:(id)sender{

	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate clickOnLoginButton:sender];
}


-(void)clickONAddClinicsButton:(id)sender{
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	RootViewController *rootView=appDelegate.m_rootViewController;
	[rootView addSettingViewOnRootView];
}

- (IBAction) closeButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) articleListButtonPressed:(id)sender
{
	if ([self isKindOfClass:[WebViewController class]]) 
        [(WebViewController *)self showPopOver:sender];
 
}


@end
