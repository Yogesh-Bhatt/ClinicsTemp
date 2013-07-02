//
//  NotesDetailsViewController_iPad.h
//  Clinics
//
//  Created by Ashish Awasthi on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ClinicsDataHolder.h"
#import "IssueDataHolder.h"
#import "TableSectionView.h"
#import "LoginViewController.h"
#import "ListBackIssueController.h"

@interface NotesDetailsViewController_iPad : BaseViewController<UITableViewDelegate,UITableViewDataSource> {
    
	IBOutlet UITableView *m_tblClinicDetail;
    ClinicsDataHolder *m_clinicDataHolder;
    IssueDataHolder   *m_issueDataHolder;
	
    UIPopoverController         *m_popoverController; 
	
    NSMutableArray *m_arrArticles;
    id m_parentRootVC;

	NSInteger buttnTag;

	BOOL afterDwonLoading;
	BOOL ClickInAbstractButton;
	
	NSString  *categoryName;
	
	NSInteger authentication;
	BOOL  firstTime;
}
@property(nonatomic,retain) UIPopoverController         *m_popoverController; 
@property(nonatomic,retain)NSString  *categoryName;
@property(nonatomic, retain)ClinicsDataHolder   *m_clinicDataHolder;
@property(nonatomic, retain)IssueDataHolder     *m_issueDataHolder;
@property (nonatomic, assign) id                m_parentRootVC;
@property (nonatomic, assign)NSInteger      authentication;
- (void) didRotate:(id)sender;
- (void)setClinicDetailView;
- (void) dismissPopoover;
- (void) showPopOver;

-(void)firstCategoryAndFirstCategory:(BOOL)toc;
-(void)completeDwonloadFullTextAndPdf;
-(void)downloadFileFromServer:(NSString *)choiceString;

-(void)popToLastView;
-(void)changeSizeNavigationBarTitle;
-(void)setLoginButtonHidden;
@end