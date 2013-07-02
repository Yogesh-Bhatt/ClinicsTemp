//
//  TableCellView.m
//  Clinics
//
//  Created by Kiwitech on 02/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableCellView.h"


@implementation TableCellView
@synthesize m_btnCheck;
@synthesize m_imgView;
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
	[m_imgView release];
    [super dealloc];
}

- (void)setData:(ClinicsDataHolder *)clinicsDataHolder
{
    m_clinicDataHolder = clinicsDataHolder;
 	

    m_lblClinicName.text = clinicsDataHolder.sClinicTitle;
     m_lblEditor.text = clinicsDataHolder.sConsultingEditor;
	if (clinicsDataHolder.CEName == isTwo)
		m_lblNamehardCode.text= @"Consulting Editors:";
	else 
		
	m_lblNamehardCode.text= @"Consulting Editor:";
	

	
	if ([clinicsDataHolder.sConsultingEditor length] == isOne) {
		m_lblNamehardCode.hidden=TRUE;
		m_lblEditor.hidden=TRUE;
	}else {
		m_lblNamehardCode.hidden=FALSE;
		m_lblEditor.hidden=FALSE;
	}

	if(clinicsDataHolder.sChecked == 1){
		[m_btnCheck setBackgroundImage:[UIImage imageNamed:@"BtnCheckUnselected.png"] forState:UIControlStateNormal];
	
	}else {
		[m_btnCheck setBackgroundImage:[UIImage imageNamed:@"BtnCheckSelected.png"] forState:UIControlStateNormal];
	}

    
}



- (IBAction) buttonPressed:(id)sender
{
    DatabaseConnection *database = [DatabaseConnection sharedController];
    ClinicsDataHolder *clinicDataHolder = [[database loadClinicData:m_clinicDataHolder.nClinicID] retain]; 
    
    [clinicDataHolder release];
  
}


@end
