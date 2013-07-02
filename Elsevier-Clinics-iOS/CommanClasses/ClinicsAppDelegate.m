//
//  ClinicsAppDelegate.m
//  Clinics
//
//  Created by Ashish Awasthi on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All  rights reserved.
//
# define ProductId @"com.kiwitech.kiwitechdev.apns.201209.autorenew3"

#define  KLoginAlertKey   10001

#define  kBuyAlertTag 3333333

#import "ClinicsAppDelegate.h"
#import "WebViewController.h"
#import "MKStoreManager.h"
#import "LoadingViewlogin.h"
#import "DownloadController.h"
#import "UIDevice+IdentifierAddition.h"

#import "DataRecord.h"


@implementation ClinicsAppDelegate

@synthesize homeEditorView;
@synthesize flagLoginOneAll;
@synthesize checkexpireDateInApppurchase;
@synthesize   login;
@synthesize firstClinicID;
@synthesize viewController;
@synthesize rootViewController;
@synthesize window=_window;
@synthesize ariticleListView;
@synthesize navigationController = _navigationController;

@synthesize m_rootViewController;
@synthesize webViewController;
@synthesize seletedClinicID;
@synthesize clinicDetailsView;
@synthesize seletedIssuneID;
@synthesize  clinicsDetails;
@synthesize downLoadUrl;
@synthesize listbackIssueView;
@synthesize firstCategoryID;
@synthesize CheckedClinic;
@synthesize previousTag;
@synthesize nextTag;
@synthesize firstCategoryName;
@synthesize h_TabBarPrevTag;
@synthesize m_nCurrentTabTag;
@synthesize aritcleListView;
@synthesize lastSelectedClinicList;

@synthesize openHTMLADDNoteOpenView;
@synthesize secetionOpenOrClose;
@synthesize clickONFullTextOrPdf;
// iphone releted
@synthesize rootView_iPhone;
@synthesize wewView_iPhone;
@synthesize clinicsdeatils_iPhone;
@synthesize diveceType;
@synthesize authentication;
@synthesize tabOnLoiginButton;
@synthesize m_downloadArticlesArr;
@synthesize m_downloadedConnectionArr;
@synthesize downloadQueue = _downloadQueue;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
	// First Time Save Setting FALSE
    
    m_downloadArticlesArr = [[NSMutableArray alloc] init];
    m_downloadedConnectionArr = [[NSMutableArray alloc] init];
     
    [[NSUserDefaults standardUserDefaults]setObject:@"101" forKey:@"Flag"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    if (![[PersistenceDataStore sharedManager] getDatawithKey:KFirstLunchSettingKey]) {
        [[PersistenceDataStore sharedManager] setData:KFirstLunchKey withKey:KFirstLunchSettingKey];
    }
    
    [MKStoreManager sharedManager];
	
	diveceType = 1;
    
	h_TabBarPrevTag = kTAB_CLINICS;
	previousTag = 1;
	nextTag = 1;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		diveceType = 0;
	}
    
    
	checkexpireDateInApppurchase=FALSE;
	
	// click on  clickONFullTextOrPdf is false
	
	clickONFullTextOrPdf=FALSE;
	//this   flag  check dwonload list of aricle on webview
	aritcleListView = TRUE;
	
	// This Condition use For Add Note in Html Alert Pop Come
	openHTMLADDNoteOpenView=FALSE;
	
	//*****************
	
	// use for aritcle  in pres or Not
    
	lastSelectedClinicList=[[NSMutableDictionary alloc] init];
    
	[[NSUserDefaults standardUserDefaults] synchronize];
	// login
	
    login = FALSE;
    
    DatabaseConnection *dbConnection =[DatabaseConnection sharedController];
	[dbConnection createDatabaseCopyIfNotExist];
	
    //*********************** Here Implement  update Database Logic ***********************
    
    BOOL  updateDataBase  = [[[NSUserDefaults standardUserDefaults]  valueForKey:@"UpdateDataBase"] boolValue];
    
    if (!updateDataBase) {
        
        NSString  *query = @"ALTER TABLE tblIssue ADD Access Numeric";
        [dbConnection alterDataBase:query];
        
        NSDictionary    *dataDict =  [CGlobal getCurrentDateFromServer];
        
        NSString    *currentDateStr = [dataDict valueForKey:@"CurrentDate"];
        NSString    *backDateStr = [dataDict valueForKey:@"PreviousDate"];
        
        NSString  *seletedQuery = @"Select   DISTINCT ClinicID  from tblIssue ";
        NSArray   *clinicIdArr = [dbConnection retriveClinicIdFromIssueTable:seletedQuery];
        
        [self updateLast12MonthIssue:clinicIdArr previousaDate:backDateStr currentDate:currentDateStr];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UpdateDataBase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //*********************** Here Implement  update Database Logic ***********************
    
    firstCategoryID  = 0;
    
	// this is for below 4.3 OS
    
	if (diveceType == 1) {
		
		[[UIApplication sharedApplication] setStatusBarHidden:TRUE];
        self.window.rootViewController = _navigationController;
		[self.window makeKeyAndVisible];
	}
	else {
		
		rootView_iPhone = [[RootViewController_iPhone alloc] initWithNibName:@"RootViewController_iPhone" bundle:nil];
		self.navigationController=[[[UINavigationController alloc] initWithRootViewController:rootView_iPhone] autorelease];
		[self.window addSubview:self.navigationController.view];
		[self.window makeKeyAndVisible];
		RELEASE(rootView_iPhone);
		
	}
    
    
    return YES;
}


