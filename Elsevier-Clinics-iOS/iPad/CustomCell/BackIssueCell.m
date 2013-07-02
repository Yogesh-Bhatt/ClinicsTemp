    //
//  BackIssueCell.m
//  Clinics
//
//  Created by Ashish Awasthi on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BackIssueCell.h"


@implementation BackIssueCell
@synthesize m_lblTitle;
@synthesize m_btnNumber;
@synthesize m_imgView;
@synthesize m_imgAccessoryImage;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}




- (void)dealloc {
    [super dealloc];
}


@end
