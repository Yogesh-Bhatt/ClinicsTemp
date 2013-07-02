//
//  LoadingViewLogin_IPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingViewLogin_IPhone : NSObject
{
}

+(void)displayLoadingIndicator:(UIView *)parentView :(UIInterfaceOrientation)toOrentation;
+(void)removeLoadingIndicator;

+(void)setTitle:(NSString*)title;

@end