//
//  AboutAppListViewController_iPhone.h
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewTabBar_iPhone.h"

@interface AboutAppListViewController_iPhone :SettingViewTabBar_iPhone {
    
	NSMutableArray    *sharedOptionArr;
	NSInteger         rowIndex;
}

-(void)defaultSelectedAbouttheApp;
-(void)setNavigationBaronView;

@property(nonatomic,retain)IBOutlet   UITableView    *shareTableView;


@end
