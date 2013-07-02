//
//  CAURLDownload.h
//  AllToZero
//
//  Created by Glenn Smith on 11/6/11.
//  Copyright (c) 2011 CouleeApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAURLDownload : NSObject <NSURLConnectionDelegate> {
   NSURL *url;
   id target;
#ifdef __BLOCKS__
   void (^finishedBlock)(void);
   void (^failedBlock)(void);
#endif
   SEL selector, failSelector,receiveResponseSel;
   NSDictionary *userInfo;
   NSMutableData *data;
   NSError *error;
    
   NSURLConnection *conn;
    
    double expectedLength;
    
}

#ifdef __BLOCKS__
@property (nonatomic) void (^finishedBlock)(void);
@property (nonatomic) void (^failedBlock)(void);
#endif
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) id target;
@property (nonatomic) SEL selector, failSelector,receiveResponseSel;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) NSURLConnection *conn;

+ (CAURLDownload *)downloadURL:(NSURL *)m_url target:(id)m_target selector:(SEL)m_selector failSelector:(SEL)m_failSelector downloadDataSel:(SEL)dataSelector userInfo:(NSDictionary *)m_userInfo;

+ (CAURLDownload *)downloadURL:(NSURL *)m_url target:(id)m_target selector:(SEL)m_selector failSelector:(SEL)m_failSelector userInfo:(NSDictionary *)m_userInfo waitTime:(int)waitSecs withDownloadDataSel:(SEL)m_dtaaDownloadSel;



#ifdef __BLOCKS__

+ (void)downloadURL:(NSURL *)m_url finished:(void(^)(void))finished failed:(void(^)(void))failure userInfo:(NSDictionary *)m_userInfo;

+ (void)downloadURL:(NSURL *)m_url finished:(void(^)(void))finished failed:(void(^)(void))failure userInfo:(NSDictionary *)m_userInfo waitTime:(int)waitSecs;

#endif

-(void)cancelDownload;


@end
