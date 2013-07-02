//
//  SettingDetailsViewController_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableCellView.h"
#import "ViewWebPageClinic_iPhone.h"
#import "TableSectionView_iPhone.h"
#import "TableCellView_iPhone.h"

@interface SettingDetailsViewController_iPhone : UIViewController<UIWebViewDelegate> {

	
    IBOutlet UITableView     *m_tblClinics;
    NSMutableArray           *m_arrCategory;
	TableCellView_iPhone     *m_tableCell;
	NSInteger                sectionIndex;
	ViewWebPageClinic_iPhone  *webview;
	UIView                   *instructionView;
	
	UILabel                  *m_lblTitle;
	UIButton                *backButton;
	UIButton               *saveButton;
	UIButton              *cancelbutton;
	UIView             *  backLodingview;
	
}

-(void)backToCategoryView:(id)sender;
-(void)pressONSaveButton:(id)sender;
-(void)selectClinicSection:(NSInteger )Section;
-(void)CheckUpdate;
-(void)callClinicsListViewController;
-(void)saveYourSettingFollowedClinics;

@end
