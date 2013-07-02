//
//  ClinicDetailHeaderCellView_iPhone.h
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClinicDetailHeaderCellView_iPhoneDelegate

-(void)downloadIssue;


@end

@interface ClinicDetailHeaderCellView_iPhone : UITableViewCell 
{
    UIImageView *m_imgView;
    UILabel     *m_lblClinicTitle;
    UILabel     *m_lblDate;
    UILabel     *m_lblIssueTitle;
    UILabel     *m_lblConsultingEditor;
    
    IBOutlet UIButton *m_downloadBtn;
    
    id callerDelegate;
}

@property (nonatomic, assign) id <ClinicDetailHeaderCellView_iPhoneDelegate> callerDelegate;
@property(nonatomic, retain)IBOutlet UIImageView *m_imgView;
@property(nonatomic, retain)IBOutlet UIButton    *m_downloadBtn;
@property(nonatomic, retain)IBOutlet UILabel     *m_lblClinicTitle;
@property(nonatomic, retain)IBOutlet UILabel     *m_lblDate;
@property(nonatomic, retain)IBOutlet UILabel     *m_lblIssueTitle;
@property(nonatomic, retain)IBOutlet UILabel     *m_lblConsultingEditor;

@end
