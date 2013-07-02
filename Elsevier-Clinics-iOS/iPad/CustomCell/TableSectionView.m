//
//  TableSectionView.m
//  Clinics
//
//  Created by Kiwitech on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableSectionView.h"

#import "DatabaseConnection.h"
@implementation TableSectionView

@synthesize m_lblTitle;
@synthesize  ariticleButton;
@synthesize issueButton;
@synthesize seletedBtn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
    if (self) 
    {
			
		
		
    }
    return self;
}


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder{
	
	self = [super initWithCoder:aDecoder];
    if (self) 
    {
		ariticleButton=[UIButton buttonWithType:UIButtonTypeCustom];
		ariticleButton.frame=CGRectMake(395, 1,  101, 30);
		[self addSubview:ariticleButton];
		
		issueButton=[UIButton buttonWithType:UIButtonTypeCustom];
		issueButton.frame=CGRectMake(295, 1,  101, 30);
	    [self addSubview:issueButton];
		seletedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
		if ([CGlobal isOrientationPortrait]) {
		seletedBtn.frame=CGRectMake(648, 1,  116, 30);	
		}
		else {
			seletedBtn.frame=CGRectMake(590, 1,  116, 30);	
		}

		
	    [self addSubview:seletedBtn];
		
    }
    return self;
	
}




-(void)changeImageOnclickButton:(BOOL)Flag{
	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
	if ([loginId intValue]==100) {
		[ariticleButton setBackgroundImage:[UIImage imageNamed:@"articleinpressselected.png"] forState:UIControlStateNormal];
		[issueButton setBackgroundImage:[UIImage imageNamed:@"allissuesunselected.png"] forState:UIControlStateNormal];
		
		}
	else {
		
		//allissuesunselected
		[ariticleButton setBackgroundImage:[UIImage imageNamed:@"articleinpressunselected.png"] forState:UIControlStateNormal];
		[issueButton setBackgroundImage:[UIImage imageNamed:@"allissuesselected.png"] forState:UIControlStateNormal];
	}

}
-(void)changeSelectAllImage:(NSInteger) section :(NSInteger)categoryID{	
	DatabaseConnection *database = [DatabaseConnection sharedController];
	NSInteger checked=[database retriveCategoryAllclinicSelected:[NSString stringWithFormat:@"Select checked  from tblClinic where CategoryID=%d",categoryID]];
	if (section == isOne) {
		if(checked != isOne) // All clinic this category are selected 
		[seletedBtn setBackgroundImage:[UIImage imageNamed:@"deselectall.png"] forState:UIControlStateNormal];
			else 
			[seletedBtn setBackgroundImage:[UIImage imageNamed:@"selectall.png"] forState:UIControlStateNormal];	
			
		
	  }
	else {
		if(checked != isOne) // All clinic this category are selected 
			[seletedBtn setBackgroundImage:[UIImage imageNamed:@"deselectall.png"] forState:UIControlStateNormal];
		else 
			[seletedBtn setBackgroundImage:[UIImage imageNamed:@"selectall.png"] forState:UIControlStateNormal];	
		
	}
}

- (void)dealloc
{
    RELEASE(m_lblTitle);
    
    [super dealloc];
}

@end
