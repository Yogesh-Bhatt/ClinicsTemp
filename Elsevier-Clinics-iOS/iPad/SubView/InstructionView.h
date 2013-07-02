//
//  InstructionView.h
//  Clinics
//
//  Created by Ashish Awasthi on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InstructionViewDelegate <NSObject>

-(void)tabOnOkButton:(id)sender;

@end

@interface InstructionView : UIView<UIWebViewDelegate>{

}

@property (nonatomic, assign) id <InstructionViewDelegate> delegate;
-(void)changeOrientaionView;
@end
