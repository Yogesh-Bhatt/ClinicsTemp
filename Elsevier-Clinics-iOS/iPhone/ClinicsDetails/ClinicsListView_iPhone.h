//
//  ClinicsListView_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClnicsTableSectionView.h"
#import "ClnicsTableCellView.h"
#import "TabBarHomeView_iPhone.h"
#import "ClinicsDetailsView_iPhone.h"

@interface ClinicsListView_iPhone :TabBarHomeView_iPhone <TableCellViewDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>
{
    IBOutlet UITableView    *m_tblClinics;
    NSMutableArray *m_arrClinics;
    NSMutableArray *sectionInfoArray;
    NSInteger openSectionIndex;   
   
    NSMutableArray *m_arrCategoryImage;
    NSMutableArray *m_arrCategory;
    NSMutableArray *m_arrButtonCategory;
    CategoryOpenOrClose m_CategoryType;
    ClnicsTableCellView   *lastSelectedCell;
    IBOutlet UIScrollView *m_scrollView;

	BOOL  loadtableViewFirstAfterSetting;
	UIPopoverController *		m_popoverController;
	NSString  *catgeryName;
	NSInteger   clinicID;
	NSInteger latButtontag;
	NSInteger  categoryID;
	NSInteger  clinicsection;
	
	UIButton  *addClinics;
	UIView  *backLoding;
	ClinicsDetailsView_iPhone  *clinicsdetailsView;
	NSInteger  updateissueClinicID;
    
    IBOutlet UIImageView *m_imageView;
    
	
}
@property(nonatomic,retain)ClinicsDetailsView_iPhone  *clinicsdetailsView;
@property(nonatomic,retain) UIScrollView *m_scrollView;
@property(nonatomic,retain)UITableView    *m_tblClinics;
@property (nonatomic, assign) NSInteger         openSectionIndex;
@property (nonatomic, retain) NSMutableArray    *sectionInfoArray;
@property (nonatomic, assign) BOOL              isShowPopOverView;

-(void)resetButtonImageFromCategory:(NSInteger)sectedTag :(BOOL)flag;

- (void)initClinicListView;
-(void)resheftCategoryBtnWithOffset:(int)increasedHeight:(BOOL)flag;
- (IBAction) categoryButtonPressed:(id)sender;
-(void)openlaststageIssuelevel;
-(void)filpScrennShowBackIssue:(NSInteger)IndexSection;

@end
