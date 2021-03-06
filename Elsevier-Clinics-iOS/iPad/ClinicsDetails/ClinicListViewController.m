//
//  ClinicListViewController.m
//  Clinics
//
//  Created by Kiwitech on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClinicListViewController.h"
#import "ClnicsTableCellView.h"
#import "ClinicDetailViewController.h"
#import "SectionInfo.h"
#import "ClinicsDataHolder.h"
#import "IssueDataHolder.h"
#import "CategoryCustomBtn.h"
#import "RootViewController.h"
#import "RemberTableData.h"
#import "SettingListViewContoller.h"
#import "BookMarkListViewController_iPad.h"
#import <QuartzCore/QuartzCore.h>
#import "ClinicsAppDelegate.h"

@implementation ClinicListViewController
@synthesize m_scrollView;
@synthesize openSectionIndex;
@synthesize sectionInfoArray;
@synthesize isShowPopOverView;
@synthesize m_tblClinics;

// ********************* add category Buttton *************************

- (void) addButtons
{
    RELEASE(m_arrButtonCategory);
    m_arrButtonCategory = [[NSMutableArray alloc] init];
	self.h_Tabbar.selectedItem = [self.h_Tabbar.items objectAtIndex:0];
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
	//remove alll button
	 
	for (UIView  *View1 in [m_scrollView subviews]) {
		[View1 removeFromSuperview];
	}
	if (m_arrCategory) {
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
		if (categoryDataHolder.nCategoryID == 8) {
			[btnCategory setTitle:[NSString stringWithFormat:@"     Orthopedics / Biomechanics / R..."] forState:UIControlStateNormal];
		}
        [m_scrollView addSubview:btnCategory];
        [m_arrButtonCategory addObject:btnCategory];
        [btnCategory release];  
        
        yOffset = yOffset + 51;
		if (storeFirstCategoryID==TRUE) {
			appDelegate.firstCategoryName = categoryDataHolder.sCategoryName;
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
    
    	NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:m_tblClinics]))
    {
        // For each Tap, set up a corresponding SectionInfo object to contain the default height for each row.
	
		
		for (int i=0; i< [m_arrClinics count]; i++) 
        {
            ClinicsDataHolder *clinicDataHolder =[m_arrClinics objectAtIndex:i] ;
			// ***************first ClinicID***************
			 ClinicsDataHolder *clinicDataHolder1 =[m_arrClinics objectAtIndex:0] ;
			appDelegate.firstClinicID = clinicDataHolder1.nClinicID;
			
		// ***************first ClinicID***************
            SectionInfo *sectionInfo = [[SectionInfo alloc] init];		
            
            sectionInfo.issueArray = clinicDataHolder.arrIssue;
            sectionInfo.open = NO;
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:44.0];
            NSInteger countOfQuotations = [sectionInfo.issueArray  count];
			// ***************removeIssue LastIssueID ***************
			
            for (NSInteger i = 0; i < countOfQuotations; i++) 
            {
                [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
				
            }
            
            [infoArray addObject:sectionInfo];
            [sectionInfo release];
		}
		
		self.sectionInfoArray = [infoArray retain];
		
	}
    [infoArray release];
    [m_tblClinics reloadData];
    //[m_view toggleOpen:nil];
   // ClnicsTableSectionView *view = (ClnicsTableSectionView *)[m_tblClinics viewWithTag:0];
    
   // [view toggleOpen:nil];
    
    
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

	if ([m_arrButtonCategory count ]>0) {
        
        // ************************ Open And  Hide Category ***********************
         [self resetClinicState];
        
		[self categoryButtonPressed:[m_arrButtonCategory objectAtIndex:clinicBtnPressedTag]];
        
        /*
        if(([self.sectionInfoArray count]-1) >= clinicBtnPressedTag && clinicBtnPressedTag >= 0){
            
            SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:clinicBtnPressedTag];
            
            if (!sectionInfo.headerView)
            {
                
                ClnicsTableSectionView *view = sectionInfo.headerView;
                [view toggleOpen:nil];
                
                
            }
            
        }
         */
	}

}

-(void)openlaststageIssuelevel{
    
	
	loadtableViewFirstAfterSetting = TRUE;
	
	if ([m_arrButtonCategory count ]>0) {

            [self ShowSelectedRowInTableView:0 :0];
		}
	
	
}

