
//  DownloadingLoaderView.m
//  AR
//
//  Created by Subhash Chand on 3/1/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import "DownloadingLoaderView.h"
#import "ClinicsAppDelegate.h"

#define PROCESS_BAR_WIDTH 400.0
#define PROCESS_BAR_HEIGHT 20.0
#define PROCESS_BAR_WIDTH_iPhone 260.0
#define PROCESS_BAR_HEIGHT_iPhone 15.0

@implementation DownloadingLoaderView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		ClinicsAppDelegate   *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
		self.backgroundColor = [UIColor blackColor];
		self.alpha=0.60;
		if (appDelegate.diveceType == 1) {   // here is Open Ipad Code
            
            downloadlbl=[[UILabel alloc]initWithFrame:CGRectMake(0.0, (self.frame.size.height-70)/2+75, self.frame.size.width, 30)];
            downloadlbl.backgroundColor=[UIColor clearColor];
            [downloadlbl setTextColor:[UIColor whiteColor]];
            [downloadlbl setTextAlignment:UITextAlignmentCenter];
            downloadlbl.font=[UIFont boldSystemFontOfSize:20];
            
            
            [self addSubview:downloadlbl];
            
            downloadArticle=[[UILabel alloc]initWithFrame:CGRectMake(0.0, (self.frame.size.height-70)/2+45, self.frame.size.width, 30)];
            downloadArticle.backgroundColor=[UIColor clearColor];
            [downloadArticle setTextColor:[UIColor whiteColor]];
            [downloadArticle setTextAlignment:UITextAlignmentCenter];
            downloadArticle.font=[UIFont boldSystemFontOfSize:20];
            [self addSubview:downloadArticle];
            
            indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.frame.size.width-40)/2,(self.frame.size.height-70)/2,25,25)];
            indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            [self addSubview:indicatorView];
            [indicatorView startAnimating];
            // Initialization code
            processBgImage=[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-PROCESS_BAR_WIDTH)/2+15,  (self.frame.size.height-70)/2+120, PROCESS_BAR_WIDTH, PROCESS_BAR_HEIGHT)];
            [processBgImage setImage:[UIImage imageNamed:@"Process-bar.png"]];
            [self addSubview:processBgImage];
            processBgImage.hidden=YES;
            processFillImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.0+15,  0.0, PROCESS_BAR_WIDTH, PROCESS_BAR_HEIGHT)];
            [processFillImage setImage:[UIImage imageNamed:@"Process-bar-loader.png"]];
		}// here is Open Ipad close
		else {
			
            downloadlbl=[[UILabel alloc]initWithFrame:CGRectMake(40, 260, 200, 30)];
            downloadlbl.backgroundColor=[UIColor clearColor];
			[downloadlbl setTextColor:[UIColor whiteColor]];
			[downloadlbl setTextAlignment:UITextAlignmentCenter];
			downloadlbl.font=[UIFont boldSystemFontOfSize:14];
            
			[self addSubview:downloadlbl];
			
			downloadArticle=[[UILabel alloc]initWithFrame:CGRectMake(0, 240, 320, 30)];
			downloadArticle.backgroundColor=[UIColor clearColor];
			[downloadArticle setTextColor:[UIColor whiteColor]];
			[downloadArticle setTextAlignment:UITextAlignmentCenter];
			downloadArticle.font=[UIFont boldSystemFontOfSize:14];
			[self addSubview:downloadArticle];
			
            
			indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150,220,25,25)];
			indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
			[self addSubview:indicatorView];
			[indicatorView startAnimating];
			// Initialization code
			processBgImage=[[UIImageView alloc]initWithFrame:CGRectMake(15,  295, PROCESS_BAR_WIDTH_iPhone, PROCESS_BAR_HEIGHT_iPhone)];
			[processBgImage setImage:[UIImage imageNamed:@"Process-bar.png"]];
			[self addSubview:processBgImage];
			processBgImage.hidden=YES;
            processFillImage=[[UIImageView alloc]initWithFrame:CGRectMake(0.0+15,  0.0, PROCESS_BAR_WIDTH_iPhone, PROCESS_BAR_HEIGHT_iPhone)];
            [processFillImage setImage:[UIImage imageNamed:@"Process-bar-loader.png"]];
			
		}
        
        
		
		
    }
    return self;
}