-(BOOL)isSubscriptionActive:(NSInteger)a_clinicId{
    
    DatabaseConnection *dbConnection=[DatabaseConnection sharedController];
    
    NSString   *featureID  = [dbConnection retriveFromClinicsTableFeatureID:[NSString stringWithFormat:@"select FeatureId from tblclinic where ClinicID = %d",a_clinicId]];
    
    NSLog(@"%@",featureID);
    
    BOOL   subcription = [[MKStoreManager sharedManager] isSubscriptionActive:featureID];
    
    return subcription;
    
}

-(void)purchasedClinicWithID:(NSInteger)a_clinicid{
    
    NSLog(@"%d",seletedClinicID);
    
    restoreBuyCheck = clickBulkBuy;
    
    if ([CGlobal checkNetworkReachabilityWithAlert])
    {
        
        NSString  *isItLogin = [[NSUserDefaults standardUserDefaults] objectForKey:KisItLoginKey];
        
        if ([isItLogin isEqualToString:@"YES"]) {
            
            nowLoginIsTrue = LoginYes;
            UIAlertView   *subcriptionAlerView=[[UIAlertView  alloc] initWithTitle:@"" message:KOnlyInAppAlertMsgKey delegate:self cancelButtonTitle:nil otherButtonTitles:@"Buy Now…",@"Restore",@"Cancel",nil];
            subcriptionAlerView.tag = kBuyAlertTag;
            [subcriptionAlerView show];
            [subcriptionAlerView release];
            
            
        }else{
            
            nowLoginIsTrue = LoginNo;
            UIAlertView   *subcriptionAlerView=[[UIAlertView  alloc] initWithTitle:@"" message:KInAppAndLoginAlertMsgKey  delegate:self cancelButtonTitle:nil otherButtonTitles:@"Buy Now…",@"Restore",@"Login",@"Cancel",nil];
            subcriptionAlerView.tag = kBuyAlertTag;
            [subcriptionAlerView show];
            [subcriptionAlerView release];
            
        }
        
        
        //        DatabaseConnection *dbConnection=[DatabaseConnection sharedController];
        //        NSString   *featureID  = [dbConnection retriveFromClinicsTableFeatureID:[NSString stringWithFormat:@"select FeatureId from tblclinic where ClinicID=%d",a_clinicid]];
        //
        //        [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        //
        //        NSLog(@"Rohit ActualBuy SelectedClinicID:%d featureID:%@",a_clinicid,featureID);
        //        // ******************* here Call to purchage Clinics ********************
        //        restoreBuyCheck = clickBuy;
        //
        //        [[MKStoreManager sharedManager] buyFeature:featureID onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
        //            [self productPurchased:featureID Reciept:purchasedReceipt];
        //        } onCancelled:^{
        //            [self transactionCanceled];
        //        }];
        
    }
    
}


