//
//  ListBackIssueController_iPhone.h
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackIssueCell_iPhone.h"
#import "ClinicsDataHolder.h"
#import "ClinicsListView_iPhone.h"

@interface ListBackIssueController_iPhone : UIViewController {
    
	IBOutlet BackIssueCell_iPhone   *backIssueCell;
	IBOutlet UITableView    *backIssueTable;
	NSMutableArray   *backIssueArr;
	ClinicsDataHolder   *clinicsDataholder;
	ClinicsListView_iPhone   *clinicsListView;
	UIButton   *doneButton;
}
@property(nonatomic,retain)ClinicsListView_iPhone   *clinicsListView;
@property(nonatomic,retain)ClinicsDataHolder   *clinicsDataholder;
-(void)loadDataInTableView:(NSInteger )clinicID;
-(void)setNavigationBaronView;
@end