//
//  SettingDetailViewController.m
//  Clinics
//
//  Created by Ashish Awasthi on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingDetailViewController.h"
#import "FeedbackView.h"
#import "RootViewController.h"
#import "SettingListViewContoller.h"
#import "TableCellView.h"
#import "TableSectionView.h"

#import "AboutAppListViewController.h"

@implementation SettingDetailViewController

@synthesize homeEditorView;
@synthesize m_parentRootVC;

//*************** change view frame **********//

- (void) didRotate:(id )sender
{
	//NSLog(@"SettingMarkdidRotate");
	if ([CGlobal isOrientationLandscape]) {
		m_imgView.frame=CGRectMake(0, 0, 704, 44);
		m_Cancel.frame=CGRectMake(550.0, 7.0, 60.0,30.0);
		m_imgView.image=[UIImage imageNamed:@"704.png"];
		TableSectionView *sectionView = (TableSectionView *)[CGlobal getViewFromXib:@"TableSectionView" classname:[TableSectionView class] owner:self];
		sectionView.seletedBtn.frame=CGRectMake(590, 1,  116, 30);
	}else {
		m_imgView.frame=CGRectMake(0, 0, 768, 44);
		m_Cancel.frame=CGRectMake(600.0, 7.0, 60.0,30.0);
		m_imgView.image=[UIImage imageNamed:@"768.png"];
		TableSectionView *sectionView = (TableSectionView *)[CGlobal getViewFromXib:@"TableSectionView" classname:[TableSectionView class] owner:self];
		sectionView.seletedBtn.frame=CGRectMake(648, 1,  116, 30);
	}
    //******************* Add Clinic Detail View **********************//
    if ([CGlobal isOrientationLandscape])
        [self hidePopOverButton];
	
    else
        [self showPopOverButton];
    
    //************* Set table frame height ****************//
    
    CGRect rcFrame = m_tblClinics.frame;
    if ([CGlobal isOrientationLandscape])
    {
		m_btnDone.frame=CGRectMake(630.0, 7.0, 60.0,30.0);
        rcFrame.size.width = 705.0;
        rcFrame.size.height = 704.0;
		if (webview) {
            webview.frame=CGRectMake(20, 20, 984, 708);
			[webview orientationChanged:UIInterfaceOrientationLandscapeLeft]	;
		}
    }
    else
    {
		m_btnDone.frame=CGRectMake(690.0, 7.0, 60.0,30.0);
        rcFrame.size.width = 768.0;
        rcFrame.size.height = 958;
		if (webview) {
            webview.frame =CGRectMake(20, 20, 728, 964);
            [webview orientationChanged:UIInterfaceOrientationPortrait];
		}
        
    }
    [self changeSizeNavigationBarTitle];
    m_tblClinics.frame = rcFrame;
    [m_tblClinics reloadData];
	if (homeEditorView) {
        [homeEditorView changeOrientaionISHomeEditorView];
	}
    
    if (m_instructionView) {
        [m_instructionView changeOrientaionView];
    }
    [self dismissPopoover];
}

// ******************** load Category ****************************

- (void) loadData
{
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    DatabaseConnection *database = [DatabaseConnection sharedController];
    m_arrCategory = [[database loadCategoryData:FALSE] retain];
    [m_tblClinics reloadData];
	
	NSString  *instruction=[[NSUserDefaults standardUserDefaults] objectForKey:@"Instruction"];
	if (instruction == nil) {
        RootViewController  *rootview=(RootViewController *)appDelegate.m_rootViewController;
        m_instructionView = [[InstructionView alloc]initWithFrame:CGRectMake(0,0,768,1024 )];
        m_instructionView.delegate = self;
        [rootview.view addSubview:m_instructionView];
        
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

-(void)viewRemoveFromSuperView{
    [m_instructionView removeFromSuperview];
    RELEASE(m_instructionView);
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	return 	TRUE;
}

//***************** bounce View ********************************

-(void)showDescriptionView
{
	m_btnDone.userInteractionEnabled=FALSE;
	m_btnPopOver.userInteractionEnabled=FALSE;
	
	webview.transform = CGAffineTransformMakeScale(0.001, 0.001);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4/1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceFirstAnimationStopped)];
	webview.transform = CGAffineTransformMakeScale(1.1, 1.1);
	[UIView commitAnimations];
	
}
//********************** animation view  close ********************************

