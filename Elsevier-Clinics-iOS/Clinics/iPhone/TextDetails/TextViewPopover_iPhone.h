//
//  TextViewPopOver.h
//  Clinics
//
//  Created by Azad Haider on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextViewPopover_iPhoneDelegate <NSObject>
@optional

-(void)increaseSize:(BOOL)flag;

@end
@interface TextViewPopover_iPhone : UIView{
    
}
@property(nonatomic,assign)id <TextViewPopover_iPhoneDelegate ,NSObject> delegate;
@end
