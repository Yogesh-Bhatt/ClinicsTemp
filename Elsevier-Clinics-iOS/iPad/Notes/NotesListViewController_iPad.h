//
//  NotesListViewController_iPad.h
//  Clinics
//
//  Created by Ashish Awasthi on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarClassHomeView.h"
#import "ClnicsTableSectionView.h"
#import "ClnicsTableCellView.h"
#import "TabBarClassHomeView.h"

@interface NotesListViewController_iPad : TabBarClassHomeView<UITableViewDelegate,UITableViewDataSource,TableCellViewDelegate> {
    
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
	
	
}
@property(nonatomic,retain) UIScrollView *m_scrollView;
@property(nonatomic,retain)UITableView    *m_tblClinics;
@property (nonatomic, assign) NSInteger         openSectionIndex;
@property (nonatomic, retain) NSMutableArray    *sectionInfoArray;
@property (nonatomic, assign) BOOL              isShowPopOverView;

-(void)resetButtonImageFromCategory:(NSInteger)sectedTag :(BOOL)flag;
-(void)ShowSelectedRowInTableView:(NSInteger)SelecedRow :(NSInteger)SeletedIndex;
- (void)initClinicListView;

-(void)resheftCategoryBtnWithOffset:(int)increasedHeight:(BOOL)flag;
- (IBAction) categoryButtonPressed:(id)sender;
-(void)setFrameM_ScrollView;
-(void)openlaststageIssuelevel;
@end
