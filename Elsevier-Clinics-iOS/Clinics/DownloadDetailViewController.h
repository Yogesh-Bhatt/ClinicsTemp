//
//  DownloadDetailViewController.h
//  Clinics
//
//  Created by Rohit Dhawan on 27/06/13.
//
//

#import <UIKit/UIKit.h>
#import "ArticleDataHolder.h"

@interface DownloadDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITableView *m_tableView;
    
    NSArray *m_articleArr;
    
    //NSMutableArray *arr;
    
   

}

-(void)refreshTblWith:(NSArray *)a_articleArr;

-(IBAction)clearAllDownloads:(id)sender;


@end
