//
//  FileDownloadViewController.m
//  FileDownload
//
//  Created by VIJAY GUPTA on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileDownloader.h"

@implementation FileDownloader
@synthesize fileName;
@synthesize dowmloadPath;
@synthesize parentController;

NSURLConnection *currentConnection;
NSMutableData *receivedData;
NSFileHandle *fileHandle;
static	FileDownloader *serverClass;

- (void)dealloc
{
    [super dealloc];
}


#pragma mark - View lifecycle

+ (FileDownloader *)getConnectionClass
{
	if(serverClass == nil)
    {
		serverClass = [[FileDownloader alloc] init];
	}
	return serverClass;
}


- (void)startDownload:(NSString *)withFileName fromFilePath:(NSString *)thisFilePath
{
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
    
    NSString *temporaryZipPath = [documentFolderPath stringByAppendingPathComponent:withFileName];
	
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:[documentFolderPath stringByAppendingPathComponent:self.fileName]];
    
    NSString *articlehtmlName = [self.fileName stringByReplacingOccurrencesOfString:@"-" withString:@""];
    articlehtmlName = [articlehtmlName stringByReplacingOccurrencesOfString:@"(" withString:@""];
    articlehtmlName = [articlehtmlName stringByReplacingOccurrencesOfString:@")" withString:@""];
    articlehtmlName = [NSString stringWithFormat:@"PII%@",articlehtmlName];
    
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@/%@.html",[documentFolderPath stringByAppendingPathComponent:self.fileName],articlehtmlName]];
    	
    if (!fileExist || [fileData bytes] == 0) 
    {
		NSMutableData *fake = [[NSMutableData alloc] initWithLength:0];
		BOOL result = [[NSFileManager defaultManager] createFileAtPath:temporaryZipPath contents:fake attributes:nil];
		[fake release];
		
		if (!result) 
        {
			//NSLog(@"Error in writing the file. Try again!!");
			[[NSNotificationCenter defaultCenter] postNotificationName:@"stopAlertView" object: nil];
			
			return;
		}
		
	    fileHandle = [[NSFileHandle fileHandleForWritingAtPath:temporaryZipPath] retain];
		
		NSURL *thisURL = [NSURL URLWithString:thisFilePath];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:thisURL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60.0f];
		[request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
		currentConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
		receivedData = [[NSMutableData data] retain];   
		//NSLog(@"NEW FILE CREATED.");
	}
    else
    {
		//NSLog(@"NEW FILE NOT CREATED. ODD IS THERE.");
		[[NSNotificationCenter defaultCenter] postNotificationName:@"stopAlertView" object: nil];
	}
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	sizeOfDownload = [response expectedContentLength];
    //NSLog(@"Expected Content Length : %ld",sizeOfDownload);
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    bytesCount = bytesCount + [data length];
    [receivedData appendData:data]; 
    
    //If the size is over 5MB, then write the current data object to a file and clear the data
    if(receivedData.length > MAX_DATA_LENGHT)
    {
        [fileHandle truncateFileAtOffset:[fileHandle seekToEndOfFile]]; //setting aFileHandle to write at the end of the file
        [fileHandle writeData:receivedData]; //actually write the data
        [receivedData release];
        receivedData = nil;
        receivedData = [[NSMutableData data] retain];
    }    
}


- (void)connectionDidFinishLoading:(NSURLConnection*)connection 
{    
   // //NSLog(@"Succeeded! Received data");
    
    [currentConnection release];
    currentConnection = nil;
    
    [fileHandle writeData:receivedData];
    [receivedData release];
    [fileHandle release];
    [self UnzipFileAndDeleteZip];    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [currentConnection release];
    currentConnection = nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"stopAlertView" object: nil];
	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Download failed!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [errorAlert show];
    [errorAlert release];
}


-(void)UnzipFileAndDeleteZip
{
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
	
    NSString *sourcePath = [documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",self.fileName]];
    NSString *destinationPath = [documentFolderPath stringByAppendingPathComponent:self.fileName];
    [SSZipArchive unzipFileAtPath:sourcePath toDestination:destinationPath];
    //NSLog(@"Success! Unzip done.");
    
    [[NSFileManager defaultManager] removeItemAtPath:sourcePath error:nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"stopAlertView" object: nil];
}


@end
