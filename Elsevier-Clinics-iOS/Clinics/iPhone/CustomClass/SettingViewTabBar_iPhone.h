//
//  SettingViewTabBar_iPhone.h
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "SettingViewTabBar_iPhone.h"
#import <MessageUI/MessageUI.h>
#import "FBShareManager.h"

@interface SettingViewTabBar_iPhone : UIViewController<UITabBarDelegate,FBShareManagerDelegate,MFMailComposeViewControllerDelegate> {
	UITabBar    *tabbar;
}
@property(nonatomic,retain)UITabBar    *tabbar;
- (IBAction) facebookButtonPressed:(id)sender;
- (IBAction) emailButtonPressed:(id)sender;
- (IBAction)twitterButtonPressed:(id)sender;
-(void)goToFeedBackView;
@end

