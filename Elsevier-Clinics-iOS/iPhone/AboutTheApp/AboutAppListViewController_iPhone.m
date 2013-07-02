//
//  AboutAppListViewController_iPhone.m
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutAppListViewController_iPhone.h"
#import "RootViewController.h"
#import "HomeEditorView_iPhone.h"
#import "ClinicsAppDelegate.h"

@implementation AboutAppListViewController_iPhone

@synthesize shareTableView;


#pragma View Life Cyclic

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
	rowIndex=-1;
	tabbar.selectedItem =[tabbar.items objectAtIndex:0];
	
	sharedOptionArr=[[NSMutableArray alloc] initWithObjects:
					 @"About The Clinics",
					 @"Terms and Conditions",nil];

	shareTableView.frame =CGRectMake(0, 44, 320, 800);
	
	[ self setNavigationBaronView];
	
    [CGlobal setFrameWith:self.view];
}


-(void)setNavigationBaronView{
	
	UIImageView  *m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(0, 0, 320, 44);
	m_imgView.image=[UIImage imageNamed:@"iPhone_NavBar.png"];
	[self.view addSubview:m_imgView];
	[m_imgView release];
	
	
    UILabel    *	m_lblTitle=[[UILabel alloc] init];
	m_lblTitle.frame=CGRectMake(0, 0, 320, 44);
	m_lblTitle.backgroundColor=[UIColor clearColor];
	m_lblTitle.font = [UIFont boldSystemFontOfSize:16.0];
	m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentCenter;
	m_lblTitle.text =@"About Us";
     [self.view addSubview:m_lblTitle];
	[m_lblTitle release];
	
	
	UIButton *homeButton=[UIButton buttonWithType:UIButtonTypeCustom];
	homeButton.frame=CGRectMake(260, 8, 46, 27);
	[homeButton setBackgroundImage:[UIImage imageNamed:@"iPhone_Home_btn.png"] forState:UIControlStateNormal];
	[homeButton addTarget:self action:@selector(GoToHomeView:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:homeButton];
	
	
}
-(void)GoToHomeView:(id)sender{
    
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.m_nCurrentTabTag = kTAB_CLINICS;
	appDelegate.h_TabBarPrevTag=kTAB_AboutApp;
	[appDelegate.rootView_iPhone  addViewController];	

}

#pragma mark --
#pragma mark <UITableViewDelegate, UITableViewDataSource> methods

-(void)defaultSelectedAbouttheApp{
	tabbar.selectedItem =[tabbar.items objectAtIndex:0];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sharedOptionArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d", indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
		cell.textLabel.numberOfLines=2;
    }
      UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aboutTheApp.png"]];
 
    cell.textLabel.text = [sharedOptionArr objectAtIndex:indexPath.row];
    cell.backgroundView = imageView;
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
       
	RELEASE(imageView);
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	HomeEditorView_iPhone  *homeViewEditor=[[HomeEditorView_iPhone alloc] init];
	[appDelegate.navigationController pushViewController:homeViewEditor animated:YES];
	[homeViewEditor  ClickOnAboutOption:indexPath.row];
    rowIndex=indexPath.row;
	[homeViewEditor release];
	
}

- (void)dealloc {
    [super dealloc];
	RELEASE(sharedOptionArr);	
}

@end
