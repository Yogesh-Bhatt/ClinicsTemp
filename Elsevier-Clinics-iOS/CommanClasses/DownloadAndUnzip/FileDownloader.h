//
//  FileDownloadViewController.h
//  FileDownload
//
//  Created by VIJAY GUPTA on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSZipArchive.h"
#import "RootViewController.h"

@interface FileDownloader : NSObject 
{
	NSString *fileName;
    NSString *dowmloadPath;
	
    NSUInteger bytesCount;
    long sizeOfDownload;
	
	UIViewController *parentController;
}

@property(nonatomic,retain) NSString *fileName;
@property(nonatomic,retain) NSString *dowmloadPath;
@property(nonatomic,retain) UIViewController *parentController;

+(FileDownloader *)getConnectionClass;
-(void)UnzipFileAndDeleteZip;
-(void)startDownload:(NSString *)withFileName fromFilePath:(NSString *)thisFilePath;

#define MAX_DATA_LENGHT 100

@end
