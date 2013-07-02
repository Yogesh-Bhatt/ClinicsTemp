//
//  DownloadDeatilView_iPhoneCell.m
//  Clinics
//
//  Created by Kiwitech International on 29/06/13.
//
//

#import "DownloadDeatilView_iPhoneCell.h"
#import "ZipArchive.h"

@implementation DownloadDeatilView_iPhoneCell

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
        
        
        CGFloat xCord = 5;
        CGFloat yCord = 5;
        
        UILabel *m_lblTitle=[[UILabel alloc] init];
        m_lblTitle.frame=CGRectMake(xCord, yCord,180,15);
        m_lblTitle.backgroundColor=[UIColor clearColor];
        m_lblTitle.font = [UIFont boldSystemFontOfSize:10.0];
        m_lblTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
        m_lblTitle.textAlignment=UITextAlignmentLeft;
        m_lblTitle.text = a_title;
        [self addSubview:m_lblTitle];
        [m_lblTitle release];
        
        yCord = yCord + m_lblTitle.frame.size.height;
        
        
        UILabel *m_lblSubTitle=[[UILabel alloc] init];
        m_lblSubTitle.frame=CGRectMake(xCord, 0,180,15);
        m_lblSubTitle.backgroundColor=[UIColor clearColor];
        m_lblSubTitle.font = [UIFont boldSystemFontOfSize:14];
        m_lblSubTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
        m_lblSubTitle.textAlignment=UITextAlignmentLeft;
        m_lblSubTitle.text = a_subTitle;
        [self addSubview:m_lblSubTitle];
        [m_lblSubTitle release];
        
        
        yCord = yCord + m_lblSubTitle.frame.size.height;
        
        
        
        
        progressView = [[DDProgressView alloc] initWithFrame: CGRectMake(5.0f, rect.size.height-18, self.bounds.size.width-155.0f, 0.0f)] ;
        [progressView setOuterColor: [UIColor redColor]] ;
        [progressView setInnerColor: [UIColor blueColor]] ;
        [self addSubview: progressView] ;
        [progressView release] ;
        
        
        
        
        cAURLDownload = [CAURLDownload downloadURL:[NSURL URLWithString:m_url] target:self selector:@selector(downloadFinished:connection:) failSelector:@selector(downloadFailed:) downloadDataSel:@selector(downloadData:connection:) userInfo:nil];
        
        UIImage *img = [UIImage imageNamed:@"btn_cancel_download.png"];
        
        closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame=CGRectMake(174, progressView.frame.origin.y , img.size.width,img.size.height);
        [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_cancel_download.png"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeDownloading:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        yCord = yCord + progressView.frame.size.height;
        
        
        m_lblPercetTitle=[[UILabel alloc] init];
        m_lblPercetTitle.frame=CGRectMake(xCord,
                                          progressView.frame.origin.y+22,
                                          150,
                                          15);
        m_lblPercetTitle.backgroundColor=[UIColor clearColor];
        m_lblPercetTitle.font = [UIFont boldSystemFontOfSize:10];
        m_lblPercetTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1.0];
        m_lblPercetTitle.textAlignment=UITextAlignmentCenter;
        m_lblPercetTitle.text = [NSString stringWithFormat:@"Downloaded"];
        [self addSubview:m_lblPercetTitle];
        [m_lblPercetTitle release];
        
    }
    return self;
}


-(void)closeDownloading:(id)sender{
    
    if(cAURLDownload != nil)
        [cAURLDownload cancelDownload];
    closeButton.hidden = TRUE;
    
}

- (void)downloadData:(NSNumber *)value connection:(CAURLDownload *)connection {
    
    
    CGFloat val = [value floatValue]/100;
    [progressView setProgress:val] ;
    m_lblPercetTitle.text = [NSString stringWithFormat:@"%d%@ Downloaded",[value integerValue],@"%"];
    
}

- (void)downloadFinished:(NSData *)recievedData connection:(CAURLDownload *)connection {
    
    NSLog(@"%@",connection.url.absoluteString);
    
    
    closeButton.hidden = TRUE;
    
    NSString   *zipFileName=[[connection.url.absoluteString componentsSeparatedByString:@"/"] lastObject];
    
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [(NSString *)[paths objectAtIndex:0] stringByAppendingPathComponent:zipFileName];
    filePath = [NSString stringWithFormat:@"%@/%@.zip",documentsDirectory,zipFileName];
    fileDocPath = [NSString stringWithFormat:@"%@/",documentsDirectory];
    
    
    NSFileManager *filemanager=[NSFileManager defaultManager];
    
	if(![filemanager contentsOfDirectoryAtPath:fileDocPath error:nil])
		[filemanager createDirectoryAtPath:fileDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSLog(@"Write Data");
    
    
	if(![filemanager fileExistsAtPath:filePath])
		[[NSFileManager defaultManager] createFileAtPath:filePath	contents: nil attributes: nil];
    
	NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	[handle seekToEndOfFile];
	[handle writeData:recievedData];
    [handle closeFile];
    
    recievedData = nil;
    NSLog(@"Un Zip Write Data");
    
    ZipArchive *za = [[ZipArchive alloc] init];
    
	if ([za UnzipOpenFile: filePath]) {
		BOOL ret = [za UnzipFileTo:fileDocPath overWrite: YES];
		if (NO == ret){
            
            NSLog(@"Error while unzip code rohit");
        }
        [za UnzipCloseFile];
	}else{
        
        NSLog(@"Unable to unzip the file");
    }
	[za release];
    
    
    NSError *error;
    
    //NSString  *file=  [fileDocPath substringToIndex:[filePath length] - 1];
    
    NSLog(@"fileDocPath %@ \n filePath %@",fileDocPath,filePath);
    if([filemanager fileExistsAtPath:filePath]){
        NSLog(@"rohit removeItemAtPath4");
        [filemanager removeItemAtPath:filePath error:&error];
        
    }
    
    
    
    
}

- (void)downloadFailed:(CAURLDownload *)connection {
    NSLog(@"Download Failed!");
    closeButton.hidden = TRUE;
    
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
