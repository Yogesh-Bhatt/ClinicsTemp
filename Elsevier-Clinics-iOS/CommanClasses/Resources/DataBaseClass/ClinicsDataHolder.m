//
//  ClinicsDataHolder.m
//  Clinics
//
//  Created by Kiwitech on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClinicsDataHolder.h"


@implementation ClinicsDataHolder

@synthesize nCategoryID;
@synthesize nClinicID;
@synthesize sClinicTitle;
@synthesize sClinicImageName;
@synthesize sConsultingEditor;
@synthesize nNumberOfIssues;
@synthesize nModified;
@synthesize nShowClinic;
@synthesize arrIssue;
@synthesize sClinicShortCode;
@synthesize sChecked;
@synthesize authencation;
@synthesize CEName;


- (id)init 
{
    self = [super init];
	if(self)
	{
		self.CEName=0;
        self.nCategoryID = 0;
		self.authencation=0;
        self.nClinicID = 0;
		self.sClinicTitle = @"";
        self.sClinicImageName = @"";
        self.nNumberOfIssues = 0;
        self.sConsultingEditor = @"";
        self.nModified = 0;
        self.nShowClinic = -1;
        self.arrIssue = [[[NSMutableArray alloc] init] autorelease];
        self.sClinicShortCode = @"";
	}	
	return self;
}


#pragma mark - Memory management

- (void)dealloc
{
    RELEASE(sClinicShortCode);
    RELEASE(sClinicTitle);
    RELEASE(sClinicImageName);
    RELEASE(sConsultingEditor);
    
    [super dealloc];
}


@end
