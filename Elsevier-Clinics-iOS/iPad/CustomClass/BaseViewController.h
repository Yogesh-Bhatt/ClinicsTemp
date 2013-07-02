//
//  BaseViewController.h
//  WoltersKluwer
//
//  Created by Ashish Awasthi on 07/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DatabaseConnection.h"
@interface BaseViewController : UIViewController 
{
    UIImageView *m_imgView;
    UILabel     *m_lblTitle;
    UIButton    *m_btnBack;
    UIButton    *m_btnDone;
    UIButton    *m_btnPopOver;
    UIButton    *m_btnSearch;
    UIButton    *m_btnLogin;
    UIButton    *m_btnClose;
    UIButton    *m_btnArticleList;
	UIView      *backLodingview;
	UIButton    *m_Cancel;
	UIButton    *m_addclinicsBtn;

}
@property(nonatomic,retain)UIButton  *m_Cancel;
@property(nonatomic,retain)UIButton  *m_addclinicsBtn;
@property(nonatomic,retain) UILabel     *m_lblTitle;
@property(nonatomic,retain) UIButton    *m_btnDone;
@property(nonatomic,retain)  UIButton    *m_btnSearch;
@property(nonatomic,retain)UIButton    *m_btnPopOver;
@property(nonatomic,retain) UIImageView *m_imgView;
@property(nonatomic,retain)UIButton   *m_btnLogin;

- (IBAction) backButtonPressed:(id)sender;
- (IBAction) doneButtonPressed:(id)sender;
- (IBAction) popOverButtonPressed:(id)sender;
- (IBAction) searchButtonPressed:(id)sender;
- (IBAction) loginButtonPressed:(id)sender;
- (IBAction) closeButtonPressed:(id)sender;
- (IBAction) articleListButtonPressed:(id)sender;

- (void)hidePopOverButton;
- (void)showPopOverButton;
-(void)cancelButtonTab:(id)sender;
-(void)clickONAddClinicsButton:(id)sender;
-(void)saveYourSettingFollowedClinics;



@end
