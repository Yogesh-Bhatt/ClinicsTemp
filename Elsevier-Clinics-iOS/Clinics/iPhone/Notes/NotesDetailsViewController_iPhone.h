//
//  NotesDetailsViewController_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/24/11.
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
#import "TabBarHomeView_iPhone.h"

@interface NotesDetailsViewController_iPhone : TabBarHomeView_iPhone<UITableViewDelegate,UITableViewDataSource> {
	
	IBOutlet UITableView *m_tblClinicDetail;
    ClinicsDataHolder *m_clinicDataHolder;
    IssueDataHolder   *m_issueDataHolder;
	
    NSMutableArray     *m_arrArticles;
  
	NSInteger         buttnTag;
	BOOL            afterDwonLoading;
	BOOL        ClickInAbstractButton;
	
	NSString  *categoryName;
	BOOL       firstTime;
	UILabel *m_lblTitle;
	UIButton  *loginButton;
	NSInteger authentication;
}

@property(nonatomic,retain)NSString  *categoryName;
@property(nonatomic, retain)ClinicsDataHolder   *m_clinicDataHolder;
@property(nonatomic, retain)IssueDataHolder     *m_issueDataHolder;

-(void)setNavigationBaronView;
- (void)setClinicDetailView;
-(void)firstCategoryAndFirstCategory:(BOOL)toc;
-(void)completeDwonloadFullTextAndPdf;
-(void)downloadFileFromServer:(NSString *)choiceString;
-(void)popToLastView;
-(void)changeImageLoginButton;
-(void)setLoginButtonHidden;

@end