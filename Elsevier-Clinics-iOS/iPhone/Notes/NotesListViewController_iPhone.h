//
//  NotesListViewController_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

#import "TabBarClassHomeView.h"
#import "ClnicsTableSectionView.h"
#import "ClnicsTableCellView.h"
#import "TabBarClassHomeView.h"
#import "NotesDetailsViewController_iPhone.h"
#import "TabBarHomeView_iPhone.h"
@interface NotesListViewController_iPhone : TabBarHomeView_iPhone<UITableViewDelegate,UITableViewDataSource,TableCellViewDelegate> {
    
	IBOutlet UITableView    *m_tblClinics;
    NSMutableArray *m_arrClinics;
    NSMutableArray *sectionInfoArray;
    NSInteger openSectionIndex;   
    ClnicsTableCellView   *lastSelectedCell;
    NSMutableArray *m_arrCategoryImage;
    NSMutableArray *m_arrCategory;
    NSMutableArray *m_arrButtonCategory;
    CategoryOpenOrClose m_CategoryType;
    IBOutlet UIScrollView *m_scrollView;
	NSString  *catgeryName;
	NSInteger   clinicID;
	NSInteger latButtontag;
	UILabel   *m_lblTitle;
	NotesDetailsViewController_iPhone  *noteDetailsView_iPhone;
}

@property(nonatomic,retain)NotesDetailsViewController_iPhone  *noteDetailsView_iPhone;
@property(nonatomic,retain)UITableView    *m_tblClinics;
@property (nonatomic, assign) NSInteger         openSectionIndex;
@property (nonatomic, retain) NSMutableArray    *sectionInfoArray;
-(void)resetButtonImageFromCategory:(NSInteger)sectedTag :(BOOL)flag;
- (void)initClinicListView;
-(void)resheftCategoryBtnWithOffset:(int)increasedHeight:(BOOL)flag;
- (IBAction) categoryButtonPressed:(id)sender;

@end
