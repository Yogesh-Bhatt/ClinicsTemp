//
//  ListBackIssueController.h
//  Clinics
//
//  Created by Ashish Awasthi on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BackIssueCell.h"

@interface ListBackIssueController : BaseViewController {
	IBOutlet BackIssueCell   *backIssueCell;
	IBOutlet UITableView    *backIssueTable;
	NSMutableArray   *backIssueArr;
	
	UIButton   *backbutton;
}
-(void)loadDataInTableView:(NSInteger )clinicID;
-(void)changePositionDoneButton;
@end
