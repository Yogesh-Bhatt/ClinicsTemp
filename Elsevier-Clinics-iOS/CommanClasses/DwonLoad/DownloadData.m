//
//  DownloadData.m
//  DownloadArticle
//
//  Created by Kiwitech Noida on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadData.h"
#import "ZipArchive.h"
#import "DownloadController.h"
#import "AritcleListViewController.h"

#import "NotesListViewController_iPhone.h"
#import "BookMarkListViewController_iPhone.h"
@implementation DownloadData
@synthesize filePath;
@synthesize fileDocPath;
@synthesize serverUrl;

- (void)startDownload:(NSString *)fileURL {
	serverUrl=[NSString stringWithFormat:@"%@.zip",fileURL];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrl]];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) {
		[[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"Cancel"];
		[connection start];
	} else {
		// Handle error
		DownloadController *downloadController=[DownloadController sharedController];
		[downloadController stopLoadingFile];
	}
}


- (void)connection:(NSURLConnection *)connection1 didReceiveData:(NSData *)data {
    
	NSString *CancalRequest = [[NSUserDefaults standardUserDefaults] objectForKey:@"Cancel"];
    ////NSLog(@"Succeeded! Received bytes of data");
	if ([CancalRequest intValue]==100) {
	NSFileManager *filemanager=[NSFileManager defaultManager];
        
    NSLog(@"%@",filePath);
        
	if(![filemanager fileExistsAtPath:filePath])
		[[NSFileManager defaultManager] createFileAtPath:filePath	contents: nil attributes: nil];
    
	NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	[handle seekToEndOfFile];
	[handle writeData:data];
    
	DownloadController *downloadController=[DownloadController sharedController];
	[downloadController appendDataWithDownloadedData:[data length]];
	[handle closeFile];
	}else {
		[connection cancel];
		if (connection) {
			[connection release];
			connection=nil;
		}
	}

}

