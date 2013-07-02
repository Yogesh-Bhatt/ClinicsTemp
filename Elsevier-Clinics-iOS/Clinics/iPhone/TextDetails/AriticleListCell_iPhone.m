//
//  AriticleListCell_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AriticleListCell_iPhone.h"
#import "ClinicDetailViewController.h"

@implementation AriticleListCell_iPhone
@synthesize m_parent;
@synthesize m_btnFreeArticle;
@synthesize m_HTMLBtn;
@synthesize m_PDFBtn;

//*************************** Set Data in TableView Cell****************************

- (void)setData:(ArticleDataHolder *)articleDataHolder
{
    m_articleDtaHolder = articleDataHolder;
 
    m_lblArticleTitle.text = articleDataHolder.sArticleTitle;

    for (int i=0; i<[articleDataHolder.arrAuthor count]; i++)
    {
        m_lblAuthors.text = [NSString stringWithFormat:@"%@ ",[articleDataHolder.arrAuthor objectAtIndex:i]];
    }
    
    if (articleDataHolder.nBookmark == 1)
        [m_btnBookmark setImage:[UIImage imageNamed:@"BtnBookmarkSelected.png"] forState:UIControlStateNormal];
    else
        [m_btnBookmark setImage:[UIImage imageNamed:@"BtnBookmarkUnselected.png"] forState:UIControlStateNormal];
    
    if (articleDataHolder.nRead == 1)
        m_btnRead.hidden = YES;
    else
        m_btnRead.hidden = NO;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}




@end
