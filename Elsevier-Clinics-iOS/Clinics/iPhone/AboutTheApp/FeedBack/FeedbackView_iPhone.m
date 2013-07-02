//
//  FeedbackView_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 10/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "FeedbackView_iPhone.h"
#import <CFNetwork/CFNetwork.h>
#import "CGlobal.h"
#import "NSData+Base64Additions.h"
#import "LoadingView.h"
#import "ClinicsAppDelegate.h"


@implementation FeedbackView_iPhone

#define kOFFSET_FOR_KEYBOARD 100.0;


-(void)awakeFromNib {
	
}
// ************** Up  TestView ****************

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView isEqual:messageTextView])
    {
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    [self setViewMovedUp:NO];
}


//*************method to move the view up/down whenever the keyboard is shown/dismissed*************

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; 
    
    CGRect rect = self.view.frame;
    
    
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
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)keyboardWillShow:(NSNotification *)notif
{
    
    if ([messageTextView isFirstResponder] && self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (![messageTextView isFirstResponder] && self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
	
    // *************register for keyboard notifications*************
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification object:self.view.window]; 
}

- (void)viewWillDisappear:(BOOL)animated
{
    // *************unregister for keyboard notifications while not visible.*************
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}



- (void)dealloc
{
    [super dealloc];
}

-(void)viewDidLoad {
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
	
    return YES;
}

- (IBAction)onClickSubmitButton:(id)sender {
    
     cancelButton.userInteractionEnabled =FALSE;
     submitButton.userInteractionEnabled =FALSE;
    
    [nameTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [messageTextView resignFirstResponder];
    NSString   *nameStr ;
    nameStr = nameTextField.text;
    nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString   *textViewStr ;
    textViewStr = nameTextField.text;
    textViewStr = [textViewStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if([nameTextField.text length] == 0 || [emailTextField.text length] == 0 || [messageTextView.text length] == 0){
         submitButton.userInteractionEnabled =TRUE;
         cancelButton.userInteractionEnabled =TRUE;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill all the fields."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];  
        [alert release];
        return;
    }
    NSString *bodyString = nil;
    
    bodyString=@"<html><body><br><table border-width='3px'>";
    
    bodyString=[bodyString stringByAppendingFormat:@"<tr><td>Name&nbsp;:&nbsp;&nbsp;</td><td>%@</td></tr>",nameStr];
    bodyString=[bodyString stringByAppendingFormat:@"<tr><td>Email&nbsp;Address&nbsp;:&nbsp;&nbsp;</td><td>%@</td></tr>",emailTextField.text];
    bodyString=[bodyString stringByAppendingFormat:@"<tr><td valign=\"top\">Message&nbsp;:</td><td>%@</td></tr>",textViewStr];
    
    //testingelsevier@gmail.com
    SKPSMTPMessage *test_smtp_message = [[SKPSMTPMessage alloc] init];
    test_smtp_message.fromEmail = @"testingelsevier@gmail.com";
    test_smtp_message.toEmail = @"allclinicsonline@elsevier.com" ;
    test_smtp_message.relayHost = @"smtp.gmail.com";
    test_smtp_message.requiresAuth = TRUE;
    test_smtp_message.login = @"testingelsevier@gmail.com";
    test_smtp_message.pass = @"elsevier";
    test_smtp_message.wantsSecure = true; //************* smtp.gmail.com doesn't work without TLS!*************
    test_smtp_message.subject = @"Clinics";
    test_smtp_message.delegate = self;
    
    NSMutableArray *parts_to_send = [NSMutableArray array];
    
    //If you are not sure how to format your message part, send an email to your self.  
    //In Mail.app, View > Message> Raw Source to see the raw text that a standard email client will generate.
    //This should give you an idea of the proper format and options you need
	
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
    cancelButton.userInteractionEnabled =TRUE;
    submitButton.userInteractionEnabled =TRUE;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Sent" message:@"Thank you for your feedback."
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];  
    [alert release];
    
   
	
}
- (void)messageFailed:(SKPSMTPMessage *)SMTPmessage error:(NSError *)error
{
    [SMTPmessage release];
     cancelButton.userInteractionEnabled =TRUE;
    submitButton.userInteractionEnabled =TRUE;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription]
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];    
    [alert release];
    //NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    cancelButton.userInteractionEnabled =TRUE;
      submitButton.userInteractionEnabled =TRUE;
    [self performSelector:@selector(onClickBackButton:)  withObject:nil afterDelay:0.0];
}




- (IBAction)onClickBackButton:(id)sender {
    
     cancelButton.userInteractionEnabled =TRUE;
      submitButton.userInteractionEnabled =TRUE;
    ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.navigationController  dismissModalViewControllerAnimated:YES];
	
}
@end
