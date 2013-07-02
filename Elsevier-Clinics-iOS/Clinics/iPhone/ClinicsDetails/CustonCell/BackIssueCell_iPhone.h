//
//  BackIssueCell_iPhone.h
//  Clinics
//
//  Created by Kiwitech on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BackIssueCell_iPhone : UITableViewCell {
	UILabel     *m_lblTitle;
    UIButton    *m_btnNumber;
    UIImageView *m_imgView;
    UIImageView *m_imgAccessoryImage;
}

@property (nonatomic, retain)IBOutlet UILabel       *m_lblTitle;
@property (nonatomic, retain)IBOutlet UIButton      *m_btnNumber;
@property (nonatomic, retain)IBOutlet UIImageView   *m_imgView;
@property (nonatomic, retain)IBOutlet UIImageView   *m_imgAccessoryImage;

@end
