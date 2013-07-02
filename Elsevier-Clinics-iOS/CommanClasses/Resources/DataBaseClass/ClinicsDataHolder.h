//
//  ClinicsDataHolder.h
//  Clinics
//
//  Created by Kiwitech on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ClinicsDataHolder : NSObject 
{
    NSInteger   nCategoryID;
    NSInteger   nClinicID;
    NSString    *sClinicTitle;
    NSString    *sClinicImageName;
    NSString    *sConsultingEditor;
    NSInteger   nNumberOfIssues;
    NSInteger   nModified;
    NSInteger   nShowClinic;
    
    NSMutableArray *arrIssue;
     NSInteger sChecked;
    NSString    *sClinicShortCode;
	NSInteger   authencation;
	NSInteger  CEName;
    
}
@property(nonatomic,assign)NSInteger  CEName;
@property(nonatomic,assign)NSInteger   authencation;
@property(nonatomic,assign) NSInteger sChecked;
@property(nonatomic, assign)NSInteger   nCategoryID;
@property(nonatomic, assign)NSInteger   nClinicID;
@property(nonatomic, retain)NSString    *sClinicTitle;
@property(nonatomic, retain)NSString    *sClinicImageName;
@property(nonatomic, retain)NSString    *sConsultingEditor;
@property(nonatomic, assign)NSInteger   nNumberOfIssues;
@property(nonatomic, assign)NSInteger   nModified;
@property(nonatomic, assign)NSInteger   nShowClinic;

@property(nonatomic, retain)NSMutableArray    *arrIssue;
@property(nonatomic, retain)NSString    *sClinicShortCode;



@end
