//
//  ArticleDataHolder.m
//  Clinics
//
//  Created by Kiwitech on 10/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ArticleDataHolder.h"


@implementation ArticleDataHolder
@synthesize  nclinicID;
@synthesize downloadDate;
@synthesize note;
@synthesize sIssueID;
@synthesize nArticleID;
@synthesize sArticleTitle;
@synthesize sAbstract;
@synthesize sArticleDescription;
@synthesize sArticleHtmlFileName;
@synthesize sArticleImageName;
@synthesize sLastModified;
@synthesize sAuthors;
@synthesize sDateOfRelease;
@synthesize sArticleType;
@synthesize nIsArticleInPress;
@synthesize nBookmark;
@synthesize nRead;
@synthesize arrAuthor;
@synthesize sPDFfileName;
@synthesize sPageRange;
@synthesize sKeyWords;
@synthesize sArticleInfoId;
@synthesize doi_Link;


- (id)init 
{
    self = [super init];
	if(self)
	{    
		self.nclinicID=-1;
		self.downloadDate=@"";
        self.sIssueID = @"";
        self.nArticleID = 0;
		self.sArticleTitle = @"";
        self.sAbstract = @"";
        self.sArticleDescription = @"";
        self.sArticleHtmlFileName = @""; 
        self.sArticleImageName = @"";
        self.sLastModified = @"";
        self.sAuthors = @"";
        self.sDateOfRelease = @"";
        self.sArticleType = @"";
        self.nIsArticleInPress = -1;
        self.nBookmark = -1;
        self.nRead = -1;
        self.arrAuthor = [[[NSMutableArray alloc] init] autorelease];
        self.sPDFfileName = @"";
        self.sPageRange = @"";
        self.sKeyWords = @"";
        self.sArticleInfoId = @"";
	}	
	return self;
}




#pragma mark - Memory management

- (void)dealloc
{
	RELEASE(doi_Link);
	RELEASE(downloadDate);
    RELEASE(sIssueID);
    RELEASE(sArticleInfoId);
    RELEASE(sKeyWords);
    RELEASE(sPageRange);
    RELEASE(sPDFfileName);
    RELEASE(sArticleTitle);
    RELEASE(sAbstract);
    RELEASE(sArticleDescription);
    RELEASE(sArticleHtmlFileName);
    RELEASE(sArticleImageName);
    RELEASE(sLastModified);
    RELEASE(sAuthors);
    RELEASE(sDateOfRelease);
    RELEASE(sArticleType);
    
    [super dealloc];
}

@end
