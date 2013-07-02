//
//  TabBarClass.h
//  Clinics
//
//  Created by Ashish Awasthi on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarClass.h"
#import <MessageUI/MessageUI.h>
#import "HomeEditorView.h"
#import "SharePopOverView.h"

@interface TabBarClass : UIViewController<UITabBarDelegate,FBShareManagerDelegate,MFMailComposeViewControllerDelegate,SharePopOverViewDelegate> {
    
	UITabBar    *tabbar;
    
    
	
}

@property(nonatomic,retain)UITabBar    *tabbar;
-(void)goToFeedBackView;



@end
