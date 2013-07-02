//
//  ArticleCellView_iPhone.m
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ArticleCellView_iPhone.h"

#import "ArticleCellView_iPhone.h"

#import "ClinicsDetailsView_iPhone.h"
#import "BookMarkListViewController_iPhone.h"
#import "ClinicsAppDelegate.h"
//#import "NotesListViewController_iPhone.h"
@implementation ArticleCellView_iPhone

@synthesize m_parent;
@synthesize m_btnFreeArticle;
@synthesize m_HTMLBtn;
@synthesize m_PDFBtn;
- (void)setData:(ArticleDataHolder *)articleDataHolder
{
    m_articleDtaHolder = articleDataHolder;

    //****************Set Text of Cell****************
    m_lblArticleTitle.text = articleDataHolder.sArticleTitle;

    
    for (int i=0; i<[articleDataHolder.arrAuthor count]; i++)
    {
        m_lblAuthors.text = [NSString stringWithFormat:@"%@ ",[articleDataHolder.arrAuthor objectAtIndex:i]];
    }
    

	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
	// ************************  don't add bookmarks on Articlein press************************
    
	if ([loginId intValue] == ishundred) {
		m_btnBookmark.hidden=TRUE;
	}
	else {
		m_btnBookmark.hidden=FALSE;
	}
	
    if (articleDataHolder.nBookmark == 1)
        [m_btnBookmark setImage:[UIImage imageNamed:@"iPhone_BookmarksYellow.png"] forState:UIControlStateNormal];
    else
        [m_btnBookmark setImage:[UIImage imageNamed:@"iPhone_BookmarksGray.png"] forState:UIControlStateNormal];
    
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

- (IBAction)bookmarkButtonPressed:(id)sender
{
    DatabaseConnection *database = [DatabaseConnection sharedController];
    ArticleDataHolder *articleDataHolder = [[database loadArticleInfo:m_articleDtaHolder.nArticleID] retain]; 
	NSInteger  clinicID=0;
	NSInteger  CategoryID=0;
	clinicID=[database    selectClinicIDFromIssueTable:[NSString stringWithFormat:@"select clinicid from tblissue where issueid=%@",m_articleDtaHolder.sIssueID]];
	CategoryID=[database  selectClinicIDFromIssueTable:[NSString stringWithFormat:@"select categoryID from tblclinic where clinicId=%d",clinicID]];
    
    if (articleDataHolder.nBookmark == 1){
		[database   updateBookmarkInArticleData:[NSString stringWithFormat:@"UPDATE tblArticle SET Bookmark = 0,CategoryID = 0 where ArticleId = %d",m_articleDtaHolder.nArticleID]];
    }
    else { 
		[database   updateBookmarkInArticleData:[NSString stringWithFormat:@"UPDATE tblArticle SET Bookmark = 1,CategoryID = %d  where ArticleId = %d",CategoryID,m_articleDtaHolder.nArticleID]]; // Add Bookmark
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Article has been added to Bookmarks." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
	}
	[articleDataHolder release];
	
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	
	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
	
	if(appDelegate.clinicsDetails==kTAB_CLINICS){
		ClinicsDetailsView_iPhone  *clinicDetailsView=(ClinicsDetailsView_iPhone *)appDelegate.clinicsdeatils_iPhone;
		if ([loginId intValue]==100) {
			
			[clinicDetailsView  articleInpressClecnicDetails];
		}
		else {
			
			[clinicDetailsView setClinicDetailView];
		}
		
	}// 
	// ************************call on bookmarks************************
    
	else if(appDelegate.clinicsDetails==kTAB_BOOKMARKS){
		BookMarksDetailsViewController_iPhone  *bookmarksDetailsView=(BookMarksDetailsViewController_iPhone *)appDelegate.rootView_iPhone.bookmarks_iPhone.bookmarkDetails_iPhone;

		if (bookmarksDetailsView) {
			[bookmarksDetailsView  popToLastView];
		}
		
		[bookmarksDetailsView setClinicDetailView];
	}
	// ************************call on notes************************
    
	else if(appDelegate.clinicsDetails==kTAB_NOTES){
		NotesDetailsViewController_iPhone    *noteDetails=(NotesDetailsViewController_iPhone*)appDelegate.rootView_iPhone.noteLists_iPhone.noteDetailsView_iPhone;
		if (noteDetails) {
			[noteDetails  popToLastView];
		}
		
		[noteDetails setClinicDetailView];
		
	}

}


@end




