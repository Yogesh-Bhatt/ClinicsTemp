//
//  CategoryCustomBtn.m
//  Clinics
//
//  Created by Ashish Awasthi on 05/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryCustomBtn.h"


@implementation CategoryCustomBtn
@synthesize isBtnOpen;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setIsBtnOpen:FALSE];
    }
    return self;
}



- (void)dealloc
{
    [super dealloc];
}

@end
