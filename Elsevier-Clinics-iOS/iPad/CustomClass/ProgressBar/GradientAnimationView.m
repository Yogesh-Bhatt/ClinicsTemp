//
//  GradientAnimationView.m
//  iAdTest
//
//  Created by PriyaMishra on 22/02/13.
//  Copyright (c) 2013 Kiwitech. All rights reserved.
//

#import "GradientAnimationView.h"
#import <QuartzCore/QuartzCore.h>

#define kAnimationDuration 1.0

#define kFirstColor [UIColor redColor]
#define kSecondColor [UIColor greenColor]
#define kThirdColor [UIColor yellowColor]

#define DegreesToRadians(x) ((x) * M_PI / 180.0)




@implementation GradientAnimationView
{
    CGFloat fInitWidth;  // GradientAnimationView width
    CGFloat fInitHeight;  // GradientAnimationView height
    
    UIColor *startGradientColor ;
    UIColor *currentColor;
}

@synthesize fProgressValue;

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        fInitWidth = self.frame.size.width;
        
        startGradientColor = [UIColor redColor];
        
        CAGradientLayer *layer = (CAGradientLayer *)[self layer];
        layer.cornerRadius = 10;
        
        // layer.startPoint = CGPointMake(0.5, 0);
        layer.endPoint = CGPointMake(0.5, 1);
        
        
        layer.colors = [NSArray arrayWithObjects:
                        (id)[[[UIColor colorWithRed:(242.0/255)
                                              green:(174.0/255)
                                               blue:(24.0/255)
                                              alpha:1] colorWithAlphaComponent:1.0f] CGColor],
                        (id)[[[UIColor colorWithRed:(236.0/255)
                                              green:(104.0/255)
                                               blue:(1.0/255)
                                              alpha:1] colorWithAlphaComponent:1.0f] CGColor],
                        nil];
        
        
    }
    return self;
}

- (void) animateWithProgressWithValue:(NSInteger)value
{
    CGFloat fNewWidth = (value/100)*fInitWidth;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
        
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                fNewWidth,
                                self.frame.size.height);
    
    [UIView commitAnimations];
    
}



@end
