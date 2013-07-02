//
//  RootViewController_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingListViewController_iPhone.h"
#import "SettingDetailsViewController_iPhone.h"
#import "ClinicsListView_iPhone.h"
#import "AboutAppListViewController_iPhone.h"
#import"BookMarkListViewController_iPhone.h"
#import "NotesListViewController_iPhone.h"

@interface RootViewController_iPhone : UIViewController {

	SettingListViewController_iPhone  *settingList_iPhone;
	SettingDetailsViewController_iPhone  *settingDetails_iPhone;
	ClinicsListView_iPhone    *clinicListView;
	AboutAppListViewController_iPhone   *abouttheAppView_iPhone;
	BookMarkListViewController_iPhone   *bookmarks_iPhone;
	NotesListViewController_iPhone   *noteLists_iPhone  ;
    
    UIView          *backLoding;
    
    
}
@property(nonatomic,retain)ClinicsListView_iPhone    *clinicListView;
@property(nonatomic,retain)SettingListViewController_iPhone  *settingList_iPhone;

@property(nonatomic,retain)BookMarkListViewController_iPhone *bookmarks_iPhone;
@property(nonatomic,retain)NotesListViewController_iPhone   *noteLists_iPhone  ;

@property(nonatomic,retain)AboutAppListViewController_iPhone   *abouttheAppView_iPhone;

- (void) addViewController;
- (void)addSettingViewOnRootView;
- (void)loadOnlyUpadteIssueFromServer;


-(void)checkUserChangesUserNameOrPassword:(BOOL)flag 
                                withView :(UIView *)view
                           withOrienation:(UIInterfaceOrientation )interfaceOrientati;
-(void)saveUpdateIssue:(NSDictionary  *)updateIssueDict;

@end
