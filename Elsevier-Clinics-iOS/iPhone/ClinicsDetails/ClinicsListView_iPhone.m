//
//  ClinicsListView_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClinicsListView_iPhone.h"
#import "ClnicsTableCellView.h"
#import "ListBackIssueController_iPhone.h"
#import "SectionInfo.h"
#import "ClinicsDataHolder.h"
#import "IssueDataHolder.h"
#import "CategoryCustomBtn.h"
#import "RootViewController.h"
#import "RemberTableData.h"
#import "LoadingHomeView_iPhone.h"
#import "BookMarkListViewController_iPad.h"
#import <QuartzCore/QuartzCore.h>
#import "ClinicsAppDelegate.h"
@implementation ClinicsListView_iPhone
@synthesize m_scrollView;
@synthesize openSectionIndex;
@synthesize sectionInfoArray;
@synthesize isShowPopOverView;
@synthesize m_tblClinics;

@synthesize clinicsdetailsView;

// ********************* add category Buttton *************************

- (void) addButtons
{
    RELEASE(m_arrButtonCategory);
    m_arrButtonCategory = [[NSMutableArray alloc] init];
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.h_TabBarPrevTag=kTAB_CLINICS;
	appDelegate.firstCategoryID=-1;
	
	appDelegate.clinicsDetails=kTAB_CLINICS;
	
    RELEASE(m_arrCategoryImage);
    m_arrCategoryImage  = [[NSMutableArray alloc] initWithObjects:
                           @"TblCellCardiology",
                           @"TblCellEmergency1",
                           @"TblCellInternalMedicine",
                           @"TblCellOrthopedics",
                           @"TblCellPathology",
                           @"TblCellPrimary",
                           @"TblCellPsychiatry",
                           @"TblCellRadiologic",
                           @"TblCellSurgery",
                           @"TblCellEmergency1",
						   @"TblCellPrimary",@"TblCellEmergency1",nil];
    
    DatabaseConnection *database = [DatabaseConnection sharedController];
	
	//
	//*******************remove alll button*************************
	
	for (UIView  *View1 in [m_scrollView subviews]) {
		[View1 removeFromSuperview];
	}
	if ([m_arrCategory count]>0) {
		[m_arrCategory removeLastObject];
		m_arrCategory=nil;
	}
    m_arrCategory = [[database loadCategoryData:TRUE] retain];
    CGFloat yOffset = 0.0;
	BOOL storeFirstCategoryID=TRUE;
    for (int i=0; i <[m_arrCategory count]; i++)
    {
        CategoryDataHolder *categoryDataHolder = [m_arrCategory objectAtIndex:i];
        
         [[PersistenceDataStore sharedManager] setData:KNextLunchKey withKey:KFirstLunchSettingKey];
       

        CategoryCustomBtn *btnCategory = [[CategoryCustomBtn alloc] initWithFrame:CGRectMake(0.0, yOffset, 320.0, 51.0)];
        btnCategory.tag = i;
		btnCategory.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		[btnCategory setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
		btnCategory.titleLabel.frame=CGRectMake(0, 0, 230,44);
        btnCategory.titleLabel.textAlignment = UITextAlignmentLeft;
        [btnCategory.titleLabel setFont:[UIFont systemFontOfSize:18]];
		NSString  *imageName=[  NSString stringWithFormat:@"%@.png",[m_arrCategoryImage objectAtIndex:i]];
        [btnCategory setTitle:[NSString stringWithFormat:@"     %@", categoryDataHolder.sCategoryName] forState:UIControlStateNormal];
        [btnCategory setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
		[btnCategory setTitleColor:[UIColor colorWithRed:72/255 green:72/255 blue:72/255 alpha:1.0] forState:UIControlStateNormal];
        [btnCategory addTarget:self action:@selector(categoryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		if (categoryDataHolder.nCategoryID==8) {
			[btnCategory setTitle:[NSString stringWithFormat:@"     Orthopedics / Biomechanics / R..."] forState:UIControlStateNormal];
		}
        [m_scrollView addSubview:btnCategory];
        [m_arrButtonCategory addObject:btnCategory];
        [btnCategory release];  
        
        yOffset = yOffset + 51;
		if (storeFirstCategoryID==TRUE) {
			appDelegate.firstCategoryName=categoryDataHolder.sCategoryName;
			appDelegate.firstCategoryID=categoryDataHolder.nCategoryID;
			storeFirstCategoryID=FALSE;
		}
		
		
    }   
}


- (void)loadTableData:(CategoryDataHolder *)categoryDataHolder
{
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    DatabaseConnection *database = [DatabaseConnection sharedController];
	
	if ([m_arrClinics count]) {
		[m_arrClinics removeAllObjects];
		[m_arrClinics release];
		m_arrClinics=nil;
		if ([sectionInfoArray count]>0) {
			[sectionInfoArray removeAllObjects];
			[sectionInfoArray release];
			sectionInfoArray=nil;
		}
		
		
	}
    m_arrClinics = [[database SelectUnCheckedClinic:categoryDataHolder.nCategoryID] retain];  
    
    //// for making Section ////
    
    self.openSectionIndex = NSNotFound;
    
    if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:m_tblClinics]))
    {
        // For each Tap, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (int i=0; i< [m_arrClinics count]; i++) 
        {
            ClinicsDataHolder *clinicDataHolder =[m_arrClinics objectAtIndex:i] ;
			// first ClinicID
			ClinicsDataHolder *clinicDataHolder1 =[m_arrClinics objectAtIndex:0] ;
			appDelegate.firstClinicID = clinicDataHolder1.nClinicID;
			
			// first ClinicID
            SectionInfo *sectionInfo = [[SectionInfo alloc] init];		
            
            sectionInfo.issueArray = clinicDataHolder.arrIssue;
            sectionInfo.open = NO;
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:44.0];
            NSInteger countOfQuotations = [sectionInfo.issueArray  count];
			// removeIssue LastIssueID 
			
            for (NSInteger i = 0; i < countOfQuotations; i++) 
            {
                [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
				
            }
            
            [infoArray addObject:sectionInfo];
            [sectionInfo release];
		}
		
		self.sectionInfoArray = [infoArray retain];
		[infoArray release];
	}
    
    [m_tblClinics reloadData]; 
}

- (void)initClinicListView
{
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.secetionOpenOrClose=0;
    
	//Adding Buttons for Category
    [self addButtons];
	categoryID=-1;
	clinicsection=-1;
	loadtableViewFirstAfterSetting=TRUE;
	self.h_Tabbar.selectedItem = [self.h_Tabbar.items objectAtIndex:0];
	if ([m_arrButtonCategory count ]>0) {
		[self categoryButtonPressed:[m_arrButtonCategory objectAtIndex:0]];
	}
	
}

-(void)openlaststageIssuelevel{
    
    // ********************* add category Buttton *************************
	[self addButtons];
	
	loadtableViewFirstAfterSetting=TRUE;
	
	if ([m_arrButtonCategory count ]>0) {
		if (categoryID>=0)
			[self categoryButtonPressed:[m_arrButtonCategory objectAtIndex:categoryID]];
		ClnicsTableSectionView *sectionView = (ClnicsTableSectionView *)[CGlobal getViewFromXib:@"ClnicsTableSectionView" classname:[ClnicsTableSectionView class] owner:self]; 
		if (clinicsection>0) {
			[self sectionHeaderView:sectionView sectionOpened:clinicsection];
			
			
			ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
			appDelegate.secetionOpenOrClose=1; //section open
			
		}
	}
	
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
	

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark --
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    
	lastSelectedCell=nil;

	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
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
	m_lblTitle.text=@"Followed Clinics";
	[self.view addSubview:m_lblTitle];
	[m_lblTitle release];
	
	UIButton *addClinicsBtn =[UIButton buttonWithType:UIButtonTypeCustom];
	addClinicsBtn.frame=CGRectMake(240, 8, 63, 25);
	[addClinicsBtn setBackgroundImage:[UIImage imageNamed:@"iPhone_AddClinics_btn.png"] forState:UIControlStateNormal];
	[addClinicsBtn addTarget:self action:@selector(CliickonAddClinicButton:) forControlEvents:UIControlEventTouchUpInside];
	[self .view addSubview:addClinicsBtn];
    
    
    [CGlobal setFrameWith:self.view];
    
    if(IS_WIDESCREEN){
        
        m_scrollView.backgroundColor = [UIColor clearColor];
        CGRect rect =  m_scrollView.frame;
        rect.origin.y = 60;
        m_scrollView.frame = rect;
        
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark --
#pragma mark Table view data source and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView 
{        
    return [m_arrClinics count];
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section 
{
    SectionInfo *sectionInfoObj = (SectionInfo *)[self.sectionInfoArray objectAtIndex:section];
    NSInteger numStoriesInSection = [sectionInfoObj.issueArray count];
	return sectionInfoObj.open ? numStoriesInSection : 0;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section 
{
    /*  Create the section header views lazily.   */

    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	
    ClinicsSingletonManager *singletonObj=[ClinicsSingletonManager sharedManager];
    
    if (!sectionInfo.headerView) 
    {
        ClnicsTableSectionView *sectionView = (ClnicsTableSectionView *)[CGlobal getViewFromXib:@"ClnicsTableSectionView" classname:[ClnicsTableSectionView class] owner:self];
		
        sectionView.delegate = self;
        sectionView.section = section;
        //***** call function ******* 
        [sectionView initData];
        ClinicsDataHolder *clinicDataHolder = (ClinicsDataHolder *)[m_arrClinics objectAtIndex:section];
		sectionView.m_lblTitle.text = clinicDataHolder.sClinicTitle;
		
		//Checking for new issues related to Clinic
        
        NSInteger newIssuesCount= 0;
        
        for (NSDictionary *dict in singletonObj.m_arrLatestIssues)
        {
            if ([[dict valueForKey:KClinicsID] integerValue]==clinicDataHolder.nClinicID)
            {
                newIssuesCount++;
            }
        }
        
        //Create Button If new Issues exists
        if (newIssuesCount>0)
        {
            UIImage *img=[UIImage imageNamed:@"noti.png"];
            
            UIButton *issuesCountBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [issuesCountBtn setTitle:[NSString stringWithFormat:@"%d",newIssuesCount]
                            forState:UIControlStateNormal];
            
            [issuesCountBtn setBackgroundImage:img
                                      forState:UIControlStateNormal];
            
            issuesCountBtn.userInteractionEnabled= NO;
            
            issuesCountBtn.frame=CGRectMake(sectionView.m_lblTitle.frame.origin.x+sectionView.m_lblTitle.frame.size.width+20,
                                            sectionView.frame.size.height/2-img.size.height/2-5,
                                            img.size.width,
                                            img.size.height);
            
            [sectionView addSubview:issuesCountBtn];
            
        }
		
        sectionInfo.headerView = sectionView;
    }
    return sectionInfo.headerView;          
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath 
{    
    NSString *sIdentifier = [NSString stringWithFormat:@"CellIdentifier_%d",indexPath.row];
	
    ClnicsTableCellView *cell = (ClnicsTableCellView *)[tableView dequeueReusableCellWithIdentifier:sIdentifier];
	cell.selectionStyle=UITableViewCellSelectionStyleGray;
	
    if (cell == nil)
	{
        cell = (ClnicsTableCellView *)[CGlobal getViewFromXib:@"ClnicsTableCellView" classname:[ClnicsTableCellView class] owner:self];
	}	
    
    SectionInfo *sectionInfoObj = (SectionInfo *)[self.sectionInfoArray objectAtIndex:indexPath.section];
    IssueDataHolder *issueDataHolder; 
	if (indexPath.row == 1 && [sectionInfoObj.issueArray count]>0) {
		cell.m_lblTitle.text=@"Back Issues";
	}
	else{
		issueDataHolder= (IssueDataHolder *)[sectionInfoObj.issueArray objectAtIndex:indexPath.row];
		cell.m_lblTitle.text = issueDataHolder.sIssueTitle;

	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
    //**************** Condition chage button Article and ToC****************
	
	[[NSUserDefaults standardUserDefaults]setObject:@"101" forKey:@"Flag"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
    [UIView setAnimationsEnabled:TRUE];
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	ClinicsDetailsView_iPhone  *clinicDetailsView=[[ClinicsDetailsView_iPhone alloc] initWithNibName:@"ClinicsDetailsView_iPhone" bundle:nil];
	if (indexPath.row<1) {
		ClinicsDataHolder *clinicDataHolder = (ClinicsDataHolder *)[m_arrClinics objectAtIndex:indexPath.section];
		clinicDetailsView.m_clinicDataHolder = clinicDataHolder;
		SectionInfo *sectionInfoObj = (SectionInfo *)[self.sectionInfoArray objectAtIndex:indexPath.section];
		IssueDataHolder *issueDataHolder = (IssueDataHolder *)[sectionInfoObj.issueArray objectAtIndex:indexPath.row];
		
	
		clinicDetailsView.categoryName=catgeryName;
		clinicDetailsView.m_issueDataHolder = issueDataHolder;
		// ****************use for login Deatils****************
		appDelegate.seletedClinicID=issueDataHolder.nClinicID;
		[appDelegate.navigationController pushViewController:clinicDetailsView animated:YES];
		[clinicDetailsView loadDataFromServerISuuseData:TRUE];
		
				issueDataHolder = nil;
	}
	else {
		[self filpScrennShowBackIssue:indexPath.section];
	}
	clinicsdetailsView=clinicDetailsView;
	[clinicDetailsView release];

}

#pragma mark --
#pragma mark <ClnicsTableSectionView Delegate>

-(void)sectionHeaderView:(ClnicsTableSectionView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {

	
	[[NSUserDefaults standardUserDefaults]setObject:@"101" forKey:@"Flag"];
	clinicsection=sectionOpened;
	if (sectionOpened>=[sectionInfoArray count]) {
		sectionOpened=[sectionInfoArray count]-1;
	}
	
	
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	ClinicsDataHolder *clinicDataHolder = (ClinicsDataHolder *)[m_arrClinics objectAtIndex:sectionOpened];
	clinicID  = (NSInteger )clinicDataHolder.nClinicID;
	sectionInfo.open = YES;
    
    NSString *clinicsName = clinicDataHolder.sClinicTitle;
    
    [[GANTracker sharedTracker] startTrackerWithAccountID:GoogleAnalyticsID
                                           dispatchPeriod:10
                                                 delegate:nil];
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:clinicsName
                                        withError:&error]) {
    }
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */ 
    NSInteger countOfRowsToInsert = [sectionInfo.issueArray count];
    if (countOfRowsToInsert > 0)
    { [[NSUserDefaults  standardUserDefaults] setObject:@"1" forKey:@"SectionSeleted"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
        sectionHeaderView.m_imgView.image=[UIImage imageNamed:@"GastroenterologyBar-2.png"];
		
    }
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) 
    {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
	
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) 
    {
		SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        
        previousOpenSection.headerView.backgroundColor =[UIColor clearColor];
        previousOpenSection.headerView.m_imgView.image=[UIImage imageNamed:@"GastroenterologyBar-1.png"];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.issueArray count];
		
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) 
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
        
       
    }
	
	[self resheftCategoryBtnWithOffset:(countOfRowsToInsert*42)-([indexPathsToDelete count]*42) :FALSE];

    //**************** Style the animation so that there's a smooth flow in either direction.****************
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) 
    {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else 
    {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    //**************** Apply the updates.****************
    [m_tblClinics beginUpdates];
    [m_tblClinics insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [m_tblClinics deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [m_tblClinics endUpdates];
    self.openSectionIndex = sectionOpened;
    
    [indexPathsToInsert release];
    [indexPathsToDelete release];
    
    
    //Reset Badge if Clinics new Issues Visited
    
    ClinicsSingletonManager *singletonObj=[ClinicsSingletonManager sharedManager];
    
    NSMutableIndexSet *discardedClinicsIndexs = [NSMutableIndexSet indexSet];
    
    NSUInteger index = 0;
    
    for (NSDictionary *dict in singletonObj.m_arrLatestIssues)
    {
        if ([[dict valueForKey:KClinicsID] integerValue]==clinicDataHolder.nClinicID)
            [discardedClinicsIndexs addIndex:index];
        
        index++;
    }
    
    [singletonObj.m_arrLatestIssues removeObjectsAtIndexes:discardedClinicsIndexs];
    
    //Set App Icon Badge Number
    [singletonObj setAppBadgeNumberTo:singletonObj.m_arrLatestIssues.count];
    
    
    //Remove Notification button from Clinic Header Cell View
    for (id view in sectionInfo.headerView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
 
}


-(void)sectionHeaderView:(ClnicsTableSectionView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed 
{
	//  Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
	
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	sectionHeaderView.m_imgView.image=[UIImage imageNamed:@"GastroenterologyBar-1.png"];
    
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [m_tblClinics numberOfRowsInSection:sectionClosed];
    [self resheftCategoryBtnWithOffset:-countOfRowsToDelete*42 :FALSE];
	
    if (countOfRowsToDelete > 0) 
    {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) 
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [m_tblClinics deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        [indexPathsToDelete release];
    }
    self.openSectionIndex = NSNotFound;
    
}



#pragma mark --
#pragma mark <UIButoon Methods>CAllback

-(float) shiftButtonDown:(CategoryCustomBtn *)buttonSender
{

    float yOffset=m_tblClinics.frame.origin.y+m_tblClinics.frame.size.height;
    for (int index=buttonSender.tag+1;index<[m_arrCategory count] ; index++) {
        CategoryCustomBtn *btn=[m_arrButtonCategory objectAtIndex:index];
        btn.frame=CGRectMake(btn.frame.origin.x, yOffset, btn.frame.size.width, btn.frame.size.height);
        yOffset+=btn.frame.size.height;
    }
	
    return yOffset;
}

-(float) shiftButtonUp:(CategoryCustomBtn *)buttonSender
{
   
    
    float yOffset=buttonSender.frame.origin.y+buttonSender.frame.size.height;
    for (int index=buttonSender.tag+1;index<[m_arrCategory count] ; index++) {
		
        CategoryCustomBtn *btn=[m_arrButtonCategory objectAtIndex:index];
		btn.titleLabel.textColor=[UIColor blackColor];
        [self.view bringSubviewToFront:btn];
        btn.frame=CGRectMake(btn.frame.origin.x, yOffset, btn.frame.size.width, btn.frame.size.height);
        yOffset+=btn.frame.size.height;
    }
	
    return yOffset;    
}

-(void)removeTableView
{
    [m_tblClinics removeFromSuperview];
	
}
-(void)hidePreviousOpenTable:(CategoryCustomBtn*)openBtn
{
    [UIView beginAnimations:@"Menuscoller" context:nil];
    [UIView setAnimationDuration:0.5];
	
    float scrollercontentheight=[self shiftButtonUp:openBtn];
    m_tblClinics.frame=CGRectMake(m_tblClinics.frame.origin.x, m_tblClinics.frame.origin.y, m_tblClinics.frame.size.width, 0.0);
    m_scrollView.contentSize = CGSizeMake(320.0, scrollercontentheight); 
    [UIView commitAnimations];
    [openBtn setIsBtnOpen:FALSE];
	
}

// ************************ Open And  Hide Category ***********************
- (IBAction) categoryButtonPressed:(id)sender
{    
	
    CategoryCustomBtn *btn = (CategoryCustomBtn*)sender;
    catgeryName=btn.titleLabel.text;
	latButtontag=btn.tag;
	categoryID=btn.tag;
    CategoryDataHolder *categoryDataHolder = [m_arrCategory objectAtIndex:btn.tag];
    
    if ([categoryDataHolder.arrClinics count] >0)
    {
        if (btn.isBtnOpen==TRUE) 
        {  
			latButtontag=0;
			[self resetButtonImageFromCategory:btn.tag :FALSE];
            [self hidePreviousOpenTable:btn];
        }
		else
		{  
			[self resetButtonImageFromCategory:btn.tag :TRUE];
			if([m_tblClinics superview])
			{
				for (int index=0;index<[m_arrButtonCategory count] ; index++)
				{
					CategoryCustomBtn *tempBtn = [m_arrButtonCategory objectAtIndex:index];                
					if (tempBtn.isBtnOpen==TRUE) {
						
						
						float scrollercontentheight=[self shiftButtonUp:tempBtn];
						m_tblClinics.frame=CGRectMake(m_tblClinics.frame.origin.x, m_tblClinics.frame.origin.y, m_tblClinics.frame.size.width, 0.0);
						m_scrollView.contentSize = CGSizeMake(320.0, scrollercontentheight); 
						[tempBtn setIsBtnOpen:FALSE];                 
					}    
				}    
			}
			// loading Clinic data in table
            
			[self loadTableData:categoryDataHolder];
            m_tblClinics.frame=CGRectMake(m_tblClinics.frame.origin.x,btn.frame.origin.y + btn.frame.size.height, m_tblClinics.frame.size.width, 0.0);
			[UIView beginAnimations:@"Menuscoller" context:nil];
			[UIView setAnimationDuration:0.5];
			
			//****************Adding Clinics Table ****************
			CGRect tblFrame = m_tblClinics.frame;
			tblFrame.origin.y = btn.frame.origin.y + btn.frame.size.height;
			tblFrame.size.height=m_tblClinics.contentSize.height;
            m_tblClinics.frame = tblFrame;
			[m_scrollView addSubview:m_tblClinics];
			float scrollercontentheight= [self shiftButtonDown:sender];
			
			//****************Setting scrollView Frame****************
			m_scrollView.contentSize = CGSizeMake(320.0, scrollercontentheight); 
			[btn setIsBtnOpen:TRUE];
			[UIView commitAnimations];
		}
        //****************making space for new button view****************
    } 
	
	if(btn.isBtnOpen==TRUE) {
		if (latButtontag>=7) {
			CGPoint pt = m_scrollView.frame.origin ;
			pt.x = 0 ;
			pt.y+= 280;
			[m_scrollView setContentOffset:pt animated:YES];
		}
	}
	
}
-(void)resheftCategoryBtnWithOffset:(int)increasedHeight :(BOOL)flag
{
    float yOffset=m_scrollView.contentSize.height+increasedHeight;
    int index;
	CategoryCustomBtn *tempBtn ;
    for (index=0;index<[m_arrButtonCategory count] ; index++)
    {
		tempBtn = [m_arrButtonCategory objectAtIndex:index];                
        if (tempBtn.isBtnOpen==TRUE)
        {
            break;
            
        }    
    }    
    for (index++; index<[m_arrButtonCategory count]; index++) {
        CategoryCustomBtn *tempBtn = [m_arrButtonCategory objectAtIndex:index];                
        tempBtn.frame=CGRectMake(tempBtn.frame.origin.x, tempBtn.frame.origin.y+(float)increasedHeight, tempBtn.frame.size.width, tempBtn.frame.size.height);
        yOffset=tempBtn.frame.origin.y+tempBtn.frame.size.height;
    }
    m_tblClinics.frame=CGRectMake(m_tblClinics.frame.origin.x, m_tblClinics.frame.origin.y, m_tblClinics.frame.size.width, m_tblClinics.frame.size.height+increasedHeight);
    m_scrollView.contentSize = CGSizeMake(320.0, yOffset); 

	if(flag==TRUE) {
		if (latButtontag>=7) {
			CGPoint pt = m_scrollView.frame.origin ;
			pt.x = 0 ;
			pt.y+= 250;
			[m_scrollView setContentOffset:pt animated:YES];
		}
	}

}

-(void)resetButtonImageFromCategory:(NSInteger)sectedTag :(BOOL)flag{
	if (flag) {
		
		for (int i=0; i<[m_arrButtonCategory count]; i++) {
			CategoryCustomBtn   *btn=[m_arrButtonCategory objectAtIndex:i];	
			if (sectedTag==i) {
				NSString   *imageName=[NSString stringWithFormat:@"%@S.png",[m_arrCategoryImage objectAtIndex:i]];
				[btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
			}
			else {
				NSString   *imageName=[NSString stringWithFormat:@"%@.png",[m_arrCategoryImage objectAtIndex:i]];
				[btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
			}
			
			
		}	
	}
	else {
		for (int i=0; i<[m_arrButtonCategory count]; i++) {
			CategoryCustomBtn   *btn=[m_arrButtonCategory objectAtIndex:i];	
			NSString   *imageName=[NSString stringWithFormat:@"%@.png",[m_arrCategoryImage objectAtIndex:i]];
			[btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
		}
		
	}
	
	
}

-(void)filpScrennShowBackIssue:(NSInteger)IndexSection{

	
	ClinicsDataHolder *clinicDataHolder = (ClinicsDataHolder *)[m_arrClinics objectAtIndex:IndexSection];
	ListBackIssueController_iPhone  *listBackIssue;
	listBackIssue=[[ListBackIssueController_iPhone alloc] init];
	listBackIssue.clinicsDataholder=clinicDataHolder;
	listBackIssue.clinicsListView=self;
	[listBackIssue loadDataInTableView:clinicID];
	listBackIssue.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[self view] cache:YES];
	
	[self.view addSubview:listBackIssue.view];
	[UIView commitAnimations];
	[UIView setAnimationsEnabled:FALSE];
	[listBackIssue release];
	
	
	
}

-(void)CliickonAddClinicButton:(id)sender{
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate.rootView_iPhone  addSettingViewOnRootView];
}
@end
