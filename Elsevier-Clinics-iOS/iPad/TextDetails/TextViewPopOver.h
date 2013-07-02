//
//  TextViewPopOver.h
//  Clinics
//
//  Created by Azad Haider on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextViewPopOverDelegate <NSObject>
@optional

-(void)increaseSize:(BOOL)flag;
    

@end
@interface TextViewPopOver : UIViewController{

}
@property(nonatomic,assign)id <TextViewPopOverDelegate ,NSObject> delegate;
@end
