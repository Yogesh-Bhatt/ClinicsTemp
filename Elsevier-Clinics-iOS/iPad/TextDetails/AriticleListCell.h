//
//  AriticleListCell.h
//  Clinics
//
//  Created by Ashish Awasthi on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AriticleListCell : UITableViewCell {
	
	IBOutlet UIButton *m_btnBookmark;
    IBOutlet UIButton *m_btnRead;
    IBOutlet UIButton *m_btnFreeArticle;
	IBOutlet UIButton *m_HTMLBtn;
	IBOutlet UIButton *m_PDFBtn;
    IBOutlet UILabel  *m_lblArticleTitle;
    IBOutlet UILabel  *m_lblAuthors;

    ArticleDataHolder *m_articleDtaHolder;
    
    id m_parent;
	
}

@property(nonatomic,retain)UIButton *m_btnFreeArticle;
@property(nonatomic,retain)UIButton *m_HTMLBtn;
@property(nonatomic,retain)UIButton *m_PDFBtn;
@property (nonatomic, assign)id m_parent;

- (void)setData:(ArticleDataHolder *)articleDataHolder;

@end
