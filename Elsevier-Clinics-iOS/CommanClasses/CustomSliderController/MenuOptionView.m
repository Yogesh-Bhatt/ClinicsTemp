//
//  MenuOptionView.m
//  Elsevier
//
//  Created by Yogesh Bhatt on 03/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuOptionView.h"
#import "ReferenceData.h"
#import "CustomScrollView.h"
#import "ClinicsAppDelegate.h"

@implementation MenuOptionView

@synthesize delegate;


- (id)initWithFrame:(CGRect)frame Buttons:(NSMutableArray*)arr {
    
    self = [super initWithFrame:frame];
	
    if (self) {
        // Initialization code.
		
    //self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
		UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 59)];
		backImage.tag = 333;
		backImage.userInteractionEnabled = YES;
		backImage.image = [UIImage imageNamed:@"option_bg_ipad.png"];
		[self addSubview:backImage];
		[backImage release];
	}
	
    return self;
}

- (void) btnClicked:(id)sender {
	
	UIButton *btn = sender;
    // *****************jump To next Scetion Heading *****************
	if([delegate respondsToSelector:@selector(jumpToSectionTag:)])
		[delegate jumpToSectionTag:[[arrList objectAtIndex:btn.tag]Section_id]];
}

- (void) addOptions:(NSMutableArray*)arr {
	ClinicsAppDelegate   *appDelegate=[UIApplication sharedApplication].delegate;
	NSInteger xCoodinate = 10;

	NSInteger yCoodinate = 10;
	
	arrList = arr;
	CustomScrollView *scrollView;
	if (appDelegate.diveceType == 1) {
     scrollView = [[CustomScrollView  alloc] initWithFrame:CGRectMake(0, 0, 1024, 59)];
	}else {
		scrollView = [[CustomScrollView  alloc] initWithFrame:CGRectMake(0, 0, 320, 59)];
	}

	//scrollView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
	[self addSubview:scrollView];
	

	for (int i = 0; i < [arr count]; i++) {
		
		CGSize expectedLabelSize = [[NSString stringWithFormat:@"%@,", [[arr objectAtIndex:i]section_Title]] sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(530.0, 40.0)  lineBreakMode:UILineBreakModeWordWrap]; 
		
		btnMenuOptions = [UIButton buttonWithType:UIButtonTypeCustom];
		btnMenuOptions.tag = i;
		btnMenuOptions.frame = CGRectMake(xCoodinate, yCoodinate, expectedLabelSize.width, 40);
		[btnMenuOptions addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
		[btnMenuOptions setBackgroundImage:[UIImage imageNamed:@"blank_image.png"] forState:UIControlStateNormal];
		btnMenuOptions.titleLabel.font = [UIFont systemFontOfSize:14.0];
		[btnMenuOptions setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[btnMenuOptions setTitle:((ReferenceData *)[arr objectAtIndex:i]).section_Title forState:UIControlStateNormal];
		[scrollView addSubview:btnMenuOptions];
		
		xCoodinate += expectedLabelSize.width + 10;
	}
	// add demy condition
	if ([arr count]<=0) {
		btnMenuOptions = [UIButton buttonWithType:UIButtonTypeCustom];
		btnMenuOptions.tag = 0;
		btnMenuOptions.frame = CGRectMake(480, yCoodinate, 100, 40);
		//[btnMenuOptions addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
		[btnMenuOptions setBackgroundImage:[UIImage imageNamed:@"blank_image.png"] forState:UIControlStateNormal];
		btnMenuOptions.titleLabel.font = [UIFont systemFontOfSize:14.0];
		[btnMenuOptions setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[btnMenuOptions setTitle:@"No Object" forState:UIControlStateNormal];
		[scrollView addSubview:btnMenuOptions];
		
	}
	[scrollView setContentSize:CGSizeMake(xCoodinate, 59)];
	
	if (appDelegate.diveceType == 1) {
	if (xCoodinate < 1024) {
		CGRect scrollFrame = scrollView.frame;
		scrollFrame.origin.x = (1024-xCoodinate)/2;
		scrollFrame.size.width = xCoodinate;
		scrollView.frame = scrollFrame;
	}
	}
	else {
		if (xCoodinate < 320) {
		CGRect scrollFrame = scrollView.frame;
		scrollFrame.origin.x = (320-xCoodinate)/2;
		scrollFrame.size.width = xCoodinate;
		scrollView.frame = scrollFrame;
		}
	}

	[scrollView release];

}


- (void)checkOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		
	}
	else {
		
	}

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
	
}


@end
