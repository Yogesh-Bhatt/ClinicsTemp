//
//  DatabaseConnection.m
//  WoltersKluwer
//
//  Created by Kiwitech on 03/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatabaseConnection.h"
#import "IssueDataHolder.h"
#import "RemberTableData.h"
@interface DatabaseConnection (Private)
+ (DatabaseConnection *)sharedController;
-(void)createDatabaseCopyIfNotExist;
-(BOOL)openConnection;

@end

@implementation DatabaseConnection

static DatabaseConnection * _sharedDatabaseConnection;

#pragma mark -
#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone {	
    @synchronized(self) {
        if (_sharedDatabaseConnection == nil) {
			// assignment and return on first allocation
            _sharedDatabaseConnection = [super allocWithZone:zone];	
			
            return _sharedDatabaseConnection;
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;	
}

- (id)retain {
    return self;	
}

- (unsigned)retainCount {
    return UINT_MAX;
}


- (id)autorelease {
    return self;	
}

+ (DatabaseConnection *)sharedController {
	@synchronized(self) {
        if (_sharedDatabaseConnection == nil) {
            [[self alloc] init];
        }
    }
    return _sharedDatabaseConnection;
}

- (void)dealloc {
	[_sharedDatabaseConnection release];
	[super dealloc];
}


#pragma mark -
#pragma mark PDF Methods

-(void)createDatabaseCopyIfNotExist{
    
	BOOL success;
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSError *error;
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:kDATABASE_NAME];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if(success)return;
	
	NSString *defaultDBPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:kDATABASE_NAME];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if(!success){
		NSAssert1(0,@"Failed to create writable database file with massage '%@'.",[error localizedDescription]);
	}
	
}
-(BOOL)openConnection
{
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *path=[documentsDirectory stringByAppendingPathComponent:kDATABASE_NAME];
	if(sqlite3_open([path UTF8String],&database)==SQLITE_OK)
		return TRUE;
	else
		return FALSE;
}

-(void)alterDataBase:(NSString *)query{
    

    if([self openConnection])
	{	
        
		const char *sql=[query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
	

}

#pragma mark -
#pragma mark <Load Issue Data>

- (NSMutableArray *) loadIssuesData:(NSInteger )nClinicID
{
    NSMutableArray *arrIssues = [[[NSMutableArray alloc] init] autorelease] ;
    
    if ([self openConnection])
    {
        NSString *sql = [NSString stringWithFormat:@"Select download, IssueID, ClinicID, IssueTitle, IssueNumber, Volume, ReleaseDate, Editors, LastModified, PrefaceTitle, Preface, PageRange,Cover_Img from tblIssue where ClinicID = %d order by ReleaseDate desc  limit 2", nClinicID];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                IssueDataHolder *pdataHolder = [[IssueDataHolder alloc] init];
				if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.download = sqlite3_column_int(statement, 2);
                } 
                
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.sIssueID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.nClinicID = sqlite3_column_int(statement, 2);
                } 
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.sIssueTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.nIssueNumber = sqlite3_column_int(statement, 4);
                }
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.nVolume = sqlite3_column_int(statement, 5);
                } 
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.sReleaseDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                }
                if(sqlite3_column_text(statement,7))
				{
                    pdataHolder.sEditors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                } 
                if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.sLastModified = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,8)];
                } 
                if(sqlite3_column_text(statement,9))
				{
                    pdataHolder.sPrefaceTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9)];
                }
                if(sqlite3_column_text(statement,10))
				{
                    pdataHolder.sPreface = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,10)];
                }
                if(sqlite3_column_text(statement,11))
				{
                    pdataHolder.sPageRange = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)];
                }
                
				if(sqlite3_column_text(statement,12))
				{
                    pdataHolder.cover_Img = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)];
                }
                
                [arrIssues addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
	
		return arrIssues ; 
}

- (void) saveIssueData:(NSMutableDictionary *)dictionaryData
{
   // BOOL bSuccess = NO;
    
	
    if([self openConnection])
	{	
        NSString *Query = [NSString stringWithFormat:@"INSERT INTO tblIssue (download,ClinicID, IssueID, IssueTitle, IssueNumber, Volume, ReleaseDate, Editors, LastModified, PrefaceTitle, Preface, PageRange,Cover_Img) VALUES(0, %d, '%@', '%@', %d, %d, '%@', '%@', '%@', '%@', '%@', '%@','%@')", 
            [[dictionaryData objectForKey:@"clinics_id"] intValue], 
            [dictionaryData objectForKey:@"issue_id"], 
            [dictionaryData objectForKey:@"issue_title"],
            [[dictionaryData objectForKey:@"issue_number"] intValue], 
            [[dictionaryData objectForKey:@"volume"] intValue],
            [dictionaryData objectForKey:@"date_of_release"], 
            [dictionaryData objectForKey:@"editors"],
            [dictionaryData objectForKey:@"last_modified"], 
            [dictionaryData objectForKey:@"PrefaceTitle"], 
            [dictionaryData objectForKey:@"Preface"],
            [dictionaryData objectForKey:@"page_range"],
		    [dictionaryData objectForKey:@"Cover_Image"]];
		        
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			if(sqlite3_step(statement) == SQLITE_DONE) 
            {
               
				////NSLog(@"%@",[dictionaryData objectForKey:@"Cover_Image"]);	
            }
            else 
            {
			}
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
	
    
}

- (IssueDataHolder *) loadIssueInfo:(NSString *)sIssueID
{
    IssueDataHolder *pdataHolder = [[[IssueDataHolder alloc] init] autorelease];
    
    if ([self openConnection])
    {
        NSString *sql = [NSString stringWithFormat:@"Select IssueID, ClinicID, IssueTitle, IssueNumber, Volume, ReleaseDate, Editors, LastModified, PrefaceTitle, Preface, PageRange,cover_Img, download from tblIssue where IssueID = '%@'", sIssueID];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {                
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.sIssueID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.nClinicID = sqlite3_column_int(statement, 1);
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sIssueTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.nIssueNumber = sqlite3_column_int(statement, 3);
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.nVolume = sqlite3_column_int(statement, 4);
                } 
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.sReleaseDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                }
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.sEditors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                } 
                if(sqlite3_column_text(statement,7))
				{
                    pdataHolder.sLastModified = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                } 
                if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.sPrefaceTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,8)];
                }
                if(sqlite3_column_text(statement,9))
				{
                    pdataHolder.sPreface = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9)];
                }
                if(sqlite3_column_text(statement,10))
				{
                    pdataHolder.sPageRange = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,10)];
                }
				if(sqlite3_column_text(statement,11))
				{
                    pdataHolder.cover_Img = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)];
                }
				
				if(sqlite3_column_text(statement,12))
				{
                    pdataHolder.download = sqlite3_column_int(statement, 12);
                } 
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return pdataHolder ; 
}

