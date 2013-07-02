//
//  PDFHomeView.h
//  PW_iPad
//
//  Created by Subhash Chand on 1/25/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFReaderScroller.h"
#import "PdfLoader.h"
#import "Data.h"

#define PDF_SCROLLER_X_OFFSET 0.0
#define PDF_SCROLLER_Y_OFFSET 35.0
#define PDF_SCROLLER_WIDTH self.frame.size.width
#define PDF_SCROLLER_HEIGHT self.frame.size.height-60.0

@interface PDFHomeView : UIView {
	PDFReaderScroller *pdfScrollView;
	PDFReaderScroller *tempPDFScrollView;
	BOOL isPageAnimated;
	UILabel *viewHeading;
	PdfLoader *pdfLoader;
}
- (void)pageTurnBelow;
-(void)loadFirstPdfView;
-(void)showLoader;
-(void)hideLoader;
-(void)loadPdfForFileName:(ArticleData*)articalObject;
//-(void)setMenuView:(UIView*)menuViewObject;
-(void)changePdfOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
