    //
//  TabBarClassHomeView.m
//  Clinics
//
//  Created by Ashish Awasthi on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabBarClassHomeView.h"

#import "ClinicListViewController.h"
#import "ClinicDetailViewController.h"
#import "SettingListViewContoller.h"
#import "SettingDetailViewController.h"
#import "LoginViewController.h"
#import "BookMarksDetailsViewController_iPad.h"
#import "BookMarkListViewController_iPad.h"

#import "AboutAppListViewController.h"
#import "NotesListViewController_iPad.h"
#import "NotesDetailsViewController_iPad.h"
#import "RootViewController.h"
#import "ClinicsAppDelegate.h"


@implementation TabBarClassHomeView
@synthesize m_parentRootVC;
@synthesize h_Tabbar;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    [super viewDidLoad];
	h_Tabbar=[[UITabBar alloc] init];
	h_Tabbar.frame=CGRectMake(0, 699, 320, 49);
	h_Tabbar.delegate=self;
	NSMutableArray   *itemArr=[[NSMutableArray alloc] init];
	UITabBarItem  *item1=[[UITabBarItem alloc] initWithTitle:@"Clinics" image:[UIImage imageNamed:@"TabClinicsUnselected.png"] tag:1];
	UITabBarItem  *item2=[[UITabBarItem alloc] initWithTitle:@"Bookmarks" image:[UIImage imageNamed:@"BookmarksUnselected.png"] tag:2];
	UITabBarItem  *item3=[[UITabBarItem alloc] initWithTitle:@"Notes" image:[UIImage imageNamed:@"notesunselected.png"] tag:3];
	UITabBarItem  *item4=[[UITabBarItem alloc] initWithTitle:@"More" image:[UIImage imageNamed:@"TabExtrasUnselected.png"] tag:4];
	[itemArr addObject:item1];
	[itemArr addObject:item2];
	[itemArr addObject:item3];
	[itemArr addObject:item4];
	h_Tabbar.items=itemArr ;
	[self.view addSubview:h_Tabbar];
	
	
	RELEASE(item1);
	RELEASE(item2);
	RELEASE(item3);
	RELEASE(item4);
	RELEASE(itemArr);
	
}


//#pragma mark --
//#pragma mark <UITabBar Delegate Methods>
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{    
	
	//  ***************Add  Clinic List Tab Bar***************
	ClinicsAppDelegate  *appDelegate=[UIApplication sharedApplication].delegate;
	  if (item.tag==1) {
		   appDelegate.m_nCurrentTabTag = 1;
		   if ([CGlobal isOrientationLandscape])  {
		  [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab Button Pressed" object:self];
	  }else {
		  ClinicListViewController  *clinicListView=[[ClinicListViewController alloc ] initWithNibName:@"ClinicListViewController" bundle:nil];
		  [self.navigationController pushViewController:clinicListView animated:YES];
          
		  clinicListView.m_scrollView.frame=CGRectMake(0, 45, 320, 600);
		  [clinicListView initClinicListView];
          
		  ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
		  RootViewController  *rootView=(RootViewController *)appDelegate.rootViewController;
		  [rootView removeClinicDetailsViewFromRootView:item.tag];
          RELEASE(clinicListView);
          
		  
	  }
	   appDelegate.h_TabBarPrevTag=kTAB_CLINICS;    
		  
	  }
     // ***************add Book marks  list ***************

      else  if(item.tag==2){
		appDelegate.m_nCurrentTabTag = 2;
	    if ([CGlobal isOrientationLandscape])  {
			
		[[NSNotificationCenter defaultCenter] postNotificationName:@"Tab Button Pressed" object:self];
	     }
		else {
		BookMarkListViewController_iPad  *bookmarkListView=[[BookMarkListViewController_iPad alloc ] initWithNibName:@"BookMarkListViewController_iPad" bundle:nil];
            [self.navigationController pushViewController:bookmarkListView animated:YES];

		bookmarkListView.m_scrollView.frame=CGRectMake(0, 45, 320, 600);
		[bookmarkListView initClinicListView];
		
		ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
		RootViewController  *rootView=(RootViewController *)appDelegate.rootViewController;
		[rootView removeClinicDetailsViewFromRootView:item.tag];
            
            RELEASE(bookmarkListView);

	    }
		appDelegate.h_TabBarPrevTag=kTAB_BOOKMARKS;
        }	  

         

    // ***************add Notes  list ***************

       else  if(item.tag==3){
		appDelegate.m_nCurrentTabTag = 3;
	  if ([CGlobal isOrientationLandscape])  {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"Tab Button Pressed" object:self];
	   
	  }else {
		NotesListViewController_iPad  *notesListView=[[NotesListViewController_iPad alloc ] initWithNibName:@"NotesListViewController_iPad" bundle:nil];
		[self.navigationController pushViewController:notesListView animated:YES];
		notesListView.m_scrollView.frame=CGRectMake(0, 45, 320, 600);	 
		[notesListView initClinicListView];
		ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
		RootViewController  *rootView=(RootViewController *)appDelegate.rootViewController;
		[rootView removeClinicDetailsViewFromRootView:item.tag];
          
          RELEASE(notesListView);
		
	    }
		appDelegate.h_TabBarPrevTag=kTAB_NOTES;
        }

	// *************** Add    Setting View***************
       else if (item.tag == 4)
       {
		 
		   appDelegate.m_nCurrentTabTag = 5;
        if ([CGlobal isOrientationLandscape]) 
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab Button Pressed" object:self];
        }
		else 
		{
			// ***************check last time selected clinic***************
			ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
			AboutAppListViewController  *settingListView=[[AboutAppListViewController alloc ] initWithNibName:@"AboutAppListViewController" bundle:nil];
			[self.navigationController pushViewController:settingListView animated:YES];
			settingListView=nil;
			RootViewController  *rootView=(RootViewController *)appDelegate.rootViewController;
	    	[rootView removeClinicDetailsViewFromRootView:5];
            RELEASE(settingListView);
			
		}
		   appDelegate.h_TabBarPrevTag=kTAB_AboutApp;
	   }
		
	   
  
    
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
	RELEASE(h_Tabbar);
    [super dealloc];
}


@end