- (void)bounceFirstAnimationStopped {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceSecondAnimationStopped)];
	webview.transform = CGAffineTransformMakeScale(0.98, 0.98);
	[UIView commitAnimations];
    
    // ******************* load link On webView*************************
	[webview loadWeb];
}

- (void)bounceSecondAnimationStopped {
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	webview.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}


-(void)hideDescriptionView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.1];
	
	webview.transform = CGAffineTransformMakeScale(0.25, 0.25f);
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeSubViews)];
	[UIView commitAnimations];
	
    
}

-(void)removeSubViews
{
	
    if (webview)
    {
		m_btnPopOver.userInteractionEnabled=TRUE;
		m_btnDone.userInteractionEnabled=TRUE;
		webview.alpha=0.0;
        [webview removeFromSuperview];
        webview=nil;
		
    }
}

#pragma mark--
#pragma mark----Opening Web Page Methods------
-(void)pushToWebView:(id)sender
{
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([CGlobal isOrientationPortrait])
    {
        webview=[[ViewWebPageClinic alloc] initWithFrame:CGRectMake(20, 20, 728, 964)];
    }
    else
    {
        
		webview=[[ViewWebPageClinic alloc] initWithFrame:CGRectMake(20, 20, 984, 708)];
    }
	RootViewController  *rootview=(RootViewController *)appDelegate.m_rootViewController;
	ClinicDetailViewController  *clinicDetails=(ClinicDetailViewController *)appDelegate.clinicDetailsView;
	[clinicDetails dismissPopoover];
    [rootview.view  addSubview:webview];
    webview.backgroundColor=[UIColor darkTextColor];
    [webview.doneBtn addTarget:self action:@selector(hideDescriptionView) forControlEvents:UIControlEventTouchUpInside];
	webview.url=@"http://www.clinics.com";
    //***************** bounce View ********************************
    [self showDescriptionView];
	
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
    RELEASE(m_arrCategory);
    [self dismissPopoover];
    RELEASE (m_popoverController);
    
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
	m_btnLogin.hidden=TRUE;
	m_arrCategory=[[NSMutableArray alloc] init];
	if ([CGlobal isOrientationLandscape]) {
		m_btnPopOver.hidden=TRUE;
		m_Cancel.frame=CGRectMake(540.0, 7.0, 60.0,30.0);
		m_btnDone.frame=CGRectMake(630.0, 7.0, 60.0,30.0);
		m_imgView.frame=CGRectMake(0, 0, 704, 44);
		m_imgView.image=[UIImage imageNamed:@"704.png"];
	}else {
        m_btnPopOver.hidden=FALSE;
		m_Cancel.frame=CGRectMake(600.0, 7.0, 60.0,30.0);
		m_btnDone.frame=CGRectMake(690.0, 7.0, 60.0,30.0);
		m_imgView.frame=CGRectMake(0, 0, 768, 44);
		m_imgView.image=[UIImage imageNamed:@"768.png"];
	}
	
    // Do any additional setup after loading the view from its nib.
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.viewController=self;
	sectionIndex=0;
    if (m_popoverController != nil)
        [m_popoverController dismissPopoverAnimated:YES];
    
    [self changeSizeNavigationBarTitle];
    m_lblTitle.textAlignment=UITextAlignmentCenter;
	m_lblTitle.text =@"All";
    
    
    //************* Set table frame height ****************//
    CGRect rcFrame = m_tblClinics.frame;
    if ([CGlobal isOrientationLandscape])
    {
        rcFrame.size.width = 705.0;
        rcFrame.size.height = 704.0;
    }
    else
    {
        rcFrame.size.width = 768.0;
        rcFrame.size.height = 958;
    }
    
    m_tblClinics.frame = rcFrame;
    
    
	
    
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
	return YES;
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
    return 137.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (sectionIndex==0) {
		TableSectionView *sectionView = (TableSectionView *)[CGlobal getViewFromXib:@"TableSectionView" classname:[TableSectionView class] owner:self];
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
		
		TableSectionView *sectionView = (TableSectionView *)[CGlobal getViewFromXib:@"TableSectionView" classname:[TableSectionView class] owner:self];
		sectionView.issueButton.hidden=TRUE;
		sectionView.ariticleButton.hidden=TRUE;
		sectionView.seletedBtn.tag=section;
		CategoryDataHolder *categoryDataHolder = (CategoryDataHolder *)[m_arrCategory objectAtIndex:sectionIndex-1];
        [sectionView   changeSelectAllImage:categoryDataHolder.checked :categoryDataHolder.nCategoryID];
		[sectionView.seletedBtn addTarget:self action:@selector(ClickOnSeletedAllButton:) forControlEvents:UIControlEventTouchUpInside];
        sectionView.m_lblTitle.text = categoryDataHolder.sCategoryName;
		return sectionView;
	}
    
    [self changeSizeNavigationBarTitle];
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
    
    cell = (TableCellView *)[tableView dequeueReusableCellWithIdentifier:sIdentifier];
    
    if (cell == nil)
	{
        cell = (TableCellView *)[CGlobal getViewFromXib:@"TableCellView" classname:[TableCellView class] owner:self];
		
	}
    
	cell.m_btnCheck.tag = indexPath.row;
	ClinicsDataHolder *clinicDataHolder;
	if(sectionIndex==0){
		CategoryDataHolder *categoryDataHolder = (CategoryDataHolder *)[m_arrCategory objectAtIndex:indexPath.section];
		clinicDataHolder = (ClinicsDataHolder *) [categoryDataHolder.arrClinics objectAtIndex:indexPath.row];
		
		[cell setData:clinicDataHolder];
		
	}
	else {
		CategoryDataHolder *categoryDataHolder = (CategoryDataHolder *)[m_arrCategory objectAtIndex:sectionIndex-1];
		clinicDataHolder = (ClinicsDataHolder *) [categoryDataHolder.arrClinics objectAtIndex:indexPath.row];
		[cell setData:clinicDataHolder];
		
	}
	
	
    NSString  *imageName = [NSString stringWithFormat:@"%@",clinicDataHolder.sClinicImageName];
	cell.m_imgView.image=[UIImage imageNamed:imageName];
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	UIImage  *image=cell.m_btnCheck.currentBackgroundImage;
    if (image==[UIImage imageNamed:@"BtnCheckSelected.png"]) {
        appDelegate.CheckedClinic=101;
    }
	[cell.m_btnCheck addTarget:self action:@selector(clickOnCheckButton:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"Setting");
    return cell;
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
    
    if (image==[UIImage imageNamed:@"BtnCheckSelected.png"]) {
        [database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 1 where ClinicID = %d",ClinicID]];
        [cell1.m_btnCheck setBackgroundImage:[UIImage imageNamed:@"BtnCheckUnselected.png"] forState:UIControlStateNormal];
    }
    else {
        [database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 0 where ClinicID = %d",ClinicID]];
        [cell1.m_btnCheck  setBackgroundImage:[UIImage imageNamed:@"BtnCheckSelected.png"] forState:UIControlStateNormal];
        
    }
    
	
	
	NSInteger checked=[database retriveCategoryAllclinicSelected:[NSString stringWithFormat:@"Select checked  from tblClinic where CategoryID=%d",categoryDataHolder1.nCategoryID]];
	if(checked==0){ // **************All clinic this category are selected **************
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblcategory Set Checked=1 where CategoryID = %d",categoryDataHolder1.nCategoryID]];
		
		
	} else  { // NO  All clinic this category are selected
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
	
	if (image==[UIImage imageNamed:@"BtnCheckSelected.png"]) {
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 1 where ClinicID = %d",ClinicID]];
		[cell1.m_btnCheck setBackgroundImage:[UIImage imageNamed:@"BtnCheckUnselected.png"] forState:UIControlStateNormal];
	}
	else {
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 0 where ClinicID = %d",ClinicID]];
		[cell1.m_btnCheck  setBackgroundImage:[UIImage imageNamed:@"BtnCheckSelected.png"] forState:UIControlStateNormal];
		
	}
	
	
	
	NSInteger checked=[database retriveCategoryAllclinicSelected:[NSString stringWithFormat:@"Select checked  from tblClinic where CategoryID=%d",categoryDataHolder1.nCategoryID]];
	
	
	if(checked==0){ //************** All clinic this category are selected **************
		[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblcategory Set Checked=1 where CategoryID = %d",categoryDataHolder1.nCategoryID]];
		
		
	} else  { //************** NO  All clinic this category are selected **************
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

- (void) doneButtonPressed
{
    
	if ([CGlobal checkNetworkReachabilityWithAlert]) {
        ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.m_nCurrentTabTag = kTAB_CLINICS;
        appDelegate.h_TabBarPrevTag=kTAB_EXTRAS;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab Button Pressed" object:self];
	}
}

-(void)cancelButtonpress:(id)sender{
    
    
	DatabaseConnection *database = [DatabaseConnection sharedController];
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 1 "]];
    
	NSMutableDictionary   *dict=appDelegate.lastSelectedClinicList;
	NSArray   *arr=[dict allKeys];
	[database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 0 where ClinicID IN %@",arr]];
	appDelegate.m_nCurrentTabTag = kTAB_CLINICS;
	appDelegate.h_TabBarPrevTag=kTAB_EXTRAS;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Tab Button Pressed" object:self];
	
}

#pragma mark --
#pragma mark UIPooverController Functions

- (void) dismissPopoover
{
    
    
	if(m_popoverController != nil)
	{
		if([m_popoverController isPopoverVisible])
			[m_popoverController dismissPopoverAnimated:YES];
		RELEASE(m_popoverController);
	}
    
    
}

- (void) showPopOver
{
    [self dismissPopoover];
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	id  viewController;
	if (appDelegate.nextTag==1) {
        viewController = [[SettingListViewContoller alloc] initWithNibName:@"SettingListViewContoller" bundle:nil];
	}
	
    else if(appDelegate.nextTag==3) {
		viewController=[[AboutAppListViewController alloc] initWithNibName:@"AboutAppListViewController" bundle:nil];
	}
	m_popoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
	m_popoverController.delegate = self;
    [m_popoverController setPopoverContentSize:CGSizeMake(320.0, 768.0)];
    [m_popoverController presentPopoverFromRect:CGRectMake(-100.0, -740.0 , 320.0, 768.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
	[viewController release];
	viewController=nil;
	
}

-(void)selectClinicSection:(NSInteger )Section{
	sectionIndex=Section;
    [self changeSizeNavigationBarTitle];
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
    NSLog(@"btn.tag %d",btn.tag);
    
	DatabaseConnection *database = [DatabaseConnection sharedController];
	
    if (sectionIndex==0) {
        // **************Seleced All Clinic inCategory  Tab All**************
        CategoryDataHolder	*categoryDataHolder1 = (CategoryDataHolder *)[m_arrCategory objectAtIndex:btn.tag];
        if (categoryDataHolder1.checked==0){
            
            [database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 0 "]];
            [database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblcategory Set Checked=1 "]];
        }
        else {
            // **************Deselect all ClinicS  in Category tab All**************
            [database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Checked = 1"]];
            
            [database upadateCheckUnCheckArticle:[NSString stringWithFormat:@"update tblcategory Set Checked=0 "]];
        }
        
    }
	else {
		// **************Seleced All Clinic inCategory  Single section**************
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
			//************** DeSeleced All Clinic inCategory Single section**************
			
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

// *********************** change Top Label Size  when Rotate Divice ******************* 

-(void)changeSizeNavigationBarTitle{
    
    if ([CGlobal isOrientationLandscape]) 
        m_lblTitle.frame= CGRectMake(0, 0.0, 550, 44.0);
    else
        m_lblTitle.frame= CGRectMake(82, 0.0, 520, 44.0); 
    
}

@end
