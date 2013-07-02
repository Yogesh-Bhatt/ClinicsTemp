
#import <UIKit/UIKit.h>
#import "ClinicsDataHolder.h"
#import "IssueDataHolder.h"
#import "TableSectionView.h"
#import "LoginViewController.h"
#import "TabBarHomeView_iPhone.h"

@interface BookMarksDetailsViewController_iPhone :TabBarHomeView_iPhone <UITableViewDataSource,UITableViewDelegate> {
    
	IBOutlet UITableView *m_tblClinicDetail;
    ClinicsDataHolder *m_clinicDataHolder;
    IssueDataHolder   *m_issueDataHolder;
	
    UIPopoverController         *m_popoverController; 
	
    NSMutableArray *m_arrArticles;
   
	NSInteger    buttnTag;
	BOOL        afterDwonLoading;
	BOOL            ClickInAbstractButton;
	NSString     *categoryName;
	
	UIButton    *loginButton;
	UILabel     *m_lblTitle;
	
}
@property(nonatomic,retain) UIPopoverController         *m_popoverController; 
@property(nonatomic,retain)NSString  *categoryName;
@property(nonatomic, retain)ClinicsDataHolder   *m_clinicDataHolder;
@property(nonatomic, retain)IssueDataHolder     *m_issueDataHolder;

//***************************** Method *****************************

- (void)setClinicDetailView;
- (void)setNavigationBaronView;
-(void)firstCategoryAndFirstCategory:(BOOL)toc;
-(void)completeDwonloadFullTextAndPdf;
-(void)downloadFileFromServer:(NSString *)choiceString;
-(void)popToLastView;
-(void)changeImageLoginButton;
-(void)setLoginButtonHidden;
@end
