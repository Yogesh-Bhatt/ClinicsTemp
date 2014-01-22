//
//  SettingListViewContaoller.m
//  Clinics
//
//  Created by Ashish Awasthi on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingListViewContoller.h"

#import "ClinicListViewController.h"
#import "ClinicsAppDelegate.h"


@implementation SettingListViewContoller
@synthesize m_tblCategory;
@synthesize m_tabBar;

- (void) loadData
{
	
    DatabaseConnection *database = [DatabaseConnection sharedController];
    m_arrCategory = [[database loadCategoryData:FALSE] retain];
    
		for (int i=0; i<[m_arrCategory count]; i++) {
            
			CategoryDataHolder *categoryDataHolder = (CategoryDataHolder *)[m_arrCategory objectAtIndex:i];

			[temp_Arr addObject:categoryDataHolder.sCategoryName];
            
	}
    
	[temp_Arr insertObject:@"All" atIndex:0];
    [m_tblCategory reloadData];
}

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
	
	if (temp_Arr) {
	RELEASE(temp_Arr);
	}
    RELEASE(m_arrCategoryImage);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	rowIndex=-1;
	
	UIImageView  *m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(-1, 0, 322, 44);
	m_imgView.image=[UIImage imageNamed:@"WelcomeUser.png"];
	[self.view addSubview:m_imgView];
	[m_imgView release];
    // Do any additional setup after loading the view from its nib.
	temp_Arr=[[NSMutableArray alloc] init];
    
    m_arrCategoryImage  = [[NSMutableArray alloc] initWithObjects:
						   @"1",
                           @"2",
                           @"3",
                           @"4",
                           @"5",
                           @"6",
                           @"7",
                           @"8",
                           @"9",
                           @"1",
						   @"2",
						   @"3",@"4",nil];
	
	UILabel *m_lblTitle=[[UILabel alloc] init];
	m_lblTitle.frame=CGRectMake(0, 0, 320, 44);
	m_lblTitle.backgroundColor=[UIColor clearColor];
	m_lblTitle.font = [UIFont boldSystemFontOfSize:20.0];
    m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentLeft;
	m_lblTitle.text =@" WELCOME USER";
	[self.view addSubview:m_lblTitle];
	[m_lblTitle release];
  
   CGRect rcframe =  m_tblCategory.frame;
  rcframe.origin.y = 44;
  m_tblCategory.frame = rcframe;
	
   [self loadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark
#pragma mark - <UITableView Delegate Methods>


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
    return [m_arrCategory count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d", indexPath.row];
;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	UILabel* label;
    if (cell == nil) 
    {
		
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		label = [[UILabel alloc] init];
		label.tag=101;
		[cell addSubview:label];
		[label release];
    }
	UILabel *labeltxt=(UILabel *)[cell viewWithTag:101];
	labeltxt.frame=CGRectMake(30, 0, 250, 51);
    labeltxt.text = [NSString stringWithFormat:@"%@",[temp_Arr objectAtIndex:indexPath.row]];
    labeltxt.backgroundColor=[UIColor clearColor];
	labeltxt.textColor=[UIColor blackColor];
	labeltxt.font=[UIFont systemFontOfSize:18];
	labeltxt.textAlignment=UITextAlignmentLeft;
	cell.selectionStyle=UITableViewCellSelectionStyleGray;
    UIImageView *imgView;

		NSString *imageName=[NSString stringWithFormat:@"%@.png",[m_arrCategoryImage objectAtIndex:indexPath.row]];
		imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
		
	
    cell.backgroundView = imgView;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	rowIndex=indexPath.row;
	 ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate.viewController selectClinicSection:indexPath.row];
    
}


@end