-(void)clickOnLoginButton:(id)sender{
    
    restoreBuyCheck = clickBuy;
    
	btnlogin=[[UIButton alloc] init];
	btnlogin=(UIButton *)sender;
	UIImage *Image = btnlogin.currentImage;
	DatabaseConnection *dbConnection=[DatabaseConnection sharedController];
	
    if (diveceType == 1) {   // *************this code use for IpadLogin*************
        
        if (clickONFullTextOrPdf == TRUE) {
            
            tabOnLoiginButton = HTMLORPDF;
            
			NSString   *featureID  = [dbConnection retriveFromClinicsTableFeatureID:[NSString stringWithFormat:@"select FeatureId from tblclinic where ClinicID = %d",seletedClinicID]];
            
            NSLog(@"%@",[NSString stringWithFormat:@"///////////////////////////////////////////////////////// \nrohit selectedClinicID:%d featureID:%@",seletedClinicID,featureID                                                                             ]);
            
            NSLog(@"%@",[NSString stringWithFormat:@"rohit DownloadURL:%@",downLoadUrl ]);
            
            //************* Here check user all ready purchage this Clinics in iPad ***********************************
            
            [self showMessage:[NSString stringWithFormat:@"FeatureID:%@",featureID]];
            
            
            
            BOOL   subcription = [[MKStoreManager sharedManager] isSubscriptionActive:featureID];
            
            
            if (subcription){
                
                //************* Dwonload Zip File From Server pdf as well as Full Text **********************
                [self downloadFileFromServer:downLoadUrl];
			}
			else{
                
                NSString  *isItLogin = [[NSUserDefaults standardUserDefaults] objectForKey:KisItLoginKey];
                
                if ([isItLogin isEqualToString:@"YES"]) {
                    
                    nowLoginIsTrue = LoginYes;
                    UIAlertView   *subcriptionAlerView=[[UIAlertView  alloc] initWithTitle:@"" message:KOnlyInAppAlertMsgKey delegate:self cancelButtonTitle:nil otherButtonTitles:@"Buy Now…",@"Restore",@"Cancel",nil];
                    subcriptionAlerView.tag = kBuyAlertTag;
                    [subcriptionAlerView show];
                    [subcriptionAlerView release];
                    
                }else{
                    
                    nowLoginIsTrue = LoginNo;
                    UIAlertView   *subcriptionAlerView=[[UIAlertView  alloc] initWithTitle:@"" message:KInAppAndLoginAlertMsgKey  delegate:self cancelButtonTitle:nil otherButtonTitles:@"Buy Now…",@"Restore",@"Login",@"Cancel",nil];
                    subcriptionAlerView.tag = kBuyAlertTag;
                    [subcriptionAlerView show];
                    [subcriptionAlerView release];
                    
                }
			}
        }
        else {
            
            // ************* tab on login button *************
            
            if (Image==[UIImage imageNamed:@"BtnLogout.png"]) {
                
                UIAlertView   *alertView=[[UIAlertView  alloc] initWithTitle:@"Logout" message:@" Do you want to logout?"delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO",nil];
                alertView.tag = KLoginAlertKey;
                [alertView show];
                [alertView release];
                
            }
            else{
                tabOnLoiginButton = LoginButton;
                loginView=[[LoginViewController alloc] init];
                loginView.downLoadUrl=downLoadUrl;
                
                if ([CGlobal isOrientationLandscape])
                {
                    loginView.view.frame=CGRectMake(0, 0, 1024, 768);
                }
                else
                {
                    loginView.view.frame=CGRectMake(0, 0, 768, 1024);
                }
                RootViewController *root=(RootViewController *)rootViewController;
                WebViewController  *web=(WebViewController*)webViewController;
                if(webViewController){
                    [web.view addSubview:loginView.view];
                }
                if (rootViewController) {
                    [root.view addSubview:loginView.view];
                    
                }
            }
            
            
            
        }
		
	}
	
	// ************* here login code in Iphone*************
	else {
		if (clickONFullTextOrPdf == YES) {
			//************* seleted Full text or pdf*************
            tabOnLoiginButton = HTMLORPDF;
            
			NSString   *featureID  = [dbConnection retriveFromClinicsTableFeatureID:[NSString stringWithFormat:@"select FeatureId from tblclinic where ClinicID=%d",seletedClinicID]];
            
            //************* Here Check user All ready purchage This Clinics in Iphone ***********************************
            
            NSLog(@"iPhone login");
			BOOL   subcription = [[MKStoreManager sharedManager] isSubscriptionActive:featureID];
            
			if (subcription ){
                
                [self downloadFileFromServer:downLoadUrl];
                
                return;
			}
			else{
				
				NSString  *isItLogin = [[NSUserDefaults standardUserDefaults] objectForKey:KisItLoginKey];
                
                if ([isItLogin isEqualToString:@"YES"]) {
                    nowLoginIsTrue = LoginYes;
                    UIAlertView   *subcriptionAlerView=[[UIAlertView  alloc] initWithTitle:@"" message:KOnlyInAppAlertMsgKey delegate:self cancelButtonTitle:nil otherButtonTitles:@"Buy Now…",@"Restore",@"Cancel",nil];
                    subcriptionAlerView.tag = kBuyAlertTag;
                    [subcriptionAlerView show];
                    [subcriptionAlerView release];
                }else{
                    nowLoginIsTrue = LoginNo;
                    UIAlertView   *subcriptionAlerView=[[UIAlertView  alloc] initWithTitle:@"" message:KInAppAndLoginAlertMsgKey delegate:self cancelButtonTitle:nil otherButtonTitles:@"Buy Now…",@"Restore",@"Login",@"Cancel",nil];
                    subcriptionAlerView.tag = kBuyAlertTag;
                    [subcriptionAlerView show];
                    [subcriptionAlerView release];
                }
                
                
                return;
			}
		}
        
        //******************* tab on login button *******************
        if (Image==[UIImage imageNamed:@"iPhone_Logout_btn.png"]) {
            UIAlertView   *alertView=[[UIAlertView  alloc] initWithTitle:@"Logout" message:@"Do you want to logout?"delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO",nil];
            alertView.tag = KLoginAlertKey;
            [alertView show];
            [alertView release];
        }
        else{
            
            tabOnLoiginButton = LoginButton;
            loginView_iPhone=[[LoginViewController_iPhone alloc] initWithNibName:@"LoginViewController_iPhone" bundle:nil];
            loginView_iPhone.downLoadUrl=downLoadUrl;
            loginView_iPhone.viewController=[self.navigationController topViewController];
            [[self.navigationController topViewController].view addSubview:loginView_iPhone.view];
            
        }
        
    }
    
	//*******************use in iPhone*******************
	authentication = [dbConnection retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",seletedClinicID]];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex1{
    
	DatabaseConnection *database = [DatabaseConnection sharedController];
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex1];
    
    
    
	if (alertView.tag == kBuyAlertTag) {
		// in App login
        
        if (nowLoginIsTrue == LoginYes ) {
            return;
        }
        if ([title isEqualToString:@"Restore"]) {
            //NSLog(@"Restore");
            
            [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            
            restoreBuyCheck = clickRestore;
            
            [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^(NSArray *transactions){
                
                [self restoreCompletedWithTransactions:transactions];
                
            } onError:^(NSError *error) {
                
                [self restoreCancelled];
            }];
            
            
		}else if ([title isEqualToString:@"Login"]) {
			// *******************here Ipad Code login*******************
			if(diveceType == 1){
                
                loginView=[[LoginViewController alloc] init];
                loginView.downLoadUrl=downLoadUrl;
                if ([CGlobal isOrientationLandscape])
                {
                    loginView.view.frame=CGRectMake(0, 0, 1024, 768);
                }
                else
                {
                    loginView.view.frame=CGRectMake(0, 0, 768, 1024);
                }
                RootViewController *root=(RootViewController *)rootViewController;
                WebViewController  *web=(WebViewController*)webViewController;
                if(webViewController){
                    [web.view addSubview:loginView.view];
                }
                if (rootViewController) {
                    [root.view addSubview:loginView.view];
                    
                }
            }
            //******************* here Iphone code *******************
			else {
                
				loginView_iPhone=[[LoginViewController_iPhone alloc] initWithNibName:@"LoginViewController_iPhone" bundle:nil];
				loginView_iPhone.viewController=[self.navigationController topViewController];
				loginView_iPhone.downLoadUrl=downLoadUrl;
				[[self.navigationController topViewController].view addSubview:loginView_iPhone.view];
                
				
			}
            
			
		}else if([title isEqualToString:@"Buy Now…"])
        {
            //Buy code
            if(buttonIndex1==0){
                if ([CGlobal checkNetworkReachabilityWithAlert])
                {
                    DatabaseConnection *dbConnection=[DatabaseConnection sharedController];
                    NSString   *featureID  = [dbConnection retriveFromClinicsTableFeatureID:[NSString stringWithFormat:@"select FeatureId from tblclinic where ClinicID=%d",seletedClinicID]];
                    
                    [MBProgressHUD showHUDAddedTo:self.window animated:YES];
                    
                    NSLog(@"Rohit ActualBuy SelectedClinicID:%d featureID:%@",seletedClinicID,featureID);
                    // ******************* here Call to purchage Clinics ********************
                    
                    
                    [[MKStoreManager sharedManager] buyFeature:featureID onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                        [self productPurchased:featureID Reciept:purchasedReceipt];
                    } onCancelled:^{
                        [self transactionCanceled];
                    }];
                    
                }
                
                
            }
            
        }
		
	}
    
	else if(alertView.tag == KLoginAlertKey){
		DatabaseConnection *database = [DatabaseConnection sharedController];
		// ******************* logout in Button press *******************
		if (buttonIndex1==0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:KisItLoginKey];
            
			if (diveceType == 1) {  // ******************* here Ipad Code  open *******************
                NSString *rember = [[NSUserDefaults standardUserDefaults] objectForKey:@"Rember"];
                if ([rember intValue]==0) {
                    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"LOGIN"];
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PASSWORD"];
                }
                
                [btnlogin setImage:[UIImage imageNamed:@"BtnLogin.png"] forState:UIControlStateNormal];
                login = NO;
                
                NSInteger  GlobalLogin = [database retriveCategoryAllAutntication:@"SELECT authencation FROM tblClinic"];
				if (GlobalLogin == isOne) {
                    [database updateAuthecationInClinicTable:@"UPDATE tblClinic SET Authencation = 0"];
                }
                else {
                    [self logOutForMutltipleAccess];
                }
                
			}
			//  *******************here Ipad Code  closed *******************
			
			//  *******************here Iphone code  open *******************
			else {
				NSString *rember = [[NSUserDefaults standardUserDefaults] objectForKey:@"Rember"];
                if ([rember intValue] == 0) {
					[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"LOGIN"];
					[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PASSWORD"];
				}
				[btnlogin setImage:[UIImage imageNamed:@"iPhone_Login_btn.png"] forState:UIControlStateNormal];
                
				login = NO;
                
				NSInteger  GlobalLogin = [database retriveCategoryAllAutntication:@"SELECT authencation FROM tblClinic"];
				if (GlobalLogin == isOne) {
                    
                    [database updateAuthecationInClinicTable:@"UPDATE tblClinic SET Authencation = 0"];
                    
                }
                else {
                    
                    [self logOutForMutltipleAccess];
                    
                }
                
                
				
			}
            // ******************* here Iphone code close *******************
		}
		
	}
    
	authentication = [database retriveAuthenticationfromServer:[NSString stringWithFormat:@"SELECT authencation FROM tblClinic WHERE ClinicId = %d",seletedClinicID]];
    
    
}

-(void)restoreCompletedWithTransactions:(NSArray*)transactions{
    
    if([transactions count] == 0){
        
        [self showMessage:@"Restore failed.You have not purchased any clinic."];
        return;
        
    }
    [self showMessage:@"Restore completed"];
    [MBProgressHUD hideHUDForView:self.window animated:YES];
    
}

-(void)restoreCancelled{
    
    [self showMessage:@"Restore cancelled"];
    [MBProgressHUD hideHUDForView:self.window animated:YES];
    
}


-(void)logOutForMutltipleAccess{
    
    DatabaseConnection *database = [DatabaseConnection sharedController];
    
    NSArray  *issnDataArr = [[NSUserDefaults standardUserDefaults] objectForKey:KMultipleLoginKey];
    
    for (int i = 0; i<[issnDataArr count]; i++) {
        
        NSString   *queryStr = [NSString stringWithFormat:@"UPDATE tblClinic SET Authencation = 0 where  ISSN = '%@'",[[issnDataArr objectAtIndex:i]  valueForKey:@"issn"] ];
        [database updateAuthecationInClinicTable:queryStr];
    }
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KMultipleLoginKey];
}

