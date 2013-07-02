//
//  ClinicDetailHeaderCellView.m
//  Clinics
//
//  Created by Kiwitech on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClinicDetailHeaderCellView.h"


@implementation ClinicDetailHeaderCellView
@synthesize callerDelegate;
@synthesize m_imgView;
@synthesize m_lblClinicTitle;
@synthesize m_lblDate;
@synthesize m_lblIssueTitle;
@synthesize m_lblConsultingEditor;
@synthesize m_downloadBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    callerDelegate = nil;
    RELEASE(m_imgView);
    RELEASE(m_lblClinicTitle);
    RELEASE(m_lblDate);
    RELEASE(m_lblIssueTitle);
    RELEASE(m_lblConsultingEditor);
    
    [super dealloc];
}

-(IBAction)downloadIssue:(id)sender{
    
    if([callerDelegate respondsToSelector:@selector(downloadIssue)]){
        
        [callerDelegate downloadIssue];
        
    }
    
}

@end
