//
//  TabBarHomeView_iPhone.h
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>






@interface TabBarHomeView_iPhone : UIViewController<UITabBarDelegate> {
	UITabBar    *h_Tabbar;
	id m_parentRootVC;
}
@property(nonatomic,retain)UITabBar    *h_Tabbar;
@property (nonatomic, assign) id                m_parentRootVC;
@end

