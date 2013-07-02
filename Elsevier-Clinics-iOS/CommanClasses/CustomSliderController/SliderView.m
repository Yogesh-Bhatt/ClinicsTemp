//
//  SliderView.m
//  SRPS
//
//  Created by Subhash on 24/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SliderView.h"


@implementation SliderView
@synthesize isTouchEnabled;
@synthesize callerDelegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"Touch Begin");
    
    if([self.callerDelegate respondsToSelector:@selector(onTaponSlider:)])
		[self.callerDelegate onTaponSlider:NO];
	[super touchesBegan:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"Touch End");
	[super touchesEnded:touches withEvent:event];

	[self setIsTouchEnabled:TRUE];
    
	if([self.callerDelegate respondsToSelector:@selector(moveToSlide)])
		[self.callerDelegate moveToSlide];
    if([self.callerDelegate respondsToSelector:@selector(onTaponSlider:)])
		[self.callerDelegate onTaponSlider:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if([self.callerDelegate respondsToSelector:@selector(onTaponSlider:)])
		[self.callerDelegate onTaponSlider:YES];
}


- (void)dealloc {
    self.callerDelegate = nil;
    [super dealloc];
}
@end
