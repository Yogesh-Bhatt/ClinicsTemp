//
//  FeedbackView.h
//  EWT
//
//  Created by Ashish Awasthi on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdfLoader.h"
#import "SKPSMTPMessage.h"
#import "ClinicsAppDelegate.h"
@interface FeedbackView : UIViewController  <UITextViewDelegate,SKPSMTPMessageDelegate>{
    
    IBOutlet UITextField *nameTextField;
  
    IBOutlet UITextView *messageTextView;
    IBOutlet UILabel *titleLabel;
    

     IBOutlet UIView  *m_leanView;
     IBOutlet UIView  *m_mailView;
     
    IBOutlet UIImageView *nameImage;
    IBOutlet UIImageView *emailImage;
    IBOutlet UIImageView *textImage;

    
    IBOutlet UILabel *namelbl;
    IBOutlet UILabel *emaillbl;
    IBOutlet UILabel *textbl;
	
    IBOutlet UIButton *submitButton;
    IBOutlet UIButton *CancelButton;
       
  IBOutlet  UITextField *emailTextField;
    id callerDelegate;
	
    DetailTypeView viewType;
}

@property (nonatomic, assign) id callerDelegate;
@property (nonatomic, assign) DetailTypeView viewType;


- (IBAction)onClickSubmitButton:(id)sender;
- (IBAction)onClickResetButton:(id)sender;
- (IBAction)onClickBackButton:(id)sender;
-(void)setViewMovedUp:(BOOL)movedUp;
-(void)handleIosVersionOrieantion;
@end
