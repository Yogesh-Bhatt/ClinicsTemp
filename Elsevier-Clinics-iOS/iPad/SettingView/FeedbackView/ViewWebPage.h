//
//  ViewWebPage.h
//  EWT
//
//  Created by Ashish Awasthi on 28/07/11.
//  Copyright 2011 Kiwitech corp. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewWebPage : UIView <UIWebViewDelegate>
{
    UIImageView *navBar;
    UIButton *doneBtn; 
    NSString *url;
    UIView  *actView;
    UIActivityIndicatorView *activityIndct;
    UIView * backGroundView;
}

@property(nonatomic,retain)NSString *url;
@property(nonatomic,retain)UIButton *doneBtn;

-(void)loadWeb;
-(void) orientationChanged:(UIInterfaceOrientation )orientation;
-(void)newView:(CGRect)frm;
-(void)networkConnection;
@end
