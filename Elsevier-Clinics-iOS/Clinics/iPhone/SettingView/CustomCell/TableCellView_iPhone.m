//
//  TableCellView_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "TableCellView_iPhone.h"


@implementation TableCellView_iPhone
@synthesize m_btnCheck;
@synthesize m_imgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
}

- (void)dealloc
{
	[m_imgView release];
    [super dealloc];
}

- (void)setData:(ClinicsDataHolder *)clinicsDataHolder
{
    m_clinicDataHolder = clinicsDataHolder;
    m_lblClinicName.text = clinicsDataHolder.sClinicTitle;
	m_lblEditor.text = clinicsDataHolder.sConsultingEditor;
	if ([clinicsDataHolder.sConsultingEditor length] == 1) {
		m_lblNamehardCode.hidden=TRUE;
		m_lblEditor.hidden=TRUE;
	}else {
		m_lblNamehardCode.hidden=FALSE;
		m_lblEditor.hidden=FALSE;
	}
	
	if(clinicsDataHolder.sChecked == 1){
		[m_btnCheck setBackgroundImage:[UIImage imageNamed:@"iPhone_RadioUnselected.png"] forState:UIControlStateNormal];
		
	}else {
		[m_btnCheck setBackgroundImage:[UIImage imageNamed:@"iPhone_RadioSelected.png"] forState:UIControlStateNormal];
	}
	
}

- (IBAction) buttonPressed:(id)sender
{
    DatabaseConnection *database = [DatabaseConnection sharedController];
    ClinicsDataHolder *clinicDataHolder = [[database loadClinicData:m_clinicDataHolder.nClinicID] retain]; 
    
    RELEASE(clinicDataHolder);
}

@end
