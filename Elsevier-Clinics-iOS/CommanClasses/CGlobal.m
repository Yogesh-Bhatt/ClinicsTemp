//
//  CGlobal.m
//  WoltersKluwer
//
//  Created by Kiwitech on 03/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CGlobal.h"
#import <MessageUI/MessageUI.h>
#import "JSON.h"
#import "Reachability.h"
#import "ReferenceData.h"

@implementation CGlobal


+ (id)getViewFromXib:(NSString *)sNibName classname:(Class)ClassName owner:(id)owner
{
	id View = nil;
	NSArray *arrViews = [[NSBundle mainBundle] loadNibNamed:sNibName owner:owner options:nil];
	for(id view in arrViews)
	{
		if([view isKindOfClass:ClassName])
		{
			View = view;
		}
	}
	return View;
}

//********************** Check Orienation ****************************

+ (BOOL)isOrientationLandscape
{	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	UIDeviceOrientation orienStatusBar = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
	
	if((orientation == UIInterfaceOrientationPortrait) || (orientation == UIDeviceOrientationPortraitUpsideDown))  
	{
		return NO;
	}
	else if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) 
	{
		return YES;
	}
	else  
	{
		if ((orienStatusBar == UIDeviceOrientationPortrait) || (orienStatusBar == UIDeviceOrientationPortraitUpsideDown))
		{
			return NO;
		}
		else if ((orienStatusBar == UIDeviceOrientationLandscapeLeft) || (orienStatusBar == UIDeviceOrientationLandscapeRight))
		{
			return YES;
		}
	}	
	return NO;
}

//********************** Check Orienation ****************************

+ (BOOL)isOrientationPortrait
{	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	UIDeviceOrientation orienStatusBar = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
	
	if((orientation == UIInterfaceOrientationPortrait) || (orientation == UIDeviceOrientationPortraitUpsideDown))  
	{
		return YES;
	}
	else if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) 
	{
		return NO;
	}
	else  // for faceup or facedown orientation
	{
		if ((orienStatusBar == UIDeviceOrientationPortrait) || (orienStatusBar == UIDeviceOrientationPortraitUpsideDown))
		{
			return YES;
		}
		else if ((orienStatusBar == UIDeviceOrientationLandscapeLeft) || (orienStatusBar == UIDeviceOrientationLandscapeRight))
		{
			return NO;
		}
	}	
	return NO;
}

//********************** Here CheCh mail Exixts Or Not ****************************

+ (BOOL)isMailAccountSet
{
    if(![MFMailComposeViewController canSendMail])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Mail Accounts" message:@" Please set up an e-mail account on your device in order to send email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    return YES;
}

//  ************** Show Message Alert ********************

+ (void)showMessage:(NSString *)sTitle msg:(NSString *)sMsg
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sTitle message:sMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

// ************************ Here dwonload  clinics data *****************************

+ (NSDictionary *)jsonParsor
{

	 DatabaseConnection *dbConnection=[DatabaseConnection sharedController];
    
     if([self checkNetworkReachabilityWithAlert]){
         
		NSMutableArray    *clinicIdArr=[dbConnection retriveSelectedCinnicID];
		NSMutableString   *str=[[NSMutableString alloc] init];
         
		for (int i=0; i<[clinicIdArr count]; i++) {
			if (i==[clinicIdArr count]-1) 
			[str appendString:[NSString stringWithFormat:@"%@",[clinicIdArr objectAtIndex:i]]];
			else 
			[str appendString:[NSString stringWithFormat:@"%@,",[clinicIdArr objectAtIndex:i]]];

		}

		NSMutableString *getUpdateUrl=[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@%@",selectedClinics,str]];
		[getUpdateUrl replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [getUpdateUrl length])];
		
		
        
		NSError* error;
		NSString *responseString = [NSString stringWithContentsOfURL:[NSURL URLWithString:getUpdateUrl] encoding:NSUTF8StringEncoding  error:&error];
	
		SBJSON *json = [[SBJSON new] autorelease];
        [getUpdateUrl release];
		NSDictionary *dataDics = [json objectWithString:responseString error:&error];
         
        if (dataDics) {
            [[NSUserDefaults standardUserDefaults]setObject:[dataDics objectForKey:@"date"] forKey:@"lastDate"];
        }
		NSString  *date = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastDate"];
         
		[dbConnection upadateCheckUnCheckArticle:[NSString stringWithFormat:@"UPDATE tblClinic SET Modified = '%@' where ClinicID IN %@",date,clinicIdArr]];

		[str release];
        return dataDics;
    }
     
    return nil;
}


