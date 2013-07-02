//
//  ClnicsTableSectionView.h
//  Clinics
//
//  Created by Kiwitech on 10/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableCellViewDelegate;

@interface ClnicsTableSectionView : UIView 
{
    UILabel     *m_lblTitle;

    UIImageView *m_imgView;
    UIImageView *m_imgAccessoryImage;
    UIButton *disclosureButton;
    NSInteger section;
	BOOL flag;
}

@property (nonatomic, retain)IBOutlet UILabel       *m_lblTitle;
@property (nonatomic, retain)IBOutlet UIImageView   *m_imgView;
@property (nonatomic, retain)IBOutlet UIImageView   *m_imgAccessoryImage;

@property (nonatomic, assign) id <TableCellViewDelegate> delegate;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, retain) UIButton *disclosureButton;


- (void) initData;

-(void)toggleOpenWithUserAction:(BOOL)userAction;

@end

/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol TableCellViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(ClnicsTableSectionView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(ClnicsTableSectionView*)sectionHeaderView sectionClosed:(NSInteger)section;

@end

