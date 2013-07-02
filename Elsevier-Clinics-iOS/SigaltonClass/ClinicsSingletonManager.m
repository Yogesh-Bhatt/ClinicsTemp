//
//  MCSingletonManager.m
//  MusicChoice
//
//  Created by Ashish Awasthi on 14/01/13.
//  Copyright (c) 2013 Kiwitech International. All rights reserved.
//

#import "ClinicsSingletonManager.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
//#import "IPAddress.h"


@implementation ClinicsSingletonManager

@synthesize delegate;
@synthesize m_arrLatestIssues;

static ClinicsSingletonManager* _sharedManager; // self


#pragma mark Singleton Methods

+(ClinicsSingletonManager *)sharedManager
{
    
	@synchronized(self) 
    {
        if (_sharedManager == nil) {
			
            [[self alloc] init]; // assignment not done here
        }
    }
    
    return _sharedManager;
}


-(id)init{
    
    self = [super init];
    
    if (self)
    {
       
        //_parseDataController = [[Controller alloc] init];
        //m_signedInFromMSO = NO;
        self.m_arrLatestIssues=[[NSMutableArray alloc]init];
       
    }
    
    return self;
}


+ (id)allocWithZone:(NSZone *)zone{	
    
    @synchronized(self) {
		
        if (_sharedManager == nil) {
			
            _sharedManager = [super allocWithZone:zone];
            
            
            return _sharedManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone{
    
    return self;	
}


- (id)retain{
	
    return self;	
}

- (unsigned)retainCount{
    
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    
    //do nothing
}

- (id)autorelease{
    
    return self;	
}

- (void)dealloc
{
    delegate = nil;
   
    [super dealloc];
}


-(void)getAlertViewForMailResultComposeController:(MFMailComposeResult)a_result{
    
	switch (a_result)
	{
		case MFMailComposeResultCancelled:
			[self showAlert:@"Message" 
                    message:@"Email was cancelled" 
                    withTag:0 
               withDelegate:nil];
			break;
			
		case MFMailComposeResultSaved:
			[self showAlert:@"Message" 
                    message:@"Email was saved" 
                    withTag:0 
               withDelegate:nil];
			break;	
			
		case MFMailComposeResultSent:
			[self showAlert:@"Message" 
                    message:@"Sent" 
                    withTag:0 
               withDelegate:nil];
			break;
			
		case MFMailComposeResultFailed:
			[self showAlert:@"Error" 
                    message:@"Sending Email Failed" 
                    withTag:0 
               withDelegate:nil];
			break;
		default:
			[self showAlert:@"Message" 
                    message:@"Email was not sent" 
                    withTag:0 
               withDelegate:nil];
			break;		
	}		
    
}



- (float)setHeightOfLbl:(NSString *)a_lblText 
            withLblFont:(UIFont *)a_fontStr 
           withLblWidth:(float)a_lblWidth{
    
	return [a_lblText sizeWithFont:a_fontStr 
                         constrainedToSize:CGSizeMake(a_lblWidth, 99999) 
                             lineBreakMode:UILineBreakModeWordWrap].height;
	
}



- (CGSize)getExpectedLabelSizeForText:(NSString *)a_textStr 
                                 fontName:(NSString*)a_fontStr  
                             fontSize:(NSInteger)a_fontSize 
                         maxLabelSize:(CGSize)a_maxSize
                        lineBreakMode:(UILineBreakMode)a_lineBreakMode
{
    return [a_textStr sizeWithFont:[UIFont systemFontOfSize:a_fontSize] 
             constrainedToSize:a_maxSize 
                 lineBreakMode:a_lineBreakMode];
}



- (UIImage*)getImageObjectFromName:(NSString *)a_imgNameStr
{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
                                             pathForAuxiliaryExecutable:a_imgNameStr]];
}



- (void)showAlert:(NSString*)a_titleStr 
          message:(NSString*)a_messageStr 
          withTag:(NSUInteger)a_tag 
     withDelegate:(UIViewController*)a_delegate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:a_titleStr 
                                                        message:a_messageStr 
                                                       delegate:a_delegate 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
    
    alertView.tag = a_tag;
    [alertView show];
    [alertView release];
}

