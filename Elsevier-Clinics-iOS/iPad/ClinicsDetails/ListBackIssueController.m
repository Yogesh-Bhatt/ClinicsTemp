    //
//  ListBackIssueController.m
//  Clinics
//
//  Created by Ashish Awasthi on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "DatabaseConnection.h"
#import "ListBackIssueController.h"

#import "ClinicDetailViewController.h"
#import  "CGlobal.h" 
#import "IssueDataHolder.h"
#import "ClinicsAppDelegate.h"


@implementation ListBackIssueController



- (void)viewDidLoad {
    [super viewDidLoad];
    
	m_btnLogin.hidden=TRUE;
	m_btnPopOver.hidden=TRUE;

	if ([CGlobal isOrientationLandscape]) {
		m_imgView.frame=CGRectMake(0, 0, 768, 44);
		m_imgView.image=[UIImage imageNamed:@"768.png"];
	}else {
		m_imgView.frame=CGRectMake(0, 0, 768, 44);
		m_imgView.image=[UIImage imageNamed:@"768.png"];
	}
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.listbackIssueView=self;
	m_lblTitle.text=@"Back Issues";
	self.view.backgroundColor=[UIColor clearColor];
	backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
	if ([CGlobal isOrientationLandscape]) {
	backbutton.frame=CGRectMake(640.0, 7.0, 50.0,30.0);
	}
    else {
	backbutton.frame=CGRectMake(700.0, 7.0, 50.0,30.0);
	
	}
	
	[backbutton setImage:[UIImage imageNamed:@"BtnDone.png"] forState:UIControlStateNormal];
	[backbutton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backbutton];
	
	
}

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
   
	m_lblTitle.textAlignment=UITextAlignmentCenter;
	
}

-(void)doneButtonPressed:(id)sender{

	ClinicsAppDelegate  *appDelegate=[UIApplication sharedApplication].delegate;
	appDelegate.listbackIssueView =nil;
	ClinicDetailViewController   *detailsView=(ClinicDetailViewController *)appDelegate.clinicDetailsView;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.8];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeViewRootView)];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:detailsView.view cache:YES];

	[UIView commitAnimations];
	backIssueTable.delegate=nil;
	backIssueTable.dataSource=nil;
	
	
}


-(void)removeViewRootView{
	[self.view removeFromSuperview];
}


-(void)changePositionDoneButton{
    
    @try{
	if ([CGlobal isOrientationLandscape]){ 
		if (m_btnPopOver) {
			m_btnPopOver.hidden=TRUE;
		}
		
		backbutton.frame=CGRectMake(640.0, 7.0, 50.0,30.0);
	}
    else {
		backbutton.frame=CGRectMake(700.0, 7.0, 50.0,30.0);
		if (m_btnPopOver) {
			m_btnPopOver.hidden=FALSE;
		}
	 }
    }@catch (NSException * e){
        //NSLog(@"Exception: %@", e);
    }
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
	return 70.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //NSLog(@"create: %i", indexPath.row);
    static NSString *CellIdentifier = @"Cell";
	
	BackIssueCell *cell = (BackIssueCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
	{
        cell = (BackIssueCell *)[CGlobal getViewFromXib:@"BackIssueCell" classname:[BackIssueCell class] owner:self];
	}	
	cell.m_lblTitle.text=((IssueDataHolder *)[backIssueArr objectAtIndex:indexPath.row]).sIssueTitle;
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
   
	
	ClinicsAppDelegate  *appDelegate=[UIApplication sharedApplication].delegate;
	ClinicDetailViewController   *detailsView=(ClinicDetailViewController *)appDelegate.clinicDetailsView;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.8];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeViewRootView)];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:detailsView.view cache:YES];
	[UIView commitAnimations];
	
	NSString  *issuneID=	((IssueDataHolder *)[backIssueArr objectAtIndex:indexPath.row]).sIssueID;
	[detailsView reloadBackIssueIndetaialsView:issuneID];

	
	
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
		
	
	
}


@end
