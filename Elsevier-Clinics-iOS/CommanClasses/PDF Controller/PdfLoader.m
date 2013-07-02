//
//  PdfLoader.m
//  SRPS
//
//  Created by Subhash on 17/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PdfLoader.h"


@implementation PdfLoader


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.frame.size.width-40)/2,(self.frame.size.height-70)/2,37,37)];
		indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[self addSubview:indicatorView];
		[indicatorView startAnimating];
    }
    return self;
}
-(void)chnageOnOrientationChange
{
	indicatorView.frame=CGRectMake((self.frame.size.width-40)/2,(self.frame.size.height-70)/2,70,70);
}
-(void)chnageOnOrientationChangeLandScape
{
	indicatorView.frame=CGRectMake(480.0,300.0,37,37);

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
	[indicatorView release];
}


@end
