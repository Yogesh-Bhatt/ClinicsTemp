//
//  SettingListViewContaoller.h
//  Clinics
//
//  Created by Ashish Awasthi on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TabBarClass.h"
@interface SettingListViewContoller :UIViewController <UITableViewDelegate, UITableViewDataSource>
{
       
    IBOutlet UITableView *m_tblCategory;
    NSMutableArray *m_arrCategory;
    NSMutableArray *m_arrCategoryImage;
	NSMutableArray  *temp_Arr;
	NSInteger   rowIndex;
	
	
}

@property(nonatomic,retain)UITabBar   *m_tabBar;
@property(nonatomic,retain)UITableView *m_tblCategory;
@end
