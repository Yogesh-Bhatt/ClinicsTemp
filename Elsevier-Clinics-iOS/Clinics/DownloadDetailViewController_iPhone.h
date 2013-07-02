//
//  DownloadDetailViewController_iPhoneViewController.h
//  Clinics
//
//  Created by Kiwitech International on 29/06/13.
//
//

#import "DDProgressView.h"
#import "CAURLDownload.h"

@interface DownloadDetailViewController_iPhone : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITableView *m_tableView;
    
    NSArray *m_articleArr;
    
    NSMutableArray *arr;
}

-(void)refreshTblWith:(NSArray *)a_articleArr;

-(IBAction)clearAllDownloads:(id)sender;

@end
