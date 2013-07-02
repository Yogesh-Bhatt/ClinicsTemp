//
//  AritcleListViewController.h
//  Clinics
//
//  Created by Ashish Awasthi on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableSectionView.h"
#import "ClinicDetailHeaderCellView.h"
#import "ArticleDataHolder.h"
#import "AriticleListCell.h"
#import "WebViewController.h"
#import "IssueDataHolder.h"

@class WebViewController;

@interface AritcleListViewController : UIViewController {
	IBOutlet   UITableView    *atritcleListTableView;
	WebViewController  *webViewController;
	TableSectionView *sectionView;
	NSMutableArray   *articleInfoArr;
	
	NSInteger  buttnTag;
	BOOL pressAbstructBtn;
	BOOL pressHTMLBtn;
	BOOL pressPdfBtn;
	ArticleDataHolder *	articleDataHolder;
	BOOL  allReadyLogin;
	UIView  *backLoding;
   
}
@property(nonatomic,retain)UIView  *backLoding;
@property(nonatomic,assign)BOOL  allReadyLogin;
@property(nonatomic,retain)id  webViewController;
@property(nonatomic,retain)NSMutableArray   *articleInfoArr;

-(void)ClickOnIssueButton:(id)sender;
-(void)ClickOnAtricleButton:(id)sender;
- (void)setClinicDetailView;
-(void)downloadFileFromServer:(NSString *)choiceString;
-(void)completeDwonloadFullTextAndPdfReloadONWebView;
-(void)loadDataAricleINpressFromServer;
@end