-(void)setFrameM_ScrollView{
    
	self.m_scrollView.frame=CGRectMake(0, 45, 320, 580);
	
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
	
	
    RELEASE(m_arrCategoryImage);
    RELEASE(m_arrButtonCategory);
    RELEASE(m_arrClinics);
    RELEASE(sectionInfoArray);
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
	
    // Do any additional setup after loading the view from its nib.
    self.contentSizeForViewInPopover = CGSizeMake(320, 768);
	lastSelectedCell=nil;

	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
	UIImageView  *m_imgView=[[UIImageView alloc] init];
	m_imgView.frame=CGRectMake(-1, 0, 322, 44);
	m_imgView.image=[UIImage imageNamed:@"WelcomeUser.png"];
	[self.view addSubview:m_imgView];
	[m_imgView release];
	
	UILabel *m_lblTitle=[[UILabel alloc] init];
	m_lblTitle.frame=CGRectMake(0, 0, 320, 44);
	m_lblTitle.backgroundColor=[UIColor clearColor];
	m_lblTitle.font = [UIFont boldSystemFontOfSize:20.0];
    m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
	m_lblTitle.textAlignment=UITextAlignmentLeft;
	m_lblTitle.text=@" Followed Clinics";
	[self.view addSubview:m_lblTitle];
	[m_lblTitle release];
	if ([CGlobal isOrientationPortrait]) {
		  h_Tabbar.frame=CGRectMake(0, 719, 320, 49);
	}
 
	
    if (self.isShowPopOverView == YES)
   {
        //***************setting table Frame***************
        CGRect rcframe =  m_tblClinics.frame;
        rcframe.size.height = (self.view.frame.size.height - 72.0);
        m_tblClinics.frame = rcframe;
    }
    
    
    
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"Login" action:@"clinics.com" label:nil value:-1 withError:&error]) {
        NSLog(@"error");
    }
    if(error){
        NSLog(@"%@",[error description]);
    }
    
    //clinicBtnPressedTag = 0;
    
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
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	
    ClinicsSingletonManager *singletonObj=[ClinicsSingletonManager sharedManager];
    
    if (!sectionInfo.headerView) 
    {
        ClnicsTableSectionView *sectionView = (ClnicsTableSectionView *)[CGlobal getViewFromXib:@"ClnicsTableSectionView" classname:[ClnicsTableSectionView class] owner:self];
		
        //sectionView.tag = section;
        
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
            UIImage *img=[UIImage imageNamed:@"img_notifications_new.png"];
            
            UIButton *issuesCountBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            
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
        
       if(section == clinicSectionBtnPressed){
           
           // [sectionInfo.headerView toggleOpen:nil];
           m_view = sectionView;
          [self performSelector:@selector(refresh:) withObject:sectionView afterDelay:1.1];
    }
    
    }
    return sectionInfo.headerView;          
}