- (void) updateIssueData:(NSMutableDictionary *)dictionaryData
{
   
    
    if([self openConnection])
	{	
        NSString *Query = [NSString stringWithFormat:@"UPDATE tblIssue SET ClinicID = %d, IssueTitle = '%@', IssueNumber = %d, Volume = %d, ReleaseDate = '%@', Editors = '@', LastModified = '%@', PrefaceTitle = '%@', Preface = '%@', PageRange = '%@' WHERE  IssueID = '%@' Cover_Image='%@'", 
                           [[dictionaryData objectForKey:@"clinics_id"] intValue], 
                           [dictionaryData objectForKey:@"issue_title"],
                           [[dictionaryData objectForKey:@"issue_number"] intValue], 
                           [[dictionaryData objectForKey:@"volume"] intValue],
                           [dictionaryData objectForKey:@"date_of_release"], 
                           [dictionaryData objectForKey:@"editors"],
                           [dictionaryData objectForKey:@"last_modified"], 
                           [dictionaryData objectForKey:@"PrefaceTitle"], 
                           [dictionaryData objectForKey:@"Preface"],
                           [dictionaryData objectForKey:@"page_range"],
                           [dictionaryData objectForKey:@"issue_id"]];
						   [dictionaryData objectForKey:@"Cover_Image"];
        
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			if(sqlite3_step(statement) == SQLITE_DONE) 
            {
              
            }
            else 
            {
                
            }
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}

#pragma mark -
#pragma mark <Load Category Data>

- (NSMutableArray *) loadCategoryData:(BOOL )flag
{
    NSMutableArray *arrCategory = [[[NSMutableArray alloc] init] autorelease] ;
    settinGFlag=flag;
	NSMutableArray  *arr=[self retriveCategorySelectedCatgoryID:@"Select   DISTINCT CategoryID  from tblClinic where checked=0"];
    if ([self openConnection])
    {   const char *sql;
		NSMutableString   *str=nil;
		if (flag==TRUE) {
			str=[NSString stringWithFormat:@"Select CategoryID, CategoryName, CategoryImageName from tblCategory  where CategoryID  IN %@",arr];
		
        }
		else {
			str=[NSString stringWithFormat:@"Select CategoryID, CategoryName, CategoryImageName,Checked from tblCategory"];
		}

		sql =[str UTF8String] ;
        
        NSLog(@"%@",str);
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                CategoryDataHolder *pdataHolder = [[CategoryDataHolder alloc] init];
                
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.nCategoryID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.sCategoryName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                }
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sCategoryImageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }  
				
				if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.checked = sqlite3_column_int(statement, 3);
                } 
                if (flag==TRUE) {
					pdataHolder.arrClinics = [self SelectUnCheckedClinic:pdataHolder.nCategoryID];
				}else {
					pdataHolder.arrClinics = [self loadClinicsInfo:pdataHolder.nCategoryID] ;
				}

                
                      
                [arrCategory addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
       
	return arrCategory ; 
}

- (CategoryDataHolder *) loadCategoryInfo:(NSInteger)nCategoryID
{
    CategoryDataHolder *categoryDataHolder = [[[CategoryDataHolder alloc] init] autorelease];
    
    if ([self openConnection])
    {
        NSString *sql = [NSString stringWithFormat:@"Select CategoryID, CategoryName, CategoryImageName from tblCategory where CategoryID = %d",nCategoryID];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if(sqlite3_column_text(statement,0))
				{
                    categoryDataHolder.nCategoryID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    categoryDataHolder.sCategoryName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                }
                if(sqlite3_column_text(statement,2))
				{
                    categoryDataHolder.sCategoryImageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }  
				
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return categoryDataHolder ; 
}

- (void) saveCategoryData:(NSMutableDictionary *)dictionaryData
{
   
    
    if([self openConnection])
	{	
        NSString *Query = [NSString stringWithFormat:@"INSERT INTO tblCategory (CategoryID, CategoryName, CategoryImageName) VALUES(%d, '%@', '%@')", 
            [[dictionaryData objectForKey:@"Category_Id"]intValue], 
            [dictionaryData objectForKey:@"Category_Name"], 
            [dictionaryData objectForKey:@"Category_Img_Name"]];
        
        
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}

- (void) updateCategoryData:(NSMutableDictionary *)dictionaryData
{
   
    
    if([self openConnection])
	{	
        NSString *Query = [NSString stringWithFormat:@"UPDATE tblCategory SET CategoryName = '%@', CategoryImageName = '%@' WHERE CategoryID = %d", 
            [dictionaryData objectForKey:@"Category_Name"], 
            [dictionaryData objectForKey:@"Category_Img_Name"],
            [[dictionaryData objectForKey:@"Category_Id"] intValue]];
        
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}


#pragma mark -
#pragma mark <Load Clinics Data>

- (NSMutableArray *) loadClinicsInfo:(NSInteger)nCategoryID
{
    NSMutableArray *arrClinics = [[[NSMutableArray alloc] init] autorelease] ;
    
    if ([self openConnection])
    {        
         NSString *sql = [NSString stringWithFormat:@"Select CategoryID, ClinicID, ClinicTitle, ClinicThumbImageName, ConsultingEditor, Modified, showClinic, Checked, authencation, CECount  from tblClinic where CategoryID  = %d",nCategoryID];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {      
                ClinicsDataHolder *pdataHolder = [[ClinicsDataHolder alloc] init];

                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.nCategoryID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.nClinicID = sqlite3_column_int(statement, 1);
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sClinicTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.sClinicImageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.sConsultingEditor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                }
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.nModified = sqlite3_column_int(statement, 5);
                } 
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.nShowClinic = sqlite3_column_int(statement, 6);
                } 
				if(sqlite3_column_text(statement,7))
				{
                   pdataHolder.sChecked = sqlite3_column_int(statement, 7);
                }  
				if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.authencation = sqlite3_column_int(statement, 8);
                }
				if(sqlite3_column_text(statement,9))
				{
                    pdataHolder.CEName = sqlite3_column_int(statement,9 );
                }
				if (settinGFlag==TRUE) {
                pdataHolder.arrIssue = [self loadIssuesData:pdataHolder.nClinicID];
                pdataHolder.nNumberOfIssues  = [pdataHolder.arrIssue count];
				}

                [arrClinics addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrClinics ; 
}
// add awasthi
- (NSMutableArray *) SelectUnCheckedClinic:(NSInteger)nCategoryID
{
    NSMutableArray *arrClinics = [[[NSMutableArray alloc] init] autorelease] ;
    
    if ([self openConnection])
    {        
		NSString *sql = [NSString stringWithFormat:@"Select CategoryID, ClinicID, ClinicTitle, ClinicThumbImageName, ConsultingEditor, Modified, showClinic,Checked, authencation  from tblClinic where CategoryID  = %d And Checked=0",nCategoryID];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {      
                ClinicsDataHolder *pdataHolder = [[ClinicsDataHolder alloc] init];
				
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.nCategoryID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.nClinicID = sqlite3_column_int(statement, 1);
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sClinicTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.sClinicImageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.sConsultingEditor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                }
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.nModified = sqlite3_column_int(statement, 5);
                } 
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.nShowClinic = sqlite3_column_int(statement, 6);
                } 
				if(sqlite3_column_text(statement,7))
				{
					pdataHolder.sChecked = sqlite3_column_int(statement, 7);
                }  
				if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.authencation = sqlite3_column_int(statement, 8);
                }
                pdataHolder.arrIssue = [self loadIssuesData:pdataHolder.nClinicID];
                pdataHolder.nNumberOfIssues  = [pdataHolder.arrIssue count];
				
                [arrClinics addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrClinics ; 
}

- (NSMutableArray *) loadClinicsData:(NSString *)query
{
    NSMutableArray *arrClinics = [[[NSMutableArray alloc] init] autorelease] ;
    
    if ([self openConnection])
    {
        const char *sql = [query UTF8String];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ClinicsDataHolder *pdataHolder = [[ClinicsDataHolder alloc] init];
                
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.nCategoryID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.nClinicID = sqlite3_column_int(statement, 1);
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sClinicTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.sClinicImageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.sConsultingEditor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                }
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.nModified = sqlite3_column_int(statement, 5);
                } 
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.nShowClinic = sqlite3_column_int(statement, 6);
                } 
              
				if(sqlite3_column_text(statement,7))
				{
                    pdataHolder.authencation = sqlite3_column_int(statement, 7);
                }
                pdataHolder.arrIssue = [self loadIssuesData:pdataHolder.nClinicID];
                pdataHolder.nNumberOfIssues  = [pdataHolder.arrIssue count];
                
                [arrClinics addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrClinics ; 
}

