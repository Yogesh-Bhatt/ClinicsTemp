//
//  LoaderView.m
//  AR
//
//  Created by Subhash Chand on 1/20/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import "LoaderView.h"


@implementation LoaderView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self setBackgroundColor:[UIColor colorWithRed:0.03 green:0.04 blue:0.05 alpha:0.6]];
		
		titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(100.0,(self.frame.size.height-70)/2+70.0 , (self.frame.size.width-200)/2, 60.0)];
		[titleLbl setBackgroundColor:[UIColor clearColor]];
		[titleLbl setTextAlignment:UITextAlignmentCenter];
		[titleLbl setTextColor:[UIColor whiteColor]];
		titleLbl.numberOfLines=2;
		[titleLbl setFont:[UIFont boldSystemFontOfSize:16]];
		[self addSubview:titleLbl];
		
		indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.frame.size.width-70)/2,(self.frame.size.height-70)/2,70,70)];
		indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[self addSubview:indicatorView];
		[indicatorView startAnimating];
    }
    return self;
}

-(void)showTitleLableForLoader:(NSString*)title
{
	[titleLbl setText:title];
}
-(void)resetFrame
{
	titleLbl.frame=CGRectMake((self.frame.size.width-500)/2,(self.frame.size.height-70)/2+70.0 , 500, 60.0);
	indicatorView.frame=CGRectMake((self.frame.size.width-70)/2,(self.frame.size.height-70)/2,70,70);
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
	[titleLbl release];
}


@end
