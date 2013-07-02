//
//  SharePopOverView.h
//  Clinics
//
//  Created by Azad Haider on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FBShareManager.h"
#import <Twitter/Twitter.h>

@protocol SharePopOverViewDelegate <NSObject>

@optional
-(void)dismissPopoover;
@end

typedef enum {
    
    aboutView = 1,
    webView,

}comeFromSharePopover;

@interface SharePopOverView : UIViewController{
    
 
}
@property(nonatomic,assign)comeFromSharePopover viewType;
@property(nonatomic,copy)NSString   *m_doiLink;
@property(nonatomic,assign) id <SharePopOverViewDelegate> delegate;

- (void)emailButtonPressed:(id)sender;
- (void)facebookButtonPressed:(id)sender;
- (void)twitterButtonPressed:(id)sender;

@end
