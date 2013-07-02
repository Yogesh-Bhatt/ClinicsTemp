//
//  WebViewController_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "TextViewPopover_iPhone.h"
#import "ArticleDataHolder.h"
#import <MessageUI/MessageUI.h>
#import "HighLightWebView.h"
#import "MenuOptionView.h"
#import "CustomSliderView.h"
#import "PDFHomeView.h"
#import "AddNotesView_iPhone.h"
#import "AritcleListViewController_iPhone.h"
@class AritcleListViewController_iPhone;
// share AP
#import "FBShareManager.h"


@interface WebViewController_iPhone :UIViewController <UIWebViewDelegate,FBShareManagerDelegate, 
MFMailComposeViewControllerDelegate,UIScrollViewDelegate,AddNotesView_iPhoneDelegate,MenuViewcallerDelegate,CustomsliderDelegate,UIDocumentInteractionControllerDelegate>
{
	// share 
	AddNotesView_iPhone  *addNotesView_iPhone;
	HighLightWebView        *m_webView;
    IBOutlet UIActivityIndicatorView *m_activity;
    UIBarButtonItem *m_BackButton;
    ArticleDataHolder *m_articleDataHolder;
	

	PDFHomeView  *pdfhomeview;
	UIImageView	 *singleImage;
	UIButton  *croosBtn;
	UIWebView   *imageWebView;
	NSMutableArray   *menuArr;
	NSMutableArray * articalSectioinDataList;
	MenuOptionView   *menuOBJ;
	
	UIImageView *bacKImageView;
	BOOL isThisAbstract;
	
	UIPopoverController  *m_popoverController;

	NSMutableArray  *m_ariticleData;
	IBOutlet UISearchBar  *searchBar;
	
	IBOutlet	 UIButton   *resizeButton;
	IBOutlet UILabel  *ariticleTitlelbl;
	IBOutlet  UIView  *optionImageView;
	IBOutlet UIButton  *bookmarksBtn;
	IBOutlet UIButton  *shareButton;
	IBOutlet UIButton  *searchButton;
	
	UIButton  *loginButton;
	UIButton  *closeButton;
	UIButton  *optionButton;
	UIButton   *tocButton;
    BOOL	hideMenuOption;
	NSInteger  articleID;
	NSString   *aritcleInfoID;
	NSString   *doiLinkStr;
    NSString  * firstHeadingId;
    TextViewPopover_iPhone *m_shareView;
	AritcleListViewController_iPhone  *aricleToCView;
    UIButton  *iBookPdfBtn;
    UIDocumentInteractionController   * docController;
	NSString    *m_pdfPath;
}

@property(nonatomic,retain)AritcleListViewController_iPhone  *aricleToCView;
@property(nonatomic, retain)ArticleDataHolder *m_articleDataHolder;
@property(nonatomic,retain)NSMutableArray  *m_ariticleData;
 @property(nonatomic,assign) whichOptionYouwantToSee  textType;
-(void)checkAndPushToImageThumbsForImageName:(NSString *)ImageName;
-(void)openPDFfile:(ArticleDataHolder *)articleDataHolder;
-(void)openHTMLfile:(ArticleDataHolder *)articleDataHolder;
-(void)openAbstrauct:(ArticleDataHolder *)articleDataHolder;

-(IBAction)clickOnResizeButton:(id)sender;
-(void)jumpToSection:(NSString*)sectionTagValue;
- (IBAction)bookmarkButtonPressed:(id)sender;
-(IBAction)clickONSearchButton:(id)sender;
-(void)clickOnOptionButton:(id)sender;

-(IBAction)sharedButtonPress:(id)sender;
-(NSString*)getFilePathNameForArticleId:(NSString*)articleId andFileName:(NSString*)fileName;

// share method
- (IBAction)twitterButtonPressed:(id)sender;
- (IBAction) facebookButtonPressed:(id)sender;
- (IBAction) emailButtonPressed:(id)sender;
-(void)setNavigationBarOnThisView;

// Show Aleer full text
-(void)loadHtmlFileAddNotes;
-(void)downloadAritcleShowFullText;
-(void)downloadFileFromServer:(NSString *)choiceString;
-(void)clickOncancelButton;
- (void) dismissPopoover;
-(void)changeImageLoginButton;
-(void)hidAndShowBookmarksButton;
-(void)scrollToTop;
@end

