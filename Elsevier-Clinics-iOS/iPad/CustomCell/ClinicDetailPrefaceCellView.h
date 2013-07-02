//
//  ClinicDetailPrefaceCellView.h
//  Clinics
//
//  Created by Kiwitech on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ClinicDetailPrefaceCellView : UITableViewCell 
{
    UILabel *m_lblPrefaceTitle;
    UILabel *m_lblPreface;
}
@property(nonatomic, retain)IBOutlet UILabel *m_lblPrefaceTitle;
@property(nonatomic, retain)IBOutlet UILabel *m_lblPreface;

@end
