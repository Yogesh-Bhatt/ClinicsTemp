//
//  SettingDetailsViewController_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingDetailsViewController_iPhone.h"
#import "RootViewController_iPhone.h"
#import "LoadingHomeView_iPhone.h"
#import "ClinicsAppDelegate.h"

@implementation SettingDetailsViewController_iPhone


- (void)viewDidLoad {
    
    [super viewDidLoad];
	[self.navigationController.navigationBar setHidden:TRUE];
    [super viewDidLoad];
	
	UIImageView  *m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(0, 0, 320, 44);
	m_imgView.image=[UIImage imageNamed:@"iPhone_NavBar.png"];
	[self.view addSubview:m_imgView];
	[m_imgView release];


	m_lblTitle=[[UILabel alloc] init];
	m_lblTitle.frame=CGRectMake(60, 0,145, 44);
	m_lblTitle.backgroundColor=[UIColor clearColor];
	m_lblTitle.font = [UIFont boldSystemFontOfSize:16.0];
    m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentCenter;
	m_lblTitle.text =@" WELCOME USER";
	[self.view addSubview:m_lblTitle];
	
	
     backButton=[UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame=CGRectMake(10, 8, 50, 27);
	[backButton setBackgroundImage:[UIImage imageNamed:@"iPhone_Back_btn.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backToCategoryView:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:backButton];

	cancelbutton=[UIButton buttonWithType:UIButtonTypeCustom];
	cancelbutton.frame=CGRectMake(205, 10, 49, 25);
	[cancelbutton setBackgroundImage:[UIImage imageNamed:@"iPhone_Cancel_btn.png"] forState:UIControlStateNormal];
	[cancelbutton addTarget:self action:@selector(cancelButtonpress:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:cancelbutton];
	
	saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
	saveButton.frame=CGRectMake(265, 10, 45, 25);
	[saveButton setBackgroundImage:[UIImage imageNamed:@"iPhone_Save_btn.png"] forState:UIControlStateNormal];
	[saveButton addTarget:self action:@selector(pressONSaveButton:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:saveButton];
	
}

#pragma mark --
#pragma mark <UITableViewDelegate, UITableViewDataSource> methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (sectionIndex==0) {
		return[m_arrCategory count];
	}
	else {
		return 1;
	}

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{    
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{    
	if (sectionIndex==0) {
		TableSectionView_iPhone *sectionView = (TableSectionView_iPhone *)[CGlobal getViewFromXib:@"TableSectionView_iPhone" classname:[TableSectionView_iPhone class] owner:self];
		CategoryDataHolder *categoryDataHolder = (CategoryDataHolder *)[m_arrCategory objectAtIndex:section];
		sectionView.issueButton.hidden=TRUE;
		sectionView.seletedBtn.tag=section;
		sectionView.ariticleButton.hidden=TRUE;
		[sectionView   changeSelectAllImage:categoryDataHolder.checked :categoryDataHolder.nCategoryID];
		[sectionView.seletedBtn addTarget:self action:@selector(ClickOnSeletedAllButton:) forControlEvents:UIControlEventTouchUpInside];
		sectionView.m_lblTitle.text = categoryDataHolder.sCategoryName;    
		return sectionView;
	}
	else {
		
		TableSectionView_iPhone *sectionView = (TableSectionView_iPhone *)[CGlobal getViewFromXib:@"TableSectionView_iPhone" classname:[TableSectionView_iPhone class] owner:self];
		sectionView.issueButton.hidden=TRUE;
		sectionView.ariticleButton.hidden=TRUE;
		sectionView.seletedBtn.tag=section;
		CategoryDataHolder *categoryDataHolder = (CategoryDataHolder *)[m_arrCategory objectAtIndex:sectionIndex-1];
		[sectionView   changeSelectAllImage:categoryDataHolder.checked :categoryDataHolder.nCategoryID];
		[sectionView.seletedBtn addTarget:self action:@selector(ClickOnSeletedAllButton:) forControlEvents:UIControlEventTouchUpInside];
      
		sectionView.m_lblTitle.text = categoryDataHolder.sCategoryName;    
		return sectionView;
	}
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{	      CategoryDataHolder *categoryDataHolder  ;
	if (sectionIndex==0) {
		categoryDataHolder = (CategoryDataHolder *)[m_arrCategory objectAtIndex:section];
	}
	else {
		categoryDataHolder = (CategoryDataHolder *)[m_arrCategory objectAtIndex:sectionIndex-1];
	}
	
    return ([categoryDataHolder.arrClinics count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
    NSString *sIdentifier = [NSString stringWithFormat:@"CellIdentifier_%d",indexPath.row];
    
    m_tableCell = (TableCellView_iPhone *)[tableView dequeueReusableCellWithIdentifier:sIdentifier];
    
    if (m_tableCell == nil)
	{
        m_tableCell = (TableCellView_iPhone *)[CGlobal getViewFromXib:@"TableCellView_iPhone" classname:[TableCellView_iPhone class] owner:self];
		
	}	
    
	m_tableCell.m_btnCheck.tag = indexPath.row;
	ClinicsDataHolder *clinicDataHolder;
	if(sectionIndex==0){
		CategoryDataHolder *categoryDataHolder = (CategoryDataHolder *)[m_arrCategory objectAtIndex:indexPath.section];
		clinicDataHolder = (ClinicsDataHolder *) [categoryDataHolder.arrClinics objectAtIndex:indexPath.row];
		
		[m_tableCell setData:clinicDataHolder];
		
	}
	else {
		CategoryDataHolder *categoryDataHolder = (CategoryDataHolder *)[m_arrCategory objectAtIndex:sectionIndex-1];
		clinicDataHolder = (ClinicsDataHolder *) [categoryDataHolder.arrClinics objectAtIndex:indexPath.row];
		[m_tableCell setData:clinicDataHolder];
		
	}

	NSString  *imageName = [NSString stringWithFormat:@"%@",clinicDataHolder.sClinicImageName];
	m_tableCell.m_imgView.image=[UIImage imageNamed:imageName];
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	UIImage  *image=m_tableCell.m_btnCheck.currentBackgroundImage;
	if (image==[UIImage imageNamed:@"iPhone_RadioSelected.png"]) {
		appDelegate.CheckedClinic=101;
    }
	[m_tableCell.m_btnCheck addTarget:self action:@selector(clickOnCheckButton:) forControlEvents:UIControlEventTouchUpInside];
	
    return m_tableCell;	  
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	CategoryDataHolder *categoryDataHolder1;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (sectionIndex==0 ) {
		categoryDataHolder1 = (CategoryDataHolder *)[m_arrCategory objectAtIndex:indexPath.section];
	}else {
		categoryDataHolder1 = (CategoryDataHolder *)[m_arrCategory objectAtIndex:sectionIndex-1];
	}
	
	ClinicsDataHolder *clinicDataHolder1 = (ClinicsDataHolder *) [categoryDataHolder1.arrClinics objectAtIndex:indexPath.row];
	NSInteger ClinicID = clinicDataHolder1.nClinicID;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	
	TableCellView *	cell1=	(TableCellView *) [m_tblClinics cellForRowAtIndexPath:indexPath];
	
	UIImage *image = cell1.m_btnCheck.currentBackgroundImage;
	
	if (image==[UIImage imageNamed:@"iPhone_RadioSelected.png"]) {
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 1 where ClinicID = %d",ClinicID]];
		[cell1.m_btnCheck setBackgroundImage:[UIImage imageNamed:@"iPhone_RadioUnselected.png"] forState:UIControlStateNormal];
	}
	else {
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 0 where ClinicID = %d",ClinicID]];
		[cell1.m_btnCheck  setBackgroundImage:[UIImage imageNamed:@"iPhone_RadioSelected.png"] forState:UIControlStateNormal];
		
	}
	
	
	
	NSInteger checked=[database retriveCategoryAllclinicSelected:[NSString stringWithFormat:@"Select checked  from tblClinic where CategoryID=%d",categoryDataHolder1.nCategoryID]];
    
	if(checked == 0){ //************************* All clinic this category are selected *************************
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblcategory Set Checked=1 where CategoryID = %d",categoryDataHolder1.nCategoryID]];
		
		
	} else  { // ************************* NO  All clinic this category are selected *************************
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblcategory Set Checked=0 where CategoryID = %d",categoryDataHolder1.nCategoryID]];
	}
	[self CheckUpdate];
	[m_tblClinics reloadData];

}

-(void)clickOnCheckButton:(id)sender{
    
	UIButton  *Btn=(UIButton *)sender;
	UIView *view1 = (UIView*)[Btn superview];
	TableCellView *cell1 = (TableCellView*)[view1 superview];
	
	NSIndexPath *path = (NSIndexPath*)[m_tblClinics indexPathForCell:cell1];
	UIImage *image = cell1.m_btnCheck.currentBackgroundImage;

	CategoryDataHolder *categoryDataHolder1;
	
	if (sectionIndex==0) {
		categoryDataHolder1 = (CategoryDataHolder *)[m_arrCategory objectAtIndex:path.section];
		
	}else {
		
		categoryDataHolder1 = (CategoryDataHolder *)[m_arrCategory objectAtIndex:sectionIndex-1];
		
	}
	
    ClinicsDataHolder *clinicDataHolder1 = (ClinicsDataHolder *) [categoryDataHolder1.arrClinics objectAtIndex:Btn.tag];
	NSInteger ClinicID = clinicDataHolder1.nClinicID;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	
	if (image==[UIImage imageNamed:@"iPhone_RadioSelected.png"]) {
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 1 where ClinicID = %d",ClinicID]];
		[cell1.m_btnCheck setBackgroundImage:[UIImage imageNamed:@"iPhone_RadioUnselected.png"] forState:UIControlStateNormal];
	}
	else {
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 0 where ClinicID = %d",ClinicID]];
		[cell1.m_btnCheck  setBackgroundImage:[UIImage imageNamed:@"iPhone_RadioSelected.png"] forState:UIControlStateNormal];
		
	}

	NSInteger checked=[database retriveCategoryAllclinicSelected:[NSString stringWithFormat:@"Select checked  from tblClinic where CategoryID=%d",categoryDataHolder1.nCategoryID]];
	
	
	if(checked==0){ // ********************* All clinic this category are selected *********************
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblcategory Set Checked=1 where CategoryID = %d",categoryDataHolder1.nCategoryID]];
		
		
	} else  { // *********************NO  All clinic this category are selected *********************
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblcategory Set Checked=0 where CategoryID = %d",categoryDataHolder1.nCategoryID]];
	}
    
	[self CheckUpdate];
	[m_tblClinics reloadData];
	
	
}

-(void)CheckUpdate{
	if (m_arrCategory) {
		[m_arrCategory release];
		
	}
	DatabaseConnection *database = [DatabaseConnection sharedController];
    m_arrCategory = [[database loadCategoryData:FALSE] retain];
	
}

#pragma mark
#pragma mark - <UIbutton Pressed Methods>

-(void)pressONSaveButton:(id)sender
{
    if ([CGlobal checkNetworkReachabilityWithAlert]) {
		DatabaseConnection *database = [DatabaseConnection sharedController];
		NSInteger checked=[database selectCheckOrNot:[NSString stringWithFormat:@"Select checked  from tblClinic"]];
		ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
		if (checked==0) {
			DatabaseConnection *database = [DatabaseConnection sharedController];
			NSMutableArray  *arr=[database selectCheckedClinicArr];
			NSMutableDictionary   *dict=appDelegate.lastSelectedClinicList;
			BOOL flag=FALSE;
			for (int i=0; i<[arr count]; i++) {
				NSString  *str =[dict objectForKey:[arr objectAtIndex:i]];
				if (str == nil) {
					flag=TRUE;
				}
			}
			if (flag == TRUE) {
                [self saveYourSettingFollowedClinics];

			}
			else {
				// *************************Save  you after deselect your last Change.*************************
                
				if ([arr count]<[dict count]) {
                    [self callClinicsListViewController];

				}else {
					[self callClinicsListViewController];
				}

			}
		}
		else {
			
			UIAlertView   *alertView=[[UIAlertView  alloc] initWithTitle:@"" message:@"Please select at least one clinic."delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
			[alertView show];
			[alertView release];
			
			
		}
    }
}

-(void)saveYourSettingFollowedClinics{

    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
   /*
    for (NSString *file in [fm contentsOfDirectoryAtPath:documentsDirectory error:&error]) {
     
        if(!([file isEqualToString:@"Clinics_DB.sqlite"]) || !([file isEqualToString:@"NewClinics_DB.sqlite"])){
            BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory, file] error:&error];
            //NSLog(@"rohit removeItemAtPath456");
            if (!success || error) {
                //************************* it failed.*************************
            }
        }
        
    }		
    */
    backLodingview=[[UIView alloc] init];
    backLodingview.backgroundColor=[UIColor blackColor];
    backLodingview.alpha=0.60;
    [self.view addSubview:backLodingview];
    
    backLodingview.frame=CGRectMake(0, 0, 320,480);
    [LoadingHomeView_iPhone displayLoadingIndicator:backLodingview :UIInterfaceOrientationPortrait];
    [LoadingHomeView_iPhone chagengeMessageLoadingView:addClinics];
    
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(loadDataFromServer) userInfo:nil repeats:NO];

}

-(void)loadDataFromServer{
    
	[LoadingHomeView_iPhone removeLoadingIndicator];
	[backLodingview removeFromSuperview];
	[backLodingview release];
	backLodingview=nil;
	NSMutableDictionary *issuesDataDict = (NSMutableDictionary *)[[CGlobal jsonParsor] retain];
    
    if (issuesDataDict) {//*********************** Here We Check Dictonary have any value*******************
	[CGlobal loadIssueDataFromServer:issuesDataDict];  
	[self callClinicsListViewController];
    }
    RELEASE(issuesDataDict);
}

-(void)callClinicsListViewController{
    
    
	if ([CGlobal checkNetworkReachabilityWithAlert]) {
		ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
		appDelegate.m_nCurrentTabTag = kTAB_CLINICS;
		appDelegate.h_TabBarPrevTag=kTAB_EXTRAS;
		[self.navigationController popViewControllerAnimated:NO];
		[appDelegate.rootView_iPhone  addViewController];
		
	}
		
}

-(void)cancelButtonpress:(id)sender{
    
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
   DatabaseConnection *database = [DatabaseConnection sharedController];
    NSInteger checked=[database selectCheckOrNot:[NSString stringWithFormat:@"Select checked  from tblClinic"]];
    NSString *msgStr;
    
    if(checked == 0){
   
    NSMutableArray  *checkedClinicsArr=[database selectCheckedClinicArr];
    NSMutableDictionary   *selectedClinicsDict= appDelegate.lastSelectedClinicList;
    BOOL flag=FALSE;
    for (int i=0; i<[checkedClinicsArr count]; i++) {
        NSString  *str =[selectedClinicsDict objectForKey:[checkedClinicsArr objectAtIndex:i]];
        if (str == nil) {
            flag=TRUE;
        }
    }
    if (flag) {
        msgStr  = @"Save your Settings.";
    }else{
        
        ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
        [database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 1 "]];
        
        NSMutableDictionary   *selectedClinicsDict=appDelegate.lastSelectedClinicList;
        NSArray   *keysArr=[selectedClinicsDict allKeys];
        [database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 0 where ClinicID IN %@",keysArr]];
        appDelegate.m_nCurrentTabTag = kTAB_CLINICS;
        appDelegate.h_TabBarPrevTag=kTAB_EXTRAS;
        [self.navigationController popViewControllerAnimated:NO];
        [appDelegate.rootView_iPhone  addViewController];
        return ;
    }
    }
    

else{
    msgStr = @"Please select at least one Clinics title and save your settings." ;
}
    

    UIAlertView   *alertView=[[UIAlertView  alloc] initWithTitle:@"" message:msgStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
     [alertView show];
    RELEASE(alertView);

    
    
}


-(void)selectClinicSection:(NSInteger )Section{
    
	sectionIndex=Section;
	[self CheckUpdate];
	[m_tblClinics reloadData];
	if (sectionIndex==0) {
		m_lblTitle.text =@"All";
		
	}
	else {
		CategoryDataHolder *categoryDataHolder = (CategoryDataHolder *)[m_arrCategory objectAtIndex:sectionIndex-1];
		m_lblTitle.text =[NSString stringWithFormat:@"%@",categoryDataHolder.sCategoryName];
	}
	
	
}

-(void)ClickOnSeletedAllButton:(id)sender{
	
	UIButton   *btn=(UIButton *)sender;
	DatabaseConnection *database = [DatabaseConnection sharedController];
	
	
	if (sectionIndex==0) {
		//************************* Seleced All Clinic inCategory  Tab All*************************
		CategoryDataHolder	*categoryDataHolder1 = (CategoryDataHolder *)[m_arrCategory objectAtIndex:btn.tag];
		if (categoryDataHolder1.checked==0){
			
			[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 0 "]];
			[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblcategory Set Checked=1 "]];
		}
		else {
			// *************************Deselect all ClinicS  in Category tab All*************************
			[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 1"]];
			
			[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblcategory Set Checked=0 "]];
		}
		
	}
	else {
		//************************* Seleced All Clinic inCategory  Single section*************************
		CategoryDataHolder	*categoryDataHolder1 = (CategoryDataHolder *)[m_arrCategory objectAtIndex:sectionIndex-1];
		if (categoryDataHolder1.checked==0) {
			for (int i=0; i<[categoryDataHolder1.arrClinics count]; i++) {
				ClinicsDataHolder *clinicDataHolder1 = (ClinicsDataHolder *) [categoryDataHolder1.arrClinics objectAtIndex:i];
				NSInteger ClinicID = clinicDataHolder1.nClinicID;
				[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 0 where ClinicID = %d",ClinicID]];
				
		    }
			[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblcategory Set Checked=1 where CategoryID = %d",categoryDataHolder1.nCategoryID]];
		}
		else {
			// *************************DeSeleced All Clinic inCategory Single section*************************

			CategoryDataHolder	*categoryDataHolder1 = (CategoryDataHolder *)[m_arrCategory objectAtIndex:sectionIndex-1];
			for (int i=0; i<[categoryDataHolder1.arrClinics count]; i++) {
				ClinicsDataHolder *clinicDataHolder1 = (ClinicsDataHolder *) [categoryDataHolder1.arrClinics objectAtIndex:i];
				NSInteger ClinicID = clinicDataHolder1.nClinicID;
				[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 1 where ClinicID = %d",ClinicID]];
				
			}
			[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblcategory Set Checked=0 where CategoryID = %d",categoryDataHolder1.nCategoryID]];
		}
	}
	
	[self CheckUpdate];
	[m_tblClinics reloadData];
	
}

// ******************** back To last view *****************************

-(void)backToCategoryView:(id)sender{
    
	[self.navigationController popViewControllerAnimated:YES];
	
}


- (void)didReceiveMemoryWarning {
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    
    [super dealloc];
    RELEASE(m_lblTitle);
    if (m_arrCategory) {
    RELEASE(m_arrCategory);
	}

}


@end
