//
//  ClinicDetailHeaderCellView_iPhone.h
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClinicDetailHeaderCellView_iPhone : UITableViewCell 
{
    UIImageView *m_imgView;
    UILabel     *m_lblClinicTitle;
    UILabel     *m_lblDate;
    UILabel     *m_lblIssueTitle;
    UILabel     *m_lblConsultingEditor;
}

@property(nonatomic, retain)IBOutlet UIImageView *m_imgView;
@property(nonatomic, retain)IBOutlet UILabel     *m_lblClinicTitle;
@property(nonatomic, retain)IBOutlet UILabel     *m_lblDate;
@property(nonatomic, retain)IBOutlet UILabel     *m_lblIssueTitle;
@property(nonatomic, retain)IBOutlet UILabel     *m_lblConsultingEditor;

@end
