//
//  TableSectionView_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableSectionView_iPhone : UIView 
{
    UILabel *m_lblTitle;
	IBOutlet UIButton  *ariticleButton;
	IBOutlet UIButton  *issueButton;
	IBOutlet   UIButton   *seletedBtn;
	
}
@property(nonatomic,retain)UIButton   *seletedBtn;
@property(nonatomic,retain)UIButton  *ariticleButton;
@property(nonatomic,retain)UIButton  *issueButton;
@property(nonatomic, retain)IBOutlet UILabel *m_lblTitle;
-(void)changeImageOnclickButton:(BOOL)Flag;
-(void)changeSelectAllImage:(NSInteger) section :(NSInteger)categoryID;
@end

