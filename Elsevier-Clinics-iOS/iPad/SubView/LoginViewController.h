//
//  LoginViewController.h
//  Clinics
//
//  Created by Ashish Awasthi on 27/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewlogin.h"
#import "ASIHTTPRequest.h"
#import "NSData+AESCrypt.h"
#import "NSString+AESCrypt.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate> 

{   IBOutlet UITextField  *userNameTxt;
	IBOutlet UITextField *passwordtxt;
    IBOutlet UIButton  *cancelBtn;
	IBOutlet UIButton   *loginBtn;
	IBOutlet UISwitch   *switchBtn;
	NSString  *downLoadUrl;
	
	BOOL  loginflag;
}
@property(nonatomic,retain) UITextField *passwordtxt;
@property(nonatomic,retain)IBOutlet UITextField  *userNameTxt;
@property(nonatomic,retain)	NSString  *downLoadUrl;
@property(nonatomic,retain)UIButton  *cancelBtn;

-(void)clickOnLoginButton:(id)sender;
-(void)downloadFileFromServer:(NSString *)choiceString;
-(void)rememberLastAccess:(NSArray *)issnDataArr;
-(BOOL)loginTrueForAccessIssn:(NSArray *) issnDataArr;
@end
