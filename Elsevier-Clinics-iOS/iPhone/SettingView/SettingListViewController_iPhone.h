//
//  SettingListViewController_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstructionView_iPhone.h"

@interface SettingListViewController_iPhone : UIViewController<UIWebViewDelegate,InstructionView_iPhoneDelegate> {
    
	NSMutableArray          *m_arrCategoryImage;
	IBOutlet  UITableView    *settingTableView;
	NSMutableArray           *m_clinicsNameArr;
	NSMutableArray          *m_arrCategory;
    InstructionView_iPhone *m_instructionView;
}

- (void)loadDataclinicsDataFromDataBase;
- (void)loadDataClinicFromServer;
@end
