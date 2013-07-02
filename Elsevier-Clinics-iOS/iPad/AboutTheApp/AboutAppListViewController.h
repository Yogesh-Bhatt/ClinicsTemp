//
//  AboutAppListViewController.h
//  Clinics
//
//  Created by Kiwitech LLC on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarClass.h"

@interface AboutAppListViewController :TabBarClass {
    
	IBOutlet   UITableView    *shareTableView;
	NSMutableArray   *sharedOptionArr;
	NSMutableArray  *temp_Arr;
	NSInteger   rowIndex;
    UIPopoverController *m_popoverController;
}
-(void)defaultSelectedAbouttheApp;
@property(nonatomic,retain)UITableView    *shareTableView;
@end
