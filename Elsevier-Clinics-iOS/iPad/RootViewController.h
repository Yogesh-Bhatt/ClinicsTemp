//
//  RootViewController.h
//  Clinics
//
//  Created by Kiwitech on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClinicListViewController.h"
#import "ClinicDetailViewController.h"
#import "SettingListViewContoller.h"
#import "SettingDetailViewController.h"
#import "LoginViewController.h"
#import "BookMarksDetailsViewController_iPad.h"
#import "BookMarkListViewController_iPad.h"

#import "AboutAppListViewController.h"
#import "NotesListViewController_iPad.h"
#import "NotesDetailsViewController_iPad.h"
@interface RootViewController : BaseViewController
{

	UIPopoverController *	m_popoverController;
	//BOOL orientationFlag;
	
	ClinicListViewController    *m_clinicListVC;
    ClinicDetailViewController  *m_clinicDetailVC;
    
    SettingListViewContoller   *m_settingListVC;
    SettingDetailViewController *m_settingDetailVC;
	
	BookMarksDetailsViewController_iPad   *bookMarkDetailsView;
	BookMarkListViewController_iPad  *bookMarksListView;
	
	// NotesView Object
	NotesListViewController_iPad    *m_NotesListView;
	NotesDetailsViewController_iPad   *m_NotesDetailsView;
	AboutAppListViewController   *aboutListView;
	HomeEditorView  *homeEditor;
	UIView         *backLoding;
}

-(void)removeClinicDetailsViewFromRootView:(NSInteger )SeletedTag;
-(void)hideClinicsListViewController;

@property(nonatomic, retain)ClinicListViewController    *m_clinicListVC;
@property(nonatomic, retain)ClinicDetailViewController  *m_clinicDetailVC;

@property(nonatomic, retain)SettingListViewContoller    *m_settingListVC;
@property(nonatomic, retain)SettingDetailViewController  *m_settingDetailVC;

@property(nonatomic,retain)BookMarksDetailsViewController_iPad   *bookMarkDetailsView;
@property(nonatomic,retain)BookMarkListViewController_iPad   *bookMarksListView;

@property(nonatomic,retain)NotesDetailsViewController_iPad   *m_NotesDetailsView;
@property(nonatomic,retain)NotesListViewController_iPad    *m_NotesListView;

@property(nonatomic,retain) AboutAppListViewController   *aboutListView;
@property(nonatomic,retain)HomeEditorView  *homeEditor;
-(void)rotateDiviceInSettingTabBarClick;
-(void)addSettingViewOnRootView;
-(void)loadOnlyUpadteIssueFromServer;


-(void)checkUserChangesUserNameOrPassword:(BOOL)flag 
                                withView :(UIView *)view
                           withOrienation:(UIInterfaceOrientation )interfaceOrientation;

-(void)handleIosVersionOrieantion;
-(void)saveUpdateIssue:(NSDictionary  *)updateIssueDict;

@end
