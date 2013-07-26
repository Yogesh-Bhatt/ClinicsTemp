//
//  LoginViewController_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController_iPhone.h"
#import "LoginViewController.h"
#import "Reachability.h"
#import "XMLParser.h"
#import "CGlobal.h"
#import "AritcleListViewController.h"
#import "DownloadController.h"
#import "RootViewController.h"
#import "ClinicsDetailsView_iPhone.h"
#import "BookMarksDetailsViewController_iPhone.h"
#import "NotesDetailsViewController_iPhone.h"

@implementation LoginViewController_iPhone
@synthesize cancelBtn;
@synthesize downLoadUrl;
@synthesize passwordtxt;
@synthesize userNameTxt;
@synthesize viewController;

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
    [super dealloc];
	[userNameTxt release];
	[passwordtxt release];
	[downLoadUrl release];
	[downLoadUrl release];
	
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewDidUnload{
    
	userNameTxt.delegate=nil;
	passwordtxt.delegate=nil;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	userNameTxt.delegate=self;
	passwordtxt.delegate=self;
	[userNameTxt becomeFirstResponder];
	
	[cancelBtn addTarget:self action:@selector(clickOnLoginCancelButton:) forControlEvents:UIControlEventTouchUpInside];
	[loginBtn addTarget:self action:@selector(clickOnLoginButton:) forControlEvents:UIControlEventTouchUpInside];
	[switchBtn addTarget:self action:@selector(cliclOnRememberMe:) forControlEvents:UIControlEventTouchUpInside];
	
	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN"];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
    NSString *remeberUserNameAndPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"Rember"];
	
	Reachability* reachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
	
	if(remoteHostStatus == NotReachable) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network connection not available" message:@"You are offline. Please go online to log in" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	
	if ([remeberUserNameAndPassword intValue] ==1) {
        switchBtn.on = TRUE;
		userNameTxt.text = loginId;
		passwordtxt.text = password;
		
	}
    else{
        switchBtn.on = FALSE;
    }

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark --
#pragma mark <UIButton Pressed> methods

-(void)clickOnLoginCancelButton:(id)sender{
	
	[self.view removeFromSuperview];
	
}

//************************** Login Start ******************************

-(void)clickOnLoginButton:(id)sender{

	isItfirstRequest = YES;
		
	if ([userNameTxt.text length] == 0 || [passwordtxt.text length] == 0) {
        NSString  *msg = nil;
        
        if ([userNameTxt.text length] == 0) {
            msg = @"Please enter your user name.";
        }
        if ([passwordtxt.text length] == 0) {
            msg = @"Please enter your password.";
        }
        
        if ([userNameTxt.text length] == 0 && [passwordtxt.text length] == 0) {
            msg = @"Please enter your login details.";
        }
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login details" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
        return ;
	}

	else {
       loginBtn.userInteractionEnabled = NO;
		[LoadingViewLogin_IPhone displayLoadingIndicator:self.view :self.interfaceOrientation];
		[LoadingViewlogin setTitle:@"Logging in..."];

		NSURL *url = [NSURL URLWithString:[SERVERBASEURL stringByAppendingString:@"/v1/auth/user"]]; 
        
		NSString *login = [userNameTxt.text AES256EncryptWithKey:SYMMETRICKEY];
		
		NSString *pwd = [passwordtxt.text AES256EncryptWithKey:SYMMETRICKEY];
		
		//NSLog(@"Login is :- %@\n Password is :- %@",login,pwd);
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
		
		[request addRequestHeader:@"consumerid" value:CONSUMERID];
		[request addRequestHeader:@"appid" value:@"TheClinics"];
		[request addRequestHeader:@"name" value:login];
		[request addRequestHeader:@"cred" value:pwd];
		
		[request setDelegate:self];
		[request startAsynchronous]; 
		
	}
	
}


//************************** Rember User Name or pass word  ******************************

-(void)cliclOnRememberMe:(id)sender{
    
	if ([switchBtn isOn]) {
        switchBtn.on = TRUE;
    }
    else{
    switchBtn.on = FALSE;
    }

}

//************************** Remeber User Name or pass word  ******************************

- (void) setNilUserDefaults {
    
	[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"LOGIN"];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PASSWORD"];
	
}

