//
//  GradientAnimationView.h
//  iAdTest
//
//  Created by PriyaMishra on 22/02/13.
//  Copyright (c) 2013 Kiwitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientAnimationView : UIView
{
}

@property (nonatomic, assign)CGFloat fProgressValue;

- (void) animateWithProgressWithValue:(NSInteger)value;

@end
