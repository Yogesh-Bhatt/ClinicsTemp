//
//  PhotoRecord.m
//  ClassicPhotos
//
//  Created by Ashish Awasthi on 8/3/13.
//  Copyright (c) Ashish Awasthi iOS Developer. All rights reserved.
//

#import "DataRecord.h"

@implementation DataRecord

@synthesize urlStr = _urlStr;
@synthesize image = _image;
@synthesize URL = _URL;
@synthesize hasImage = _hasImage;
@synthesize filtered = _filtered;
@synthesize failed = _failed;
@synthesize getData = _getData;


- (BOOL)hasImage {
    return _image != nil;
}


- (BOOL)isFailed {
    return _failed;
}


- (BOOL)isFiltered {
    return _filtered;
}

@end