-(void)releaseLoginView{
	[loginView release];
	loginView=nil;
}

// ******************* change Orienation Login View ************************

-(void)changeOrientatioLoginview{
    
	if (loginView) {
        if ([CGlobal isOrientationLandscape])
        {
            [LoadingViewlogin inSideIpadLandScape];
            CGRect view1Frame = loginView.view.frame;
            if ([loginView.passwordtxt  isFirstResponder] || [loginView.userNameTxt isFirstResponder]) {
                view1Frame.origin.y = -140;
            }
            else {
                view1Frame.origin.y = 0;
            }
            
            loginView.view.frame = view1Frame;
        }
        else
        {
            [LoadingViewlogin inSideIpadPortrait];
            CGRect view1Frame = loginView.view.frame;
            view1Frame.origin.y = 0;
            loginView.view.frame = view1Frame;
        }
	}
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    [self downLoadUpdateIssueInBackgound];
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
}



- (void)applicationWillTerminate:(UIApplication *)application
{
	
	
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (NSOperationQueue *)downloadQueue {
    
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.name = @"Download Queue";
        _downloadQueue.maxConcurrentOperationCount = 1;
    }
    return _downloadQueue;
}

-(void)downLoadUpdateIssueInBackgound{
    
    
    DatabaseConnection *dbConnection = [DatabaseConnection sharedController];
    NSMutableArray  *clincsIdArr =[dbConnection selectCheckedClinicArr];
    NSMutableString *getUpdateUrl = nil;
    if([CGlobal checkNetworkReachabilityWithAlert]){
        
        NSMutableArray  *dateArr = [dbConnection selectModifiedDateFromArticleTable:[NSString stringWithFormat:@"select modified from tblclinic where clinicID IN %@",clincsIdArr]];
        
        NSMutableString   *dateStr=[[NSMutableString alloc] init];
        NSMutableString   *IdDStr=[[NSMutableString alloc] init];
        for (int i=0; i<[dateArr count]; i++) {
            if (i==[clincsIdArr count]-1)
                [dateStr appendString:[NSString stringWithFormat:@"%@",[dateArr objectAtIndex:i]]];
            else
                [dateStr appendString:[NSString stringWithFormat:@"%@,",[dateArr objectAtIndex:i]]];
            
        }
        
        for (int i=0; i<[clincsIdArr count]; i++) {
            if (i==[clincsIdArr count]-1)
                [IdDStr appendString:[NSString stringWithFormat:@"%@",[clincsIdArr objectAtIndex:i]]];
            else
                [IdDStr appendString:[NSString stringWithFormat:@"%@,",[clincsIdArr objectAtIndex:i]]];
            
        }
        
        
		getUpdateUrl=[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@clinicid=%@&date=%@",kdwonloadAllUpdateIssue,IdDStr,dateStr]];
        RELEASE(IdDStr);
        RELEASE(dateStr);
        
        
		[getUpdateUrl replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [getUpdateUrl length])];
        
    }
    
    DataRecord    *dataRecord = [[DataRecord alloc] init];
    dataRecord.urlStr = getUpdateUrl;
    RELEASE(getUpdateUrl);
    
    DownloaderData    *downLoadData = [[DownloaderData alloc] initWithPhotoRecord:dataRecord atIndexPath:nil delegate:self];
    [self.downloadQueue addOperation:downLoadData];
}

