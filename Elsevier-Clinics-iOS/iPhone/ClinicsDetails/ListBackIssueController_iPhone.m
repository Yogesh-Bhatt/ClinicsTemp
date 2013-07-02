//
//  ListBackIssueController_iPhone.m
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "DatabaseConnection.h"
#import "ListBackIssueController_iPhone.h"

#import"ClinicsDetailsView_iPhone.h"
#import  "CGlobal.h" 
#import "IssueDataHolder.h"
#import "ClinicsAppDelegate.h"

@implementation ListBackIssueController_iPhone

@synthesize clinicsDataholder;
@synthesize clinicsListView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.listbackIssueView=self;
	[self setNavigationBaronView];

}


-(void)setNavigationBaronView{
	
	UIImageView  *m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(-1, 0, 322, 44);
	m_imgView.image=[UIImage imageNamed:@"iPhone_NavBar.png"];
	[self.view addSubview:m_imgView];
	[m_imgView release];
	
	UILabel *m_lblTitle=[[UILabel alloc] init];
	m_lblTitle.frame=CGRectMake(0, 0, 250, 44);
	m_lblTitle.backgroundColor=[UIColor clearColor];
	m_lblTitle.font = [UIFont boldSystemFontOfSize:16.0];
    m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentCenter;
	m_lblTitle.text=@"Back Issues";
	[self.view addSubview:m_lblTitle];
	[m_lblTitle release];
	
	
	self.view.backgroundColor=[UIColor clearColor];
	doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame=CGRectMake(260, 10, 45, 25);
	[doneButton setImage:[UIImage imageNamed:@"iPhone_Done_btn.png"] forState:UIControlStateNormal];
	[doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:doneButton];
	
}

// ******************************** Access Data From data Base  ********************************
-(void)loadDataInTableView:(NSInteger )clinicID{
	
	DatabaseConnection *database = [DatabaseConnection sharedController];
    //******** Load Article Data *************//
	if (backIssueArr) {
		[backIssueArr release];
		backIssueArr=nil;
	}
     backIssueArr = [[database backIssuesData:clinicID] retain]; 
    
    if ([backIssueArr count]>0) {
        [backIssueArr removeObjectAtIndex:0]; 
    }
	
}

//********************************** click On  Flip ThisView *******************

-(void)doneButtonPressed:(id)sender{
	
    [UIView setAnimationsEnabled:TRUE];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.8];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeViewRootView)];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:clinicsListView.view cache:YES];
	[UIView commitAnimations];
	backIssueTable.delegate=nil;
	backIssueTable.dataSource=nil;
	 [UIView setAnimationsEnabled:FALSE];
	
}


-(void)removeViewRootView{
	[self.view removeFromSuperview];
}

#pragma mark--
#pragma mark------- UITable View Delegate Methods----------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{	        
    return ([backIssueArr count]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 51;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //NSLog(@"create: %i", indexPath.row);
    static NSString *CellIdentifier = @"Cell";
	
	BackIssueCell_iPhone *cell = (BackIssueCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
	{
        cell = (BackIssueCell_iPhone *)[CGlobal getViewFromXib:@"BackIssueCell_iPhone" classname:[BackIssueCell_iPhone class] owner:self];
	}	
	cell.m_lblTitle.text=((IssueDataHolder *)[backIssueArr objectAtIndex:indexPath.row]).sIssueTitle;
    return cell;
}

//********************************** click On TableViewCell Flip ThisView *******************

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	[UIView setAnimationsEnabled:TRUE];
	ClinicsAppDelegate  *appDelegate=[UIApplication sharedApplication].delegate;

	ClinicsDetailsView_iPhone  *clinicsDetails=[[ClinicsDetailsView_iPhone alloc] initWithNibName:@"ClinicsDetailsView_iPhone"bundle:nil];
	NSString  *issuneID=	((IssueDataHolder *)[backIssueArr objectAtIndex:indexPath.row]).sIssueID;
	clinicsDetails.m_clinicDataHolder=clinicsDataholder;
	[appDelegate.navigationController pushViewController:clinicsDetails animated:YES];
	
	[clinicsDetails reloadBackIssueIndetaialsView:issuneID];
	[clinicsDetails release];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
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
	if (clinicsDataholder) {
		[clinicsDataholder release];
	}

}


@end
