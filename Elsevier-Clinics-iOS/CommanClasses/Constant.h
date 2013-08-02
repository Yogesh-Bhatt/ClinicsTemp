//
//  Constant.h
//  WoltersKluwer
//
//  Created by Kiwitech on 06/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//




#define RELEASE(_obj) if(_obj != nil) [_obj release], _obj = nil

#define kDOCUMENT_DIR		[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//******************** Alert Message **********************

#define KAlertMessageArticleInPressKey  @"This clinic has no articles in press."
#define  KOnlyInAppAlertMsgKey                   @"Do you want to purchase this clinic?"
#define  KInAppAndLoginAlertMsgKey           @"Access full text and PDF by either purchasing a Clinics subscription or logging in to an existing account."
#define  KLoginSuccessNotHaveAccessMsgKey   @"You have no paid clinics subscriptions. Purchase an in-app subscription to continue."           
#define isOne  1
#define isTwo  2
#define isThere 3
#define isFivehundred  500 
#define ishundred  100 
#define commomLogin 

#define GoogleAnalyticsID    @"UA-25020697-3"
#define KCommanLoginStrKey   @"1876-2751"
#define KMultipleLoginKey    @"RememberMutltipleLogin"
#define KisItLoginKey        @"isItLogin" 

#define kDATABASE_NAME       @"Clinics_DB.sqlite"
#define kNewDATABASE_NAME       @"NewClinics_DB.sqlite"

/*
//live urls
#define dwonlodaUrl                     @"http://208.109.209.216/clinics.test/files/"
#define selectedClinics                 @"http://208.109.209.216/clinics/fetchclinic.php?clinicid="
#define kdownloadIssue                  @"http://208.109.209.216/clinics/fetchissue.php?issueid="
#define kcheckupdateIssue               @"http://208.109.209.216/clinics/fetchissuecount.php?"
#define kdwonloadUpadteIssue            @"http://208.109.209.216/clinics/fetchissuelist.php?clinicid="
#define kdwonloadAricleInPress          @"http://208.109.209.216/clinics/fetchaiplist.php?clinicid="
#define  kdwonloadAllUpdateIssue        @"http://208.109.209.216/clinics/fetchissuelistv2.php?"
#define  KcurrentDataURL                @"http://208.109.209.216/clinics/fetchdbdate.php"

#define  KSubcriptionUpdateUrl               @"http://208.109.209.216/clinics.test/subscribe.php?deviceId="
#define  KIsItHaveSubcriptionUrl             @"http://208.109.209.216/clinics.test/verify_subscription.php?deviceId="

// login info 
#define SERVERBASEURL    @"https://services.healthadvance.com/JournalServices"
#define IssueImageUrl    @"http://208.109.209.216/clinics.test/files/cover/"

*/



 //development urls
 #define dwonlodaUrl                     @"http://208.109.209.216/clinics.test/files/"
 #define selectedClinics                 @"http://208.109.209.216/clinics.test/fetchclinic.php?clinicid="
 #define kdownloadIssue                  @"http://208.109.209.216/clinics.test/fetchissue.php?issueid="
 #define kcheckupdateIssue               @"http://208.109.209.216/clinics.test/fetchissuecount.php?"
 #define kdwonloadUpadteIssue            @"http://208.109.209.216/clinics.test/fetchissuelist.php?clinicid="
 #define kdwonloadAricleInPress          @"http://208.109.209.216/clinics.test/fetchaiplist.php?clinicid="
 #define  kdwonloadAllUpdateIssue        @"http://208.109.209.216/clinics.test/fetchissuelistv2.php?"
 #define  KcurrentDataURL                @"http://208.109.209.216/clinics.test/fetchdbdate.php"
 
 #define  KSubcriptionUpdateUrl               @"http://208.109.209.216/clinics/subscribe.php?deviceId="
 #define  KIsItHaveSubcriptionUrl             @"http://208.109.209.216/clinics/verify_subscription.php?deviceId="
 
 // login info
 #define SERVERBASEURL    @"https://services.healthadvance.com/JournalServices"
 #define IssueImageUrl    @"http://208.109.209.216/clinics.test/files/cover/"


