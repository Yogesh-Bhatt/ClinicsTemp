    //
//  AboutAppListViewController.m
//  Clinics
//
//  Created by Kiwitech LLC on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutAppListViewController.h"
#import "RootViewController.h"
#import "SharePopOverView.h"
#import "HomeEditorView.h"
#import "ClinicDetailViewController.h"
#import "ClinicsAppDelegate.h"


@implementation AboutAppListViewController
@synthesize shareTableView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.contentSizeForViewInPopover = CGSizeMake(320, 768);
	rowIndex=-1;
	tabbar.selectedItem =[tabbar.items objectAtIndex:0];
	UIImageView  *m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(-1, 0, 322, 44);
	m_imgView.image=[UIImage imageNamed:@"WelcomeUser.png"];
	[self.view addSubview:m_imgView];
	[m_imgView release];
    
	sharedOptionArr=[[NSMutableArray alloc] initWithObjects:
					 @"About The Clinics",
					 @"Terms and Conditions",nil];

	UILabel *m_lblTitle=[[UILabel alloc] init];
	m_lblTitle.frame=CGRectMake(0, 0, 320, 44);
	m_lblTitle.backgroundColor=[UIColor clearColor];
	m_lblTitle.font = [UIFont boldSystemFontOfSize:20.0];
    m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentLeft;
	m_lblTitle.text =@" About App";
	[self.view addSubview:m_lblTitle];
	[m_lblTitle release];
	shareTableView.frame =CGRectMake(0, 44, 320, 800);
	shareTableView.scrollEnabled = FALSE;

	
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
	HomeEditorView  *homeView=(HomeEditorView *)appDelegate.m_rootViewController.homeEditor; 
	
	rowIndex=indexPath.row;
	
	[homeView  ClickOnAboutOption:indexPath.row];

}

- (void)dealloc {
    [super dealloc];
	
	[sharedOptionArr release];
	sharedOptionArr=nil;
	
}


@end
