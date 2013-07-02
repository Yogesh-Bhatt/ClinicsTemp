//
//  HomeEditorView_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 11/10/11.

//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewWebPageClinic.h"
#import"SettingViewTabBar_iPhone.h"

@interface HomeEditorView_iPhone :UIViewController<UIWebViewDelegate>{
    
	UIWebView     *myWebView;
	UIImageView   *imgBackground;
    DetailTypeView  viewType;
    NSString*   webURL;
    BOOL        isTermsandCondition;
	UILabel    *m_lblTitle;
	ViewWebPageClinic  *webview;
	UIButton    *btnClose;
	UIButton     *homeButton;
	SettingViewTabBar_iPhone  *tabbarView;
}

@property (nonatomic, assign)  DetailTypeView viewType;
-(void)pushToWebView:(NSString *)clickUrl;
-(void)removeSubViews;
-(void)ClickOnAboutOption:(NSInteger)indexpath;

@end

