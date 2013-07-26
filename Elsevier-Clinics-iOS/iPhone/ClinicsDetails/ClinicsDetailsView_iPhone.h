//
//  ClinicDetailViewController.h
//  Clinics
//
//  Created by Ashish Awasthi on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import "ClinicsDataHolder.h"
#import "IssueDataHolder.h"
#import "TableSectionView_iPhone.h"
#import "LoadingViewLogin_IPhone.h"
#import "ListBackIssueController.h"
#import "TabBarHomeView_iPhone.h"
#import "ClinicDetailHeaderCellView_iPhone.h"
#import "CAURLDownload.h"
#import "DownloadDetailViewController_iPhone.h"

@class ListBackIssueController;

@interface ClinicsDetailsView_iPhone :TabBarHomeView_iPhone<UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate,ClinicDetailHeaderCellView_iPhoneDelegate>
{
    IBOutlet UITableView *m_tblClinicDetail;
    ClinicsDataHolder *m_clinicDataHolder;
    IssueDataHolder   *m_issueDataHolder;
    UIPopoverController         *m_popoverController; 
    NSMutableArray *m_arrArticles;
	TableSectionView_iPhone *sectionView;
	BOOL aritcleInPressFlag;
	NSInteger buttnTag;
	BOOL afterDwonLoading;
	ListBackIssueController  *listBackIssue;
	BOOL ClickInAbstractButton;
	NSString  *categoryName;
	BOOL bacKIssueflag;
	
    UIView	 *backLoding;
	NSInteger   m_issueId;
	NSInteger  updateissueClinicID;
	
	UIButton     *loginButton;
	UILabel    *m_lblTitle;
	BOOL   tabOnArticleinPress;
    
    UIButton *downloadPopOverBtn;
    
    NSMutableArray *m_downloadQueueArr;
    
    UIView *downloadPopOverview;
    DownloadDetailViewController_iPhone *downloadDetailviewController;
    
    BOOL check;
    
    
}
@property(nonatomic,retain) UIPopoverController         *m_popoverController; 
@property(nonatomic,retain)NSString  *categoryName;
@property(nonatomic, retain)ClinicsDataHolder   *m_clinicDataHolder;
@property(nonatomic, retain)IssueDataHolder     *m_issueDataHolder;
@property (nonatomic, assign)NSInteger      authentication;

- (void)setClinicDetailView;
-(void)articleInpressClecnicDetails;
-(void)firstCategoryAndFirstCategory:(BOOL)toc;
-(void)completeDwonloadFullTextAndPdf;
-(void)downloadFileFromServer:(NSString *)choiceString;
-(void)reloadBackIssueIndetaialsView:(NSString *)IssueID;

-(void)loadDataFromServerISuuseData:(BOOL)flag;
-(void)loadDataAricleINpressFromServer;
-(void)setNavigationBaronView;
-(void)changeImageLoginButton;
-(void)setLoginButtonHidden;
-(void)latestDownloadedArticles;

@end