-(void)ChangeFramedwonloadingSubView{
    
	if ([CGlobal isOrientationPortrait]) {
        cencelBtn.frame = CGRectMake((self.frame.size.width-PROCESS_BAR_WIDTH)/2+PROCESS_BAR_WIDTH+30 ,(self.frame.size.height-70)/2+115, 28, 28.0);
        downloadlbl.frame=CGRectMake(0.0, (self.frame.size.height-70)/2+75, self.frame.size.width, 30);
        downloadArticle.frame=CGRectMake(0.0, (self.frame.size.height-70)/2+45, self.frame.size.width, 30);
        indicatorView.frame=CGRectMake((self.frame.size.width-40)/2,(self.frame.size.height-70)/2,37,37);
        processBgImage.frame=CGRectMake((self.frame.size.width-PROCESS_BAR_WIDTH)/2,  (self.frame.size.height-70)/2+120, PROCESS_BAR_WIDTH, PROCESS_BAR_HEIGHT);
        processFillImage.frame=CGRectMake(0.0,  0.0, PROCESS_BAR_WIDTH, PROCESS_BAR_HEIGHT);
	}else {
		cencelBtn.frame = CGRectMake((self.frame.size.width-PROCESS_BAR_WIDTH)/2+PROCESS_BAR_WIDTH+50 ,(self.frame.size.height-70)/2+115, 28, 28.0);
		downloadlbl.frame=CGRectMake(20, (self.frame.size.height-70)/2+75, self.frame.size.width, 30);
		downloadArticle.frame=CGRectMake(20, (self.frame.size.height-70)/2+45, self.frame.size.width, 30);
		indicatorView.frame=CGRectMake((self.frame.size.width-40)/2+20,(self.frame.size.height-70)/2,37,37);
		processBgImage.frame=CGRectMake((self.frame.size.width-PROCESS_BAR_WIDTH)/2+20,  (self.frame.size.height-70)/2+120, PROCESS_BAR_WIDTH, PROCESS_BAR_HEIGHT);
		processFillImage.frame=CGRectMake(20,  0.0, PROCESS_BAR_WIDTH, PROCESS_BAR_HEIGHT);
	}
    
	
}
-(void)setDownloadedArticle:(NSString*)massageString
{
    ClinicsAppDelegate   *appDelegate= (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	if (cencelBtn) {
		[cencelBtn removeFromSuperview];
		[cencelBtn release];
		cencelBtn=nil;
		
	}
	if (appDelegate.diveceType == 1) {
        cencelBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width-PROCESS_BAR_WIDTH)/2+PROCESS_BAR_WIDTH+25 ,(self.frame.size.height-70)/2+115, 28, 28.0)];
        [cencelBtn setBackgroundImage:[UIImage imageNamed:@"Loadingcancel.png"] forState:UIControlStateNormal];
	}
	else {
		cencelBtn=[[UIButton alloc]initWithFrame:CGRectMake(280,PROCESS_BAR_WIDTH_iPhone+30, 22, 22.0)];
		[cencelBtn setBackgroundImage:[UIImage imageNamed:@"Loadingcancel.png"] forState:UIControlStateNormal];
        
	}
    
	[cencelBtn addTarget:self action:@selector(cencelDownloadBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:cencelBtn];
	
	[downloadArticle setText:massageString];
}

-(void)setDisplayMassage:(NSString*)massageString
{
	[downloadlbl setText:massageString];
}

-(void)fillProcessImageForValue:(NSInteger)value
{
    ////NSLog(@"%d",value);
    ClinicsAppDelegate   *appDelegate = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
	if(processBgImage.hidden==YES)
		processBgImage.hidden=NO;
	if(value>0)
		[processBgImage addSubview:processFillImage];
	
	if (appDelegate.diveceType == 1) {
        processFillImage.frame=CGRectMake(0.0, 0.0, value*(PROCESS_BAR_WIDTH/100), PROCESS_BAR_HEIGHT);
	}else {
		processFillImage.frame=CGRectMake(0.0, 0.0, value*(PROCESS_BAR_WIDTH_iPhone/100), PROCESS_BAR_HEIGHT_iPhone);
        
	}
    
}

-(IBAction)cencelDownloadBtnClicked
{
	[[NSUserDefaults standardUserDefaults] setObject:@"101" forKey:@"Cancel"];
	[self removeFromSuperview];
	self=nil;
    
}



- (void)dealloc {
    [super dealloc];
	if (downloadlbl) 
        [downloadlbl release];
	if (indicatorView) 
        [indicatorView release];
	if (processBgImage) 
        [processBgImage release];
	
}


@end
