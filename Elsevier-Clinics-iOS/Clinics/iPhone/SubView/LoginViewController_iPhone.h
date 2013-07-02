//
//  LoginViewController_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <UIKit/UIKit.h>
#import "LoadingViewLogin_IPhone.h"
#import "ASIHTTPRequest.h"
#import "NSData+AESCrypt.h"
#import "NSString+AESCrypt.h"

@interface LoginViewController_iPhone : UIViewController<UITextFieldDelegate> 
{  
    IBOutlet UITextField  *userNameTxt;
	IBOutlet UITextField *passwordtxt;
    
	IBOutlet UIButton   *loginBtn;
	IBOutlet UISwitch   *switchBtn;
	NSString  *downLoadUrl;
	id         viewController;
	BOOL       isItfirstRequest;
}
@property(nonatomic,retain)id  viewController;
@property(nonatomic,retain) UITextField *passwordtxt;
@property(nonatomic,retain)IBOutlet UITextField  *userNameTxt;
@property(nonatomic,retain)	NSString  *downLoadUrl;
@property(nonatomic,retain)IBOutlet UIButton  *cancelBtn;

-(void)clickOnLoginButton:(id)sender;
-(void)cliclOnRememberMe:(id)sender;
-(void)downloadFileFromServer:(NSString *)choiceString;

-(BOOL)loginTrueForAccessIssn:(NSArray *) issnDataArr;
-(void)rememberLastAccess:(NSArray *)issnArr;

@end

