//
//  DownloadDeatilView_iPhoneCell.h
//  Clinics
//
//  Created by Kiwitech International on 29/06/13.
//
//

#import "DDProgressView.h"
#import "CAURLDownload.h"

@interface DownloadDeatilView_iPhoneCell : UITableViewCell{
    
    DDProgressView *progressView;
    
    CAURLDownload *cAURLDownload;
    UILabel *m_lblPercetTitle;
    UIButton *closeButton;
    NSString *filePath;
    NSString *fileDocPath;
    UILabel *m_resultTitle;
    
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  downloadedCustomViewWithFrame:(CGRect)rect  withDownloadUrl:(NSString *)m_url withTitle:(NSString *)a_title withSubTitle:(NSString *)a_subTitle;

@end
