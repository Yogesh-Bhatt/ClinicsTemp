//
//  ClinicDetailViewController.h
//  Clinics
//
//  Created by Ashish Awasthi on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import "ClinicsDataHolder.h"
#import "IssueDataHolder.h"
#import "TableSectionView.h"
#import "LoginViewController.h"
#import "ListBackIssueController.h"
#import "ClinicDetailHeaderCellView.h"
#import "CAURLDownload.h"
#import "DownloadDetailViewController.h"
typedef enum {
    
    reloadClinics = 1,
    reloadDownloadedArticles
    
}ReloadArticleType;

ReloadArticleType    reloadArticleType;

@class ListBackIssueController;
@interface ClinicDetailViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate,ClinicDetailHeaderCellViewDelegate>
{
    IBOutlet UITableView *m_tblClinicDetail;
    ClinicsDataHolder *m_clinicDataHolder;
    IssueDataHolder   *m_issueDataHolder;
    UIPopoverController         *m_popoverController; 
    NSMutableArray *m_arrArticles;
    id m_parentRootVC;
	TableSectionView *sectionView;
	BOOL aritcleInPressFlag;
	NSInteger buttnTag;
	BOOL afterDwonLoading;
	ListBackIssueController  *listBackIssue;
	BOOL ClickInAbstractButton;
	NSString  *categoryName;
	BOOL bacKIssueflag;

    UIView	 *backLoding;
	NSInteger   IssueID;
	NSInteger  updateissueClinicID;
	
	BOOL tabOnArticleinPress;
    
    UIButton *downloadPopOverBtn;
    
    NSMutableArray *m_downloadQueueArr;
    
    UIPopoverController *downloadPopOverController;
    DownloadDetailViewController *downloadDetailviewController;
    
}
@property (nonatomic,retain) UIPopoverController         *m_popoverController;
@property (nonatomic,retain) NSString  *categoryName;
@property (nonatomic, retain) ClinicsDataHolder   *m_clinicDataHolder;
@property (nonatomic, retain) IssueDataHolder     *m_issueDataHolder;
@property (nonatomic, assign) id                m_parentRootVC;
@property (nonatomic, assign) NSInteger      authentication;

- (void) didRotate:(id)sender;
- (void)setClinicDetailView;
- (void) dismissPopoover;
- (void) showPopOver;
- (void)articleInpressClecnicDetails;
- (void)firstCategoryAndFirstCategory:(BOOL)toc;
- (void)completeDwonloadFullTextAndPdf;
- (void)downloadFileFromServer:(NSString *)choiceString;
- (void)reloadBackIssueIndetaialsView:(NSString *)IssueID;
- (void)filpScrennShowBackIssue:(NSInteger )clinicID;
- (void)loadDataFromServerISuuseData:(BOOL)flag;
- (void)loadDataAricleINpressFromServer;

- (void)changeSizeNavigationBarTitle;
- (void)loadLatestDownloadedArticles;
- (void)setLoginButtonHidden;
- (void)changeXPosAddClinicsButton;
- (void)showLoginButton:(BOOL)flag;
@end
