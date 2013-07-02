//
//  TextViewPopOver.m
//  Clinics
//
//  Created by Azad Haider on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextViewPopOver.h"

@implementation TextViewPopOver

@synthesize delegate;

-(void)viewDidLoad{
    
        NSArray *optionArr;
         // Initialization code
    
         optionArr = [NSArray arrayWithObjects:@"chootaipad.png",@"badaaipad.png",Nil];
        int xCor = 5; 
        
        for (int i = 0; i<[optionArr count]; i++) {
            
            UIImage *imageName = [UIImage imageNamed:[optionArr objectAtIndex:i]];
            UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [optionBtn addTarget:self action:@selector(tabObOptionButton:) forControlEvents:UIControlEventTouchUpInside];
            [optionBtn setBackgroundImage:imageName forState:UIControlStateNormal];
            optionBtn.tag = i;
            optionBtn.frame = CGRectMake(xCor, 5, imageName.size.width, imageName.size.height);
            [self.view addSubview:optionBtn];
            
            xCor = xCor+imageName.size.width+5;
            
        }


   [super viewDidLoad];
}


// *********************************** Increase & decrease Text ***********************************

-(void)tabObOptionButton:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag)
    {
        case 0:
            if ([self.delegate respondsToSelector:@selector(increaseSize:)]) {
                [self.delegate increaseSize:FALSE];
            }
            break;
        case 1:
            if ([self.delegate respondsToSelector:@selector(increaseSize:)]) {
                [self.delegate increaseSize:TRUE];
            }
            break;
        
        default:
            break;
    }
    
}

@end