- (void)showAlertWithOption:(NSString*)a_titleStr 
          message:(NSString*)a_messageStr 
          withTag:(NSUInteger)a_tag 
                 withOption:(NSArray *)OptionArr
     withDelegate:(UIViewController*)a_delegate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:a_titleStr 
                                                        message:a_messageStr 
                                                       delegate:a_delegate 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
    
    alertView.tag = a_tag;
    [alertView show];
    [alertView release];
}

-(BOOL)isCameraAvilable{
    
    BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    BOOL frontCameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerCameraDeviceFront];

    return cameraAvailable || frontCameraAvailable; 
}

- (NSString*)trimString:(NSString*)a_str
{
    return [a_str stringByTrimmingCharactersInSet:[NSCharacterSet 
                                                   whitespaceAndNewlineCharacterSet]];
}
 


-(BOOL)checkNetworkReachability
{
	Reachability *internetReachable = [[[Reachability reachabilityForInternetConnection] retain] autorelease];
	[internetReachable startNotifier];
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	
    switch (internetStatus){
            
		case NotReachable:
		{
			//////NSLog(@"The internet is down.");
			return NO;
			break;
		}
		case ReachableViaWiFi:
		{
			//////NSLog(@"The internet is working via WIFI.");
			return YES;
			break;
		}
		case ReachableViaWWAN:
		{
			//////NSLog(@"The internet is working via WWAN.");
			return YES;
			break;
		}
	}
	return FALSE;
}

-(BOOL)checkNetworkReachableViaWiFi
{
	Reachability *internetReachable = [[[Reachability reachabilityForInternetConnection] retain] autorelease];
	[internetReachable startNotifier];
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
   
    return (internetStatus == ReachableViaWiFi);
   
}

-(BOOL)checkNetworkReachableViaMobileNetwork
{
	Reachability *internetReachable = [[[Reachability reachabilityForInternetConnection] retain] autorelease];
	[internetReachable startNotifier];
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    
    return (internetStatus == ReachableViaWWAN);
return YES;
}


-(BOOL)checkNetworkReachabilityWithAlert{
	
	Reachability *internetReachable = [Reachability reachabilityForInternetConnection];
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    
	switch (internetStatus)
	
	{
		case NotReachable:
		{
		
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Unable to connect"
															message: @"No internet connection!"
														   delegate: self
												  cancelButtonTitle: @"OK"
												  otherButtonTitles: nil];
			[alert show];
			[alert release];
			return NO;
			break;
		}
		case ReachableViaWiFi:
		{
			////NSLog(@"The internet is working via WIFI.");
			return YES;
			break;
		}
		case ReachableViaWWAN:
		{
			////NSLog(@"The internet is working via WWAN.");
			return YES;
			break;
		}
	}
	return FALSE;
}



-(void)animationWithFrame:(CGRect)a_frame
                 withView:(UIView*)a_view 
             withSelector:(SEL)a_selector 
             withDuration:(float)a_duration 
             withDelegate:(id)a_delegate
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:a_duration];
    [UIView setAnimationDelegate:a_delegate];
    
    if(a_delegate != nil)
    {
        [UIView setAnimationDidStopSelector:a_selector];
    }
    
    a_view.frame = a_frame;
    [UIView commitAnimations];
}

-(void)animationWithFrame:(CGRect)a_frame
                  withView:(UIView*)a_view
                  withSubView:(NSArray*)subViewArr
              withAlpha:(float )a_alpha
              withSelector:(SEL)a_selector
             withDuration:(float)a_duration
             withDelegate:(id)a_delegate
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:a_duration];
    [UIView setAnimationDelegate:a_delegate];
    
    if(a_delegate != nil)
    {
        [UIView setAnimationDidStopSelector:a_selector];
    }
    
    for (UIView   *view in subViewArr) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.9];
        [UIView setAnimationDelegate:a_delegate];
        view.alpha = a_alpha;
        a_view.frame = a_frame;
         [UIView commitAnimations];
     }
   
    [UIView commitAnimations];
   
}

