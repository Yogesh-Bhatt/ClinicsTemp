//
//  InstructionView_iPhone.h
//  Clinics
//
//  Created by Azad Haider on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import <UIKit/UIKit.h>

@protocol InstructionView_iPhoneDelegate <NSObject>

-(void)tabOnOkButton:(id)sender;

@end
@interface InstructionView_iPhone : UIView<UIWebViewDelegate>{
    
}
@property (nonatomic, assign) id <InstructionView_iPhoneDelegate> delegate;

@end
