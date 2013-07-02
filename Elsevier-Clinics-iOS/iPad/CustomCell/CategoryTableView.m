//
//  CategoryTableView.m
//  Clinics
//
//  Created by Kiwitech on 03/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryTableView.h"
#import "CategoryInfo.h"
#import "SectionInfo.h"
#import "ClnicsTableCellView.h"

#import "ClinicsAppDelegate.h"

@implementation CategoryTableView

@synthesize openSectionIndex;
@synthesize sectionInfoArray;
@synthesize m_bOPEN;

- (void) initData:(CategoryInfo *)categoryInfoObj
{
    m_bOPEN = NO;
    
    [arrClinic removeAllObjects];
    arrClinic = [categoryInfoObj.clinicArray retain];
    
    CGRect rcFrame = self.frame;
    rcFrame.size.height = [arrClinic count] * 44.0 ;
    self.frame = rcFrame;
   

    //******************************// for making Section //*******************//
    
    self.openSectionIndex = NSNotFound;
       NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self]))
    {
        // For each Tap, set up a corresponding SectionInfo object to contain the default height for each row.
     
        
        for (int i=0; i< [categoryInfoObj.clinicArray count]; i++) 
        {
            SectionInfo *sectionInfo = [[SectionInfo alloc] init];		
            
            ClinicsDataHolder *clinicDataHolder =[categoryInfoObj.clinicArray objectAtIndex:i] ;
            sectionInfo.issueArray = clinicDataHolder.arrIssue;
            sectionInfo.open = NO;
            
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:44.0];
            NSInteger countOfQuotations = [sectionInfo.issueArray  count];
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
    //******************************//*******************//
    self.dataSource = self;
    self.delegate = self;
    [self reloadData];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    RELEASE(sectionInfoArray);

    [super dealloc];
}

#pragma mark --
#pragma mark Table view data source and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView 
{         
    return [arrClinic  count];
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
    if (!sectionInfo.headerView) 
    {
        ClnicsTableSectionView *sectionView = (ClnicsTableSectionView *)[CGlobal getViewFromXib:@"ClnicsTableSectionView" classname:[ClnicsTableSectionView class] owner:self];
        
        sectionView.delegate = self;
        sectionView.section = section;
        
        //***** call function ******* 
        [sectionView initData];
        
        ClinicsDataHolder *clinicDataHolder = (ClinicsDataHolder *)[arrClinic objectAtIndex:section];
        
        sectionView.m_lblTitle.text = clinicDataHolder.sClinicTitle;
        //[sectionView.m_btnNumber setTitle:[NSString stringWithFormat:@"%d", clinicDataHolder.nNumberOfIssues] forState:UIControlStateNormal];
                
        sectionInfo.headerView = sectionView;
    }
    return sectionInfo.headerView;    
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath 
{    
    NSString *sIdentifier = [NSString stringWithFormat:@"CellIdentifier_%d_%d",indexPath.row, indexPath.section];
	
    ClnicsTableCellView *cell = (ClnicsTableCellView *)[tableView dequeueReusableCellWithIdentifier:sIdentifier];
	
    if (cell == nil)
	{
        cell = (ClnicsTableCellView *)[CGlobal getViewFromXib:@"ClnicsTableCellView" classname:[ClnicsTableCellView class] owner:self];
	}	

     SectionInfo *sectionInfoObj = (SectionInfo *)[self.sectionInfoArray objectAtIndex:indexPath.section];
     IssueDataHolder *issueDataHolder = (IssueDataHolder *)[sectionInfoObj.issueArray objectAtIndex:indexPath.row];
     cell.m_lblTitle.text = issueDataHolder.sIssueTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClinicsDataHolder *clinicDataHolder = (ClinicsDataHolder *)[arrClinic objectAtIndex:indexPath.section];
    IssueDataHolder *issueDataHolder = (IssueDataHolder *)[clinicDataHolder.arrIssue objectAtIndex:indexPath.row];
    
    ClinicsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.m_rootViewController.m_clinicDetailVC.m_clinicDataHolder = clinicDataHolder;
    appDelegate.m_rootViewController.m_clinicDetailVC.m_issueDataHolder = issueDataHolder;
    
    [appDelegate.m_rootViewController.m_clinicDetailVC setClinicDetailView];
}


#pragma mark --
#pragma mark <ClnicsTableSectionView Delegate>
 
-(void)sectionHeaderView:(ClnicsTableSectionView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened 
{
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
    
    sectionInfo.open = YES;
    m_bOPEN = YES;
        
    // Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
    
    NSInteger countOfRowsToInsert = [sectionInfo.issueArray count];
    
    if (countOfRowsToInsert > 0)
    {
        sectionHeaderView.m_imgAccessoryImage.image = [UIImage imageNamed:@"AccessoryWhiteDown.png"];
        sectionHeaderView.m_imgAccessoryImage.frame = CGRectMake(295, 19, 11, 5);
    }
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) 
    {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    
    //Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
    
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
        
        previousOpenSection.headerView.m_imgAccessoryImage.image = [UIImage imageNamed:@"AccessoryWhiteRight.png"];
        previousOpenSection.headerView.m_imgAccessoryImage.frame = CGRectMake(295, 16, 5, 11);
    }
    
    // Style the animation so that there's a smooth flow in either direction.
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
    
    // Apply the updates.
    [self beginUpdates];
    [self insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self endUpdates];
    self.openSectionIndex = sectionOpened;
    
    [indexPathsToInsert release];
    [indexPathsToDelete release];    
}


-(void)sectionHeaderView:(ClnicsTableSectionView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed 
{
    // Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
    
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
    
    sectionHeaderView.m_imgAccessoryImage.image = [UIImage imageNamed:@"AccessoryWhiteRight.png"];
    sectionHeaderView.m_imgAccessoryImage.frame = CGRectMake(295, 16, 5, 11);
    
    sectionInfo.open = NO;
    m_bOPEN = NO;
    NSInteger countOfRowsToDelete = [self numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) 
    {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) 
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        [indexPathsToDelete release];
    }
    self.openSectionIndex = NSNotFound;    
}

 


@end