+(void)setFrameWith:(UIView *)a_view{
    
    if(IS_WIDESCREEN){
        CGRect rect =  a_view.frame;
        rect.size.height = 568;
        a_view.frame = rect;
        
	}
    
}
// ****************************** Here Dwonload isssue *************************

+ (NSDictionary *)jsonParsorSecond:(NSString *)str
{

      if([self checkNetworkReachabilityWithAlert]){
          
		NSMutableString *getUpdateUrl=[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@%@",kdownloadIssue,str]];
		[getUpdateUrl replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [getUpdateUrl length])];
		
		NSError* error;
		NSString *responseString = [NSString stringWithContentsOfURL:[NSURL URLWithString:getUpdateUrl] encoding:NSUTF8StringEncoding  error:&error];
	
		SBJSON *json = [[SBJSON new] autorelease];
        [getUpdateUrl release];
		NSDictionary *dataDics=[json objectWithString:responseString error:&error];
		

        return dataDics;
    }
	
    return nil;
}

// ****************************** Here Dwonload Article In Presss  ************************* 

+ (NSDictionary *)jsonParsorAricleInpress:(NSInteger )clinicId 
{
	DatabaseConnection *dbConnection=[DatabaseConnection sharedController];
    
	NSString  *date = [dbConnection selectModifiedDateFromClinicTable:[NSString stringWithFormat:@"select downloaddate from tblArticle where clinicID = %d and isArticleInPress=1",clinicId]];
	
    if([self checkNetworkReachabilityWithAlert]){
		NSMutableString *getUpdateUrl=[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@%d&date=%@",kdwonloadAricleInPress,clinicId,date]];
		[getUpdateUrl replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [getUpdateUrl length])];
		NSError* error;
		NSString *responseString = [NSString stringWithContentsOfURL:[NSURL URLWithString:getUpdateUrl] encoding:NSUTF8StringEncoding  error:&error];
		
		SBJSON *json = [[SBJSON new] autorelease];
        [getUpdateUrl release];
		NSDictionary *dataDics=[json objectWithString:responseString error:&error];

        return dataDics;
    }
	
    return nil;
}


//***************************************** here Dwonload update issue ********************

+ (NSDictionary *)dwoloadAllSeletedClinicsUpdateIssue:(NSArray *)clincsIdArr{
    
	DatabaseConnection *dbConnection = [DatabaseConnection sharedController];
    
    if([self checkNetworkReachabilityWithAlert]){
        
        NSMutableArray  *dateArr = [dbConnection selectModifiedDateFromArticleTable:[NSString stringWithFormat:@"select modified from tblclinic where clinicID IN %@",clincsIdArr]];
        
        NSMutableString   *dateStr=[[NSMutableString alloc] init];
        NSMutableString   *IdDStr=[[NSMutableString alloc] init];
        for (int i=0; i<[dateArr count]; i++) {
            if (i==[clincsIdArr count]-1) 
                [dateStr appendString:[NSString stringWithFormat:@"%@",[dateArr objectAtIndex:i]]];
            else 
                [dateStr appendString:[NSString stringWithFormat:@"%@,",[dateArr objectAtIndex:i]]];
            
        }
        
        for (int i=0; i<[clincsIdArr count]; i++) {
            if (i==[clincsIdArr count]-1) 
                [IdDStr appendString:[NSString stringWithFormat:@"%@",[clincsIdArr objectAtIndex:i]]];
            else 
                [IdDStr appendString:[NSString stringWithFormat:@"%@,",[clincsIdArr objectAtIndex:i]]];
            
        }
        
        
		NSMutableString *getUpdateUrl=[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@clinicid=%@&date=%@",kdwonloadAllUpdateIssue,IdDStr,dateStr]];
        RELEASE(IdDStr);
        RELEASE(dateStr);
        
        
		[getUpdateUrl replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [getUpdateUrl length])];
        
		NSError* error;
		NSString *responseString = [NSString stringWithContentsOfURL:[NSURL URLWithString:getUpdateUrl] encoding:NSUTF8StringEncoding  error:&error];
		
		
		SBJSON *json = [[SBJSON new] autorelease];
        [getUpdateUrl release];
		NSDictionary *dataDics=[json objectWithString:responseString error:&error];
        return dataDics;
    }
	
    return nil;
    
}

