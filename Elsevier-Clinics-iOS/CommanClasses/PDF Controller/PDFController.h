//
//  PDFController.h
//  SRPS
//
//  Created by Subhash on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data.h"

@interface PDFController : NSObject {
	CGPDFPageRef pdfPage;
	CGPDFDocumentRef pdfBook;
	
	int totalPages;
	int currentPage;
}
//@property(nonatomic,retain)NSString *thumbPdfName;
@property CGPDFPageRef pdfPage;
@property int totalPages;
//-(CGPDFPageRef)getCurrentPdfPage;
@property int currentPage;
+ (PDFController *)sharedController;
- (bool)pageTurnNext;
- (bool)pageTurnPrev;
- (void)pageTurnTo:(int)aPage;
- (BOOL)loadPdf:(ArticleData*)articalObject;
@end
