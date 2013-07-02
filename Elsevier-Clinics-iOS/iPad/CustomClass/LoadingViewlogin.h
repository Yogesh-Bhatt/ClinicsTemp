//
//  LoadingViewlogin.h
//  LiveLoop
//  
//  Created by Ashish Awasthi on 15/12/09.
//  Copyright 2009 Kiwitech. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LancetAppDelegate.h"

@interface LoadingViewlogin : NSObject
{
}

+(void)displayLoadingIndicator:(UIView *)parentView :(UIInterfaceOrientation)toOrentation;
+(void)removeLoadingIndicator;
+(void)inSideIpadPortrait;
+(void)inSideIpadLandScape;
+(void)setTitle:(NSString*)title;

@end
