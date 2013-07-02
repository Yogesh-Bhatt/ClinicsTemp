//
//  PDFHomeView.m
//  PW_iPad
//
//  Created by Subhash Chand on 1/25/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import "PDFHomeView.h"
#import "PDFController.h"

@implementation PDFHomeView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self setBackgroundColor:[UIColor redColor]];
		
	}
    return self;
}
-(void)loadPdfForFileName:(ArticleData*)articalObject
{
	UIImageView *topBarImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 36.0)]autorelease];
	[topBarImageView setImage:[UIImage imageNamed:@"sami-top-bar.png"]];
	[topBarImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self addSubview:topBarImageView];
	
	UIImageView *botomBarImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0.0, self.frame.size.height-36.0, self.frame.size.width, 36.0)]autorelease];
	[botomBarImageView setImage:[UIImage imageNamed:@"sami-top-bar.png"]];
	[botomBarImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self addSubview:botomBarImageView];
	
	UIButton *backBtn=[[[UIButton alloc]initWithFrame:CGRectMake(20.0, 6.0, 151.0, 24.0)]autorelease];
	[backBtn setImage:[UIImage imageNamed:@"pdf_home_back_btn.png"] forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:backBtn];
	
	PDFController *pdfController=[PDFController sharedController];
	[pdfController loadPdf:articalObject];
	
	viewHeading = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-100.0,0,68.0,36)];
	viewHeading.text= @"";
	viewHeading.backgroundColor=[UIColor clearColor];
	viewHeading.textAlignment=UITextAlignmentCenter;
	viewHeading.font=[UIFont systemFontOfSize:20];
	viewHeading.textColor=[UIColor colorWithRed:0.146 green:0.254 blue:0.326 alpha:1.0];

	[self addSubview:viewHeading];
	
	[viewHeading setText:[NSString stringWithFormat:@"%i/%i",pdfController.currentPage,pdfController.totalPages]];
	
	
	[self loadFirstPdfView];
	
	pdfLoader=[[PdfLoader alloc]initWithFrame:CGRectMake(PDF_SCROLLER_X_OFFSET, PDF_SCROLLER_Y_OFFSET, PDF_SCROLLER_WIDTH, PDF_SCROLLER_HEIGHT)];
	[self addSubview:pdfLoader];
	pdfLoader.hidden=YES;
}

-(void)changePdfOrientation:(UIInterfaceOrientation)interfaceOrientation{
	pdfScrollView.frame= CGRectMake(PDF_SCROLLER_X_OFFSET, PDF_SCROLLER_Y_OFFSET, PDF_SCROLLER_WIDTH, PDF_SCROLLER_HEIGHT);
	[self pageTurnBelow];
	
	viewHeading.frame=	CGRectMake(self.frame.size.width-100.0,0,68.0,36);
	
	

	
}

-(void)showLoader
{
	pdfLoader.hidden=NO;
	[self bringSubviewToFront:pdfLoader];
}

-(void)hideLoader
{
	pdfLoader.hidden=YES;
}
-(void)loadFirstPdfView
{
	pdfScrollView=[[PDFReaderScroller alloc]initWithFrame:CGRectMake(PDF_SCROLLER_X_OFFSET, PDF_SCROLLER_Y_OFFSET, PDF_SCROLLER_WIDTH, PDF_SCROLLER_HEIGHT)];
	[pdfScrollView setPDFDelegate:self];
	[self addSubview:pdfScrollView];
}


- (void)pdfAnimationDidStop {
	
	[pdfScrollView removeFromSuperview];
	[pdfScrollView release];
	pdfScrollView = tempPDFScrollView;
	[pdfScrollView setPDFDelegate:self];
	tempPDFScrollView = nil;
	isPageAnimated=NO;
	
	PDFController *pdfController=[PDFController sharedController];
	[viewHeading setText:[NSString stringWithFormat:@"%i/%i",pdfController.currentPage,pdfController.totalPages]];
	
}

