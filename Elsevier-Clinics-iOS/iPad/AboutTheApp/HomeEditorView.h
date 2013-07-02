//
//  HomeEditorView.h
//  Elsevier
//
//  Created by Ashish Awasthi on 20/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharePopOverView.h"

@class ViewWebPage;
@class PopWebView;

@interface HomeEditorView :UIViewController<UIWebViewDelegate,UIPopoverControllerDelegate,SharePopOverViewDelegate>{
    
	UIWebView *myWebView;
	UIImageView *imgBackground;
    DetailTypeView  viewType;
    NSString* webURL;
    BOOL isTermsandCondition;
	PopWebView* viewWebPage;
	UILabel *m_lblTitle;
	UIImageView  *m_imgView;
	UIPopoverController	 *m_popoverController;
    UIPopoverController  *m_sharePopOver;
}

@property (nonatomic, assign)  DetailTypeView viewType;
-(void)showFeedbackView;
-(void)pushToWebView;
-(void)removeSubViews;
-(void)ClickOnAboutOption:(NSInteger)indexpath;
-(void)btnCloseClicked:(id)sender;
-(void)changeOrientaionISHomeEditorView;
- (void)showPopOver;
- (void) dismissPopoover;
-(void)showSharePopOver;
@end
