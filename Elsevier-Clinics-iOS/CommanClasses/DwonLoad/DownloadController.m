//
//  DownloadController.m
//  AR
//
//  Created by Subhash Chand on 3/1/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import "DownloadController.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "DownloadData.h"

#define SERVER_BASE_URL @"http://208.109.209.216/CEN/files/"

@implementation DownloadController

@synthesize downloadQueDataList;
@synthesize sender;
@synthesize callBackFuntion;
@synthesize choiceString;

static DownloadController* _sharedDownloadController;

#pragma mark -
#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone {	
    
    @synchronized(self) {
        if (_sharedDownloadController == nil) {
			// assignment and return on first allocation
            _sharedDownloadController = [super allocWithZone:zone];			
            return _sharedDownloadController;
        }
    }
	
    return nil; 
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;	
}

- (id)retain {
    return self;	
}

- (unsigned)retainCount {
    return UINT_MAX;
}


- (id)autorelease {
    return self;	
}

+ (DownloadController*)sharedController {
	@synchronized(self) {
        if (_sharedDownloadController == nil) {
            [[self alloc] init];
        }
    }
    return _sharedDownloadController;
}


-(void)addLoaderForView
{
	ClinicsAppDelegate *appdelegate=(ClinicsAppDelegate*)[[UIApplication sharedApplication]delegate];
	
	if ([CGlobal isOrientationLandscape])
	{
		loaderView=[[DownloadingLoaderView alloc]initWithFrame:CGRectMake(0.0, 0.0, 1024, 768)];
	}
	else
	{  
		loaderView=[[DownloadingLoaderView alloc]initWithFrame:CGRectMake(0.0, 0.0, 768, 1024)];
	}
	
	[appdelegate.navigationController.view addSubview:loaderView];
}

-(void)ChangeFramewhenRootateDwonloadingStart{
	
	if ([CGlobal isOrientationLandscape])
	{
		loaderView.frame=CGRectMake(0.0, 0.0, 1024, 768);
		[loaderView ChangeFramedwonloadingSubView];
	}
	else
	{  
		loaderView.frame=CGRectMake(0.0, 0.0, 768, 1024);
		[loaderView ChangeFramedwonloadingSubView];
	}
	

	
}
-(void)createDownloadQueForQueData:(NSString*)choiceStr{
    
    choiceString = choiceStr;
    
	if ([choiceStr length]>0) {
		currentDownloadIndex=0;
		 [self DownloadFilesForArticle:choiceStr];
	}
}





-(BOOL)stopLoadingFile
{
	
	if (loaderView) {
    [loaderView removeFromSuperview];
		[loaderView release];
		loaderView=nil;
	}
	
	return FALSE;
}


-(void)setExpectedData:(double)expectedData
{
	expectedRecivingData += expectedData;
}


-(void)appendDataWithDownloadedData:(double)byteData
{
  //  //NSLog(@"%f",byteData);
	NSInteger fileIndex;
	fileIndex = currentDownloadIndex + 1;
	if (loaderView==nil) {
		return;
	}
    
	downloadedData+=(double)byteData;
    
	//****************Downloading %d of %d Full-Text Articles...****************
    
    if (isAbstract) {
        
        [loaderView setDownloadedArticle:[NSString stringWithFormat:@"Loading... %i of 1",[self.downloadQueDataList count]]];
    }
    else{
   
        [loaderView setDownloadedArticle:[NSString stringWithFormat:@"Loading %i of 1 Full-Text Articles...",[self.downloadQueDataList count]]];
    }
    
	[loaderView setDisplayMassage:[NSString stringWithFormat:@"%i\%% completed...",(int)(100.0/((double)expectedRecivingData/(double)downloadedData))]];
    
	[loaderView fillProcessImageForValue:(int)(100.0/((double)expectedRecivingData/(double)downloadedData))];
	
  }

- (BOOL) DownloadFilesForArticle:(NSString*)sourceUrl {
    
    if ([self doesConnectedToNetworkWithErrorMassage:nil]) {
		
		NSString   *zipFileName=[[sourceUrl componentsSeparatedByString:@"/"] lastObject];
        NSString  *isabstructText = [[zipFileName componentsSeparatedByString:@"_"] lastObject];
        if ([isabstructText isEqualToString:@"abs"]) 
            isAbstract = TRUE;
        else
          isAbstract = FALSE;   
            
        
		DownloadData *filesdown=[[[DownloadData alloc]init]autorelease];
        
		NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
        NSString *documentsDirectory = [(NSString *)[paths objectAtIndex:0] stringByAppendingPathComponent:zipFileName];
		[filesdown setFilePath:[NSString stringWithFormat:@"%@/%@.zip",documentsDirectory,zipFileName]];
		[filesdown setFileDocPath:[NSString stringWithFormat:@"%@/",documentsDirectory]];
		[filesdown startDownload:sourceUrl];
		
	}
	else {
		return FALSE;
	}
	
	return TRUE;

}


- (BOOL)doesConnectedToNetworkWithErrorMassage:(NSString*)massage {
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	if(isReachable && !needsConnection) 
	{
		return YES;
	}
	else
	{
		if(massage==nil)
		{
			[self stopLoadingFile];
			UIAlertView *baseAlert = [[UIAlertView alloc] 
									  initWithTitle:@"No Network" 
									  message:@"A network connection is required. Please verify your network settings and try again." 
									  delegate:nil cancelButtonTitle:nil 
									  otherButtonTitles:@"OK", nil];	
			[baseAlert show];
			[baseAlert release];
		}
		else {
			[self stopLoadingFile];
			UIAlertView *baseAlert = [[UIAlertView alloc] 
									  initWithTitle:@"No Network" 
									  message:massage 
									  delegate:nil cancelButtonTitle:nil 
									  otherButtonTitles:@"OK", nil];	
			[baseAlert show];
			[baseAlert release];
			

		}
		
		return NO;
	}
}


- (void)dealloc {
	[super dealloc];
	if(loaderView != nil)
		[loaderView release];
}
@end