- (ClinicsDataHolder *) loadClinicData:(NSInteger)nClinicID
{
    ClinicsDataHolder *clinicDataHolder = [[[ClinicsDataHolder alloc] init] autorelease];
    
    if ([self openConnection])
    {
        NSString *sql = [NSString stringWithFormat:@"Select CategoryID, ClinicID, ClinicTitle, ClinicThumbImageName, ConsultingEditor, Modified, showClinic,authencation  from tblClinic where ClinicID  = %d",nClinicID];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {                      
                if(sqlite3_column_text(statement,0))
				{
                    clinicDataHolder.nCategoryID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    clinicDataHolder.nClinicID = sqlite3_column_int(statement, 1);
                } 
                if(sqlite3_column_text(statement,2))
				{
                    clinicDataHolder.sClinicTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    clinicDataHolder.sClinicImageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    clinicDataHolder.sConsultingEditor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                }
                if(sqlite3_column_text(statement,5))
				{
                    clinicDataHolder.nModified = sqlite3_column_int(statement, 5);
                } 
                if(sqlite3_column_text(statement,6))
				{
                    clinicDataHolder.nShowClinic = sqlite3_column_int(statement, 6);
                } 
                
				if(sqlite3_column_text(statement,7))
				{
                    clinicDataHolder.authencation = sqlite3_column_int(statement, 7);
                } 
                clinicDataHolder.arrIssue = [self loadIssuesData:clinicDataHolder.nClinicID];
                clinicDataHolder.nNumberOfIssues  = [clinicDataHolder.arrIssue count];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return clinicDataHolder ; 
}

- (void) updateShowClinic:(NSInteger)nClinicID ShowClinic:(NSInteger)nShowClinic
{
	if([self openConnection])
	{	
        NSString *Query = [NSString stringWithFormat:@"UPDATE tblClinic SET showClinic = %d where ClinicID = %d", nShowClinic, nClinicID];
        
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}


- (void) saveClinicData:(NSMutableDictionary *)dictionaryData
{
   
    
    if([self openConnection])
	{	
        NSString *Query =[NSString stringWithFormat:@"UPDATE tblClinic SET Modified = '%@'", [dictionaryData objectForKey:@"Modified_date"]];
		
                
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}

- (void) updateClinicData:(NSMutableDictionary *)dictionaryData
{
    
    
    if([self openConnection])
	{	
		 NSString *Query =[NSString stringWithFormat:@"UPDATE tblClinic SET Modified = '%@'", [dictionaryData objectForKey:@"Modified_date"]];
               
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}


#pragma mark -
#pragma mark <load Article Data>

- (NSMutableArray *) loadArticleDataWith:(NSString *)a_query
{
    NSMutableArray *arrArticle = [[[NSMutableArray alloc] init] autorelease];
    
    if ([self openConnection])
    {
        NSString *sql = a_query;
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ArticleDataHolder *pdataHolder = [[ArticleDataHolder alloc] init];
                
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.nArticleID = sqlite3_column_int(statement, 0);
                }
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.sIssueID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                }
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sArticleTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.sAbstract = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.sArticleHtmlFileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                }
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.sLastModified = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                }
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.sAuthors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                }
                if(sqlite3_column_text(statement,7))
				{
                    pdataHolder.sArticleType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                }
                if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.nIsArticleInPress = sqlite3_column_int(statement, 8);
                }
                if(sqlite3_column_text(statement,9))
				{
                    pdataHolder.nBookmark = sqlite3_column_int(statement, 9);
                }
                if(sqlite3_column_text(statement,10))
				{
                    pdataHolder.nRead = sqlite3_column_int(statement, 10);
                }
                if(sqlite3_column_text(statement,11))
				{
                    pdataHolder.sPDFfileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)];
                }
                if(sqlite3_column_text(statement,12))
				{
                    pdataHolder.sPageRange = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)];
                }
                if(sqlite3_column_text(statement,13))
				{
                    pdataHolder.sKeyWords = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,13)];
                }
                if(sqlite3_column_text(statement,14))
				{
                    pdataHolder.sDateOfRelease = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,14)];
                }
                if(sqlite3_column_text(statement,15))
				{
                    pdataHolder.sArticleInfoId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,15)];
                }
				if(sqlite3_column_text(statement,16))
				{
                    pdataHolder.doi_Link = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,16)];
                }
                
                [arrArticle addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrArticle ;
}

- (NSMutableArray *) loadArticleData:(NSString *)sIssueID
{
     NSMutableArray *arrArticle = [[[NSMutableArray alloc] init] autorelease];
    
    if ([self openConnection])
    {
        NSString *sql = [NSString stringWithFormat:@"Select ArticleId, IssueId, ArticleTitle, Abstract, ArticlehtmlFileName, LastModified, Author, ArticleType, IsArticleInPress, Bookmark, Read, PdfFileName, PageRange, keywords, ReleaseDate, ArticleInfoId, Doi_Link from tblArticle where IssueId = '%@'", sIssueID];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ArticleDataHolder *pdataHolder = [[ArticleDataHolder alloc] init];
                
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.nArticleID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.sIssueID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sArticleTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.sAbstract = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.sArticleHtmlFileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                } 
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.sLastModified = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                }
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.sAuthors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                } 
                if(sqlite3_column_text(statement,7))
				{
                    pdataHolder.sArticleType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                } 
                if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.nIsArticleInPress = sqlite3_column_int(statement, 8);
                } 
                if(sqlite3_column_text(statement,9))
				{
                    pdataHolder.nBookmark = sqlite3_column_int(statement, 9);
                } 
                if(sqlite3_column_text(statement,10))
				{
                    pdataHolder.nRead = sqlite3_column_int(statement, 10);
                }
                if(sqlite3_column_text(statement,11))
				{
                    pdataHolder.sPDFfileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)];
                } 
                if(sqlite3_column_text(statement,12))
				{
                    pdataHolder.sPageRange = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)];
                } 
                if(sqlite3_column_text(statement,13))
				{
                    pdataHolder.sKeyWords = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,13)];
                } 
                if(sqlite3_column_text(statement,14))
				{
                    pdataHolder.sDateOfRelease = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,14)];
                } 
                if(sqlite3_column_text(statement,15))
				{
                    pdataHolder.sArticleInfoId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,15)];
                }
				if(sqlite3_column_text(statement,16))
				{
                    pdataHolder.doi_Link = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,16)];
                }
                                         
                [arrArticle addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrArticle ; 
}

