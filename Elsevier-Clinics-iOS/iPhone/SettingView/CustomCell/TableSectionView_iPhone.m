//
//  TableSectionView_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


// Created by Ashish Awasthi on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableSectionView_iPhone.h"

#import "DatabaseConnection.h"
@implementation TableSectionView_iPhone

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
		ariticleButton.frame=CGRectMake(163, 0,  78, 25);
		[self addSubview:ariticleButton];
		
		issueButton=[UIButton buttonWithType:UIButtonTypeCustom];
		issueButton.frame=CGRectMake(85, 0,  78, 25);
	    [self addSubview:issueButton];
		seletedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
		if ([CGlobal isOrientationPortrait]) {
			seletedBtn.frame=CGRectMake(220, 0,  93, 24);	
		}
		else {
			seletedBtn.frame=CGRectMake(220, 0,  93, 24);	
		}
		
		
	    [self addSubview:seletedBtn];
		
    }
    return self;
	
}


-(void)changeImageOnclickButton:(BOOL)Flag{
    
	NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Flag"];
	if ([loginId intValue]==100) {
		[ariticleButton setBackgroundImage:[UIImage imageNamed:@"iPhone_ArticlesPressSelected_btn.png"] forState:UIControlStateNormal];
		[issueButton setBackgroundImage:[UIImage imageNamed:@"iPhone_TocUnselected_btn.png"] forState:UIControlStateNormal];
		
	}
	else {
		
		//******************** All issues Un Selected/********************
		[ariticleButton setBackgroundImage:[UIImage imageNamed:@"iPhone_ArticlesPressUnselected_btn.png"] forState:UIControlStateNormal];
		[issueButton setBackgroundImage:[UIImage imageNamed:@"iPhone_TocSelected_btn.png"] forState:UIControlStateNormal];
	}
	
}
-(void)changeSelectAllImage:(NSInteger) section :(NSInteger)categoryID{	
    
	DatabaseConnection *database = [DatabaseConnection sharedController];
	NSInteger checked=[database retriveCategoryAllclinicSelected:[NSString stringWithFormat:@"Select checked  from tblClinic where CategoryID=%d",categoryID]];
	if (section == 1) {
        
		if(checked == 0) {
            // *************************** All clinic this category are selected  **********************
			[seletedBtn setBackgroundImage:[UIImage imageNamed:@"iPhone_DeselectAll.png"] forState:UIControlStateNormal];
        }else {
			[seletedBtn setBackgroundImage:[UIImage imageNamed:@"iPhone_SelectAll.png"] forState:UIControlStateNormal];	
        }

    }else {
		if(checked == 0) {
            // *************************** All clinic this category are selected  **********************
			[seletedBtn setBackgroundImage:[UIImage imageNamed:@"iPhone_DeselectAll.png"] forState:UIControlStateNormal];
        }else {
            [seletedBtn setBackgroundImage:[UIImage imageNamed:@"iPhone_SelectAll.png"] forState:UIControlStateNormal];	
        }
    }
    
}

- (void)dealloc
{
    RELEASE(m_lblTitle);
    
    [super dealloc];
}

@end
