//
//  ClinicListViewController.h
//  Clinics
//
//  Created by Kiwitech on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClnicsTableSectionView.h"
#import "ClnicsTableCellView.h"
#import "TabBarClassHomeView.h"


@interface ClinicListViewController :TabBarClassHomeView <TableCellViewDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>
{
    IBOutlet UITableView    *m_tblClinics;
    NSMutableArray *m_arrClinics;
    NSMutableArray *sectionInfoArray;
    NSInteger openSectionIndex;   
    BOOL isShowPopOverView;
    NSMutableArray *m_arrCategoryImage;
    NSMutableArray *m_arrCategory;
    NSMutableArray *m_arrButtonCategory;
    CategoryOpenOrClose m_CategoryType;
    ClnicsTableCellView   *lastSelectedCell;
    IBOutlet UIScrollView *m_scrollView;
	NSMutableArray *remberArr;
	BOOL  loadtableViewFirstAfterSetting;
	UIPopoverController *		m_popoverController;
	NSString  *catgeryName;
	NSInteger   clinicID;
	NSInteger latButtontag;
	NSInteger  categoryID;
	NSInteger  clinicsection;
	
	
}
@property(nonatomic,retain) UIScrollView *m_scrollView;
@property(nonatomic,retain)UITableView    *m_tblClinics;
@property (nonatomic, assign) NSInteger         openSectionIndex;
@property (nonatomic, retain) NSMutableArray    *sectionInfoArray;
@property (nonatomic, assign) BOOL              isShowPopOverView;

-(void)resetButtonImageFromCategory:(NSInteger)sectedTag :(BOOL)flag;
-(void)ShowSelectedRowInTableView:(NSInteger)SelecedRow :(NSInteger)SeletedIndex;
-(void)initClinicListView;
-(void)downlaodBackIssueFromServer;
-(void)resheftCategoryBtnWithOffset:(int)increasedHeight:(BOOL)flag;
- (IBAction) categoryButtonPressed:(id)sender;
-(void)setFrameM_ScrollView;
-(void)openlaststageIssuelevel;

@end
