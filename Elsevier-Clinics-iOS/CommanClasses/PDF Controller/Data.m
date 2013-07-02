//
//  Data.m
//  Elsevier
//
//  Created by Yogesh Bhatt on 08/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Data.h"


@implementation Data

@end

/////////////////////////////////////////////////////////////////////

@implementation NewsData 

@synthesize title;
@synthesize desc;

-(void) dealloc {
	
	[title release];
	[desc release];
	[super dealloc];
}

@end


/////////////////////////////////////////////////////////////////////


@implementation ArticleData
@synthesize articleID;
@synthesize issueId;
@synthesize title;
@synthesize author;
@synthesize HTML;
@synthesize pdf;
@synthesize abstract1;
@synthesize keyword;
@synthesize releaseDate;
@synthesize type;
@synthesize articleinPress;
@synthesize pageRange;
@synthesize isArticlePurchased;
@synthesize articleInfoId;


- (void) dealloc {
	
	[pageRange release];
	[title release];
	[author release];
	[HTML release];
	[pdf release];
	[abstract1 release];
	[keyword release];
	[releaseDate release];
	[type release];
	[articleinPress release];
	[super dealloc];
}

@end

/////////////////////////////////////////////////////////////////////

@implementation AuthorsData

@synthesize authorId;
@synthesize authorName;
@synthesize authorDesc;
@synthesize articleId;
@synthesize articleInfoId;
- (void) dealloc {
	
	[authorName release];
	[authorDesc release];
	[super dealloc];
}

@end

/////////////////////////////////////////////////////////////////////

@implementation EditorData

@synthesize editorId;
@synthesize editorName;
@synthesize faculty;
@synthesize campus;
@synthesize address;
@synthesize telephone;
@synthesize fax;
@synthesize email;

- (void) dealloc {
	
	[editorName release];
	[faculty release];
	[campus release];
	[address release];
	[telephone release];
	[fax release];
	[email release];
	[super dealloc];
}

@end

/////////////////////////////////////////////////////////////////////

@implementation NotesData
@synthesize noteId;
@synthesize notes;

- (void) dealloc {
	[notes release];
	[super dealloc];
}
   
@end
