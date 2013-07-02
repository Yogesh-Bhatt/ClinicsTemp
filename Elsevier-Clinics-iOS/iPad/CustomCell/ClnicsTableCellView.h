//
//  ClnicsTableCellView.h
//  Clinics
//
//  Created by Kiwitech on 10/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ClnicsTableCellView : UITableViewCell 
{
    UILabel *m_lblTitle;
	UIImageView  *backImage;
	
}
@property(nonatomic,retain)IBOutlet UIImageView *backImage;
@property(nonatomic, retain)IBOutlet UILabel *m_lblTitle;

@end
