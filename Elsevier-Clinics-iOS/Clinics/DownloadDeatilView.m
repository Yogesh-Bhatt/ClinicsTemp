//
//  DownloadDeatilView.m
//  Clinics
//
//  Created by Rohit Dhawan on 26/06/13.
//
//

#import "DownloadDeatilView.h"
#import "ZipArchive.h"

@implementation DownloadDeatilView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  downloadedCustomViewWithFrame:(CGRect)rect  withDownloadUrl:(NSString *)m_url withTitle:(NSString *)a_title withSubTitle:(NSString *)a_subTitle{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        CGFloat xCord = 10;;
        CGFloat yCord = 10;
        
        m_lblTitle=[[UILabel alloc] init];
        m_lblTitle.frame=CGRectMake(xCord, yCord, 300, 30);
        m_lblTitle.numberOfLines = 1;
        m_lblTitle.backgroundColor=[UIColor clearColor];
        m_lblTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        m_lblTitle.textColor = [UIColor colorWithRed:38/255.0 green:166.0/255.0 blue:221.0/255.0 alpha:1.0];
        m_lblTitle.textAlignment=UITextAlignmentLeft;
        m_lblTitle.text = a_title;
        [self addSubview:m_lblTitle];
        [m_lblTitle release];
        
        yCord = yCord + m_lblTitle.frame.size.height;
        
        
        progressView = [[DDProgressView alloc] initWithFrame: CGRectMake(20.0f,yCord+5, self.bounds.size.width-80.0f, 20.0f)] ;
        //[progressView setOuterColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"progressOuter.png"]]];
        [progressView setInnerColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"progress.png"]]];
        [self addSubview: progressView] ;
        [progressView release] ;
        
        cAURLDownload = [CAURLDownload downloadURL:[NSURL URLWithString:m_url] target:self selector:@selector(downloadFinished:connection:) failSelector:@selector(downloadFailed:) downloadDataSel:@selector(downloadData:didReceiveData:) userInfo:nil];
        
        UIImage *img = [UIImage imageNamed:@"btn_cancel_download.png"];
        
        closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame=CGRectMake(280, yCord+5 , img.size.width,img.size.height);
        [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_cancel_download.png"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeDownloading:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        yCord = yCord + progressView.frame.size.height;
        
        
        m_lblPercetTitle=[[UILabel alloc] init];
        m_lblPercetTitle.frame=CGRectMake(20,yCord,self.bounds.size.width-80.0f, 44);
        m_lblPercetTitle.backgroundColor=[UIColor clearColor];
        m_lblPercetTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:13];;
        m_lblPercetTitle.textColor = [UIColor colorWithRed:49.0/255.0 green:78.0/255.0 blue:132.0/255.0 alpha:1.0];
        m_lblPercetTitle.textAlignment=UITextAlignmentCenter;
        m_lblPercetTitle.text = [NSString stringWithFormat:@"%@ Downloaded",@"0%"];
        [self addSubview:m_lblPercetTitle];
        [m_lblPercetTitle release];
        
        m_resultTitle =[[UILabel alloc] init];
        m_resultTitle.frame=CGRectMake(xCord,50, 300, 40);
        m_resultTitle.numberOfLines = 1;
        m_resultTitle.backgroundColor=[UIColor clearColor];
        m_resultTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:10];
        m_resultTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
        m_resultTitle.textAlignment=UITextAlignmentCenter;
        m_resultTitle.text = @"";
        [self addSubview:m_resultTitle];
        [m_resultTitle release];
        m_resultTitle.hidden = TRUE;
             
    }
    return self;
}

- (void)refreshDataWithTitle:(NSString *)a_title{
    
    m_lblTitle.text = a_title;
    
}


-(void)displayMsg:(NSString *)a_msg{
    
    m_resultTitle.text = a_msg;
    m_resultTitle.hidden = FALSE;
    m_lblPercetTitle.hidden = TRUE;
    progressView.hidden = TRUE;
    closeButton.hidden = TRUE;
}

-(void)closeDownloading:(id)sender{
    
    if(cAURLDownload != nil)
        [cAURLDownload cancelDownload];
    
    [self displayMsg:@"Downloading Canceled"];
}

- (void)downloadData:(NSNumber *)value didReceiveData:(NSData *)data {
    
    
    CGFloat val = [value floatValue]/100;
    [progressView setProgress:val] ;
    m_lblPercetTitle.text = [NSString stringWithFormat:@"%d%@ Downloaded",[value integerValue],@"%"];
    
    data = nil;
}

- (void)downloadFinished:(NSData *)recievedData connection:(CAURLDownload *)connection {
    
    NSLog(@"%@",connection.url.absoluteString);
    
    [self displayMsg:@"Download Complete"];
   
    
    NSString   *zipFileName=[[connection.url.absoluteString componentsSeparatedByString:@"/"] lastObject];
    
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [(NSString *)[paths objectAtIndex:0] stringByAppendingPathComponent:zipFileName];
    filePath = [NSString stringWithFormat:@"%@/%@.zip",documentsDirectory,zipFileName];
    fileDocPath = [NSString stringWithFormat:@"%@/",documentsDirectory];
    
    
    //////////////////////////////to write first so that we have .zip file to check/////////////
    NSFileManager *filemanager=[NSFileManager defaultManager];
    
	if(![filemanager contentsOfDirectoryAtPath:fileDocPath error:nil])
		[filemanager createDirectoryAtPath:fileDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSLog(@"%@",filePath);
    
	if(![filemanager fileExistsAtPath:filePath])
		[[NSFileManager defaultManager] createFileAtPath:filePath	contents: nil attributes: nil];
    
	NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	[handle seekToEndOfFile];
	[handle writeData:recievedData];
    [handle closeFile];
    
    //////////////////////////////////////////////////////////////////////////////////////

    
    NSLog(@"Un Zip Write Data");
    
    ZipArchive *za = [[ZipArchive alloc] init];
    
    BOOL ret = NO;
    
	if ([za UnzipOpenFile: filePath]) {
		ret = [za UnzipFileTo:fileDocPath overWrite: YES];
		if (NO == ret){
            
            NSLog(@"Error while unzip code rohit");
        }
        [za UnzipCloseFile];
        
	}else{
        
        NSLog(@"Unable to unzip the file");
    }
	[za release];
   
    [CGlobal removeZipAtFilePath:filePath];
    recievedData = nil;
    
    //Update article tbl for downloaded data
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

}

- (void)downloadFailed:(CAURLDownload *)connection {
    NSLog(@"Download Failed!");
    [self displayMsg:@"Downloading Failed"];
   
    //Do something
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
