    //
//  TabBarHomeView_iPhone.m
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabBarHomeView_iPhone.h"




#import "ClinicListViewController.h"
#import "ClinicDetailViewController.h"

#import "SettingDetailViewController.h"
#import "LoginViewController.h"
#import "BookMarksDetailsViewController_iPad.h"
#import "BookMarkListViewController_iPad.h"

#import "AboutAppListViewController_iPhone.h"
#import "NotesListViewController_iPad.h"
#import "NotesDetailsViewController_iPad.h"
#import "RootViewController.h"

#import "ClinicsAppDelegate.h"


@implementation TabBarHomeView_iPhone
@synthesize m_parentRootVC;
@synthesize h_Tabbar;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }-
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	h_Tabbar=[[UITabBar alloc] init];
    if(IS_WIDESCREEN){
        h_Tabbar.frame=CGRectMake(0, 500, 320, 49);
    }else{
        h_Tabbar.frame=CGRectMake(0, 412, 320, 49);
    }
	
	h_Tabbar.delegate=self;
	NSMutableArray   *item=[[NSMutableArray alloc] init];
	UITabBarItem  *item1=[[UITabBarItem alloc] initWithTitle:@"Clinics" image:[UIImage imageNamed:@"iPhone_ClinicsUnselected.png"] tag:1];
	UITabBarItem  *item2=[[UITabBarItem alloc] initWithTitle:@"Bookmarks" image:[UIImage imageNamed:@"iPhone_BookmarksSelected.png"] tag:2];
	UITabBarItem  *item3=[[UITabBarItem alloc] initWithTitle:@"Notes" image:[UIImage imageNamed:@"iPhone_NotesUnselected.png"] tag:3];
	UITabBarItem  *item4=[[UITabBarItem alloc] initWithTitle:@"More" image:[UIImage imageNamed:@"iPhone_MoreUnselected.png"] tag:4];
	[item addObject:item1];
	[item addObject:item2];
	[item addObject:item3];
	[item addObject:item4];
	h_Tabbar.items=item ;
	[self.view addSubview:h_Tabbar];
    
	RELEASE(item);
	
	RELEASE(item1);
	RELEASE(item2);
	RELEASE(item3);
	RELEASE(item4);
	
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{    
	
	//  Add  Clinic List Tab Bar
	ClinicsAppDelegate  *appDelegate=[UIApplication sharedApplication].delegate;
	if (item.tag==1) {
		appDelegate.m_nCurrentTabTag = 1;
		RootViewController_iPhone   *rootView_iPhone=(RootViewController_iPhone *)appDelegate.rootView_iPhone;
		[rootView_iPhone addViewController]	;   
		appDelegate.h_TabBarPrevTag=kTAB_CLINICS;    
		
	}
	// add Book marks  list 
	
	else  if(item.tag==2){
		appDelegate.m_nCurrentTabTag = 2;
		[appDelegate.rootView_iPhone addViewController]	;  
		appDelegate.h_TabBarPrevTag=kTAB_BOOKMARKS;
	}	  
	
	
	
    // add Notes  list 
	
	else  if(item.tag==3){
		appDelegate.m_nCurrentTabTag = 3;
		[appDelegate.rootView_iPhone addViewController]	;
		appDelegate.h_TabBarPrevTag=kTAB_NOTES;
	}
	
	//  Add    Setting View
	else if (item.tag == 4)
	{
		appDelegate.m_nCurrentTabTag = 5;
		[appDelegate.rootView_iPhone addViewController];
		appDelegate.h_TabBarPrevTag=kTAB_AboutApp;
	}
	
	
	
    
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
	if (h_Tabbar) {
	RELEASE(h_Tabbar);
	}
    [super dealloc];
}


@end
