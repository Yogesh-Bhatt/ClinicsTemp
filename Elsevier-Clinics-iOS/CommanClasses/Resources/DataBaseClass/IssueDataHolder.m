//
//  IssueDataHolder.m
//  Clinics
//
//  Created by Kiwitech on 10/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IssueDataHolder.h"


@implementation IssueDataHolder
@synthesize download;
@synthesize sIssueID;
@synthesize nClinicID;
@synthesize sIssueTitle;
@synthesize nIssueNumber;
@synthesize nVolume;
@synthesize sReleaseDate;
@synthesize sEditors;
@synthesize sLastModified;
@synthesize sPrefaceTitle;
@synthesize sPreface;
@synthesize sPageRange;
@synthesize  cover_Img;
- (id)init 
{
    self = [super init];
	if(self)
	{
		self.download=-1;
        self.sIssueID = @"";
        self.nClinicID = 0;
        self.sIssueTitle = @"";
        self.nIssueNumber = -1;
        self.nVolume = -1;
        self.sReleaseDate = @"";
        self.sEditors = @"";
        self.sLastModified = @"";
        self.sPrefaceTitle = @"";
        self.sPreface = @"";
        self.sPageRange = @"";
	}	
	return self;
}



#pragma mark - Memory management

- (void)dealloc
{
	[cover_Img release];
    RELEASE(sIssueID);
    RELEASE(sPageRange);
    RELEASE(sIssueTitle);
    RELEASE(sLastModified);
    RELEASE(sPrefaceTitle);
    RELEASE(sPreface);
    RELEASE(sReleaseDate);
    RELEASE(sEditors);
    
    [super dealloc];
}

@end
