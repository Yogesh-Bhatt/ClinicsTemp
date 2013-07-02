//
//  CategoryDataHolder.m
//  Clinics
//
//  Created by Kiwitech on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryDataHolder.h"


@implementation CategoryDataHolder
@synthesize checked;
@synthesize nCategoryID;
@synthesize sCategoryName;
@synthesize sCategoryImageName;
@synthesize arrClinics;

- (id)init 
{
    self = [super init];
	if(self)
	{
        self.nCategoryID = 0;
		self.checked=0;
		self.sCategoryName = @"";
        self.sCategoryImageName = @"";
        self.arrClinics = [[[NSMutableArray alloc] init] autorelease];
	}	
	return self;
}


#pragma mark - Memory management

- (void)dealloc
{

    RELEASE(sCategoryImageName);
    RELEASE(sCategoryName);
    
    [super dealloc];
}


@end