-(void)dataDownLoadComplete:(DataRecord *)downloader  {
    
    NSString    *dataStr = [[NSString alloc] initWithData:downloader.getData encoding:NSUTF8StringEncoding];
    
    NSError* error;
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *dictData=[json objectWithString:dataStr error:&error];
    
    if (diveceType == 1) {
        [m_rootViewController saveUpdateIssue:dictData];
    }else{
        [rootView_iPhone saveUpdateIssue:dictData];
    }
    //NSLog(@"======== %@",dictData);
}

- (void)dealloc{
	
    NSLog(@"AppDelDealloc");
    RELEASE(m_downloadArticlesArr);
    RELEASE(m_downloadedConnectionArr);
	// releas Iphone object
	if (wewView_iPhone) {
		RELEASE(wewView_iPhone);
	}
	if (rootView_iPhone) {
		RELEASE(rootView_iPhone);
	}
	RELEASE(clinicsdeatils_iPhone);
	RELEASE(firstCategoryName);
	RELEASE(ariticleListView);
    RELEASE(clinicDetailsView);
    RELEASE(m_rootViewController);
	RELEASE(_window);
    RELEASE(rootViewController);
	RELEASE(viewController);
	RELEASE(webViewController);
    [super dealloc];
	if (lastSelectedClinicList) {
		RELEASE(lastSelectedClinicList);
		lastSelectedClinicList=nil;
	}
}