#define SYMMETRICKEY   @"TVQYOXzYtbttR7SxGQ/YiQ=="
#define CONSUMERID     @"Q1R2x66b3IZle6iT5XnvpWGZcMfKYW8G2FB8baY8BGw="
#define LoginClinics    49
#define kFONT_SIZE          12.0

#pragma mark ------------------------------------
#pragma mark <TabBar Item Tags>

#define kTAB_CLINICS    1
#define kTAB_BOOKMARKS  2
#define kTAB_NOTES      3
#define kTAB_EXTRAS     4
#define kTAB_AboutApp   5
#define kTAB_WebView    6
#pragma mark ------------------------------------
#pragma mark <Images Name>

#define kIMG_TOP_BAR        @"TopNavigationBar.png"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#pragma mark ------------------------------------
#pragma mark <VC FRAME SIZE>

#define kLIST_VC_SIZE_WIDTH     320.0
#define kLIST_VC_SIZE_HEIGHT    748.0

#define kDETAIL_VC_SIZE_WIDTH   768.0
#define kDETAIL_VC_SIZE_HEIGHT  1024.0

// tag AlertView





#define NSLog if(0)NSLog

#define PScreenHeight   1024
#define PScreenWidth    768 
#define LScreenHeight   768
#define LScreenWidth    1024

#define TabbarBottomButtonClickedNotification @"TabbarBottomButtonClickedNotification"
#define NEXT_ARTICLE_SHOULD_DISPLAY @"nextarticleshoulddisplay"
#define PREVIOUS_ARTICLE_SHOULD_DISPLAY @"previousarticleshoulddisplay"
#define Font_Change_Notification @"Font_Change_Notification"
#define Issue_Detail_View_Type_Change @"Issue_Detail_View_Type_Change"
#define EnableArticlesButtonNotification @"EnableArticlesButtonNotification"
#define EnableFontButtonNotification @"EnableFontButtonNotification"
#define ShowTOCorAIPNotification @"ShowTOCorAIPNotification"
#define DeviceOrienationChangedNotification @"DeviceOrienationChanged"
#define IssueCellHeight  117
#define EditorBoardHeading @"European Urology"
#define TotalNumberOfMainButtons  5  

BOOL isPortrait;
BOOL isResizeButtonShrink;
BOOL isArticleInPressContentShown;
BOOL isIssueContentShown;
BOOL shouldShown;
short fontSize;
BOOL isShownOldBackDateMessage;

typedef enum {
    AbstractTextView = 1,
    FullTextView,
    PDFTextView,
    EditorView,
    AimAndScopeView,
    ArticleInPressView,
    FactsAndFiguresView,
    SubmitAnArticleView,
    SocietyView,
    LegalDisclaimerView,
    ContactView,
    FeedbackMailView,
    SupportView,
    TermsAndConditionView,
}DetailTypeView;
typedef enum 
{    
    CategoryOpen = 1,
	CategoryClose = 2
}  CategoryOpenOrClose;


typedef enum {
    
    addClinics = 1,
    dwonloadissue,
    dwonloadupdateissue,
    dwonloadArticle,
    dwonloadArticleInPress,
    dwonloadAbstruct,
    
    
}ComeFromLoadingView;

typedef enum {
    LoginButton = 1,
    HTMLORPDF,
}TabOnLoiginButton;

typedef enum {
    FullText = 1,
    AbstractText,
    PdfText,
}whichOptionYouwantToSee;

typedef enum {
    
    reloadClinics = 1,
    reloadDownloadedArticles
    
}ReloadArticleType;

ReloadArticleType    reloadArticleType;


typedef enum {
    LoginYes = 1,
    LoginNo,
}NowLoginIsTrue;

typedef enum {
    clickRestore = 1,
    clickBuy,
    clickBulkBuy
}RestoreBuyCheck;
RestoreBuyCheck    restoreBuyCheck;

#define    KFirstLunchKey  @"FirstLunch"
#define    KNextLunchKey   @"NextLunch"
#define    KFirstLunchSettingKey  @"FisrtLunchSetting"

NSInteger m_numberOfDownload;


// New Issues Badge Constants

#define    KNewIssuesInserted        @"NewIssuesInserted"
#define    KNewIssue                 @"NewIssue"

#define    KClinicsID                @"clinics_id"
#define    KIssueID                  @"issue_id"



