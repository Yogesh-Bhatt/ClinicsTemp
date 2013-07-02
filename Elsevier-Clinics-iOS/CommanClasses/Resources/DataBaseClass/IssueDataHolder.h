//
//  IssueDataHolder.h
//  Clinics
//
//  Created by Kiwitech on 10/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IssueDataHolder : NSObject
{   
	NSInteger   download;
    NSString *sIssueID;
    NSInteger nClinicID;
    NSString *sIssueTitle;
    NSInteger nIssueNumber;
    NSInteger nVolume;
    NSString *sReleaseDate;
    NSString *sEditors;
    NSString *sLastModified;
    NSString *sPrefaceTitle;
    NSString *sPreface;
    NSString *sPageRange;
	NSString  *cover_Img;
}
@property(nonatomic,assign)NSInteger   download;
@property(nonatomic, retain)NSString *sIssueID;
@property(nonatomic, assign)NSInteger nClinicID;
@property(nonatomic, retain)NSString *sIssueTitle;
@property(nonatomic, assign)NSInteger nIssueNumber;
@property(nonatomic, assign)NSInteger nVolume;
@property(nonatomic, retain)NSString *sReleaseDate;
@property(nonatomic, retain)NSString *sEditors;
@property(nonatomic, retain)NSString *sLastModified;
@property(nonatomic, retain)NSString *sPrefaceTitle;
@property(nonatomic, retain)NSString *sPreface;
@property(nonatomic, retain)NSString *sPageRange;
@property(nonatomic,retain)NSString  *cover_Img;


@end
