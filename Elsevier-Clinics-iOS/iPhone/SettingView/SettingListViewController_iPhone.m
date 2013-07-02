//
//  SettingListViewController_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingListViewController_iPhone.h"
#import "SettingDetailsViewController_iPhone.h"
#import "DatabaseConnection.h"
#import "ClinicsAppDelegate.h"

@implementation SettingListViewController_iPhone


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    
	[self.navigationController.navigationBar setHidden:TRUE];
    
    [super viewDidLoad];
	UIImageView  *m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(0, 0, 320, 44);
	m_imgView.image=[UIImage imageNamed:@"iPhone_NavBar.png"];
	[self.view addSubview:m_imgView];
	[m_imgView release];
    
	m_clinicsNameArr = [[NSMutableArray alloc] init];
    
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
	m_lblTitle.font = [UIFont boldSystemFontOfSize:16.0];
    m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentCenter;
	m_lblTitle.text =@"WELCOME USER";
	[self.view addSubview:m_lblTitle];
	[m_lblTitle release];
	
	UIButton *saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
	saveButton.frame=CGRectMake(260, 10, 45, 25);
	[saveButton setBackgroundImage:[UIImage imageNamed:@"iPhone_Home_btn.png"] forState:UIControlStateNormal];
	[saveButton addTarget:self action:@selector(pressONHomeButton:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:saveButton];
	
	[self loadDataclinicsDataFromDataBase];
	
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self loadDataClinicFromServer];
}

- (void)loadDataClinicFromServer{
    
	DatabaseConnection *database = [DatabaseConnection sharedController];
    m_arrCategory = [[database loadCategoryData:FALSE] retain];
	
	
	NSString  *instruction=[[NSUserDefaults standardUserDefaults] objectForKey:@"Instruction"];
	if (instruction == nil) {
		
        m_instructionView = [[InstructionView_iPhone alloc]initWithFrame:CGRectMake(0,0,320,480 )];
        m_instructionView.delegate = self;
        
        [self.view addSubview:m_instructionView];
        
        if(IS_WIDESCREEN){
            
            CGRect rect = m_instructionView.frame;
            rect.size.height = rect.size.height + 150;
            m_instructionView.frame = rect;
            
        }
        
    }
    
}


-(void)tabOnOkButton:(id)sender{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    m_instructionView.alpha = 0.0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(viewRemoveFromSuperView)];
    [UIView commitAnimations];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if (alertView.tag==-5) {
		if (buttonIndex==0) {
			[[NSUserDefaults standardUserDefaults] setObject:@"True" forKey:@"Instruction"];
		}
		
	}
	
}


- (void)loadDataclinicsDataFromDataBase
{
    DatabaseConnection *database = [DatabaseConnection sharedController];
    m_arrCategory = [[database loadCategoryData:FALSE] retain];
	for (int i=0; i<[m_arrCategory count]; i++) {
		CategoryDataHolder *categoryDataHolder = (CategoryDataHolder *)[m_arrCategory objectAtIndex:i];
		
		[m_clinicsNameArr addObject:categoryDataHolder.sCategoryName];
	}
	[m_clinicsNameArr insertObject:@"All" atIndex:0];
    
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
    return [m_arrCategory count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d", indexPath.row];
	
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
	labeltxt.frame=CGRectMake(30, 0, 250, 40);
    labeltxt.text = [NSString stringWithFormat:@"%@",[m_clinicsNameArr objectAtIndex:indexPath.row]];
    labeltxt.backgroundColor=[UIColor clearColor];
	labeltxt.textColor=[UIColor blackColor];
	labeltxt.font=[UIFont systemFontOfSize:16];
	labeltxt.textAlignment=UITextAlignmentLeft;
	cell.selectionStyle=UITableViewCellSelectionStyleGray;
    UIImageView *imgView;
	
	
	NSString *imageName=[NSString stringWithFormat:@"%@.png",[m_arrCategoryImage objectAtIndex:indexPath.row]];
	imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    cell.backgroundView = imgView;
    RELEASE(imgView);
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	SettingDetailsViewController_iPhone   *settingDetail_iPhone=[[SettingDetailsViewController_iPhone alloc] initWithNibName:@"SettingDetailsViewController_iPhone" bundle:nil];
	[appDelegate.navigationController pushViewController:settingDetail_iPhone animated:YES ];
	[settingDetail_iPhone selectClinicSection:indexPath.row];
	[settingDetail_iPhone release];
    
}

-(void)pressONHomeButton:(id)sender
{
	DatabaseConnection *database = [DatabaseConnection sharedController];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 1 "]];
	
	NSMutableDictionary   *dict=appDelegate.lastSelectedClinicList;
	NSArray   *arr=[dict allKeys];
	[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 0 where ClinicID IN %@",arr]];
	appDelegate.m_nCurrentTabTag = kTAB_CLINICS;
	appDelegate.h_TabBarPrevTag=kTAB_EXTRAS;
	[appDelegate.rootView_iPhone  addViewController];
	
}

- (void)dealloc
{
    RELEASE(m_arrCategoryImage);
	RELEASE(m_clinicsNameArr);
	RELEASE(m_arrCategory);
    [super dealloc];
}


@end
