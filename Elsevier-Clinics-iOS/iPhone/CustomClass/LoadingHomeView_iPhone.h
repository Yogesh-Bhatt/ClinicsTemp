//
//  LoadingHomeView_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingHomeView_iPhone : NSObject
{
}

+(void)displayLoadingIndicator:(UIView *)parentView :(UIInterfaceOrientation)toOrentation;
+(void)removeLoadingIndicator;

+(void)setTitle:(NSString*)title;

+(void)chagengeMessageLoadingView:(ComeFromLoadingView)viewType;
@end

