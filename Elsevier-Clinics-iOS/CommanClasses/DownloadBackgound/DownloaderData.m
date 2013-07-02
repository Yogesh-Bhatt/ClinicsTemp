//
//  ImageDownloader.m
//  ClassicPhotos
//
//  Created by Ashish Awasthi on 8/3/13.
//  Copyright (c) Ashish Awasthi iOS Developer. All rights reserved.
//

#import "DownloaderData.h"


// 1: Declare a private interface, so you can change the attributes of instance variables to read-write.
@interface DownloaderData ()
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) DataRecord *photoRecord;
@end


@implementation DownloaderData
@synthesize delegate = _delegate;
@synthesize indexPathInTableView = _indexPathInTableView;
@synthesize photoRecord = _photoRecord;

#pragma mark -
#pragma mark - Life Cycle

- (id)initWithPhotoRecord:(DataRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<DownloaderDataDelegate>)theDelegate {
    
    if (self = [super init]) {
        // 2: Set the properties.
        self.delegate = theDelegate;
        self.indexPathInTableView = indexPath;
        self.photoRecord = record;
        
    }
    return self;
}

#pragma mark -
#pragma mark - Downloading image

// 3: Regularly check for isCancelled, to make sure the operation terminates as soon as possible.
- (void)main {
    

    
    // 4: Apple recommends using @autoreleasepool block instead of alloc and init NSAutoreleasePool, because blocks are more efficient. You might use NSAuoreleasePool instead and that would be fine.
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        //  Changes  Here if u want dowload updadate issue in backgoround**********************
        
        NSLog(@"%@",self.photoRecord.urlStr);
        NSURL *tempURL = [NSURL URLWithString:self.photoRecord.urlStr];  // this has been changed
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tempURL
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                           timeoutInterval:60];
        
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse  *response, NSData    *recvicedData, NSError   *error){
            
            
            self.photoRecord.getData = recvicedData;
             [(NSObject *)self.delegate performSelectorOnMainThread:@selector(dataDownLoadComplete:) withObject: self.photoRecord waitUntilDone:NO];
            
            
        }];
        
       
        if (self.isCancelled)
            return;
        
        // 5: Cast the operation to NSObject, and notify the caller on the main thread.
       
        
    }
}

@end


