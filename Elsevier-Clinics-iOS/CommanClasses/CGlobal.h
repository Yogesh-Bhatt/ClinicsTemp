//
//  CGlobal.h
//  WoltersKluwer
//
//  Created by Kiwitech on 03/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CGlobal : NSObject 
{
}

+ (id)getViewFromXib:(NSString *)sNibName classname:(Class)ClassName owner:(id)owner;
+ (BOOL)isOrientationLandscape;
+ (BOOL)isOrientationPortrait;

+ (BOOL)isMailAccountSet;
+ (void)showMessage:(NSString *)sTitle msg:(NSString *)sMsg;

+ (NSDictionary *)jsonParsor;

+ (void) loadCategoryDataFromServer:(NSDictionary *)Dict;
+ (void) loadClinicsDataFromServer:(NSDictionary *)Dict;
+ (void) loadArticleDataFromServer:(NSDictionary *)Dict;
+ (void) loadIssueDataFromServer:(NSDictionary *)Dict;
+ (void) loadReferenceDataFromServer:(NSDictionary *)Dict;

+ (NSDictionary *)jsonParsorSecond:(NSString *)issueID;
+ (NSDictionary *)jsonParsorAricleInpress:(NSInteger )clinicId;
+ (NSDictionary *)dwoloadAllSeletedClinicsUpdateIssue: (NSArray *)clincsIdArr;
+(BOOL)checkNetworkReachabilityWithAlert;
+ (NSDictionary *)getCurrentDateFromServer;

+(void)updateLast12MonthIssue:(NSInteger)clinicId 
                     nextDate:(NSString *)nextDateStr 
                  currentDate:(NSString *)currentDateStr;



// *************** This Method Used for rememember subcription *******************

+(void)updateOnOurServerClinicsSubcription:(NSString *)uinqueId 
                              withClinicId:(NSInteger )clinicId;
    


+(BOOL)thisClinicsHaveASubcription:(NSString *)uinqueId 
  withClinicId:(NSInteger )clinicId;


+(void)setFrameWith:(UIView *)a_view;

+(void)removeZipAtFilePath:(NSString *)a_strPath;


@end

