//
//  ImageDownloader.h
//  ClassicPhotos
//
//  Created by Ashish Awasthi on 8/3/13.
//  Copyright (c) Ashish Awasthi iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

// 1: Import PhotoRecord.h so that you can independently set the image property of a PhotoRecord once it is successfully downloaded. If downloading fails, set its failed value to YES.
#import "DataRecord.h"

// 2: Declare a delegate so that you can notify the caller once the operation is finished.
@protocol DownloaderDataDelegate;

@interface DownloaderData : NSOperation

@property (nonatomic, assign) id <DownloaderDataDelegate> delegate;

// 3: Declare indexPathInTableView for convenience so that once the operation is finished, the caller has a reference to where this operation belongs to.
@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) DataRecord *dataRecord;

// 4: Declare a designated initializer.
- (id)initWithPhotoRecord:(DataRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<DownloaderDataDelegate>) theDelegate;

@end

@protocol DownloaderDataDelegate <NSObject>

// 5: In your delegate method, pass the whole class as an object back to the caller so that the caller can access both indexPathInTableView and photoRecord. Because you need to cast the operation to NSObject and return it on the main thread, the delegate method can’t have more than one argument.
- (void)imageDownloaderDidFinish:(DataRecord *)downloader;

-(void)dataDownLoadComplete:(DataRecord *)  downloader;

@end