//***************************************** here Dwonload update issue ********************

+ (NSDictionary *)getCurrentDateFromServer{
    
    if([self checkNetworkReachabilityWithAlert]){
        
    NSMutableString *getUpdateUrl =[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@",KcurrentDataURL]];
  
		[getUpdateUrl replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [getUpdateUrl length])];
        
		NSError* error;
		NSString *responseString = [NSString stringWithContentsOfURL:[NSURL URLWithString:getUpdateUrl] encoding:NSUTF8StringEncoding  error:&error];
		
		
		SBJSON *json = [[SBJSON new] autorelease];
        [getUpdateUrl release];
		NSDictionary *dataDics=[json objectWithString:responseString error:&error];
        return dataDics;
    }
	
    return nil;
    
}


//*************** Save Category Data *****************************//

+ (void) loadCategoryDataFromServer:(NSDictionary *)Dict
{
    DatabaseConnection *dbConnection=[DatabaseConnection sharedController];
  
    NSArray *arrCategory = [Dict objectForKey:@"CATEGORY"];
    if ([arrCategory count] > 0)
    {
        for (int i=0; i< [arrCategory count]; i++)
        {
            CategoryDataHolder *categoryDataHolder = [dbConnection loadCategoryInfo: [[((NSMutableDictionary *) [arrCategory objectAtIndex:i]) objectForKey:@"Category_Id"] intValue]];
            
            if (categoryDataHolder.nCategoryID == 0)
            {
                [dbConnection saveCategoryData:[arrCategory objectAtIndex:i]];
            }
            else
            {
                [dbConnection updateCategoryData:[arrCategory objectAtIndex:i]];
            }
        }
    }
}

//*************** Save Clinic Data *****************************//

+ (void) loadClinicsDataFromServer:(NSDictionary *)Dict
{
    DatabaseConnection *dbConnection=[DatabaseConnection sharedController];

    NSArray *arrClinics = [Dict objectForKey:@"CLINICS"];
    if ([arrClinics count] > 0)
    {
        for (int i=0; i< [arrClinics count]; i++)
        {
            ClinicsDataHolder *clinicDataHolder = [dbConnection loadClinicData: [[((NSMutableDictionary *)[arrClinics objectAtIndex:i]) objectForKey:@"Clinic_Id"] intValue]];
            if (clinicDataHolder.nClinicID == 0)
            {
                [dbConnection saveClinicData:[arrClinics objectAtIndex:i]];
            }
            else
            {
                [dbConnection updateClinicData:[arrClinics objectAtIndex:i]];
            }
        }
    }     
}

//*************** Save Article Data *****************************//

+ (void) loadArticleDataFromServer:(NSDictionary *)Dict
{
    DatabaseConnection *dbConnection=[DatabaseConnection sharedController];
	NSArray *arrArticle;
	if ([[Dict objectForKey:@"ARTICLE"] count] > 0) {
		arrArticle = [Dict objectForKey:@"ARTICLE"];
		
		ArticleDataHolder *articleDAtaHolder;
		for (int i=0; i< [arrArticle count]; i++)
		{
			articleDAtaHolder = [dbConnection loadArticleInfo: [[((NSMutableDictionary *) [arrArticle objectAtIndex:i]) objectForKey:@"article_id"] intValue]];
			if (articleDAtaHolder.nArticleID == 0)
			{
				[dbConnection saveArticleData:[arrArticle objectAtIndex:i]];
			}
        }  
		
		
		
	}
}

//*************** Save ISSUE Data *****************************//

+ (void) loadIssueDataFromServer:(NSDictionary *)Dict
{
    //************************ This logix implement only access issue***************
    DatabaseConnection *database = [DatabaseConnection sharedController];
    NSDictionary    *dataDict =  [CGlobal getCurrentDateFromServer];
    
    NSString    *currentDateStr = [dataDict valueForKey:@"CurrentDate"];
     NSString    *backDateStr = [dataDict valueForKey:@"PreviousDate"];
    
    NSArray *arrIssue = [Dict objectForKey:@"ISSUE"];
  
    
    if ([arrIssue count] > 0)
    {
        for (int i=0; i< [arrIssue count]; i++)
        {
             NSDictionary    *dict = [arrIssue objectAtIndex:i];
           NSInteger   clinicId  = [[dict objectForKey:@"clinics_id"] intValue];
            NSInteger   issueId  = [[dict objectForKey:@"issue_id"] intValue];
            
            NSString   *query = [NSString  stringWithFormat:@"select IssueID from tblIssue where IssueID = '%d'",issueId] ;
            
            BOOL ishaveIssue  = [database findIssueIdIssueTable:query];
            
            if (!ishaveIssue)
            {
                [database saveIssueData:[arrIssue objectAtIndex:i]];
            }    
    
            [CGlobal updateLast12MonthIssue:clinicId  nextDate:backDateStr currentDate:currentDateStr];
        }
    }
    
    
}