-(void)hideWithAlphaAnimation:(BOOL)a_flag
                     withView:(UIView*)a_view 
                 withSelector:(SEL)a_selector 
                 withDuration:(float)a_duration 
                 withDelegate:(id)a_delegate
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:a_duration];
    [UIView setAnimationDelegate:a_delegate];
    
    if(a_delegate != nil)
    {
        [UIView setAnimationDidStopSelector:a_selector];
    }
    
    if(a_flag)
    {
        a_view.alpha = 0;
    }
    else
    {
        a_view.alpha = 1;
    }
    
    
    [UIView commitAnimations];
}
    
-(void)drawViewBorder:(float)a_radius 
                    withMaskToBounds:(BOOL)a_flagB 
                    borderColor:(UIColor *)a_color 
                    borderWidth:(float)a_borderWidth
                    withView:(UIView *)a_view
{
    a_view.layer.cornerRadius = a_radius;
    a_view.layer.masksToBounds = a_flagB;
    a_view.layer.borderColor = [a_color CGColor];
    a_view.layer.borderWidth = a_borderWidth;
}

-(UIImage*)getImgFromDocumentDirWithName:(NSString*)a_name{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [[paths objectAtIndex:0] 
                               stringByAppendingPathComponent:a_name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:documentsPath];
    
    if (success){
        NSData *tempData = [NSData dataWithContentsOfFile:documentsPath];
        if(tempData != nil){
            return [UIImage imageWithContentsOfFile:documentsPath];
        }
    } 
    return nil;
}

- (NSString *)getLibraryPath
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *libraryFolderPath = [searchPaths objectAtIndex: 0];
    return libraryFolderPath;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setImageFromCache:(UIImageView *)a_imageView 
                 imageURLstring:(NSString *)a_strImgURL
{
    NSString *strImageName      = [[a_strImgURL componentsSeparatedByString:@"/"] lastObject];
    
    NSString *strImagePath      = [[self getLibraryPath] stringByAppendingPathComponent:strImageName];
    NSFileManager *filemanager  = [NSFileManager defaultManager];
    
    if([filemanager fileExistsAtPath:strImagePath])
    {
        a_imageView.image = [UIImage imageWithContentsOfFile:strImagePath];
    }
    else
    {
       // [MBProgressHUD showHUDAddedTo:a_imageView animated:YES];
        
        NSMutableDictionary *dictParam = [[[NSMutableDictionary alloc] init] autorelease];
        
        [dictParam setObject:a_strImgURL forKey:@"strImageUrl"];
        [dictParam setObject:a_imageView forKey:@"UIImageView"];
        
        
        [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:dictParam]; 
    }
}
    
- (void)loadImage:(NSMutableDictionary *)a_dictParam
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableString *strImgURL     =  [a_dictParam valueForKey:@"strImageUrl"];
    NSMutableString *strImageName      = [[strImgURL componentsSeparatedByString:@"/"] lastObject];
    
    [strImgURL replaceOccurrencesOfString:@" " 
                                 withString:@"%20" 
                                    options:NSCaseInsensitiveSearch 
                                      range:NSMakeRange(0, [strImgURL length])];
    
    NSData * imageData      = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strImgURL]];
    
    NSString *strImagePath  = [[self getLibraryPath] stringByAppendingPathComponent:strImageName];
    
    [imageData writeToFile:[NSString stringWithFormat:@"%@",strImagePath] atomically:YES];
    
    UIImage *img = [UIImage imageWithData:imageData];
    
    NSMutableDictionary *dictParam = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dictParam setObject:img forKey:@"UIImage"];
    [dictParam setObject:[a_dictParam valueForKey:@"UIImageView"] forKey:@"UIImageView"];
    
    [self performSelectorOnMainThread:@selector(setImageInThumb:)
                           withObject:dictParam
                        waitUntilDone:false];
    
    
    RELEASE(imageData);
    
    [pool drain];
}
    
- (void)setImageInThumb:(NSDictionary *)a_dictParam
    {
        UIImageView *imgView = [a_dictParam valueForKey:@"UIImageView"];
        UIImage  *image = [a_dictParam valueForKey:@"UIImage"];
        
        if(image)
        {
            imgView.image  = image;
        }
        else
        {
            imgView.image = [UIImage imageNamed:@"noimage.jpg"];
        }
        
       // [MBProgressHUD hideHUDForView:imgView animated:YES];
    }