- (void)connection:(NSURLConnection *)connection  didFailWithError:(NSError *)error
{
    
	UIAlertView *alertView=[[[UIAlertView alloc]initWithTitle:@"Download" message:[NSString stringWithFormat:@"Connection failed! Error - %@ ", [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease];
	[alertView show];
	
	DownloadController *downloadController=[DownloadController sharedController];
	[downloadController stopLoadingFile];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
	DownloadController *downloadController=[DownloadController sharedController];
	totalexpectedData=(double)[response expectedContentLength];
	[downloadController setExpectedData:totalexpectedData];
	NSFileManager *filemanager=[NSFileManager defaultManager];
    
	if(![filemanager contentsOfDirectoryAtPath:fileDocPath error:nil])
		[filemanager createDirectoryAtPath:fileDocPath withIntermediateDirectories:YES attributes:nil error:nil];
	
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection1
{
    // *************do something with the data*************
	NSString *CancalRequest = [[NSUserDefaults standardUserDefaults] objectForKey:@"Cancel"];
    //NSLog(@"Succeeded! Received bytes of data");
    BOOL ret = NO;
    
	if ([CancalRequest intValue]==100) {
	ZipArchive *za = [[ZipArchive alloc] init];
        
        NSLog(@"%@",fileDocPath);
       
        
        
	if ([za UnzipOpenFile: filePath]) {
		ret = [za UnzipFileTo:fileDocPath overWrite: YES];
		if (NO == ret){
        
            NSLog(@"Error while unzip code rohit");
            return;
        }
        [za UnzipCloseFile];
	}
	[za release];	
      
        DownloadController *downloadController=[DownloadController sharedController];
        [downloadController stopLoadingFile];
        
        if(ret == YES){
            
            NSArray *components =[fileDocPath componentsSeparatedByString:@"/"];
            
            NSString *zipFileNameTemp = nil;
            
            if([components count] > 2)
                zipFileNameTemp = [components objectAtIndex:([components count]-2)];
            
            NSLog(@"999999999%@",zipFileNameTemp);
            DatabaseConnection *database = [DatabaseConnection sharedController];
            NSInteger count = [database GetArticlesCount:@"SELECT COUNT(*) FROM tblArticle where downloadRank > 0"];
            [database   updateBookmarkInArticleData:[NSString stringWithFormat:@"UPDATE tblArticle SET downloadRank = %d where ArticleInfoId = '%@'",(count+1),zipFileNameTemp]];
            
        }
        
        ClinicsAppDelegate  *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
        
		if (appDelegate.openHTMLADDNoteOpenView == FALSE) {
            //************* This Condition Only For Download Alert Come In Abstruct Please Add Note************
		BOOL  articleListView=TRUE;
            
		if (appDelegate.aritcleListView == TRUE) {
			if (appDelegate.diveceType  == isOne) {// here Ipad Code open
				if (appDelegate.clinicsDetails==kTAB_CLINICS) {
					articleListView=FALSE;
					ClinicDetailViewController   *clinicdetails=(ClinicDetailViewController *)appDelegate.m_rootViewController.m_clinicDetailVC;
					[clinicdetails completeDwonloadFullTextAndPdf]; 
				}
				
				if (appDelegate.clinicsDetails==kTAB_BOOKMARKS) {
					articleListView=FALSE;
					BookMarksDetailsViewController_iPad  *bookmarksDetailsView=(BookMarksDetailsViewController_iPad *)appDelegate.m_rootViewController.bookMarkDetailsView;
					[bookmarksDetailsView completeDwonloadFullTextAndPdf];
					
				} 
				
				if (appDelegate.clinicsDetails==kTAB_NOTES) {
					articleListView=FALSE;
					NotesDetailsViewController_iPad  *notesDetailsView=(NotesDetailsViewController_iPad *)appDelegate.m_rootViewController.m_NotesDetailsView;
					[notesDetailsView completeDwonloadFullTextAndPdf];
					
				}
				
				
			}
			//  ******************here Ipad Code close ******************
			else {  
				// ****************** here Iphone code ******************
				
				if (appDelegate.clinicsDetails == kTAB_CLINICS) {
                    
					[appDelegate.clinicsdeatils_iPhone completeDwonloadFullTextAndPdf];
				 }
				
				if (appDelegate.clinicsDetails==kTAB_BOOKMARKS) {
					BookMarksDetailsViewController_iPhone  *bookmarksDetailsView_iPhone=(BookMarksDetailsViewController_iPhone *)appDelegate.rootView_iPhone.bookmarks_iPhone.bookmarkDetails_iPhone;
					[bookmarksDetailsView_iPhone completeDwonloadFullTextAndPdf];
					
				} 
				
				if (appDelegate.clinicsDetails==kTAB_NOTES) {
					NotesDetailsViewController_iPhone  *notesDetailsView_iPhone=(NotesDetailsViewController_iPhone *)appDelegate.rootView_iPhone.noteLists_iPhone.noteDetailsView_iPhone;
					[notesDetailsView_iPhone completeDwonloadFullTextAndPdf];
					
				}
			}
				
				
		if (articleListView==TRUE) {
			if (appDelegate.diveceType  == isOne)// *************this iPad*************
			 [appDelegate.ariticleListView completeDwonloadFullTextAndPdfReloadONWebView];
			else// *************this is iPhone*************
			[appDelegate.wewView_iPhone.aricleToCView completeDwonloadFullTextAndPdfReloadONWebView];
		 }
		}
		// This Condition Only For Download Alert Come In Abstruct Please Add Note
		else {
			if (appDelegate.diveceType  == isOne)
			[appDelegate.webViewController loadHtmlFileAddNotes];
				else
				[appDelegate.wewView_iPhone loadHtmlFileAddNotes];
		}

			
		}
	else{
		// remove file Home Directory
		if (appDelegate.openHTMLADDNoteOpenView == TRUE) {
			if (appDelegate.diveceType  == isOne)
				[appDelegate.webViewController loadHtmlFileAddNotes];
			else
				[appDelegate.wewView_iPhone loadHtmlFileAddNotes];
			
		}else {

		
		NSFileManager *filemanager=[NSFileManager defaultManager];
		NSError *error;

		NSString  *file=  [fileDocPath substringToIndex:[fileDocPath length] - 1];
		NSLog(@" file %@",file);
            if([filemanager fileExistsAtPath:file]){
                //NSLog(@"rohit removeItemAtPath4");
			[filemanager removeItemAtPath:file error:&error];
                
            }
		}
	
	}
        
        
	
}
    

    // Remove Zip File 
    NSFileManager *filemanager=[NSFileManager defaultManager];
    NSError *error;

    if([filemanager fileExistsAtPath:filePath]){
        //NSLog(@"rohit removeItemAtPath111");
        [filemanager removeItemAtPath:filePath error:&error];
    }
    

	
}

- (void)didReceiveMemoryWarning {
}


@end