- (void) updateBookmarkInArticleData:(NSString *)Query;
{
    //BOOL bSuccess = NO;
    
    if([self openConnection])
	{	
        
        
        
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}

- (int) GetArticlesCount:(NSString *)a_query
{
    int count = 0;
    if([self openConnection])
    {
        const char* sqlStatement = [a_query UTF8String];
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
    return count;
}

- (void) updateReadInArticleData:(NSInteger)nArticleID
{
   
    
    if([self openConnection])
	{	
        NSString *Query = [NSString stringWithFormat:@"UPDATE tblArticle SET Read = 1 where ArticleId = %d", nArticleID];
        
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}

- (ArticleDataHolder*) loadArticleInfo:(NSInteger)nArticleID
{
    ArticleDataHolder *pdataHolder = [[[ArticleDataHolder alloc] init] autorelease];
    
    if ([self openConnection])
    {
        NSString *sql = [NSString stringWithFormat:@"Select ArticleId, IssueId, ArticleTitle, Abstract, ArticlehtmlFileName, LastModified, Author, ArticleType, IsArticleInPress, Bookmark, Read, PdfFileName, PageRange, keywords, ReleaseDate, ArticleInfoId, Note, Doi_Link from tblArticle where ArticleId = %d", nArticleID];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {                
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.nArticleID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.sIssueID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sArticleTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.sAbstract = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.sArticleHtmlFileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                } 
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.sLastModified = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                }
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.sAuthors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                } 
                if(sqlite3_column_text(statement,7))
				{
                    pdataHolder.sArticleType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                } 
                if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.nIsArticleInPress = sqlite3_column_int(statement, 8);
                } 
                if(sqlite3_column_text(statement,9))
				{
                    pdataHolder.nBookmark = sqlite3_column_int(statement, 9);
                } 
                if(sqlite3_column_text(statement,10))
				{
                    pdataHolder.nRead = sqlite3_column_int(statement, 10);
                }
                if(sqlite3_column_text(statement,11))
				{
                    pdataHolder.sPDFfileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)];
                } 
                if(sqlite3_column_text(statement,12))
				{
                    pdataHolder.sPageRange = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)];
                } 
                if(sqlite3_column_text(statement,13))
				{
                    pdataHolder.sKeyWords = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,13)];
                } 
                if(sqlite3_column_text(statement,14))
				{
                    pdataHolder.sDateOfRelease = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,14)];
                } 
                if(sqlite3_column_text(statement,15))
				{
                    pdataHolder.sArticleInfoId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,15)];
                }
				if(sqlite3_column_text(statement,16))
				{
                    pdataHolder.note = sqlite3_column_int(statement, 16);
                }
				if(sqlite3_column_text(statement,17))
				{
                    pdataHolder.doi_Link = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,17)];
                }
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return pdataHolder ; 
}


- (void) saveArticleData:(NSMutableDictionary *)dictionaryData 
{
   
    
    if([self openConnection])
	{	//clinics_id
        NSString *Query = [NSString stringWithFormat:@"INSERT INTO tblArticle (ClinicID, ArticleId, IssueId, ArticleTitle, Abstract, ArticlehtmlFileName, LastModified, Author, ArticleType, IsArticleInPress, Bookmark, Read, PdfFileName, PageRange, Keywords, ReleaseDate, ArticleInfoId,Doi_Link) VALUES(%d, %d, '%@', '%@', '%@', '%@', '%@', '%@', '%@', %d, %d, %d, '%@', '%@', '%@', '%@', '%@','%@')", 
			 [[dictionaryData objectForKey:@"clinics_id"] intValue], 			   
            [[dictionaryData objectForKey:@"article_id"] intValue], 
            [dictionaryData objectForKey:@"issue_id"], 
            [dictionaryData objectForKey:@"article_title"], 
            [dictionaryData objectForKey:@"abstract"], 
            [dictionaryData objectForKey:@"html_file_name"], 
            [dictionaryData objectForKey:@"last_modify"], 
            [dictionaryData objectForKey:@"authors"], 
            [dictionaryData objectForKey:@"article_type"], 
            [[dictionaryData objectForKey:@"isArticleInPress"] intValue], 
            [[dictionaryData objectForKey:@"Bookmark"] intValue], 
            [[dictionaryData objectForKey:@"Read"] intValue],
            [dictionaryData objectForKey:@"pdf_file_name"],
            [dictionaryData objectForKey:@"page_range"],
            [dictionaryData objectForKey:@"keywords"],
            [dictionaryData objectForKey:@"date_of_release"],
            [dictionaryData objectForKey:@"article_info_id"],
		    [dictionaryData objectForKey:@"DOI_Link"]];

		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}

- (void) updateArticleData:(NSMutableDictionary *)dictionaryData
{
   
    
    if([self openConnection])
	{	
        NSString *Query = [NSString stringWithFormat:@"UPDATE tblArticle SET IssueId = '%@', ArticleTitle = '%@', Abstract = '%@', ArticlehtmlFileName = '%@', LastModified = '%@', Author = '%@', ArticleType = '%@', IsArticleInPress = %d, Bookmark = %d, Read = %d, PdfFileName = '%@', PageRange = '%@', Keywords = '%@', ReleaseDate = '%@', ArticleInfoId = '%@' where ArticleId = %d",
            [dictionaryData objectForKey:@"issue_id"], 
            [dictionaryData objectForKey:@"article_title"], 
            [dictionaryData objectForKey:@"abstract"], 
            [dictionaryData objectForKey:@"html_file_name"], 
            [dictionaryData objectForKey:@"last_modify"], 
            [dictionaryData objectForKey:@"authors"], 
            [dictionaryData objectForKey:@"article_type"], 
            [[dictionaryData objectForKey:@"isArticleInPress"] intValue], 
            [[dictionaryData objectForKey:@"Bookmark"] intValue], 
            [[dictionaryData objectForKey:@"Read"] intValue],
            [dictionaryData objectForKey:@"pdf_file_name"],
            [dictionaryData objectForKey:@"page_range"],
            [dictionaryData objectForKey:@"keywords"],
            [dictionaryData objectForKey:@"date_of_release"],
            [dictionaryData objectForKey:@"article_info_id"],
            [dictionaryData objectForKey:@"article_id"],
			[[dictionaryData objectForKey:@"clinic"] intValue]];
        
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}



// Add awasthi
-(void)upadateCheckUnCheckArticle:(NSString *)Query{
	
	if([self openConnection])
	{	
      
                           
        
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
	
}

-(NSInteger )selectCheckOrNot:(NSString *)query{
    
	NSInteger   checked=1;
	if ([self openConnection])
    {        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {      
                
                if(sqlite3_column_text(statement,0))
				{
                    checked = sqlite3_column_int(statement, 0);
					if (checked == 0) {
						break;	
					}
                } 
               
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return checked ; 
	
}

- (NSMutableArray *) loadIsuureData:(NSInteger )sClinicID
{
    NSMutableArray *arrArticle = [[[NSMutableArray alloc] init] autorelease];
    
    if ([self openConnection])
    {
        NSString *sql = [NSString stringWithFormat:@"Select  ArticleId, IssueId, ArticleTitle, Abstract, ArticlehtmlFileName, LastModified, Author, ArticleType, IsArticleInPress, Bookmark, Read, PdfFileName, PageRange, keywords, ReleaseDate, ArticleInfoId, clinicID, downloadDate,Doi_Link from tblArticle where clinicID = %d  and IsArticleInPress=1",sClinicID];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ArticleDataHolder *pdataHolder = [[ArticleDataHolder alloc] init];
                
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.nArticleID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.sIssueID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sArticleTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.sAbstract = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.sArticleHtmlFileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                } 
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.sLastModified = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                }
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.sAuthors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                } 
                if(sqlite3_column_text(statement,7))
				{
                    pdataHolder.sArticleType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                } 
                if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.nIsArticleInPress = sqlite3_column_int(statement, 8);
                } 
                if(sqlite3_column_text(statement,9))
				{
                    pdataHolder.nBookmark = sqlite3_column_int(statement, 9);
                } 
                if(sqlite3_column_text(statement,10))
				{
                    pdataHolder.nRead = sqlite3_column_int(statement, 10);
                }
                if(sqlite3_column_text(statement,11))
				{
                    pdataHolder.sPDFfileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)];
                } 
                if(sqlite3_column_text(statement,12))
				{
                    pdataHolder.sPageRange = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)];
                } 
                if(sqlite3_column_text(statement,13))
				{
                    pdataHolder.sKeyWords = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,13)];
                } 
                if(sqlite3_column_text(statement,14))
				{
                    pdataHolder.sDateOfRelease = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,14)];
                } 
                if(sqlite3_column_text(statement,15))
				{
                    pdataHolder.sArticleInfoId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,15)];
                }
				if(sqlite3_column_text(statement,16))
				{
                    pdataHolder.nclinicID =  sqlite3_column_int(statement, 16);
                } 
                if(sqlite3_column_text(statement,17))
				{
                    pdataHolder.downloadDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,17)];
                }
				
				if(sqlite3_column_text(statement,18))
				{
                    pdataHolder.doi_Link = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,18)];
                }
                [arrArticle addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrArticle ; 
}