-(IBAction)backBtnClicked
{
	[self removeFromSuperview];
}
	

- (void)pageTurnNext {
	if(isPageAnimated)
		return;
	//[menuView hideMenuBtnClicked:menuView.viewHideShowBtn];

	
	PDFController *pdfCtrlr = [PDFController sharedController];
	if (![pdfCtrlr pageTurnNext]) return;
	float translate = 0.0;
		tempPDFScrollView = [[PDFReaderScroller alloc] initWithFrame:CGRectMake(PDF_SCROLLER_WIDTH, PDF_SCROLLER_Y_OFFSET, PDF_SCROLLER_WIDTH, PDF_SCROLLER_HEIGHT)];
		translate=PDF_SCROLLER_WIDTH;
	
	
	[tempPDFScrollView setContentOffset:CGPointMake(0.0, tempPDFScrollView.contentOffset.y)];
	
	isPageAnimated=YES;

	[self addSubview:tempPDFScrollView];
	
	[UIView beginAnimations:@"next page" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(pdfAnimationDidStop)];
	
	tempPDFScrollView.center = CGPointMake(tempPDFScrollView.center.x - translate, tempPDFScrollView.center.y);
	pdfScrollView.center = CGPointMake(pdfScrollView.center.x - translate, pdfScrollView.center.y);
	[UIView commitAnimations];
	
	
}


- (void)pageTurnPrev {	
	if(isPageAnimated)
		return;
	
	//[menuView hideMenuBtnClicked:menuView.viewHideShowBtn];
	PDFController *pdfCtrlr = [PDFController sharedController];
	if (![pdfCtrlr pageTurnPrev]) return;
	
	float translate = 0.0;
		tempPDFScrollView = [[PDFReaderScroller alloc] initWithFrame:CGRectMake(-PDF_SCROLLER_WIDTH, PDF_SCROLLER_Y_OFFSET, PDF_SCROLLER_WIDTH, PDF_SCROLLER_HEIGHT)];
		translate = PDF_SCROLLER_WIDTH;
	
	
	
	[tempPDFScrollView setContentOffset:CGPointMake(tempPDFScrollView.contentSize.width-tempPDFScrollView.frame.size.width, tempPDFScrollView.contentOffset.y)];
	isPageAnimated=YES;
	[self addSubview:tempPDFScrollView];
	
	[UIView beginAnimations:@"next page" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(pdfAnimationDidStop)];
	
	tempPDFScrollView.center = CGPointMake(tempPDFScrollView.center.x + translate, tempPDFScrollView.center.y);
	pdfScrollView.center = CGPointMake(pdfScrollView.center.x + translate, pdfScrollView.center.y);
	[UIView commitAnimations];
	
}

- (void)pageTurnBelow {
	if(isPageAnimated)
		return;
	//[menuView hideMenuBtnClicked:menuView.viewHideShowBtn];

		tempPDFScrollView = [[PDFReaderScroller alloc] initWithFrame:CGRectMake(0.0, PDF_SCROLLER_Y_OFFSET, PDF_SCROLLER_WIDTH, PDF_SCROLLER_HEIGHT)];
	
	
	
	[tempPDFScrollView setContentOffset:CGPointMake(tempPDFScrollView.contentSize.width-tempPDFScrollView.frame.size.width, tempPDFScrollView.contentOffset.y)];
	
	tempPDFScrollView.alpha = 0.0;
	isPageAnimated=YES;
	[self addSubview:tempPDFScrollView];
	tempPDFScrollView.tag=111;
	//[self pageOpenView:tempPDFScrollView duration:2.0f];
	[UIView beginAnimations:@"next page" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(pdfAnimationDidStop)];
	
	tempPDFScrollView.alpha = 1.0;
	pdfScrollView.alpha = 0.0;
	[UIView commitAnimations];
	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