#pragma mark -
#pragma mark <InApp Purchase Callback> methods

- (void)productPurchased:(NSString *)productId Reciept:(NSData*)reciept
{
    
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
    
    if(restoreBuyCheck == clickBuy){
        
        NSLog(@"Product Purchased%@",productId);
        
       
        
        BOOL  success;
        NSString  *str=[[downLoadUrl componentsSeparatedByString:@"/"] lastObject];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:str];
        
        success = [fileManager fileExistsAtPath:writableDBPath];
        
        if (!success){
            
            //************* Dwonload Zip File From Server pdf as well as Full Text **********************
            [self downloadFileFromServer:downLoadUrl];
        }
        else{
            
        }
        
        
        [self updateLast12MonthIssue:YES];
        
        NSError  *error;
        if (![[GANTracker sharedTracker] trackEvent:@"Subscription" action:@"Paid users" label:nil value:-1 withError:&error]) {
            
        }
    }else if(restoreBuyCheck == clickRestore) {
        
        NSError  *error;
        if (![[GANTracker sharedTracker] trackEvent:@"Subscription" action:@"Restore users" label:nil value:-1 withError:&error]) {
            
        }
    }else if(restoreBuyCheck == clickBulkBuy){
      
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClinicPurchased"  object:nil];
        
   }
	
}

