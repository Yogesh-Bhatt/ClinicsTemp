//
//  InstructionView_iPhone.m
//  Clinics
//
//  Created by Azad Haider on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define  KwebViewTag  1005
#define  Klabeltag 1006
#define  KbackGourdView 1007

#import "InstructionView_iPhone.h"

@implementation InstructionView_iPhone

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
        
        UIView *backGourdView = [[UIView alloc] initWithFrame:self.frame];
        backGourdView.frame = self.frame;
        backGourdView.tag = KbackGourdView;
        backGourdView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        backGourdView.alpha = .3;
        backGourdView.backgroundColor = [UIColor blackColor];
        backGourdView.userInteractionEnabled= FALSE;
        [self addSubview:backGourdView];
        RELEASE(backGourdView);
        
        UILabel  *navigationLabel = [[UILabel alloc] init];
        navigationLabel.tag = Klabeltag;
        navigationLabel.textAlignment = UITextAlignmentCenter;
        navigationLabel.text = @"Welcome";
        navigationLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        navigationLabel.font = [UIFont boldSystemFontOfSize:20.0];
        navigationLabel.frame = CGRectMake(10, 76, 300, 44);
        navigationLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
        navigationLabel.userInteractionEnabled = TRUE;
        navigationLabel.backgroundColor = [UIColor colorWithRed:217.0f/255.0 green:242.0f/255.0 blue:251.0f/255 alpha:1.0f];
        [self addSubview:navigationLabel];
        
        UIImage  *imageName = [UIImage imageNamed:@"iPhone_ok.png.png"];
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [okButton addTarget:self action:@selector(tabOnOkButton:) forControlEvents:UIControlEventTouchUpInside];
        [okButton setImage:imageName forState:UIControlStateNormal];
        okButton.frame = CGRectMake(235, 9, imageName.size.width, imageName.size.height);
        [navigationLabel addSubview:okButton];
        RELEASE(navigationLabel);
        
        UIWebView   *webView=[[UIWebView alloc] init];
        webView.frame = CGRectMake(10,120,300 ,300);
        
        webView.tag = KwebViewTag;
        
        for (UIView *view1 in [webView subviews]) {
            if ([view1 isKindOfClass:[UIScrollView class]]) {
                UIScrollView  *sc=(UIScrollView *)view1;
                sc.scrollEnabled=FALSE;
            }
        }

        webView.backgroundColor=[UIColor clearColor];
        [self addSubview:webView];
        NSString   *url=[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"instriction.html"];
        NSString *fileContant = [NSString stringWithContentsOfFile:url encoding:NSUTF8StringEncoding error: nil];
        
        [webView loadHTMLString:fileContant baseURL:nil];
        RELEASE(webView);

    }
    return self;
}

//************************* Don't  Show  Again Intstruction View   *******************

-(void)tabOnOkButton:(id)sender{

    if ([self.delegate respondsToSelector:@selector(tabOnOkButton:)]) {
        [self.delegate tabOnOkButton:sender];
    }
    
     [[NSUserDefaults standardUserDefaults] setObject:@"True" forKey:@"Instruction"];

}



@end
