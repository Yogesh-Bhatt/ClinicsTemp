//
//  TextViewPopOver.m
//  Clinics
//
//  Created by Ashish Awasthi on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextViewPopover_iPhone.h"

@implementation TextViewPopover_iPhone

@synthesize delegate;

//********************** Add SubView On This View  ***************************
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *imageNamed =  [UIImage imageNamed:@"popup.png"];
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,imageNamed.size.width, imageNamed.size.height)];
        backImage.image = [UIImage imageNamed:@"popup.png"];
        [self addSubview:backImage];
        RELEASE(backImage);
        
    NSArray *arr;
    
    arr = [NSArray arrayWithObjects:@"chotaa.png",@"badaA.png",Nil];
    int xCor = 7; 
    
    for (int i = 0; i<[arr count]; i++) {
        
        UIImage *imageName = [UIImage imageNamed:[arr objectAtIndex:i]];
        UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [optionBtn addTarget:self action:@selector(tabOnOptionButton:) forControlEvents:UIControlEventTouchUpInside];
        [optionBtn setBackgroundImage:imageName forState:UIControlStateNormal];
        optionBtn.tag = i;
        optionBtn.frame = CGRectMake(xCor, 20, imageName.size.width, imageName.size.height);
        [self addSubview:optionBtn];
        
        xCor = xCor+imageName.size.width+4;
        
    }
    }
        
        return self;

}


// *********************************** Increase & decrease Text ***********************************

-(void)tabOnOptionButton:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag)
    {
        case 0://********************** Here We Decrease ***************************
            if ([self.delegate respondsToSelector:@selector(increaseSize:)]) {
                [self.delegate increaseSize:FALSE];
            }
            break;
        case 1://********************** Here We textIncraese ***************************
            if ([self.delegate respondsToSelector:@selector(increaseSize:)]) {
                [self.delegate increaseSize:TRUE];
            }
            break;
            
        default:
            break;
    }
    
}


@end


