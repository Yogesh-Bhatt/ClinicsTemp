//
//  FBShareManager.h
//  Advertising
//
//  Created by Usha Goyal on 01/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@protocol FBShareManagerDelegate <NSObject>
@optional
-(void)facebookPostDidSuccess;
-(void)facebookPostDidFail;
@end

@interface FBShareManager : NSObject <FBRequestDelegate,FBDialogDelegate,FBSessionDelegate>{
    
    Facebook* facebook;
	
	NSString *titleName;
    NSString *linkUrl;
    NSString *description;
    NSString *iconUrl;
	NSString *caption;
	NSString *msg;
	NSString *devName;
	NSString *devUrl;
    BOOL onlyLogin;
    BOOL isFBDialog;
    
    id <FBShareManagerDelegate> delegate;
}

@property (nonatomic, readwrite, assign)id <FBShareManagerDelegate> delegate;
@property(nonatomic,retain) NSString *titleName;
@property(nonatomic,retain) NSString *linkUrl;
@property(nonatomic,retain) NSString *description;
@property(nonatomic,retain) NSString *iconUrl;
@property(nonatomic,retain) NSString *caption;
@property(nonatomic,retain) NSString *msg;
@property(nonatomic,retain) NSString *devName;
@property(nonatomic,retain) NSString *devUrl;

+ (FBShareManager*)sharedManager;

-(void)loginFacebook;
-(void)publishStream;
-(void)publishStreamWithoutDialogBox;
@end