-(void)UpadateDataAndRember:(NSString *)query{
	
	
    
    if([self openConnection])
	{	
        
        
		const char *sql=[query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
	
}


-(NSMutableArray *)selectRemberTableData{
	RemberTableData *remeberMe = [[[RemberTableData alloc] init] autorelease];
     NSMutableArray *remberArr = [[[NSMutableArray alloc] init] autorelease] ;
    if ([self openConnection])
    {
        NSString *sql = [NSString stringWithFormat:@"Select ButtonIndex,HederIndex, RowIndex, SectionIndex from tblRember"];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {                
                if(sqlite3_column_text(statement,0))
				{
                    remeberMe.buttonIndex = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    remeberMe.hederIndex =  sqlite3_column_int(statement, 1);
                }
                if(sqlite3_column_text(statement,2))
				{
                    remeberMe.rowIndex = sqlite3_column_int(statement, 2);
                } 
                if(sqlite3_column_text(statement,3))
				{
                    remeberMe.sectionIndex = sqlite3_column_int(statement, 3);
                }
				[remberArr addObject:remeberMe];
			
        }
		
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	
}
return remberArr ; 	
}


- (NSMutableArray *) backIssuesData:(NSInteger )nClinicID
{
    NSMutableArray *arrIssues = [[[NSMutableArray alloc] init] autorelease] ;

    if ([self openConnection])
    {
        NSString *sql = [NSString stringWithFormat:@"Select IssueID, ClinicID, IssueTitle, IssueNumber, Volume, ReleaseDate, Editors, LastModified, PrefaceTitle, Preface, PageRange from tblIssue where ClinicID = %d  and Access = 1 order by  ReleaseDate DESC", nClinicID];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                IssueDataHolder *pdataHolder = [[IssueDataHolder alloc] init];
                
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.sIssueID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.nClinicID = sqlite3_column_int(statement, 1);
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sIssueTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.nIssueNumber = sqlite3_column_int(statement, 3);
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.nVolume = sqlite3_column_int(statement, 4);
                } 
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.sReleaseDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                }
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.sEditors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                } 
                if(sqlite3_column_text(statement,7))
				{
                    pdataHolder.sLastModified = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                } 
                if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.sPrefaceTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,8)];
                }
                if(sqlite3_column_text(statement,9))
				{
                    pdataHolder.sPreface = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9)];
                }
                if(sqlite3_column_text(statement,10))
				{
                    pdataHolder.sPageRange = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,10)];
                }
                
                [arrIssues addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
	
	return arrIssues ; 
}