//******************************************************************************************************//
// To catch the server Response   //
//******************************************************************************************************//

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching text data
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	// here login true
	//*** here code which clininc user Authencation
	NSString *responseString = [request responseString];
	
	
    int statusCode = [request responseStatusCode];
    
    if (statusCode == 200) {
		
		NSMutableDictionary *fectchDataDic = [[NSMutableDictionary alloc] init];
		
		NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
		
	    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData:data]autorelease];
        
		if (isItfirstRequest) {
            
			isItfirstRequest = NO;
			XMLParser *parser = [[[XMLParser alloc] initXMLParser:@"user"]autorelease];
			[xmlParser setDelegate:parser];
			[xmlParser parse];
			[fectchDataDic setObject:parser.parsedXML forKey:@"user"];
			
			NSArray *dataArr=[fectchDataDic objectForKey:@"user"];
			//NSLog(@"fectchDataDic %@",[[dataArr objectAtIndex:0] valueForKey:@"session"]);
			
			[fectchDataDic release];

			NSString   *loginAuthencationURl=[NSString stringWithFormat:@"%@/v1/autz/subscription?session=%@&?portal=HealthAdvance",SERVERBASEURL,[[dataArr objectAtIndex:0] valueForKey:@"session"]];
			ASIHTTPRequest *request1 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loginAuthencationURl]];
			[request1 addRequestHeader:@"consumerid" value:CONSUMERID];
			[request1 addRequestHeader:@"appid" value:@"TheClinics"];
			[request1 setDelegate:self];
			[request1 startAsynchronous]; 
		}
		else {
			
            loginBtn.userInteractionEnabled = YES;
            
			XMLParser *parser = [[[XMLParser alloc] initXMLParser:@"product"]autorelease];
			[xmlParser setDelegate:parser];
			[xmlParser parse];
			[fectchDataDic setObject:parser.parsedXML forKey:@"product"];
			NSArray *dataArr=[fectchDataDic objectForKey:@"product"];
			[fectchDataDic release];
			
            if ([dataArr count]<=0) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:KLoginSuccessNotHaveAccessMsgKey  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				
				[alert release];
                [self.view removeFromSuperview];
                return ;
            }

			
			if ([self loginTrueForAccessIssn:dataArr]) {
                
                 [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:KisItLoginKey];
                
                // track Google event********************************
                [[GANTracker sharedTracker] startTrackerWithAccountID:GoogleAnalyticsID dispatchPeriod:10.0 delegate:nil];
                
                NSError *error;
                if (![[GANTracker sharedTracker] trackEvent:@"Login" action:@"clinics.com" label:nil value:-1 withError:&error]) {
                    //NSLog(@"%@",error);
                } 
                // track Google event********************************

				[[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",userNameTxt.text] forKey:@"LOGIN"];
				[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",passwordtxt.text] forKey:@"PASSWORD"];
				
				if ([switchBtn isOn]) {
					[[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"Rember"];
				}else {
					[[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"Rember"];
				}
                
				if (appDelegate.tabOnLoiginButton == HTMLORPDF){
                    
					BOOL  success;
					NSString  *str=[[downLoadUrl componentsSeparatedByString:@"/"] lastObject];
					NSFileManager *fileManager=[NSFileManager defaultManager];
					NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
					NSString *documentsDirectory=[paths objectAtIndex:0];
					NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:str];
					success=[fileManager fileExistsAtPath:writableDBPath];
					if (!success){
        
						if (appDelegate.clinicsDetails==kTAB_CLINICS) {
							
							[appDelegate.clinicsdeatils_iPhone changeImageLoginButton];
						}
						
						if (appDelegate.clinicsDetails==kTAB_BOOKMARKS) {
							
							BookMarksDetailsViewController_iPhone  *bookmarksDetailsView_iPhone=(BookMarksDetailsViewController_iPhone *)appDelegate.rootView_iPhone.bookmarks_iPhone.bookmarkDetails_iPhone;
							[bookmarksDetailsView_iPhone changeImageLoginButton];
							
						} 
						
						if (appDelegate.clinicsDetails==kTAB_NOTES) {
							
                        NotesDetailsViewController_iPhone  *notesDetailsView_iPhone=(NotesDetailsViewController_iPhone *)appDelegate.rootView_iPhone.noteLists_iPhone.noteDetailsView_iPhone;
							[notesDetailsView_iPhone changeImageLoginButton];
							
							
						}
						if (appDelegate.wewView_iPhone) {
							[appDelegate.wewView_iPhone  changeImageLoginButton];
						}
						//************* Dwonload Zip File From Server pdf as well as Full Text **********************
						[self downloadFileFromServer:downLoadUrl];
					}
				   }
					else{
						   ClinicsAppDelegate   *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
							AritcleListViewController  *ariticleListView = (AritcleListViewController *)appDelegate.ariticleListView;
							if (appDelegate.ariticleListView) {
								[ariticleListView completeDwonloadFullTextAndPdfReloadONWebView];
								
							}   
							else {
								
								if (appDelegate.clinicsDetails==kTAB_CLINICS) {
									
									[appDelegate.clinicsdeatils_iPhone changeImageLoginButton];
								}
								
								if (appDelegate.clinicsDetails==kTAB_BOOKMARKS) {
									
									BookMarksDetailsViewController_iPhone  *bookmarksDetailsView_iPhone=(BookMarksDetailsViewController_iPhone *)appDelegate.rootView_iPhone.bookmarks_iPhone.bookmarkDetails_iPhone;
									[bookmarksDetailsView_iPhone changeImageLoginButton];
									
								} 
								
								if (appDelegate.clinicsDetails==kTAB_NOTES) {
									
									NotesDetailsViewController_iPhone  *notesDetailsView_iPhone=(NotesDetailsViewController_iPhone *)appDelegate.rootView_iPhone.noteLists_iPhone.noteDetailsView_iPhone;
									[notesDetailsView_iPhone changeImageLoginButton];
									
									
							       }
								if (appDelegate.wewView_iPhone) {
									[appDelegate.wewView_iPhone  changeImageLoginButton];
								}
							
						// here close iphone login code

					}
					
				}
				loginBtn.enabled = TRUE;
				[self.view removeFromSuperview];

			}
			
			else {
                loginBtn.userInteractionEnabled = YES;
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Please enter the right login details." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				alert.tag =101;
				[alert release];
				[LoadingViewLogin_IPhone removeLoadingIndicator];
			}

		
		}
	}

	else {
        loginBtn.userInteractionEnabled = YES;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Please enter the right login details." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		alert.tag = 101;
		[alert release];
		[LoadingViewLogin_IPhone removeLoadingIndicator];
	}

}

// To catch the Server Failure Response  //
//******************************************************************************************************//

- (void)requestFailed:(ASIHTTPRequest *)request
{
	loginBtn.userInteractionEnabled = YES;
    
    loginBtn.enabled = TRUE;
    int statusCode = [request responseStatusCode];
    if (statusCode == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Internet connection appears to be offline. Try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Log In Credentials" message:@"Wrong username or password." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		alert.tag=101;
        [alert show];
        [alert release];
    }
    [LoadingViewLogin_IPhone removeLoadingIndicator];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField;   {
	
		self.view.frame=CGRectMake(0, -80, self.view.frame.size.width,self.view.frame.size.height );
	
	
}

// return NO to disallow editing.

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	self.view.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height ); 
	return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	self.view.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height ); 
	return YES;
}
//************* Dwonload Zip File From Server pdf as well as Full Text **********************
-(void)downloadFileFromServer:(NSString *)choiceString{    
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	if (appDelegate.tabOnLoiginButton == HTMLORPDF) {  // here we check Tab On HTmloR PDf
	DownloadController *downloadController=[DownloadController sharedController];
	[downloadController setSender:self];
	[downloadController addLoaderForView];
	[downloadController createDownloadQueForQueData:choiceString];
}
		
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex1{
    
	if(alertView.tag==101){
		[LoadingViewLogin_IPhone removeLoadingIndicator];
		passwordtxt.text=nil;
		userNameTxt.text=nil;
	}
}

-(BOOL)loginTrueForAccessIssn:(NSArray *) issnDataArr{
    
    BOOL  isAuthetication = NO;
    
    ClinicsAppDelegate  *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    DatabaseConnection *database = [DatabaseConnection sharedController];
    BOOL   isThisAccessForCurrentClinic = NO;
    NSString *clinicsIssnNumber = [database selectISSN:[NSString stringWithFormat:@"SELECT ISSN FROM tblClinic WHERE ClinicId = %d", appDelegate.seletedClinicID]];
    
    
    clinicsIssnNumber	 = [clinicsIssnNumber stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString  *commonLogin = KCommanLoginStrKey;
    
    if ([commonLogin isEqualToString:[[issnDataArr objectAtIndex:0] valueForKey:@"issn"]]) {
        isAuthetication = YES;
        appDelegate.flagLoginOneAll = YES;
        NSString   *queryStr = [NSString stringWithFormat:@"UPDATE tblClinic SET Authencation = 1"];
        [database updateAuthecationInClinicTable:queryStr]; 
        
    }else{
        
        appDelegate.flagLoginOneAll = NO;
        
        for (int i=0; i<[issnDataArr count];i++) {
            
            if ([clinicsIssnNumber isEqualToString:[[issnDataArr objectAtIndex:i] valueForKey:@"issn"]]){
                isThisAccessForCurrentClinic = YES;
                break;
            }
            else {
                isThisAccessForCurrentClinic = NO;
            }
            
        }
    }
    
    if (isThisAccessForCurrentClinic) {
        
        isAuthetication = YES;
        appDelegate.login = YES;
        for (int i = 0; i<[issnDataArr count]; i++) {
            
            NSString   *queryStr = [NSString stringWithFormat:@"UPDATE tblClinic SET Authencation = 1 where  ISSN = '%@'",[[issnDataArr objectAtIndex:i] valueForKey:@"issn"]];
            [database updateAuthecationInClinicTable:queryStr];
        }
        
        [self rememberLastAccess:issnDataArr];
    }
    
    
    return isAuthetication;
}

-(void)rememberLastAccess:(NSArray *)issnDataArr{
    
    [[NSUserDefaults standardUserDefaults] setObject:issnDataArr forKey:KMultipleLoginKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