- (NSString *)getExternalIPAddress
{
   
    NSUInteger  an_Integer;
    NSArray * ipItemsArray;
    NSString *externalIP;
    
    NSURL *iPURL = [NSURL URLWithString:@"http://www.dyndns.org/cgi-bin/check_ip.cgi"];
    
    if (iPURL) {
        NSError *error = nil;
        NSString *theIpHtml = [NSString stringWithContentsOfURL:iPURL 
                                                       encoding:NSUTF8StringEncoding 
                                                          error:&error];
        if (!error) {
            NSScanner *theScanner;
            NSString *text = nil;
            
            theScanner = [NSScanner scannerWithString:theIpHtml];
            
            while ([theScanner isAtEnd] == NO)
            {
                
                // find start of tag
                [theScanner scanUpToString:@"<" intoString:NULL] ; 
                
                // find end of tag
                [theScanner scanUpToString:@">" intoString:&text] ;
                
                // replace the found tag with a space
                //(you can filter multi-spaces out later if you wish)
                theIpHtml = [theIpHtml stringByReplacingOccurrencesOfString:
                             [ NSString stringWithFormat:@"%@>", text]
                                                                 withString:@" "] ;
                ipItemsArray =[theIpHtml  componentsSeparatedByString:@" "];
                an_Integer=[ipItemsArray indexOfObject:@"Address:"];
                
                externalIP =[ipItemsArray objectAtIndex:  ++an_Integer];
                
                
                
            } 
            
            
            //NSLog(@"%@",externalIP);
        } 
        else
        {
            /*NSLog(@"Oops... g %d, %@",
                  [error code], 
                  [error localizedDescription]);*/
        }
    }

    return externalIP;
}

- (NSString *)getWiFiConnIPAddress
{
    NSString *address           = @"error";
    struct ifaddrs *interfaces  = NULL;
    struct ifaddrs *temp_addr   = NULL;
    int success                 = 0;
    
    // retrieve the current interfaces - returns 0 on success
    
    success                     = getifaddrs(&interfaces);
    
    if (success == 0) 
    {
        // Loop through linked list of interfaces
        temp_addr               = interfaces;
        while(temp_addr != NULL) 
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];               
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    //address = @"69.180.0.0";
    
    //NSLog(@"%@", address);
    return address;

}

- (void)getActivityOnView:(UIView *)a_view style:(UIActivityIndicatorViewStyle)a_style
{
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:a_style];
    
    activity.frame = CGRectMake((a_view.frame.size.width - activity.frame.size.width)/2,
                                (a_view.frame.size.height - activity.frame.size.height)/2,
                                activity.frame.size.width, activity.frame.size.height);
    
    activity.tag = 989898;
    [a_view addSubview:activity];
    [activity startAnimating];
}

- (void)removeActivityFromView:(UIView *)a_view
{
    [(UIActivityIndicatorView *)[a_view viewWithTag:989898] stopAnimating];
    [[a_view viewWithTag:989898] removeFromSuperview];
}

- (BOOL)isAppRunningFirstTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];        
    
    if([defaults objectForKey:@"firstRun"])           
    {
        return NO;
    }
    
    return YES;

}


-(NSString *)parseDateInMCFormte:(NSString *)jsonDate {
    /*
     * This will convert DateTime (.NET) object serialized as JSON by WCF to a NSDate object.
     */
    
    // Input string is something like: "/Date(1292851800000+0100)/" where
    // 1292851800000 is milliseconds since 1970 and +0100 is the timezone
    NSString *inputString = [NSString stringWithString:jsonDate];
    
    // This will tell number of seconds to add according to your default timezone
    // Note: if you don't care about timezone changes, just delete/comment it out
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    
    // A range of NSMakeRange(6, 10) will generate "1292851800" from "/Date(1292851800000+0100)/"
    // as in example above. We crop additional three zeros, because "dateWithTimeIntervalSince1970:"
    // wants seconds, not milliseconds; since 1 second is equal to 1000 milliseconds, this will work.
    // Note: if you don't care about timezone changes, just chop out "dateByAddingTimeInterval:offset" part
    NSDate *date = [[NSDate dateWithTimeIntervalSince1970:
                     [[inputString substringWithRange:NSMakeRange(6, 10)] intValue]]
                    dateByAddingTimeInterval:offset];
    
    // You can just stop here if all you care is a NSDate object from inputString,
    // or see below on how to get a nice string representation from that date:
    
    // static is nice if you will use same formatter again and again (for example in table cells)
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        // If you're okay with the default NSDateFormatterShortStyle then comment out two lines below
        // or if you want four digit year, then this will do it:
        NSString *fourDigitYearFormat = [[dateFormatter dateFormat]
                                         stringByReplacingOccurrencesOfString:@"yy"
                                         withString:@"yyyy"];
        [dateFormatter setDateFormat:fourDigitYearFormat];
    }
    
    // There you have it:
    NSString *outputString = [dateFormatter stringFromDate:date];
    
   // //NSLog(@"Date from wcf JsonDate: %@", outputString);
    
   // return date;                         
    
    return outputString;
}

