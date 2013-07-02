//
//  SharePopOverView.m
//  Clinics
//
//  Created by Azad Haider on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharePopOverView.h"


@implementation SharePopOverView
@synthesize delegate;
@synthesize m_doiLink;

@synthesize viewType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    NSArray *arr;
    NSArray *optionArr;
    arr = [NSArray arrayWithObjects:@"btn_white.png",@"btn_white.png",@"btn_white.png", nil];
    optionArr = [NSArray arrayWithObjects:@"Facebook",@"Twitter",@"Email", nil];
        int yCor = 5; 
        for (int i = 0; i<[arr count]; i++) {
            UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; 
             optionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
            [optionBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [optionBtn addTarget:self action:@selector(tabObOptionButton:) forControlEvents:UIControlEventTouchUpInside];
            [optionBtn setBackgroundImage:[UIImage imageNamed:[arr objectAtIndex:i]]forState:UIControlStateNormal]; 
            [optionBtn setTitle:[NSString stringWithFormat:@"%@",[optionArr objectAtIndex:i]] forState:UIControlStateNormal];
            optionBtn.tag = i;
            optionBtn.frame = CGRectMake(5, yCor, 272, 43);
            [self.view addSubview:optionBtn];
            yCor = yCor+48;
            
        }
    
    [super viewDidLoad];
}

-(void)tabObOptionButton:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag)
    {
        case 0:
            [self facebookButtonPressed:nil];
            break;
        case 1:
            [self twitterButtonPressed:nil];
            break;
        case 2:
            [self emailButtonPressed:nil];
            break;
        default:
            break;
    }
    if([delegate respondsToSelector:@selector(dismissPopoover)]){
        
        [delegate dismissPopoover];
    }

}

- (void) emailButtonPressed:(id)sender
{
	    
    if ([CGlobal checkNetworkReachabilityWithAlert])
    {
        if ([CGlobal isMailAccountSet])
        {
            MFMailComposeViewController  *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate =(id) self;
			[controller setSubject:@"TheClinics"];
            [controller setMessageBody:m_doiLink isHTML:NO];
			[self presentModalViewController:controller animated:YES];
            [controller release];	
        } 
    }
}

- (void)facebookButtonPressed:(id)sender
{
    
    if ([CGlobal checkNetworkReachabilityWithAlert])
    {
        if ([m_doiLink length]<=0) {
            m_doiLink = @"Clinics";
        }
        [FBShareManager sharedManager];
        [FBShareManager sharedManager].delegate = (id)self;
		[FBShareManager sharedManager].msg = m_doiLink;
        [[FBShareManager sharedManager] publishStreamWithoutDialogBox];
    }
}

- (void)twitterButtonPressed:(id)sender
{  
	if ([CGlobal checkNetworkReachabilityWithAlert])
    {
        if ([TWTweetComposeViewController canSendTweet]) {
            // Initialize Tweet Compose View Controller
            TWTweetComposeViewController *vc = [[TWTweetComposeViewController alloc] init];
            
            // Settin The Initial Text
            [vc setInitialText:m_doiLink];
            
            // Setting a Completing Handler
            [vc setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
                [self dismissModalViewControllerAnimated:YES];
            }];
            
            // Display Tweet Compose View Controller Modally
            [self presentViewController:vc animated:YES completion:nil];
            
        } else {
            // Show Alert View When The Application Cannot Send Tweets
            NSString *message = @"The application cannot send a tweet at the moment. This is because it cannot reach Twitter or you don't have a Twitter account associated with this device.";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
        }

    }
}

#pragma mark --
#pragma mark <MFMailComposeViewControllerDelegate> Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
	[self dismissModalViewControllerAnimated:YES];
    
    if(result == MFMailComposeResultSent)
    {
        [CGlobal showMessage:@"" msg:@"Mail message has been sent."];
    }
    else if (result == MFMailComposeResultSaved)
    {
        [CGlobal showMessage:@"" msg:@"Mail message has been saved."];
    }
}


#pragma mark --
#pragma mark <TwitterShareManagerDelegate>

-(void)twitterPostDidSuccess{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success"
                                                    message: @"Thank you for sharing."
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}


-(void)twitterPostDidFail{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
                                                    message: @"An error occurred while submitting your post. Please try again later."
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

#pragma mark --
#pragma mark <FBShareManagerDelegate>

-(void)facebookPostDidSuccess{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Success"
                                                    message: @"Thank you for sharing."
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}


-(void)facebookPostDidFail{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alert"
                                                    message: @"This is already shared."
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}


- (void)viewDidUnload
{
    self.delegate = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
