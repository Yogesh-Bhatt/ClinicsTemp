
//
//  DownloadArticleViewCell_iPhone.h
//  Clinics
//
//  Created by Afzal Siddiqui on 7/25/13.
//
//

#import <UIKit/UIKit.h>

@interface DownloadArticleViewCell_iPhone : UITableViewCell {
    
    IBOutlet UIButton *m_btnBookmark;
    IBOutlet UIButton *m_btnRead;
    IBOutlet UIButton *m_btnDeleteArticle;
    IBOutlet UIButton *m_HTMLBtn;
    IBOutlet UIButton *m_PDFBtn;
    IBOutlet UILabel  *m_lblArticleTitle;
    IBOutlet UILabel  *m_lblAuthors;
    
    
    ArticleDataHolder *m_articleDtaHolder;
    
    id m_parent;
}

@property(nonatomic,retain)UIButton *m_btnDeleteArticle;
@property(nonatomic,retain)UIButton *m_HTMLBtn;
@property(nonatomic,retain)UIButton *m_PDFBtn;
@property (nonatomic, assign)id m_parent;

- (IBAction)bookmarkButtonPressed:(id)sender;

- (void)setData:(ArticleDataHolder *)articleDataHolder;

@end

