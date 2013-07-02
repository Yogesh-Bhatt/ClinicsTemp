//
//  TabBarClassHomeView.h
//  Clinics
//
//  Created by Ashish Awasthi on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TabBarClassHomeView : UIViewController<UITabBarDelegate> {
UITabBar    *h_Tabbar;
id m_parentRootVC;
}
@property(nonatomic,retain)UITabBar    *h_Tabbar;
@property (nonatomic, assign) id                m_parentRootVC;
@end
