//
//  PopWebView_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PopWebView_iPhone : UIView {
	
	UIWebView* webView;
	UIButton* closeButton; 
	IBOutlet UIActivityIndicatorView* activityIndicator;
}

@property (nonatomic, retain) IBOutlet UIButton* closeButton; 
@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) NSString* webURL; 

-(IBAction)onClickCloseButton:(UIButton*)button;
-(void)onChangingDeviceOrientation ;
@end