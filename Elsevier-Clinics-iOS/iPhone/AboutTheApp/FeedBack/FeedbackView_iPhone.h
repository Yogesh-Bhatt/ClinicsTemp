//
//  FeedbackView_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <UIKit/UIKit.h>
#import "PdfLoader.h"
#import "SKPSMTPMessage.h"

@interface FeedbackView_iPhone : UIViewController  <UITextViewDelegate,SKPSMTPMessageDelegate>{
    
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextView *messageTextView;
    
    IBOutlet UIButton *submitButton;
    IBOutlet UIButton *cancelButton;
    
}

- (IBAction)onClickSubmitButton:(id)sender;
- (IBAction)onClickBackButton:(id)sender;
-(void)setViewMovedUp:(BOOL)movedUp;
-(void)onClickBackButton:(id)sender;
@end
