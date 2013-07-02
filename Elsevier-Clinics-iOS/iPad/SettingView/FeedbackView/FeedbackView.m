//
//  FeedbackView.m
//  EWT
//
//  Created by Ashish Awasthi on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedbackView.h"
#import <CFNetwork/CFNetwork.h>
#import "CGlobal.h"
#import "NSData+Base64Additions.h"
#import "LoadingView.h"

@implementation FeedbackView
@synthesize  callerDelegate,viewType ;


#define kOFFSET_FOR_KEYBOARD 250.0;

-(void)awakeFromNib {
	
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView isEqual:messageTextView])
    {
            }
}

//*************** method to move the view up/down whenever the keyboard is shown/dismissed***************
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; 
    
    CGRect rect = self.view.frame;
    
    if ([CGlobal isOrientationLandscape]) {
        if (movedUp)
        {
            rect.origin.y -= kOFFSET_FOR_KEYBOARD;
            rect.size.height += kOFFSET_FOR_KEYBOARD;
        }
        else
    {
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)keyboardWillShow:(NSNotification *)notif
{
    
}


- (void)viewWillAppear:(BOOL)animated
{
    // ***************register for keyboard notifications***************
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification object:self.view.window]; 
}

- (void)viewWillDisappear:(BOOL)animated
{
    // ***************unregister for keyboard notifications while not visible.***************
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   
     [self handleIosVersionOrieantion];
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;{
    [self handleIosVersionOrieantion];
}

-(void)handleIosVersionOrieantion{
    
    
    if ([CGlobal isOrientationPortrait]) {
        m_leanView.frame = CGRectMake(0, 0, 768, 1024);
        m_mailView.frame = CGRectMake(0, 0, 768, 1024);
        for (UIView *ViewOne in [m_mailView subviews]) {
            
            if (ViewOne.tag == 1008 && [ViewOne isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)ViewOne;
                imageView.frame = CGRectMake(80, 168, 655, 580);
                imageView.image= [UIImage imageNamed:@"textinputportrait.png"];
            }
            
            if (ViewOne.tag == 1009 && [ViewOne isKindOfClass:[UITextView class]]) {
                UITextView *testView = (UITextView *)ViewOne;
                testView.frame = CGRectMake(80, 172, 650, 590);
            }
            
            
        }
        
    }
    
    else{
        m_leanView.frame = CGRectMake(0, 0, 1024, 768);
        m_mailView.frame = CGRectMake(120, 0, 768, 768);
        
        for (UIView *ViewOne in [self.view subviews]) {
            if (ViewOne.tag == 1008 && [ViewOne isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)ViewOne;
                imageView.frame = CGRectMake(80, 168, 655, 250);
                imageView.image= [UIImage imageNamed:@"textinputlansscape.png"];
            }
            
            if (ViewOne.tag == 1009 && [ViewOne isKindOfClass:[UITextView class]]) {
                UITextView *testView = (UITextView *)ViewOne;
                testView.frame = CGRectMake(84, 172, 645, 240);
            }
            
        }
    }
	
    m_leanView.backgroundColor = [UIColor blackColor];
    m_leanView.alpha = 0.8;
    
}

// ios 6  Orieation methods.........

-(BOOL)shouldAutorotate
{
    // //NSLog(@" %@ of class   %@ ", NSStringFromSelector(_cmd), self);
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations

{
    [self handleIosVersionOrieantion];
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
    
}


// ios 6  Orieation methods.........


- (void)dealloc
{
   

    self.callerDelegate = nil;
    [super dealloc];
}

-(void)viewDidLoad {
    
    messageTextView.delegate =  self;
    [messageTextView becomeFirstResponder];

}

- (IBAction)onClickSubmitButton:(id)sender {
    
    submitButton.userInteractionEnabled =FALSE;
    CancelButton.userInteractionEnabled = FALSE;
    [nameTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [messageTextView resignFirstResponder];
    
    if([nameTextField.text length] == 0 || [emailTextField.text length] == 0 || [messageTextView.text length] == 0){
         CancelButton.userInteractionEnabled = TRUE;
         submitButton.userInteractionEnabled = TRUE;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill all the fields."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];  
        [alert release];
        return;
    }
    NSString *bodyString = nil;
    
    bodyString=@"<html><body><br><table border-width='3px'>";
    
    bodyString=[bodyString stringByAppendingFormat:@"<tr><td>Name&nbsp;:&nbsp;&nbsp;</td><td>%@</td></tr>",nameTextField.text];
    bodyString=[bodyString stringByAppendingFormat:@"<tr><td>Email&nbsp;Address&nbsp;:&nbsp;&nbsp;</td><td>%@</td></tr>",emailTextField.text];
    bodyString=[bodyString stringByAppendingFormat:@"<tr><td valign=\"top\">Message&nbsp;:</td><td>%@</td></tr>",messageTextView.text];

    SKPSMTPMessage *test_smtp_message = [[SKPSMTPMessage alloc] init];
    test_smtp_message.fromEmail = @"testingelsevier@gmail.com";
    test_smtp_message.toEmail = @"allclinicsonline@elsevier.com"  ;
    test_smtp_message.relayHost = @"smtp.gmail.com";
    test_smtp_message.requiresAuth = TRUE;
    test_smtp_message.login = @"testingelsevier@gmail.com";
    test_smtp_message.pass = @"elsevier";
    test_smtp_message.wantsSecure = true; 
    test_smtp_message.subject = @"Clinics";
	
    test_smtp_message.delegate = self;
    
    NSMutableArray *parts_to_send = [NSMutableArray array];
    
            
    NSDictionary *plain_text_part = [NSDictionary dictionaryWithObjectsAndKeys:@"text/html",kSKPSMTPPartContentTypeKey,bodyString
                                     ,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    [parts_to_send addObject:plain_text_part];
    
    
    test_smtp_message.parts = parts_to_send;
    
    [test_smtp_message send];
}



#pragma mark SKPSMTPMessage Delegate Methods

- (void)messageSent:(SKPSMTPMessage *)SMTPmessage
{
    [SMTPmessage release];
	
   CancelButton.userInteractionEnabled = TRUE;
     submitButton.userInteractionEnabled = TRUE;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Sent" message:@"Thank you for your feedback."
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];  
    [alert release];
    
    //NSLog(@"delegate - message sent");
	
}
- (void)messageFailed:(SKPSMTPMessage *)SMTPmessage error:(NSError *)error
{
    CancelButton.userInteractionEnabled = TRUE;
     submitButton.userInteractionEnabled = TRUE;
    [SMTPmessage release];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription]
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];    
    [alert release];
    //NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
     CancelButton.userInteractionEnabled = TRUE;
     submitButton.userInteractionEnabled = TRUE;
    [self performSelector:@selector(onClickBackButton:)  withObject:nil afterDelay:0.0];
}


- (IBAction)onClickResetButton:(id)sender {
    
    nameTextField.text = nil;
    emailTextField.text = nil;
    messageTextView.text = nil;
}

- (IBAction)onClickBackButton:(id)sender {
    
    submitButton.userInteractionEnabled = TRUE;
     CancelButton.userInteractionEnabled = TRUE;
   
    [self  dismissModalViewControllerAnimated:YES];
	
	
}
@end
