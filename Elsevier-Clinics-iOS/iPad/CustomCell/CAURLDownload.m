//
//  CAURLDownload.m
//  AllToZero
//
//  Created by Glenn Smith on 11/6/11.
//  Copyright (c) 2011 CouleeApps. All rights reserved.
//

#import "CAURLDownload.h"
#import "ClinicsAppDelegate.h"

@implementation CAURLDownload
@synthesize url, target, selector, data, userInfo, error, failSelector,receiveResponseSel;
#ifdef __BLOCKS__
@synthesize finishedBlock, failedBlock,conn;
#endif

- (void)start {
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:500];
    conn = [NSURLConnection connectionWithRequest:req delegate:self];
    data = [NSMutableData data];
    [data retain];
    [conn start];
    ClinicsAppDelegate *appDel = (ClinicsAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDel.m_downloadedConnectionArr addObject:conn];
    
}

+ (CAURLDownload *)downloadURL:(NSURL *)m_url target:(id)m_target selector:(SEL)m_selector failSelector:(SEL)m_failSelector userInfo:(NSDictionary *)m_userInfo waitTime:(int)waitSecs withDownloadDataSel:(SEL)m_dtaaDownloadSel{
    
    CAURLDownload *download = [[CAURLDownload alloc] init];
    download.url = m_url;
    download.target = m_target;
    download.userInfo = m_userInfo;
    download.selector = m_selector;
    download.failSelector = m_failSelector;
    download.receiveResponseSel = m_dtaaDownloadSel;
    
    [NSTimer scheduledTimerWithTimeInterval:waitSecs target:download selector:@selector(start) userInfo:nil repeats:NO];
    [download autorelease];
    return download;
}

+ (CAURLDownload *)downloadURL:(NSURL *)m_url target:(id)m_target selector:(SEL)m_selector failSelector:(SEL)m_failSelector downloadDataSel:(SEL)dataSelector userInfo:(NSDictionary *)m_userInfo {
    
    CAURLDownload * cobj = [CAURLDownload downloadURL:m_url target:m_target selector:m_selector failSelector:m_failSelector userInfo:m_userInfo waitTime:0 withDownloadDataSel:dataSelector];
    return cobj;
}

#ifdef  __BLOCKS__

+ (void)downloadURL:(NSURL *)m_url finished:(void(^)(void))finished failed:(void(^)(void))failure userInfo:(NSDictionary *)m_userInfo waitTime:(int)waitSecs  {
    CAURLDownload *download = [[CAURLDownload alloc] init];
    download.url = m_url;
    download.userInfo = m_userInfo;
    download.finishedBlock = finished;
    download.failedBlock = failure;
    [NSTimer scheduledTimerWithTimeInterval:waitSecs target:download selector:@selector(start) userInfo:nil repeats:NO];
    [download autorelease];
}

+ (void)downloadURL:(NSURL *)m_url finished:(void (^)(void))finished failed:(void (^)(void))failure userInfo:(NSDictionary *)m_userInfo {
    [CAURLDownload downloadURL:m_url finished:finished failed:failure userInfo:m_userInfo];
}

#endif

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)m_error {
    self.error = m_error;
#ifdef __BLOCKS__
    if (failedBlock)
        failedBlock();
#endif
    if (target && failSelector)
        [target performSelector:failSelector withObject:self];
    m_numberOfDownload--;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"m_error %@",[m_error localizedDescription]);
    
     //removeConn obj from global arr
    ClinicsAppDelegate *appDel = (ClinicsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.m_downloadedConnectionArr removeObject:conn];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.data setLength:0];
    expectedLength = (double)[response expectedContentLength];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)dataR
{
    
    [self.data appendData:dataR];
    NSInteger value =  (int)(100.0/(expectedLength/(double)[self.data length]));
    
    NSLog(@"===================%d",value);
    
    [target performSelector:self.receiveResponseSel withObject:[NSNumber numberWithInt:value]  withObject:self.data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
#ifdef __BLOCKS__
    if (finishedBlock)
        finishedBlock();
#endif
    if (target && selector)
        [self.target performSelector:selector withObject:[NSData dataWithData:data] withObject:self];
    m_numberOfDownload--;
    
    //removeConn obj from global arr
    ClinicsAppDelegate *appDel = (ClinicsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.m_downloadedConnectionArr removeObject:conn];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)cancelDownload{
    
    if(conn != nil){
        
         //removeConn obj from global arr
        ClinicsAppDelegate *appDel = (ClinicsAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDel.m_downloadedConnectionArr removeObject:conn];
        
        [conn cancel];
        conn = nil;
        m_numberOfDownload--;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
}
- (void)dealloc {
    
    NSLog(@"NSURLDEALLOC");
    [url release];
    [target release];
    [userInfo release];
    if (error)
        [error release];
    [data release];
    [super dealloc];
}

@end
