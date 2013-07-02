//
//  SliderDescriptionView.m
//  Elsevier
//
//  Created by Subhash Chand on 3/16/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import "SliderDescriptionView.h"


@implementation SliderDescriptionView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
	
    if (self) {
        // Initialization code.
		[self setBackgroundColor:[UIColor clearColor]];
		UIImage* image = [UIImage imageNamed:@"pop-box.png"];
		UIImageView *bgImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0,image.size.width, image.size.height)]autorelease];
		[bgImageView setImage:image];
		[self addSubview:bgImageView];
        
		sliderTextLbl=[[UILabel alloc]initWithFrame:CGRectMake(25.0, 5.0, image.size.width-50.0, image.size.height-10.0)];
		[sliderTextLbl setFont:[UIFont boldSystemFontOfSize:12]];
		[sliderTextLbl setBackgroundColor:[UIColor clearColor]];
		[sliderTextLbl setTextAlignment:UITextAlignmentCenter];
        sliderTextLbl.lineBreakMode = UILineBreakModeTailTruncation;
		[sliderTextLbl setNumberOfLines:3];
		[self addSubview:sliderTextLbl];
		
    }
	
    return self;
}
-(void)setLabelText:(NSString*)txtString :(NSString*)flag
{
	[sliderTextLbl setText:txtString];
	
	int i = [flag intValue];
	
	if (i == 0) {
		sliderTextLbl.textColor = [UIColor grayColor];
	}else {
		sliderTextLbl.textColor = [UIColor blackColor];
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
	[sliderTextLbl release];
}


@end