-(void)showMessage:(NSString*)a_str{
    
    UIAlertView   *alertView=[[UIAlertView  alloc] initWithTitle:@"Clinic" message:a_str  delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)transactionCanceled
{
    //NSLog(@"transaction failed");
    [self showMessage:@"Transaction failed"];
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
}


- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    [self showMessage:@"Transaction failed"];
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
}


//************* Dwonload Zip File From Server pdf as well as Full Text **********************

-(void)downloadFileFromServer:(NSString *)choiceString{
	
	DownloadController *downloadController=[DownloadController sharedController];
	[downloadController setSender:self];
	[downloadController addLoaderForView];
	[downloadController createDownloadQueForQueData:choiceString];
    
}

-(void)updateLast12MonthIssue:(BOOL)flag{
    
    DatabaseConnection *database = [DatabaseConnection sharedController];
    NSDictionary    *dataDict =  [CGlobal getCurrentDateFromServer];
    
    NSString    *currentDateStr = [dataDict valueForKey:@"CurrentDate"];
    NSString    *backDateStr = [dataDict valueForKey:@"PreviousDate"];
    
    NSString  *query  = [NSString stringWithFormat:@"UPDATE tblIssue SET Access = 1 where ClinicID = '%d' and ReleaseDate <= '%@' and ReleaseDate >= '%@'",seletedClinicID,currentDateStr,backDateStr];
    
    [database setFlagInAceessIssue:query];
}


-(void)updateLast12MonthIssue:(NSArray *)clinicIdArr
                previousaDate:(NSString *)backDateDateStr
                  currentDate:(NSString *)currentDateStr{
    
    DatabaseConnection *dbConnection = [DatabaseConnection sharedController];
    
    for (int i = 0; i<[clinicIdArr count]; i++) {
        
        NSString  *query  = [NSString stringWithFormat:@"UPDATE tblIssue SET Access = 1 where ClinicID  = '%d' and ReleaseDate <= '%@' and ReleaseDate >= '%@'",[[clinicIdArr objectAtIndex:i] intValue],currentDateStr,backDateDateStr];
        
        [dbConnection setFlagInAceessIssue:query];
    }
    
    
}
@end
