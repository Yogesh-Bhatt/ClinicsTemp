//
//  ArticleDataHolder.h
//  Clinics
//
//  Created by Kiwitech on 10/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ArticleDataHolder : NSObject
{   

   
}
@property (nonatomic,retain)NSString  *doi_Link;
@property(nonatomic,assign)NSInteger  nclinicID;
@property(nonatomic, retain)NSString  *downloadDate;

@property(nonatomic,assign)NSInteger  note;
@property(nonatomic, retain)NSString *sIssueID;
@property(nonatomic, assign)NSInteger nArticleID;
@property(nonatomic, retain)NSString *sArticleTitle;
@property(nonatomic, retain)NSString *sAbstract;
@property(nonatomic, retain)NSString *sArticleDescription;
@property(nonatomic, retain)NSString *sArticleHtmlFileName;
@property(nonatomic, retain)NSString *sArticleImageName;
@property(nonatomic, retain)NSString *sLastModified;
@property(nonatomic, retain)NSString *sAuthors;
@property(nonatomic, retain)NSString *sDateOfRelease;
@property(nonatomic, retain)NSString *sArticleType;
@property(nonatomic, assign)NSInteger nIsArticleInPress;
@property(nonatomic, assign)NSInteger nBookmark;
@property(nonatomic, assign)NSInteger nRead;
@property(nonatomic, retain)NSMutableArray *arrAuthor;
@property(nonatomic, retain)NSString *sPDFfileName;
@property(nonatomic, retain)NSString *sPageRange;
@property(nonatomic, retain)NSString *sKeyWords;
@property(nonatomic, retain)NSString *sArticleInfoId;




@end