+(void)removeZipAtFilePath:(NSString *)a_strPath{
    
    NSError *error = nil;
    NSFileManager *filemanager=[NSFileManager defaultManager];
    if([filemanager fileExistsAtPath:a_strPath]){
        NSLog(@"rohit removeItemAtPath4");
        [filemanager removeItemAtPath:a_strPath error:&error];
        
    }
    if(error != nil)
        NSLog(@"Error%@",[error localizedDescription]);
    
    
}

+(void)updateLast12MonthIssue:(NSInteger)clinicId 
                     nextDate:(NSString *)backDateDateStr 
                  currentDate:(NSString *)currentDateStr{
    
    DatabaseConnection *dbConnection = [DatabaseConnection sharedController];  
          
     NSString  *query  = [NSString stringWithFormat:@"UPDATE tblIssue SET Access = 1 where ClinicID = '%d' and ReleaseDate <= '%@' and ReleaseDate >= '%@'",clinicId,currentDateStr,backDateDateStr];
            
                       
    
        [dbConnection setFlagInAceessIssue:query];

}

// *************** This Method Used for rememember subcription *******************

+(void)updateOnOurServerClinicsSubcription:(NSString *)uinqueId 
                              withClinicId:(NSInteger )clinicId{
 
    NSString    *requestUrl = [NSString  stringWithFormat:@"%@%@&clinicId=%d",KSubcriptionUpdateUrl,uinqueId,clinicId];
    
    NSError* error;
    NSString *responseString = [NSString stringWithContentsOfURL:[NSURL URLWithString:requestUrl] encoding:NSUTF8StringEncoding  error:&error];
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *dataDict =[json objectWithString:responseString error:&error];
    NSArray   *dataArr = [dataDict valueForKey:@"code"];
    
    if ([[dataArr objectAtIndex:0] boolValue]) {
        
        //NSLog(@"update succesfully on server");
        
    }
    
    

    
}

+(BOOL)thisClinicsHaveASubcription:(NSString *)uinqueId 
                      withClinicId:(NSInteger )clinicId{
    
    BOOL  isitHaveSubcription = NO;
    
    NSString    *requestUrl = [NSString  stringWithFormat:@"%@%@&clinicId=%d",KIsItHaveSubcriptionUrl,uinqueId,clinicId];
    
    NSError* error;
    NSString *responseString = [NSString stringWithContentsOfURL:[NSURL URLWithString:requestUrl] encoding:NSUTF8StringEncoding  error:&error];
	
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *dataDict =[json objectWithString:responseString error:&error];
    NSArray   *dataArr = [dataDict valueForKey:@"code"];
    
    if ([[dataArr objectAtIndex:0] boolValue]) {
        isitHaveSubcription = YES;
    }
    

    return isitHaveSubcription;
}

// *************** This Method Used for rememember subcription *******************

+ (void) loadReferenceDataFromServer:(NSDictionary *)Dict
{
    DatabaseConnection *dbConnection=[DatabaseConnection sharedController];
	
    NSArray *referenaceArr = [Dict objectForKey:@"REFERENCE"];
    if ([referenaceArr count] > 0)
    {
        for (int i=0; i< [referenaceArr count]; i++)
        {

        [dbConnection saveRefeenceData:[referenaceArr objectAtIndex:i]];
            
        }
    }
	
}



// ******************** here Check net Work Reachability ************************************

+(BOOL)checkNetworkReachabilityWithAlert{
	
	Reachability *internetReachable = [[[Reachability reachabilityForInternetConnection] retain] autorelease];
	[internetReachable startNotifier];
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	switch (internetStatus)
	
	{
		case NotReachable:
		{
            
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Unable to connect"
															message: @"No internet connection!"
														   delegate: nil
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



@end
