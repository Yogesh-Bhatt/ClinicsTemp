//
//  CustomScrollView.m
//  LiveLoop
//
//  Created by Rajiv on 29/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CustomScrollView.h"
//#import "CustomImageView.h"

@implementation CustomScrollView

-(void)initSettings{ 
	self.backgroundColor = [UIColor blackColor];
	self.scrollEnabled = YES;
	//self.pagingEnabled = YES;
	self.userInteractionEnabled = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if(!self.dragging){
		[self.nextResponder touchesBegan:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if(!self.dragging){
		[self.nextResponder touchesEnded:touches withEvent:event];
	}
}

	
-(void)didMoveToSuperview{
	self.userInteractionEnabled = YES;
}



@end
