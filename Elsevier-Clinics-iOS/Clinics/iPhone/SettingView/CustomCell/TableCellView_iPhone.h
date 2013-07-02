//
//  TableCellView_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ClinicsDataHolder.h"


@interface TableCellView_iPhone : UITableViewCell
{
    IBOutlet UIImageView *m_imgView;
    IBOutlet UILabel *m_lblClinicName;
    IBOutlet UILabel *m_lblEditor;
	IBOutlet  UILabel *m_lblNamehardCode;
    IBOutlet UILabel *m_lblRecentTopics;
    IBOutlet UIButton *m_btnCheck;
	IBOutlet UIButton  *selectedBtn;
	IBOutlet UIButton  *DeselectBtn;
    ClinicsDataHolder *m_clinicDataHolder;
	
	
}

@property(nonatomic,retain) UIImageView *m_imgView;
@property(nonatomic,retain)UIButton *m_btnCheck;

- (void)setData:(ClinicsDataHolder *)clinicsDataHolder;
- (IBAction) buttonPressed:(id)sender;

@end