- (ReferenceData *) loadRefeenceInfo:(NSString *)sIssueID
{
    ReferenceData *referenceData = [[[ReferenceData alloc] init] autorelease];
    
    if ([self openConnection])
    {
        NSString *sql = [NSString stringWithFormat:@"Select Ref_id,Section_title,Section_id,Ariticle_info_id,ISSubTitle from tblReference  where Ref_id= '%@'",sIssueID];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {                
                if(sqlite3_column_text(statement,0))
				{
                    referenceData.Ref_id = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    referenceData.section_Title =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                } 
                if(sqlite3_column_text(statement,2))
				{
                    referenceData.Section_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    referenceData.aritcle_info_id =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    referenceData.isSubTitle = sqlite3_column_int(statement, 4);
                } 
                            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return referenceData ; 
}


- (NSMutableArray *) loadRefeenceInfoHTMl:(NSString *)sIssueID
{
  
     NSMutableArray *arrReference = [[[NSMutableArray alloc] init] autorelease] ;
	NSString *sql ;
    if ([self openConnection])
    {
   sql   = [NSString stringWithFormat:@"Select Ref_id,Section_title,Section_id,Ariticle_info_id,ISSubTitle from tblReference  where  Ariticle_info_id= '%@'",sIssueID];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {   
				ReferenceData *referenceData =  [[ReferenceData alloc] init];
                if(sqlite3_column_text(statement,0))
				{
                    referenceData.Ref_id = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    referenceData.section_Title =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                } 
                if(sqlite3_column_text(statement,2))
				{
                    referenceData.Section_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    referenceData.aritcle_info_id =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    referenceData.isSubTitle = sqlite3_column_int(statement, 4);
                } 
				[arrReference addObject:referenceData];
				[referenceData release];
				referenceData=nil;
			}
			
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrReference ; 
}



- (void) saveRefeenceData:(NSMutableDictionary *)dictionaryData
{
   
    
    if([self openConnection])
	{	
        NSString *Query = [NSString stringWithFormat:@"INSERT INTO tblReference (Ref_id, Section_title, Section_id, Ariticle_info_id, ISSubTitle) VALUES(%d, '%@', '%@','%@',%d)", 
						   [[dictionaryData objectForKey:@"reference_id"] intValue], 
                           [dictionaryData objectForKey:@"section_title"],
                           [dictionaryData objectForKey:@"section_id"], 
                           [dictionaryData objectForKey:@"article_info_id"] ,
                           [[dictionaryData objectForKey:@"is_this_sub_section"]intValue]]; 
		
		
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}

- (void)updateRefeenceData:(NSMutableDictionary *)dictionaryData
{
   
    
    if([self openConnection])
	{	
        NSString *Query = [NSString stringWithFormat:@"UPDATE tblReference SET Ref_id = %d, Section_title = '%@', Section_id = '%@', Ariticle-info_id = '%@', ISSubTitle = %d,", 
                           [[dictionaryData objectForKey:@"reference_id"] intValue], 
                           [dictionaryData objectForKey:@"section_title"],
                           [dictionaryData objectForKey:@"section_id"], 
                           [dictionaryData objectForKey:@"article_info_id"] ,
                           [[dictionaryData objectForKey:@"is_this_sub_section"]intValue]]; 
                                   
        
		const char *sql=[Query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
}
-(NSString *)findImageLatestIssueAEveryClinic:(NSString *)Query{
	NSString   *strImageName=nil;
      
    if ([self openConnection])
    {
       
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [Query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                                
				if(sqlite3_column_text(statement,0))
				{
                    strImageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                }
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
	
	return strImageName ; 
	
}

-(NSMutableArray *)retriveSelectedCinnicID{
	
    NSMutableArray *arrClinics = [[[NSMutableArray alloc] init] autorelease] ;
    
    if ([self openConnection])
    {
        const char *sql = "Select ClinicID  from tblClinic where checked=0";
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSInteger  nClinicID=0;
                
               
                if(sqlite3_column_text(statement,0))
				{
                    nClinicID = sqlite3_column_int(statement, 0);
                } 
				[arrClinics addObject:[NSString stringWithFormat:@"%d",nClinicID]];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrClinics ; 
	
	
}
-(NSMutableArray *)retriveCategorySelectedCatgoryID:(NSString *)query{
	
    NSMutableArray *arrClinics = [[[NSMutableArray alloc] init] autorelease] ;
    
    if ([self openConnection])
    {
        const char *sql = [query UTF8String];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSInteger  nClinicID=0;
                
				
                if(sqlite3_column_text(statement,0))
				{
                    nClinicID = sqlite3_column_int(statement, 0);
                } 
				[arrClinics addObject:[NSString stringWithFormat:@"%d",nClinicID]];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrClinics ; 
}


-( NSInteger )retriveCategoryAllclinicSelected:(NSString *)query{
	NSInteger  Cheecked=1;
    if ([self openConnection])
    {
        const char *sql =[query UTF8String];
		
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if(sqlite3_column_text(statement,0))
				{
                   Cheecked  = sqlite3_column_int(statement, 0);
					if (Cheecked==1) {
						break;
					 }
					else {
						Cheecked=0;
					}

                } 
				
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return Cheecked ; 
}
// Implement Bookmarks Logixx


-(NSInteger )selectClinicIDFromIssueTable:(NSString *)query{
	NSInteger  Cheecked=0;
    if ([self openConnection])
    {
        const char *sql =[query UTF8String];
		
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if(sqlite3_column_text(statement,0))
				{
					Cheecked  = sqlite3_column_int(statement, 0);
					
					
                } 
				
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return Cheecked ; 
	
	
}
- (NSMutableArray *) loadBookmarksCategoryData:(BOOL )flag
{
	NSMutableArray *arrCategory = [[[NSMutableArray alloc] init] autorelease] ;
	NSMutableArray  *arr;
	if (flag==TRUE) {
	arr=[self retriveCategorySelectedCatgoryID:@"Select   DISTINCT CategoryID  from tblarticle where bookmark=1"];
	}
	else {
		arr=[self retriveCategorySelectedCatgoryID:@"Select   DISTINCT CategoryID  from tblarticle where note=1"];
	}

    if ([self openConnection])
    {   const char *sql;
		NSString  *str=nil;
		
		str=[NSString stringWithFormat:@"Select CategoryID, CategoryName, CategoryImageName from tblCategory  where CategoryID  IN %@",arr];
		
		

		sql =[str UTF8String] ;
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                CategoryDataHolder *pdataHolder = [[CategoryDataHolder alloc] init];
                
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.nCategoryID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.sCategoryName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                }
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sCategoryImageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }  
				
				if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.checked = sqlite3_column_int(statement, 3);
                }  
				if (flag==TRUE) {
					pdataHolder.arrClinics = [self retriveBookmarsClincsData:TRUE :pdataHolder.nCategoryID];
				}
				else {
					pdataHolder.arrClinics = [self retriveBookmarsClincsData:FALSE :pdataHolder.nCategoryID];
				}
					
                
                [arrCategory addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrCategory ; 
	
}
-(NSMutableArray *)retriveBookmarsClincsData:(BOOL)flag :(NSInteger )categoryID{
	
	NSMutableArray *arrClinics = [[[NSMutableArray alloc] init] autorelease] ;
	NSMutableArray  *arr;
	if (flag==TRUE) {
		arr=[self retriveCategorySelectedCatgoryID:[NSString stringWithFormat:@"Select   DISTINCT clinicID  from tblarticle where bookmark=1 and categoryID=%d",categoryID]];
	}else {
		arr=[self retriveCategorySelectedCatgoryID:[NSString stringWithFormat:@"Select   DISTINCT clinicID  from tblarticle where note = 1 and categoryID=%d",categoryID]];
	}

    if ([self openConnection])
    {        
		NSString *sql = [NSString stringWithFormat:@"Select CategoryID, ClinicID, ClinicTitle, ClinicThumbImageName, ConsultingEditor, Modified, showClinic,Checked, authencation  from tblClinic where ClinicID IN %@",arr];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {      
                ClinicsDataHolder *pdataHolder = [[ClinicsDataHolder alloc] init];
				
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.nCategoryID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.nClinicID = sqlite3_column_int(statement, 1);
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sClinicTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.sClinicImageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.sConsultingEditor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                }
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.nModified = sqlite3_column_int(statement, 5);
                } 
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.nShowClinic = sqlite3_column_int(statement, 6);
                } 
				if(sqlite3_column_text(statement,7))
				{
					pdataHolder.sChecked = sqlite3_column_int(statement, 7);
                }  
				
				if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.authencation = sqlite3_column_int(statement, 8);
                }
				if (flag==TRUE) {
					pdataHolder.arrIssue = [self retriveBookmarsIssueData :TRUE :pdataHolder.nClinicID];
					pdataHolder.nNumberOfIssues  = [pdataHolder.arrIssue count];

				}else {
					pdataHolder.arrIssue = [self retriveBookmarsIssueData :FALSE :pdataHolder.nClinicID];
					pdataHolder.nNumberOfIssues  = [pdataHolder.arrIssue count];

				}
				
									
				
                [arrClinics addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrClinics ; 
	
	
}
-(NSMutableArray *)retriveBookmarsIssueData:(BOOL)flag :(NSInteger )clinicID{
	NSMutableArray *arrIssues = [[[NSMutableArray alloc] init] autorelease] ;
	NSMutableArray  *arr;
    if (flag==TRUE) {
		arr=[self retriveCategorySelectedCatgoryID:[NSString stringWithFormat:@"Select   DISTINCT issueID  from tblarticle where bookmark=1 and clinicID=%d",clinicID]];
	}
	else {
		arr=[self retriveCategorySelectedCatgoryID:[NSString stringWithFormat:@"Select   DISTINCT issueID  from tblarticle where note = 1 and clinicID=%d",clinicID]];
	}

    if ([self openConnection])
    {
        NSString *sql = [NSString stringWithFormat:@"Select IssueID, ClinicID, IssueTitle, IssueNumber, Volume, ReleaseDate, Editors, LastModified, PrefaceTitle, Preface, PageRange,Cover_Img from tblIssue where IssueID IN %@  order by ReleaseDate desc", arr];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                IssueDataHolder *pdataHolder = [[IssueDataHolder alloc] init];
                
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.sIssueID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.nClinicID = sqlite3_column_int(statement, 1);
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sIssueTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.nIssueNumber = sqlite3_column_int(statement, 3);
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.nVolume = sqlite3_column_int(statement, 4);
                } 
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.sReleaseDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                }
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.sEditors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                } 
                if(sqlite3_column_text(statement,7))
				{
                    pdataHolder.sLastModified = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                } 
                if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.sPrefaceTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,8)];
                }
                if(sqlite3_column_text(statement,9))
				{
                    pdataHolder.sPreface = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9)];
                }
                if(sqlite3_column_text(statement,10))
				{
                    pdataHolder.sPageRange = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,10)];
                }
                
				if(sqlite3_column_text(statement,11))
				{
                    pdataHolder.cover_Img = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)];
                }
                
                [arrIssues addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
	
	return arrIssues ; 
	
	
}
-(NSMutableArray *)retriveBookmarksAricleData:(BOOL)flag :(NSString * )issueID{
	
	NSMutableArray *arrArticle = [[[NSMutableArray alloc] init] autorelease];
	NSString *sql;
	if (flag == TRUE) {
	sql = [NSString stringWithFormat:@"Select ArticleId, IssueId, ArticleTitle, Abstract, ArticlehtmlFileName, LastModified, Author, ArticleType, IsArticleInPress, Bookmark, Read, PdfFileName, PageRange, keywords, ReleaseDate, ArticleInfoId, Doi_Link from tblArticle where IssueId = '%@' and Bookmark = 1 ",issueID];
	}
	else {
	sql = [NSString stringWithFormat:@"Select ArticleId, IssueId, ArticleTitle, Abstract, ArticlehtmlFileName, LastModified, Author, ArticleType, IsArticleInPress, Bookmark, Read, PdfFileName, PageRange, keywords, ReleaseDate, ArticleInfoId, Doi_Link from tblArticle where IssueId = '%@' and Bookmark=1 and IsArticleInPress = 1", issueID];
	}
    if ([self openConnection])
    {
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ArticleDataHolder *pdataHolder = [[ArticleDataHolder alloc] init];
                
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.nArticleID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.sIssueID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sArticleTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.sAbstract = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.sArticleHtmlFileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                } 
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.sLastModified = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                }
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.sAuthors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                } 
                if(sqlite3_column_text(statement,7))
				{
                    pdataHolder.sArticleType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                } 
                if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.nIsArticleInPress = sqlite3_column_int(statement, 8);
                } 
                if(sqlite3_column_text(statement,9))
				{
                    pdataHolder.nBookmark = sqlite3_column_int(statement, 9);
                } 
                if(sqlite3_column_text(statement,10))
				{
                    pdataHolder.nRead = sqlite3_column_int(statement, 10);
                }
                if(sqlite3_column_text(statement,11))
				{
                    pdataHolder.sPDFfileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)];
                } 
                if(sqlite3_column_text(statement,12))
				{
                    pdataHolder.sPageRange = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)];
                } 
                if(sqlite3_column_text(statement,13))
				{
                    pdataHolder.sKeyWords = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,13)];
                } 
                if(sqlite3_column_text(statement,14))
				{
                    pdataHolder.sDateOfRelease = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,14)];
                } 
                if(sqlite3_column_text(statement,15))
				{
                    pdataHolder.sArticleInfoId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,15)];
                }
				
				if(sqlite3_column_text(statement,16))
				{
                    pdataHolder.doi_Link = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,16)];
                }
                [arrArticle addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrArticle ; 
	
}
/// Add Notes  

