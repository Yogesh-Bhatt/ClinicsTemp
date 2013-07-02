//
//  AritcleListViewController_iPhone.h
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "TableSectionView.h"
#import "ClinicDetailHeaderCellView.h"
#import "ArticleDataHolder.h"
#import "AriticleListCell.h"
#import "WebViewController.h"

@class WebViewController_iPhone;
@interface AritcleListViewController_iPhone : UIViewController {
	IBOutlet   UITableView    *atritcleListTableView;
	WebViewController_iPhone  *webViewController_iPhone;
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
@property(nonatomic,retain)WebViewController_iPhone  *webViewController_iPhone;
@property(nonatomic,retain)NSMutableArray   *articleInfoArr;

-(void)ClickOnIssueButton:(id)sender;
-(void)ClickOnAtricleButton:(id)sender;

- (void)setClinicDetailView;
-(void)downloadFileFromServer:(NSString *)choiceString;
-(void)completeDwonloadFullTextAndPdfReloadONWebView;
-(void)loadDataAricleINpressFromServer;
-(void)setNavigationBaronView;
-(void)clickOncloseBuutton:(id)sender;
@end

