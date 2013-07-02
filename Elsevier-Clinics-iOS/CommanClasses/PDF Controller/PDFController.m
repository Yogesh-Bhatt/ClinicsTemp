//
//  PDFController.m
//  SRPS
//
//  Created by Subhash on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PDFController.h"


@implementation PDFController
@synthesize pdfPage;
@synthesize totalPages;
@synthesize currentPage;


static PDFController * _sharedPdfController;

#pragma mark -
#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone {	
    @synchronized(self) {
        if (_sharedPdfController == nil) {
			// assignment and return on first allocation
            _sharedPdfController = [super allocWithZone:zone];	
			
            return _sharedPdfController;
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

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;	
}

+ (PDFController *)sharedController {
	@synchronized(self) {
        if (_sharedPdfController == nil) {
            [[self alloc] init];
        }
    }
    return _sharedPdfController;
}

- (void)dealloc {
	[_sharedPdfController release];
	[super dealloc];
}


#pragma mark -
#pragma mark PDF Methods

-(NSString*)getPdfUrlForMagazineId:(NSString *)articalId withPdfFileName:(NSString*)fileName
{
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSMutableString *documentsDirectory=[[[NSMutableString alloc]initWithString:[paths objectAtIndex:0]]autorelease];

    documentsDirectory=(NSMutableString*)[documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
	if(![fileManager fileExistsAtPath:documentsDirectory])
		return nil;
	
	
	return documentsDirectory;
}

- (BOOL)loadPdf:(ArticleData*)articalObject {

	if(articalObject==nil)
		return FALSE;
	
	NSMutableString *pdfUrl= [[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@",articalObject]] autorelease];
	CFURLRef pdfURL = CFURLCreateWithFileSystemPath(NULL, (CFStringRef)pdfUrl, kCFURLPOSIXPathStyle, FALSE);	
	
	pdfBook = CGPDFDocumentCreateWithURL(pdfURL);
	CFRelease(pdfURL);
	
	
	totalPages = CGPDFDocumentGetNumberOfPages(pdfBook);
	if (totalPages == 0) {
		return FALSE;
	}
	currentPage=1;
	pdfPage = CGPDFDocumentGetPage (pdfBook, currentPage);
		
	//NSLog(@"Total Pages%i",totalPages);	
	return TRUE;
}




- (bool)pageTurnNext {
	if (currentPage >= totalPages)
		return NO;
	
	currentPage= currentPage + 1;
	
	pdfPage = CGPDFDocumentGetPage (pdfBook, currentPage);
	
	return YES;
}

- (bool)pageTurnPrev {
	if (currentPage == 1)
		return NO;
	
	currentPage = currentPage - 1;
	pdfPage = CGPDFDocumentGetPage (pdfBook, currentPage);
	
	
	return YES;
}


- (void)pageTurnTo:(int)aPage {
	
	currentPage = aPage;
	pdfPage = CGPDFDocumentGetPage (pdfBook, currentPage);
	
}
@end
