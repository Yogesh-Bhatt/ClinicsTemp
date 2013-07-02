//
//  WebViewController.h
//  Clinics
//
//  Created by Ashish Awasthi on 05/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleDataHolder.h"
#import <MessageUI/MessageUI.h>
#import "HighLightWebView.h"
#import "MenuOptionView.h"
#import "CustomSliderView.h"
#import "PDFHomeView.h"
#import "AddNotesView.h"
#import "AritcleListViewController.h"
@class AritcleListViewController;


@interface WebViewController : BaseViewController <UIWebViewDelegate, 
MFMailComposeViewControllerDelegate,UIScrollViewDelegate,AddNotesViewDelegate,MenuViewcallerDelegate,CustomsliderDelegate,UIDocumentInteractionControllerDelegate>
{
	// share 
	AddNotesView  *addNotesView;
	HighLightWebView        *m_webView;
    IBOutlet UIActivityIndicatorView *m_activity;
    UIBarButtonItem *m_BackButton;
    ArticleDataHolder *m_articleDataHolder;
	PDFHomeView  *pdfhomeview;
	UIImageView	 *singleImage;
	UIButton  *croosBtn;
    UIButton   *iBookPdfBtn;
	UIWebView   *imageWebView;
	NSMutableArray   *menuArr;
	NSMutableArray * articalSectioinDataList;
	MenuOptionView   *menuOBJ;
	CustomSliderView  *sliderView;
	UIImageView *bacKImageView;
	BOOL isThisAbstract;
  
	UIMenuController *thisMenuController;
	
	UIPopoverController  *m_popoverController;
	// all data reqired in AricleListView
	NSMutableArray  *m_ariticleData;
	IBOutlet UISearchBar  *searchBar;
	
	IBOutlet	 UIButton   *resizeButton;
	IBOutlet UILabel  *ariticleTitlelbl;
	IBOutlet  UIView  *optionImageView;
	IBOutlet UIButton  *bookmarksBtn;
	IBOutlet UIButton  *shareButton;
	IBOutlet UIButton  *searchButton;

	NSInteger  articleID;
	NSString   *aritcleInfoID;
	NSString   *doiLinkStr;
	AritcleListViewController  *articleListView;
	NSString  *firstHeadingId;
	 BOOL   hideMenuOption; // use jump to chapterName
	 UIPopoverController   *m_sharepopoverController;
     UIPopoverController   *m_TextIncreasePopOver;
    UIDocumentInteractionController   *docController;
	 NSString    *m_pdfPath;
    NSString     *sectionValueStr;
    
  
    
}


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
- (void)showPopOver:(id)sender;

-(IBAction)sharedButtonPress:(id)sender;
-(NSString*)getFilePathNameForArticleId:(NSString*)articleId andFileName:(NSString*)fileName;

-(void)handleIosVersionOrieantion;



// Show Aleer full text
-(void)loadHtmlFileAddNotes;
-(void)downloadAritcleShowFullText;
-(void)downloadFileFromServer:(NSString *)choiceString;
-(void)clickOncancelButton;
- (void) dismissPopoover;
-(void)hidAndShowBookmarksButton;
-(void)dismissPopOver;
-(void)scrollToTop;
- (void)dismissPopooverTeXtIncrease;
-(void)changeAddViewKeybordComeLandScape;
@end
