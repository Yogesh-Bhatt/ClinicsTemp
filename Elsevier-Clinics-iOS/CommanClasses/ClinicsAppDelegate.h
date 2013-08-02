//
//  
//  Clinics
//
//  Created by Kiwitech on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController_iPhone.h"
#import "WebViewController_iPhone.h"
#import "LoginViewController_iPhone.h"
#import "RootViewController.h"
#import "LodingHomeView.h"
#import "HomeEditorView.h"
#import <StoreKit/StoreKit.h>
#import "DownloaderData.h"
#import "InstructionView_iPhone.h"

@interface ClinicsAppDelegate : NSObject <UIApplicationDelegate,DownloaderDataDelegate,InstructionView_iPhoneDelegate>
{
	
    RootViewController *m_rootViewController;
	id viewController;
	id  clinicDetailsView;
	id rootViewController;
	id  webViewController;
	id listbackIssueView;
    id homeEditorView;
	
	UIButton  *btnlogin;
	NSString  *seletedIssuneID;
	//use Ariclein press
	NSInteger  seletedClinicID;
	NSInteger clinicsDetails;
	NSString  *downLoadUrl;
	id ariticleListView;
	LoginViewController *loginView;
	NSInteger   firstCategoryID;
	NSInteger  CheckedClinic;
	NSInteger   previousTag;
	NSInteger    nextTag;
	NSString  *firstCategoryName;
	
	NSInteger  h_TabBarPrevTag;
	NSInteger  m_nCurrentTabTag;
	BOOL  aritcleListView;
	NSMutableDictionary   *lastSelectedClinicList;
	NSInteger  firstClinicID;
	BOOL openHTMLADDNoteOpenView;
	BOOL   login;
	NSInteger  secetionOpenOrClose;
	BOOL  clickONFullTextOrPdf;
	
	UIActivityIndicatorView   *activityIndicator;
	UIAlertView  *loadingAlert;
	BOOL checkexpireDateInApppurchase;
	NSInteger  authentication;
	BOOL  flagLoginOneAll;
	
	//iphone varibles
	NSInteger diveceType;
	RootViewController_iPhone   *rootView_iPhone;
	WebViewController_iPhone   *wewView_iPhone;
	LoginViewController_iPhone    *loginView_iPhone;
	ClinicsDetailsView_iPhone   *clinicsdeatils_iPhone;
    
    NowLoginIsTrue      nowLoginIsTrue;
    
    NSMutableArray *m_downloadArticlesArr;
    NSMutableArray *m_downloadedConnectionArr;
    
    InstructionView_iPhone *m_instructionView;
}
@property(nonatomic,retain) NSMutableArray *m_downloadedConnectionArr;
@property(nonatomic,retain) NSMutableArray *m_downloadArticlesArr;
@property(nonatomic,retain) id homeEditorView;
@property(nonatomic,assign)NSInteger  authentication;
@property(nonatomic,assign)BOOL  flagLoginOneAll;
@property(nonatomic,assign) BOOL checkexpireDateInApppurchase;
@property(nonatomic,assign)NSInteger  seletedClinicID;
@property(nonatomic,assign)NSInteger  secetionOpenOrClose;
@property(nonatomic,assign)BOOL   login;
@property(nonatomic,assign)BOOL openHTMLADDNoteOpenView;
@property(nonatomic,assign)NSInteger  firstClinicID;
@property(nonatomic,retain)NSMutableDictionary   *lastSelectedClinicList;
@property(nonatomic,assign)BOOL  aritcleListView;
@property(nonatomic,assign)NSInteger  h_TabBarPrevTag;
@property(nonatomic,assign)NSInteger  m_nCurrentTabTag;
@property(nonatomic,retain)NSString  *firstCategoryName;
@property(nonatomic,assign)	NSInteger  previousTag;;
@property(nonatomic,assign)	NSInteger nextTag;
@property(nonatomic,assign)	NSInteger  CheckedClinic;
@property(nonatomic,assign)NSInteger   firstCategoryID;
@property(nonatomic,retain)id listbackIssueView;
@property(nonatomic,retain)id ariticleListView;
@property(nonatomic,retain)NSString  *downLoadUrl;
@property(nonatomic,assign)NSInteger clinicsDetails;
@property(nonatomic,retain)NSString  *seletedIssuneID;
@property(nonatomic,retain)id  clinicDetailsView;
@property(nonatomic,assign)BOOL  clickONFullTextOrPdf;

@property(nonatomic,assign)TabOnLoiginButton          tabOnLoiginButton  ;   
@property(nonatomic,retain)id viewController;
@property(nonatomic,retain)id webViewController;
@property(nonatomic,retain)id rootViewController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet RootViewController *m_rootViewController;

// Iphone Controller

@property(nonatomic,retain)RootViewController_iPhone   *rootView_iPhone;
@property(nonatomic,retain)WebViewController_iPhone   *wewView_iPhone;
@property(nonatomic,retain)ClinicsDetailsView_iPhone   *clinicsdeatils_iPhone;
@property(nonatomic,assign)NSInteger  diveceType;

@property(nonatomic,strong) NSOperationQueue     *downloadQueue;

-(void)changeOrientatioLoginview;
-(void)releaseLoginView;
-(void)clickOnLoginButton:(id)sender;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void)transactionCanceled;
- (void)productPurchased:(NSString *)productId Reciept:(NSData*)reciept;
-(void)downloadFileFromServer:(NSString *)choiceString;
-(void)updateLast12MonthIssue:(BOOL)flag;
-(void)updateLast12MonthIssue:(NSArray *)clinicIdArr 
                     previousaDate:(NSString *)backDateDateStr 
                  currentDate:(NSString *)currentDateStr;
-(void)logOutForMutltipleAccess;

-(BOOL)isSubscriptionActive:(NSInteger)a_clinicId;
-(void)purchasedClinicWithID:(NSInteger)a_clinicid;


-(NSOperationQueue *)downloadQueue;
-(void)downLoadUpdateIssueInBackgound;
@end
