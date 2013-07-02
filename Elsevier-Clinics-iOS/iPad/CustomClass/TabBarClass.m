//
//  TabBarClass.m
//  Clinics
//
//  Created by Ashish Awasthi on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabBarClass.h"
#import "ClinicsAppDelegate.h"
#import "AboutAppListViewController.h"
#import "FeedbackView.h" 
#import "SettingListViewContoller.h"
#import "SettingDetailViewController.h"
#import "AboutAppListViewController.h"
#import "HomeEditorView.h"


@implementation TabBarClass

@synthesize     tabbar;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    [super viewDidLoad];
	
   
    
	tabbar=[[UITabBar alloc] init];
	tabbar.frame=CGRectMake(0, 725, 320, 44);
	tabbar.delegate=self;
  NSMutableArray	*itemArr=[[NSMutableArray alloc] init];
	UITabBarItem  *item1=[[UITabBarItem alloc] initWithTitle:@"About" image:[UIImage imageNamed:@"TabAboutUsUnselected.png"] tag:1];
	UITabBarItem  *item2=[[UITabBarItem alloc] initWithTitle:@"Feedback" image:[UIImage imageNamed:@"FeedbackUnselected.png"] tag:2];
	UITabBarItem  *item3=[[UITabBarItem alloc] initWithTitle:@"Share" image:[UIImage imageNamed:@"ShareUnselected.png"] tag:3];
	[itemArr addObject:item1];
	[itemArr addObject:item2];
	[itemArr addObject:item3];
	tabbar.items=itemArr ;
	[self.view addSubview:tabbar];
	
	
	RELEASE(item1);
    RELEASE(item2);
	RELEASE(item3);
	RELEASE(itemArr);
	
   
}

#pragma mark --
#pragma mark <UITabBar Delegate Methods>
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	SettingDetailViewController  *settingDetails=(SettingDetailViewController *)appDelegate.viewController;
	if (item.tag==2) {
		if(settingDetails.homeEditorView)
		[settingDetails.homeEditorView btnCloseClicked:nil];
		[self goToFeedBackView];
		appDelegate.nextTag=appDelegate.previousTag;
		
	
    }
	else  if(item.tag==3){
       
        ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
       
            [appDelegate.homeEditorView showSharePopOver];  
      
	 }

	
}

-(void)goToFeedBackView{
    
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	HomeEditorView  *homeEditor=(HomeEditorView *)appDelegate.m_rootViewController.homeEditor;
	[homeEditor dismissPopoover];
	[appDelegate.clinicDetailsView  dismissPopoover];
    [homeEditor showFeedbackView ];
	
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
	RELEASE(tabbar);
}


@end
