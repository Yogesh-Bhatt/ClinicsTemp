//
//  Data.h
//  Elsevier
//
//  Created by Yogesh Bhatt on 08/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Data : NSObject {

}

@end

/////////////////////////////////////////////////////////////////////


@interface NewsData : NSObject {
	NSString *title;
	NSString *desc;
	
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *desc;
@end


/////////////////////////////////////////////////////////////////////



@interface ArticleData : NSObject {
	
	NSInteger articleID;
	NSString *issueId;
	NSString *title;
	NSString *author;
	NSString *HTML;
	NSString *pdf;
	NSString *abstract1;
	NSString *keyword;
	NSString *releaseDate;
	NSString *type;
	NSString *articleinPress;
	NSString *pageRange;
	NSString *articleInfoId;
	BOOL isArticlePurchased;
	
}
@property(nonatomic,retain)NSString *articleInfoId;
@property (nonatomic, assign) NSInteger articleID;
@property (nonatomic,retain)NSString *issueId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *HTML;
@property (nonatomic, retain) NSString *pdf;
@property (nonatomic, retain) NSString *abstract1;
@property (nonatomic, retain) NSString *keyword;
@property (nonatomic, retain) NSString *releaseDate;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *articleinPress;
@property (nonatomic, retain) NSString *pageRange;
@property(nonatomic,assign)BOOL isArticlePurchased;

@end

/////////////////////////////////////////////////////////////////////

@interface AuthorsData : NSObject
{
	NSInteger authorId;
	NSInteger articleId;
	NSString *authorName;
	NSString *authorDesc;
	NSString *articleInfoId;
}
@property(nonatomic,retain)NSString	*articleInfoId;
@property (nonatomic, assign)NSInteger authorId;
@property (nonatomic, assign)NSInteger articleId;
@property (nonatomic, retain)NSString *authorName;
@property (nonatomic, retain)NSString *authorDesc;

@end

/////////////////////////////////////////////////////////////////////

@interface EditorData : NSObject
{
	NSInteger editorId;
	NSString *editorName;
	NSString *faculty;
	NSString *campus;
	NSString *address;
	NSString *telephone;
	NSString *fax;
	NSString *email;
}

@property (nonatomic, assign) NSInteger editorId;
@property (nonatomic, retain) NSString *editorName;
@property (nonatomic, retain) NSString *faculty;
@property (nonatomic, retain) NSString *campus;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *telephone;
@property (nonatomic, retain) NSString *fax;
@property (nonatomic, retain) NSString *email;

@end

/////////////////////////////////////////////////////////////////////


@interface NotesData : NSObject
{
	NSInteger noteId;
	NSString *notes;
}
@property (nonatomic, assign) NSInteger noteId;
@property (nonatomic, retain) NSString *notes;

@end


/////////////////////////////////////////////////////////////////////
