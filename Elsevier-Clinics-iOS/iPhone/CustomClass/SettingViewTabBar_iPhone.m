    //
//  SettingViewTabBar_iPhone.m
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//





#import "SettingViewTabBar_iPhone.h"
#import "FeedbackView_iPhone.h" 
#import "SettingDetailViewController.h"
#import "AboutAppListViewController.h"
#import "HomeEditorView.h"
#import "ClinicsAppDelegate.h"

@implementation SettingViewTabBar_iPhone
@synthesize     tabbar;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	tabbar=[[UITabBar alloc] init];
	if(IS_WIDESCREEN){
        tabbar.frame=CGRectMake(0, 500, 320, 49);
    }else{
        tabbar.frame=CGRectMake(0, 412, 320, 49);
    }
	tabbar.delegate=self;
	NSMutableArray   *item = [[NSMutableArray alloc] init];
    
	//*****************About Us Feedback  Share*****************
    
	UITabBarItem  *item1=[[UITabBarItem alloc] initWithTitle:@"About" image:[UIImage imageNamed:@"iPhone_AboutUsUnselected.png"] tag:1];
	UITabBarItem  *item2=[[UITabBarItem alloc] initWithTitle:@"Feedback" image:[UIImage imageNamed:@"iPhone_FeedbackUnselected.png"] tag:2];
	UITabBarItem  *item3=[[UITabBarItem alloc] initWithTitle:@"Share" image:[UIImage imageNamed:@"iPhone_ShareUnselected.png"] tag:3];
	[item addObject:item1];
	[item addObject:item2];
	[item addObject:item3];
	tabbar.items = item ;
	[self.view addSubview:tabbar];
	
    RELEASE(item1);
    RELEASE(item2);
    RELEASE(item3);
    RELEASE(item);
 
}

#pragma mark --
#pragma mark <UITabBar Delegate Methods>

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	if (item.tag==2) {
	[self goToFeedBackView];
 
    }
	else  if(item.tag==3){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share" message:nil  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Facebook",@"Twitter",@"Email",nil];
		alert.tag=500;
		[alert show];
		[alert release];
    
	}

}

-(void)goToFeedBackView{
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	FeedbackView_iPhone   *feedback=[[FeedbackView_iPhone alloc] initWithNibName:@"FeedbackView_iPhone" bundle:nil];
	[appDelegate.navigationController presentModalViewController:feedback animated:YES];  
	[feedback release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex1{
	
	if (alertView.tag==500) {
		if (buttonIndex1==1) {
			[self facebookButtonPressed:nil];
		}
		else if(buttonIndex1==2) {
			[self twitterButtonPressed:nil];
		}
		else if(buttonIndex1==3) {
			[self emailButtonPressed:nil];
		}
		
	}

}


- (IBAction) emailButtonPressed:(id)sender
{
    if ([CGlobal checkNetworkReachabilityWithAlert])
    {
        if ([CGlobal isMailAccountSet])
        {
            MFMailComposeViewController  *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
			RootViewController_iPhone  *rootView =(RootViewController_iPhone *)appDelegate.rootView_iPhone; 
            [rootView presentModalViewController:controller animated:YES];
            
            [controller release];	
        } 
    }
}

- (IBAction) facebookButtonPressed:(id)sender
{
    if ([CGlobal checkNetworkReachabilityWithAlert] )
    {
        [FBShareManager sharedManager];
        [FBShareManager sharedManager].delegate = self;
		[FBShareManager sharedManager].msg=@"Abc";
        [[FBShareManager sharedManager] publishStreamWithoutDialogBox];
    }
}

- (IBAction)twitterButtonPressed:(id)sender
{ 
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	HomeEditorView  *homeEditor=(HomeEditorView *)appDelegate.m_rootViewController.homeEditor;
	BookMarksDetailsViewController_iPad  *bookmarks=(BookMarksDetailsViewController_iPad *)appDelegate.m_rootViewController.bookMarkDetailsView;
	NotesDetailsViewController_iPad   *noteDeatils=(NotesDetailsViewController_iPad *)appDelegate.m_rootViewController.m_NotesDetailsView;
	if (noteDeatils) {
		[noteDeatils dismissPopoover];
	}
	else if (bookmarks) {
		[bookmarks dismissPopoover];
	}
	
	[homeEditor dismissPopoover];
	
	
	[appDelegate.clinicDetailsView  dismissPopoover];
    if ([CGlobal checkNetworkReachabilityWithAlert])
    {
        if ([TWTweetComposeViewController canSendTweet]) {
            // Initialize Tweet Compose View Controller
            TWTweetComposeViewController *vc = [[TWTweetComposeViewController alloc] init];
            
            // Settin The Initial Text
            [vc setInitialText:@"Hi."];
            
            // Setting a Completing Handler
            [vc setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
                [self dismissModalViewControllerAnimated:YES];
            }];
            
            // Display Tweet Compose View Controller Modally
            [self presentViewController:vc animated:YES completion:nil];
            
        } else {
            // Show Alert View When The Application Cannot Send Tweets
            NSString *message = @"The application cannot send a tweet at the moment. This is because it cannot reach Twitter or you don't have a Twitter account associated with this device.";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
        }

    }
}

#pragma mark --
#pragma mark <MFMailComposeViewControllerDelegate> Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
	
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	RootViewController_iPhone  *rootView =(RootViewController_iPhone *)appDelegate.rootView_iPhone; 
	[rootView dismissModalViewControllerAnimated:YES];
    if(result == MFMailComposeResultSent)
    {
        [CGlobal showMessage:@"" msg:@"Mail message has been sent."];
    }
    else if (result == MFMailComposeResultSaved)
    {
        [CGlobal showMessage:@"" msg:@"Mail message has been saved."];
    }
}


#pragma mark --
#pragma mark <TwitterShareManagerDelegate>

-(void)twitterPostDidSuccess{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success"
                                                    message: @"Thank you for sharing."
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}


-(void)twitterPostDidFail{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
                                                    message: @"An error occurred while submitting your post. Please try again later."
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

#pragma mark --
#pragma mark <FBShareManagerDelegate>
-(void)facebookPostDidSuccess{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success"
                                                    message: @"Thank you for sharing."
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}


-(void)facebookPostDidFail{
	
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alert"
                                                    message: @"This is already shared."
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
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
     RELEASE(tabbar);
    [super dealloc];
}


@end
