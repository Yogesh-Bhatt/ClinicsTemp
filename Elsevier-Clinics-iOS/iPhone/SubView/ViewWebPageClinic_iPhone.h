//
//  ViewWebPageClinic_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewWebPageClinic_iPhone : UIView <UIWebViewDelegate>
{
    UIImageView *navBar;
    UIButton *doneBtn; 
    NSString *url;
    UIView  *actView;
    UIActivityIndicatorView *activityIndct;
}

@property(nonatomic,retain)NSString *url;
@property(nonatomic,retain)UIButton *doneBtn;
-(void)loadWeb;
-(void) orientationChanged:(UIInterfaceOrientation )orientation;
-(void)newView:(CGRect)frm;
@end
