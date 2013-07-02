//
//  InstructionView.m
//  Clinics
//
//  Created by Ashish Awasthi on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define  KwebViewTag  1005
#define  Klabeltag 1006
#define  KbackGourdView 1007

#import "InstructionView.h"

@implementation InstructionView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if ([CGlobal isOrientationPortrait]) 
            self.frame = CGRectMake(0,0,768 , 1024);
        else
            self.frame = CGRectMake(0,0,1024 ,768);
        
        UIView *backGourdView = [[UIView alloc] initWithFrame:self.frame];
        backGourdView.frame = self.frame;
        backGourdView.tag = KbackGourdView;
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
        
        navigationLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
        navigationLabel.userInteractionEnabled = TRUE;
        if ([CGlobal isOrientationPortrait]) 
        navigationLabel.frame = CGRectMake(220,270,320 , 48);
        else
        navigationLabel.frame = CGRectMake(400,170,320 , 48);
        
        navigationLabel.backgroundColor = [UIColor colorWithRed:217.0f/255.0 green:242.0f/255.0 blue:251.0f/255 alpha:1.0f];
        [self addSubview:navigationLabel];

        UIImage  *imageName = [UIImage imageNamed:@"okipad.png"];
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [okButton addTarget:self action:@selector(tabOnOkButton:) forControlEvents:UIControlEventTouchUpInside];
        [okButton setImage:imageName forState:UIControlStateNormal];
        okButton.frame = CGRectMake(260, 10, imageName.size.width, imageName.size.height);
        [navigationLabel addSubview:okButton];
        RELEASE(navigationLabel);
        
        UIWebView   *webView=[[UIWebView alloc] init];
        if ([CGlobal isOrientationPortrait]) 
            webView.frame = CGRectMake(220, 320,320 ,  320);
        else
            webView.frame = CGRectMake(400, 220,320 ,  320);
        
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

//************************* Here Change Orientation Intstruction View *******************

-(void)changeOrientaionView{
    
    for (UIView *viewOne in [self subviews]) {
        
        if (viewOne.tag == KwebViewTag ) {
            if ([CGlobal isOrientationPortrait]) {
            CGRect xCor = [viewOne frame];
            xCor.origin.x = 220.0f;
            [viewOne setFrame:xCor];
            CGRect yCor = [viewOne frame];
            yCor.origin.y = 320.0f;
            [viewOne setFrame:yCor];
                
            }else{
                CGRect xCor = [viewOne frame];
                xCor.origin.x = 400.0f;
                [viewOne setFrame:xCor];
                CGRect yCor = [viewOne frame];
                yCor.origin.y = 220.0f;
                [viewOne setFrame:yCor];
               
            }
        }
        if (viewOne.tag == Klabeltag ) {
            if ([CGlobal isOrientationPortrait]) {
                CGRect xCor = [viewOne frame];
                xCor.origin.x = 220.0f;
                [viewOne setFrame:xCor];
                CGRect yCor = [viewOne frame];
                yCor.origin.y = 270.0f;
                [viewOne setFrame:yCor];
                
            }else{
                CGRect xCor = [viewOne frame];
                xCor.origin.x = 400.0f;
                [viewOne setFrame:xCor];
                CGRect yCor = [viewOne frame];
                yCor.origin.y = 170.0f;
                [viewOne setFrame:yCor];
                
            }
        }

    }

    if ([CGlobal isOrientationPortrait]) 
        self.frame = CGRectMake(0,0,768 , 1024);
    else
        self.frame = CGRectMake(0,0,1024 ,768);
    
      for (UIView *viewOne in [self subviews]) {
          if (viewOne.tag == KbackGourdView) {
              viewOne.frame = self.frame;
          }
      }
}

//************************* Do'nt  Show  Again Intstruction View   *******************

-(void)tabOnOkButton:(id)sender{
     
    if ([self.delegate respondsToSelector:@selector(tabOnOkButton:)]) {
        [self.delegate tabOnOkButton:sender];
    }

  [[NSUserDefaults standardUserDefaults] setObject:@"True" forKey:@"Instruction"];
   
}


@end
