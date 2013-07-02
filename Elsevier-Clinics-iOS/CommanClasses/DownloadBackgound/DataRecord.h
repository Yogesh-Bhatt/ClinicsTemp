//
//  PhotoRecord.h
//  ClassicPhotos
//
//  Created by Ashish Awasthi on 8/3/13.
//  Copyright (c) Ashish Awasthi iOS Developer. All rights reserved.
//

#import <UIKit/UIKit.h> // because we need UIImage

@interface DataRecord : NSObject


@property (nonatomic, strong) NSString *urlStr;  // To store the name of url
@property (nonatomic, strong) NSData   *getData;  // To store the name of getData
@property (nonatomic, strong) UIImage *image; // To store the actual image
@property (nonatomic, strong) NSURL *URL; // To store the URL of the image
@property (nonatomic, readonly) BOOL hasImage; // Return YES if image is downloaded.
@property (nonatomic, getter = isFiltered) BOOL filtered; // Return YES if image is sepia-filtered
@property (nonatomic, getter = isFailed) BOOL failed; // Return Yes if image failed to be downloaded

@end