-(void)refresh:(ClnicsTableSectionView *)a_view{
    
    [a_view toggleOpen:nil];
    
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath 
{    
    NSString *sIdentifier = [NSString stringWithFormat:@"CellIdentifier_%d",indexPath.row];
	
    ClnicsTableCellView *cell = (ClnicsTableCellView *)[tableView dequeueReusableCellWithIdentifier:sIdentifier];
	
    if (cell == nil)
	{
        cell = (ClnicsTableCellView *)[CGlobal getViewFromXib:@"ClnicsTableCellView" classname:[ClnicsTableCellView class] owner:self];
	}	
    
    SectionInfo *sectionInfoObj = (SectionInfo *)[self.sectionInfoArray objectAtIndex:indexPath.section];
    IssueDataHolder *issueDataHolder; 
	  if (indexPath.row==1 && [sectionInfoObj.issueArray count]>0) {
		  cell.m_lblTitle.text=@"Back Issues";
	    }
	  else{
		  issueDataHolder= (IssueDataHolder *)[sectionInfoObj.issueArray objectAtIndex:indexPath.row];
		  cell.m_lblTitle.text = issueDataHolder.sIssueTitle;
          //NSLog(@"%@", issueDataHolder.sIssueTitle);
          cell.backImage.image=[UIImage imageNamed:@"thirdlevelunselected.png"] ;
	   }
   
	
    NSInteger  selectedRow=((RemberTableData *)[remberArr objectAtIndex:0]).rowIndex;
	
	if (loadtableViewFirstAfterSetting==TRUE) {
		if (indexPath.row==selectedRow-1) {
			[self ShowSelectedRowInTableView:indexPath.row :indexPath.section];
			cell.backImage.image=[UIImage imageNamed:@"thirdlevelselected.png"] ;
			lastSelectedCell=cell;
			loadtableViewFirstAfterSetting=FALSE;
		}
		else {
			if (selectedRow<=isOne) {
		
			if (indexPath.row==0) {
				[self ShowSelectedRowInTableView:indexPath.row :indexPath.section];
				cell.backImage.image=[UIImage imageNamed:@"thirdlevelselected.png"] ;
				lastSelectedCell=cell;
			}
			}
		}

	}

  if (indexPath.row==[sectionInfoObj.issueArray count]-1) {
	  cell.backImage.image=[UIImage imageNamed:@"thirdlevelunselectedBack.png"] ;
  }
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	// ***************Condition chage button Article and ToC***************
	
	[[NSUserDefaults standardUserDefaults]setObject:@"101" forKey:@"Flag"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	//************
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	
	if(lastSelectedCell!=nil){
		lastSelectedCell.backImage.image=[UIImage imageNamed:@"thirdlevelunselected.png"] ;
	} 
	ClnicsTableCellView   *nextcell=(ClnicsTableCellView *)[tableView cellForRowAtIndexPath:indexPath];
	if (indexPath.row==1) 
	nextcell.backImage.image=[UIImage imageNamed:@"thirdlevelselectedBack.png"] ;
	else 
    nextcell.backImage.image=[UIImage imageNamed:@"thirdlevelselected.png"] ;
	lastSelectedCell=nextcell;
	
	BOOL  flag=FALSE;
	if (indexPath.row<1) {
		if (appDelegate.listbackIssueView) {
			flag=TRUE;
			[appDelegate.listbackIssueView  doneButtonPressed:nil];
		}
		ClinicsDataHolder *clinicDataHolder = (ClinicsDataHolder *)[m_arrClinics objectAtIndex:indexPath.section];
		appDelegate.m_rootViewController.m_clinicDetailVC.m_clinicDataHolder = clinicDataHolder;
		SectionInfo *sectionInfoObj = (SectionInfo *)[self.sectionInfoArray objectAtIndex:indexPath.section];
	  IssueDataHolder *issueDataHolder = (IssueDataHolder *)[sectionInfoObj.issueArray objectAtIndex:indexPath.row];
	
	 ClinicDetailViewController  *clinicDetailsView=(ClinicDetailViewController *)appDelegate.m_rootViewController.m_clinicDetailVC;
	 clinicDetailsView.categoryName=catgeryName;
     appDelegate.m_rootViewController.m_clinicDetailVC.m_issueDataHolder = issueDataHolder;
		//*************** use for login Deatils***************
		appDelegate.seletedClinicID = issueDataHolder.nClinicID;
		appDelegate.seletedIssuneID = issueDataHolder.sIssueID;
    
		if (flag) {
			[appDelegate.m_rootViewController.m_clinicDetailVC loadDataFromServerISuuseData:TRUE];
		}
		issueDataHolder = nil;
	}
	else {
        // ***************************  dwonload back issue and Flip ******************
		[self downlaodBackIssueFromServer];
	}
}

- (IBAction)viewDownloadedArticles:(id)sender{
    
     ClinicsAppDelegate *appDelegate = (ClinicsAppDelegate *)[[UIApplication sharedApplication] delegate];
    
     [appDelegate.m_rootViewController.m_clinicDetailVC loadLatestDownloadedArticles];
    
    
}

-(void)ShowSelectedRowInTableView:(NSInteger)SelecedRow :(NSInteger)SeletedIndex{
    
    ClinicsAppDelegate *appDelegate = (ClinicsAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    if (SelecedRow<1) {
	if (SeletedIndex>=[m_arrClinics count]) {
		SeletedIndex=[m_arrClinics count]-1;
	}
	
    ClinicsDataHolder *clinicDataHolder = (ClinicsDataHolder *)[m_arrClinics objectAtIndex:SeletedIndex];
   
    appDelegate.m_rootViewController.m_clinicDetailVC.m_clinicDataHolder = clinicDataHolder;
     
    SectionInfo *sectionInfoObj = (SectionInfo *)[self.sectionInfoArray objectAtIndex:SeletedIndex];
	IssueDataHolder *issueDataHolder ;
	if(SelecedRow <[sectionInfoObj.issueArray count]){
		if ([m_arrCategory count]>0) {
		issueDataHolder = (IssueDataHolder *)[sectionInfoObj.issueArray objectAtIndex:SelecedRow];
		appDelegate.m_rootViewController.m_clinicDetailVC.m_issueDataHolder = issueDataHolder;
		ClinicDetailViewController  *clinicD=(ClinicDetailViewController *)appDelegate.m_rootViewController.m_clinicDetailVC;
			
			// ***************use for login Deatils***************
		  appDelegate.seletedClinicID=issueDataHolder.nClinicID;
        appDelegate.seletedIssuneID = issueDataHolder.sIssueID;
            
		clinicD.categoryName=catgeryName;
			// ***************filepage***************
			if (appDelegate.listbackIssueView) {
				[appDelegate.listbackIssueView  doneButtonPressed:nil];
			}
		[appDelegate.m_rootViewController.m_clinicDetailVC loadDataFromServerISuuseData:TRUE];
				
		}
		
	}
    }

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
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
   
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) 
    {
		SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        
        previousOpenSection.headerView.backgroundColor =[UIColor clearColor];
        
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.issueArray count];
		
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) 
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
        

    }
  
	[self resheftCategoryBtnWithOffset:(countOfRowsToInsert*42)-([indexPathsToDelete count]*42) :TRUE];
	

    // ***************Style the animation so that there's a smooth flow in either direction.
    
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
    
    // ***************Apply the updates.***************
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
    
    //NSLog(@"%f close", m_tblClinics.contentSize.height);
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


-(void)resetClinicState{
    
    if(([m_arrCategory count]-1) < clinicBtnPressedTag || clinicBtnPressedTag < 0){
        
        clinicBtnPressedTag = 0;
        clinicSectionBtnPressed = 0;
        
        
    }
    
    
//    NSLog(@"clinicBtnPressedTag === %d",clinicBtnPressedTag);
//    for(UIView *view in m_scrollView.subviews){
//        
//        if([view isKindOfClass:[CategoryCustomBtn class]] && view.tag == clinicBtnPressedTag ){
//            
//            NSLog(@"clinicBtnPressedTag === %d",clinicBtnPressedTag);
//            CategoryCustomBtn *btn = (CategoryCustomBtn *)view;
//            [self categoryButtonPressed:btn.tag];
//            break;
//        }
//    }
    
}

// ************************ Open And  Hide Category ***********************

- (IBAction) categoryButtonPressed:(id)sender
{    
	
    CategoryCustomBtn *btn = (CategoryCustomBtn*)sender;
    catgeryName=btn.titleLabel.text;
	latButtontag=btn.tag;
	categoryID=btn.tag;
    
    if(clinicBtnPressedTag == btn.tag){
        
    }else{
        
        clinicSectionBtnPressed = 0;
        
    }
    clinicBtnPressedTag =  btn.tag;
    
    
    
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
           // ***************loading Clinic data in table***************
           
           [self loadTableData:categoryDataHolder];
            m_tblClinics.frame=CGRectMake(m_tblClinics.frame.origin.x,btn.frame.origin.y + btn.frame.size.height, m_tblClinics.frame.size.width, 0.0);
           [UIView beginAnimations:@"Menuscoller" context:nil];
           [UIView setAnimationDuration:0.5];

           //***************Adding Clinics Table ***************
           
           CGRect tblFrame = m_tblClinics.frame;
           tblFrame.origin.y = btn.frame.origin.y + btn.frame.size.height;
           tblFrame.size.height = m_tblClinics.contentSize.height;
            m_tblClinics.frame = tblFrame;
           [m_scrollView addSubview:m_tblClinics];
           
           float scrollercontentheight= [self shiftButtonDown:sender];

           //***************Setting scrollView Frame***************
           
           m_scrollView.contentSize = CGSizeMake(320.0, scrollercontentheight); 
           [btn setIsBtnOpen:TRUE];
           [UIView commitAnimations];
       }
        //***************making space for new button view***************
    } 
	
	[self openlaststageIssuelevel];
    
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
	
	// ***************commit m_scrollView Hieght***************
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
// ***************************  dwonload back issue and Flip ******************

-(void)downlaodBackIssueFromServer{

	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate.m_rootViewController.m_clinicDetailVC  filpScrennShowBackIssue:clinicID];
	
}

@end