-(NSString*)getFormattedUTCDate:(NSString *)a_strJsonDate
{
    //@"/Date(1340185264667)/" ==> //Tue, 19 Jun 2012 19:41:15 GMT 
    
    //NSString *inputString   = [NSString stringWithString:a_strJsonDate];
    
    //NSInteger offset        = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    
    //no longer using epoch
    //NSDate *date            = [NSDate dateWithTimeIntervalSince1970:
                           //     [[inputString substringWithRange:NSMakeRange(6, 10)] intValue]];
    
    //dateByAddingTimeInterval:offset];
    
    ////NSLog(@"date is :%@",date);
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];    
    NSDate *date = [dateFormatter dateFromString:a_strJsonDate];
    [dateFormatter setDateFormat: @"EEE, dd MMM yyyy HH:mm:ss zzz"];
    
    return [dateFormatter stringFromDate:date];
    //return [dateFormatter stringFromDate:date];
}

-(NSString*)getFormattedLocalDate:(NSString *)a_strJsonDate
                       currentFormate:(NSString *)currentFormate
                       wantFormate:(NSString *)wantFormate
{    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:currentFormate];
    
    NSDate* date = [dateFormatter dateFromString:a_strJsonDate];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setDateFormat:wantFormate];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    return formattedDateString;
}


- (double)getCurrentTime
{
    double dateTime = [[NSDate date] timeIntervalSince1970];
    return dateTime;
}

-(BOOL)iSiPhoneDevice{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
        return YES;
    
    return NO;  
}
#pragma  mark validateEmail

- (BOOL) validateEmail: (NSString *) email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}

#pragma  mark date difference method

- (NSInteger)getDateDifference:(NSDate*)birthDate{
    
    NSDate *currentDate= [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar] 
                                       components:NSYearCalendarUnit 
                                       fromDate:birthDate
                                       toDate:currentDate
                                       options:0];
    NSInteger age = [ageComponents year];
    return age;
}

- (NSUInteger) getImageSize: (UIImage *)image
        imageExtension:(NSString *)imageExtension {
    if ([[imageExtension uppercaseString] compare:@"PNG"] == NSOrderedSame)
        return  [UIImagePNGRepresentation(image) length];

    if ([[imageExtension uppercaseString] compare:@"JPG"] == NSOrderedSame || [[imageExtension uppercaseString] compare:@"JPEG"] == NSOrderedSame)
        return  [UIImageJPEGRepresentation(image,0) length];

    return 0;
}


-(UIView*) wrapSiblingViews:(NSArray*)theSiblings ofSuperview:(UIView*)theSuperview
{
    CGRect bigEnoughFrame = [[theSiblings lastObject] frame];
    for (UIView * sib in theSiblings ) {
      bigEnoughFrame = CGRectUnion(bigEnoughFrame, sib.frame);
      }
    UIView * wrapper = [[UIView alloc] initWithFrame:bigEnoughFrame];
    
    [theSuperview insertSubview:wrapper aboveSubview:[theSiblings lastObject]];
    
    for (UIView * sib in theSiblings ) {
        CGRect newFrame = [theSuperview convertRect:sib.frame toView:wrapper];
       [sib removeFromSuperview];
        [wrapper addSubview:sib];
        sib.frame = newFrame;
        }
    
    return wrapper;
}

#pragma mark-
#pragma mark setAppBadgeNumber

-(void)setAppBadgeNumberTo:(NSInteger)number
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
    
}

@end
