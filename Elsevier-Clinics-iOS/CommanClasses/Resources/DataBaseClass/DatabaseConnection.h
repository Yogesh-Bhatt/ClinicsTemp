//
//  DatabaseConnection.h
//  WoltersKluwer
//
//  Created by Kiwitech on 03/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "CategoryDataHolder.h"
#import "ArticleDataHolder.h"
#import "ClinicsDataHolder.h"
#import "IssueDataHolder.h"

#import "ReferenceData.h"
#import "HighlightObject.h"

@interface DatabaseConnection : NSObject 
{
	sqlite3 *database;
	NSMutableArray *todos;
	BOOL settinGFlag;
}

+ (DatabaseConnection *)sharedController;
-(BOOL)openConnection;
-(void)createDatabaseCopyIfNotExist;
-(void)alterDataBase:(NSString *)query;


- (NSMutableArray *) loadCategoryData:(BOOL )flag;
- (CategoryDataHolder *) loadCategoryInfo:(NSInteger)nCategoryID;
- (void) saveCategoryData:(NSMutableDictionary *)dictionaryData;
- (void) updateCategoryData:(NSMutableDictionary *)dictionaryData;



- (NSMutableArray *) loadClinicsData:(NSString *)query;
- (NSMutableArray *) loadClinicsInfo:(NSInteger)nCategoryID;
- (ClinicsDataHolder *) loadClinicData:(NSInteger)nClinicID;
- (void) updateShowClinic:(NSInteger)nClinicID ShowClinic:(NSInteger)nShowClinic;
- (void) saveClinicData:(NSMutableDictionary *)dictionaryData;
- (void) updateClinicData:(NSMutableDictionary *)dictionaryData;


- (NSMutableArray *) loadIssuesData:(NSInteger )nClinicID;
- (void) saveIssueData:(NSMutableDictionary *)dictionaryData;
- (IssueDataHolder *) loadIssueInfo:(NSString *)sIssueID;
- (void) updateIssueData:(NSMutableDictionary *)dictionaryData;



- (NSMutableArray *) loadArticleData:(NSString *)sIssueID;
- (void) updateBookmarkInArticleData:(NSString *)Query;
- (void) updateReadInArticleData:(NSInteger)nArticleID;
- (ArticleDataHolder*) loadArticleInfo:(NSInteger)nArticleID;
- (void) saveArticleData:(NSMutableDictionary *)dictionaryData;
- (void) updateArticleData:(NSMutableDictionary *)dictionaryData;



//Add  Awasthi
-(void)upadateCheckUnCheckArticle:(NSString *)Query;
-(NSInteger )selectCheckOrNot:(NSString *)query;
- (NSMutableArray *) SelectUnCheckedClinic:(NSInteger)nCategoryID;
- (NSMutableArray *) loadIsuureData:(NSInteger )sClinicID;
-(void)UpadateDataAndRember:(NSString *)query;
-(NSMutableArray *)selectRemberTableData;

- (NSMutableArray *) backIssuesData:(NSInteger )nClinicID;


// load reference data

- (ReferenceData *) loadRefeenceInfo:(NSString *)sIssueID;

- (void) saveRefeenceData:(NSMutableDictionary *)dictionaryData;
- (void)updateRefeenceData:(NSMutableDictionary *)dictionaryData;
- (NSMutableArray *) loadRefeenceInfoHTMl:(NSString *)sIssueID;
-(NSString *)findImageLatestIssueAEveryClinic:(NSString *)Query;
-(NSMutableArray *)retriveSelectedCinnicID;
-(NSMutableArray *)retriveCategorySelectedCatgoryID:(NSString*)query;
-( NSInteger )retriveCategoryAllclinicSelected:(NSString *)query; 

- (NSMutableArray *) loadBookmarksCategoryData:(BOOL )flag;
-(NSMutableArray *)retriveBookmarsClincsData:(BOOL)flag :(NSInteger )categoryID;
-(NSMutableArray *)retriveBookmarsIssueData:(BOOL)flag :(NSInteger )clinicID;
-(NSMutableArray *)retriveBookmarksAricleData:(BOOL)flag :(NSString * )issueID;

-(NSInteger )selectClinicIDFromIssueTable:(NSString *)query;
-(NSString *)selectModifiedDateFromClinicTable:(NSString *)query;

// Add notes Method
-(NSMutableArray *)retriveNotesAricleData:(BOOL)flag :(NSString * )issueID;
-(void)saveNotesInNoteTable:(NSString *)query;
-(void)deleteNotedInNoteTable:(NSString *)query;
-(BOOL)updateNotesInNoteTable:(NSString *)query;
-(HighlightObject *)selectHighlightText:(NSString*)query;
-( BOOL)checkNoteInNoteTable:(NSString *)query;
-(NSMutableDictionary *)selectCheckedClinicDict;
-(NSMutableArray *)selectCheckedClinicArr;
-(NSMutableArray *)selectModifiedDateFromArticleTable:(NSString *)query;
-(void)updateAuthecationInClinicTable:(NSString *)query;

-(NSString *)selectISSN:(NSString *)query;
-(NSInteger )retriveAuthenticationfromServer:(NSString *)query;

-(NSString *)retriveFromClinicsTableFeatureID:(NSString *)query;
-(NSInteger )retriveFromClinicsTableinApppurchaseID:(NSString *)query;
-( NSInteger )retriveCategoryAllAutntication:(NSString *)query;
-(void)setFlagInAceessIssue:(NSString *)query;
-(NSMutableArray *)retriveClinicIdFromIssueTable:(NSString *)query;

-(BOOL )findIssueIdIssueTable:(NSString * )query;
@end
