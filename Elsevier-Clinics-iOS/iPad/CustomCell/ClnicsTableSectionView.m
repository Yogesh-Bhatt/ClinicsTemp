//
//  ClnicsTableSectionView.m
//  Clinics
//
//  Created by Kiwitech on 10/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClnicsTableSectionView.h"
#import <QuartzCore/QuartzCore.h>
#import "ClinicsAppDelegate.h"

@implementation ClnicsTableSectionView

@synthesize m_lblTitle;

@synthesize delegate;
@synthesize section;
@synthesize disclosureButton;
@synthesize m_imgView;
@synthesize m_imgAccessoryImage;

+ (Class)layerClass {
    
    return [CAGradientLayer class];
}

- (void) initData
{
    if (self.delegate)
    {
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        
       
        // Create and configure the disclosure button.
        disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
       disclosureButton.frame = CGRectMake(0.0, 30.0, 35.0, 35.0);
        [disclosureButton addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disclosureButton];
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)dealloc
{
    RELEASE(m_imgAccessoryImage);
    RELEASE(m_imgView);

    RELEASE(m_lblTitle);
    [super dealloc];
}

-(IBAction)toggleOpen:(id)sender 
{    
	
	  [self toggleOpenWithUserAction:YES];

	 
    
}


-(void)toggleOpenWithUserAction:(BOOL)userAction 
{
    // Toggle the disclosure button state.
    disclosureButton.selected = !disclosureButton.selected;
	ClinicsAppDelegate  *appDelegate=(ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    if (userAction)
    {
        if (disclosureButton.selected) 
        {
			if (appDelegate.secetionOpenOrClose==0) {// section close
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) 
                [self.delegate sectionHeaderView:self sectionOpened:section];
			}
			else { //call if section open
				appDelegate.secetionOpenOrClose = 0;
				if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) 
					[self.delegate sectionHeaderView:self sectionClosed:section];
			}

        }
        else 
        {
			appDelegate.secetionOpenOrClose=0;
			if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) 
				[self.delegate sectionHeaderView:self sectionClosed:section];
        }
    }

    
}


@end