-(NSMutableArray *)retriveNotesAricleData:(BOOL)flag :(NSString * )issueID{
	
	NSMutableArray *arrArticle = [[[NSMutableArray alloc] init] autorelease];
	NSString *sql;
	if (flag == TRUE) {
		// TOC
		sql = [NSString stringWithFormat:@"Select ArticleId, IssueId, ArticleTitle, Abstract, ArticlehtmlFileName, LastModified, Author, ArticleType, IsArticleInPress, Bookmark, Read, PdfFileName, PageRange, keywords, ReleaseDate, ArticleInfoId, note, Doi_Link from tblArticle where IssueId = '%@' and note = 1 ",issueID];
	}
	else {
		// Aricle oinpress
		sql = [NSString stringWithFormat:@"Select ArticleId, IssueId, ArticleTitle, Abstract, ArticlehtmlFileName, LastModified, Author, ArticleType, IsArticleInPress, Bookmark, Read, PdfFileName, PageRange, keywords, ReleaseDate, ArticleInfoId, note, Doi_Link  from tblArticle where IssueId = '%@' and note = 1 and IsArticleInPress = 1", issueID];
	}
    if ([self openConnection])
    {
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ArticleDataHolder *pdataHolder = [[ArticleDataHolder alloc] init];
                
                if(sqlite3_column_text(statement,0))
				{
                    pdataHolder.nArticleID = sqlite3_column_int(statement, 0);
                } 
                if(sqlite3_column_text(statement,1))
				{
                    pdataHolder.sIssueID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                } 
                if(sqlite3_column_text(statement,2))
				{
                    pdataHolder.sArticleTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                }
                if(sqlite3_column_text(statement,3))
				{
                    pdataHolder.sAbstract = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                }
                if(sqlite3_column_text(statement,4))
				{
                    pdataHolder.sArticleHtmlFileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                } 
                if(sqlite3_column_text(statement,5))
				{
                    pdataHolder.sLastModified = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                }
                if(sqlite3_column_text(statement,6))
				{
                    pdataHolder.sAuthors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                } 
                if(sqlite3_column_text(statement,7))
				{
                    pdataHolder.sArticleType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                } 
                if(sqlite3_column_text(statement,8))
				{
                    pdataHolder.nIsArticleInPress = sqlite3_column_int(statement, 8);
                } 
                if(sqlite3_column_text(statement,9))
				{
                    pdataHolder.nBookmark = sqlite3_column_int(statement, 9);
                } 
                if(sqlite3_column_text(statement,10))
				{
                    pdataHolder.nRead = sqlite3_column_int(statement, 10);
                }
                if(sqlite3_column_text(statement,11))
				{
                    pdataHolder.sPDFfileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)];
                } 
                if(sqlite3_column_text(statement,12))
				{
                    pdataHolder.sPageRange = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)];
                } 
                if(sqlite3_column_text(statement,13))
				{
                    pdataHolder.sKeyWords = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,13)];
                } 
                if(sqlite3_column_text(statement,14))
				{
                    pdataHolder.sDateOfRelease = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,14)];
                } 
                if(sqlite3_column_text(statement,15))
				{
                    pdataHolder.sArticleInfoId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,15)];
                }
				if(sqlite3_column_text(statement,16))
				{
                    pdataHolder.note = sqlite3_column_int(statement, 16);
                }
				if(sqlite3_column_text(statement,17))
				{
                      pdataHolder.doi_Link = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,17)];
                }
                [arrArticle addObject:pdataHolder];
                [pdataHolder release];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrArticle ; 
}
-(void)saveNotesInNoteTable:(NSString *)query{
	if([self openConnection])
	{	
        
		
		const char *sql=[query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			if(sqlite3_step(statement) == SQLITE_DONE) 
            {
				
					
            }
            else 
            {
			}
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
	
}

-(void)deleteNotedInNoteTable:(NSString *)query{
	
	if([self openConnection])
	{	
        
		const char *sql=[query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
	
	
}

-(BOOL)updateNotesInNoteTable:(NSString *)query{
	BOOL  sucess=FALSE;
    if([self openConnection])
	{	
        
		const char *sql=[query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			sucess=TRUE;
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
	
	return sucess;
}
-(HighlightObject *)selectHighlightText:(NSString*)query {
	
	HighlightObject *highlightObject=[[[HighlightObject alloc]init] autorelease];
	
	if ([self openConnection])
    {        
        sqlite3_stmt *statement;
		
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {			
			while (sqlite3_step(statement) == SQLITE_ROW)
			{
				//highlightObject.recordId=sqlite3_column_int64(selectstmt, 0);
				
				if (sqlite3_column_text(statement,0)) {
					highlightObject.noteId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
				}
				
				if (sqlite3_column_text(statement,1)) {
					highlightObject.selectedText=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
				}
				
				if (sqlite3_column_text(statement,2)) {
					highlightObject.myNotes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
				}
				
				if (sqlite3_column_text(statement,3)) {
					highlightObject.articleId=sqlite3_column_int64(statement, 3);
					
				}
				
				
				
			}
			sqlite3_finalize(statement);
		}
	}	
	
	sqlite3_close(database);
	return  highlightObject;	
}

-( BOOL)checkNoteInNoteTable:(NSString *)query{
	BOOL  noteId=FALSE;
	if ([self openConnection])
    {        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {			
			while (sqlite3_step(statement) == SQLITE_ROW)
			{
				//highlightObject.recordId=sqlite3_column_int64(selectstmt, 0);
				
				if (sqlite3_column_text(statement,0)) {
					
					noteId=TRUE;
					//[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
				}
				
				
				
				
			}
			sqlite3_finalize(statement);
		}
	}	
	
	sqlite3_close(database);
	return  noteId;	
	
}

-(NSMutableDictionary *)selectCheckedClinicDict{
	NSMutableDictionary   *checkClinicDict;

	checkClinicDict=[[[NSMutableDictionary alloc] init] autorelease];

	
	if ([self openConnection])
    {        
        sqlite3_stmt *statement;
		NSString  *query=@"select clinicId from tblclinic where checked = 0";
		
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {			
			while (sqlite3_step(statement) == SQLITE_ROW)
			{
				//highlightObject.recordId=sqlite3_column_int64(selectstmt, 0);
				
				if (sqlite3_column_text(statement,0)) {
					NSString   *clinicId =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
					
						[checkClinicDict setObject:clinicId forKey:clinicId];
					

					
				}
				
				
			}
			sqlite3_finalize(statement);
		}
	}	
	
	sqlite3_close(database);
	
		return  checkClinicDict;
	
	

	


}

-(NSMutableArray *)selectCheckedClinicArr{
	
	NSMutableArray   *arr;
	
		arr=[[[NSMutableArray alloc] init] autorelease];
	
	
	if ([self openConnection])
    {        
        sqlite3_stmt *statement;
		NSString  *query=@"select clinicId from tblclinic where checked = 0";
		
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {			
			while (sqlite3_step(statement) == SQLITE_ROW)
			{
				//highlightObject.recordId=sqlite3_column_int64(selectstmt, 0);
				
				if (sqlite3_column_text(statement,0)) {
					NSString   *clinicId =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
					
						[arr addObject:clinicId];
					
					
					
				}
				
				
			}
			sqlite3_finalize(statement);
		}
	}	
	
	
		return  arr;
	
	
	
	
}
-(NSString *)selectModifiedDateFromClinicTable:(NSString *)query{
	
	
	NSString   *modifieddate=@"";
	
	if ([self openConnection])
    {        
        sqlite3_stmt *statement;
		
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {			
			while (sqlite3_step(statement) == SQLITE_ROW)
			{
				//highlightObject.recordId=sqlite3_column_int64(selectstmt, 0);
				
				if (sqlite3_column_text(statement,0)) {
					modifieddate =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
				}
				
				
			}
			sqlite3_finalize(statement);
		}
	}	
	
	
	return  modifieddate;
}


-(NSMutableArray *)selectModifiedDateFromArticleTable:(NSString *)query{
	
	
	NSMutableArray   *modifieddate=[[[NSMutableArray alloc] init] autorelease];
	
	if ([self openConnection])
    {        
        sqlite3_stmt *statement;
		
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {			
			while (sqlite3_step(statement) == SQLITE_ROW)
			{
				//highlightObject.recordId=sqlite3_column_int64(selectstmt, 0);
				
				if (sqlite3_column_text(statement,0)) {
				   NSString *	date =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
				   [modifieddate addObject:date];
				}
				
				
			}
			sqlite3_finalize(statement);
		}
	}	
	
	
	return  modifieddate;
}
-(void)updateAuthecationInClinicTable:(NSString *)query{
	
    if([self openConnection])
	{	
        
		const char *sql=[query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	
	
	
}


-(NSString *)selectISSN:(NSString *)query{
	
	
	NSString   *modifieddate=@"";
	
	if ([self openConnection])
    {        
        sqlite3_stmt *statement;
		
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {			
			while (sqlite3_step(statement) == SQLITE_ROW)
			{
				//highlightObject.recordId=sqlite3_column_int64(selectstmt, 0);
				
				if (sqlite3_column_text(statement,0)) {
					modifieddate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
				}
				
								
				
				
			}
			sqlite3_finalize(statement);
		}
	}	
	
	sqlite3_close(database);
	
	
	
	return  modifieddate;
}

-(NSInteger )retriveAuthenticationfromServer:(NSString *)query{
    
	NSInteger   authentication=0;
	
	if ([self openConnection])
    {        
        sqlite3_stmt *statement;
		
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {			
			while (sqlite3_step(statement) == SQLITE_ROW)
			{
				//highlightObject.recordId=sqlite3_column_int64(selectstmt, 0);
				
				if (sqlite3_column_text(statement,0)) {
					authentication =sqlite3_column_int64(statement, 0);
				}
				
				
			}
			sqlite3_finalize(statement);
		}
	}	
	
	
	return  authentication;
}

-(NSString *)retriveFromClinicsTableFeatureID:(NSString *)query{
	NSString   *featureID=@"";
    
	if ([self openConnection])
    {        
        sqlite3_stmt *statement;
		
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {			
			while (sqlite3_step(statement) == SQLITE_ROW)
			{
				//highlightObject.recordId=sqlite3_column_int64(selectstmt, 0);
				
				if (sqlite3_column_text(statement,0)) {
					featureID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                   
				}
				
				
			}
			sqlite3_finalize(statement);
		}
	}	
	
	
	return  featureID;
	
}
-(NSInteger )retriveFromClinicsTableinApppurchaseID:(NSString *)query{
    
	NSInteger   inAppID=0;
	
	if ([self openConnection])
    {        
        sqlite3_stmt *statement;
		
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {			
			while (sqlite3_step(statement) == SQLITE_ROW)
			{
				//highlightObject.recordId=sqlite3_column_int64(selectstmt, 0);
				
				if (sqlite3_column_text(statement,0)) {
				inAppID =sqlite3_column_int64(statement, 0);
				}
				
				
			}
			sqlite3_finalize(statement);
		}
	}	
	
	
	return  inAppID;
	
}


-( NSInteger )retriveCategoryAllAutntication:(NSString *)query{
    
	NSInteger  Cheecked=0;
    if ([self openConnection])
    {
        const char *sql =[query UTF8String];
		
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if(sqlite3_column_text(statement,0))
				{
					Cheecked  = sqlite3_column_int(statement, 0);
					if (Cheecked == 0) {
						break;
					}
					else {
						Cheecked=1;
					}
					
                } 
				
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return Cheecked ; 
}

-(void)setFlagInAceessIssue:(NSString *)query{
    
    if([self openConnection])
	{	
        
		const char *sql=[query UTF8String];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			
		}
		
		sqlite3_step (statement);
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}	

}

-(NSMutableArray *)retriveClinicIdFromIssueTable:(NSString *)query{
	
    NSMutableArray *arrClinics = [[[NSMutableArray alloc] init] autorelease] ;
    
    if ([self openConnection])
    {
        const char *sql = [query UTF8String];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSInteger  nClinicID=0;
                
				
                if(sqlite3_column_text(statement,0))
				{
                    nClinicID = sqlite3_column_int(statement, 0);
                } 
				[arrClinics addObject:[NSString stringWithFormat:@"%d",nClinicID]];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
	return arrClinics ; 
}

-(BOOL )findIssueIdIssueTable:(NSString * )query{
    
    BOOL   isHave = NO;
    
    if ([self openConnection])
    {
        const char *sql =[query UTF8String];
		
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if(sqlite3_column_text(statement,0))
				{
                    isHave = YES;
                } 
				
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else
	{
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(database));
	}
    
    return isHave;
    
}

@end