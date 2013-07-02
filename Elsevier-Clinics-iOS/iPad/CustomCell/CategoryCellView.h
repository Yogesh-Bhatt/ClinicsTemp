//
//  CategoryCellView.h
//  Clinics
//
//  Created by Ashish Awasthi on 03/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryCellViewDelegate;


@interface CategoryCellView : UITableViewCell 
{
    UILabel     *m_lblTitle;
    UIButton    *m_btnNumber;
    UIImageView *m_imgView;
    UIImageView *m_imgAccessoryImage;
    
    UIButton *disclosureButton;
    NSInteger section;
}

@property (nonatomic, retain)IBOutlet UILabel       *m_lblTitle;
@property (nonatomic, retain)IBOutlet UIButton      *m_btnNumber;
@property (nonatomic, retain)IBOutlet UIImageView   *m_imgView;
@property (nonatomic, retain)IBOutlet UIImageView   *m_imgAccessoryImage;

@property (nonatomic, assign) id <CategoryCellViewDelegate> delegate;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, retain) UIButton *disclosureButton;


- (void) initData;

-(void)toggleOpenWithUserAction:(BOOL)userAction;

@end

/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol CategoryCellViewDelegate <NSObject>

@optional
-(void)categoryHeaderView:(CategoryCellView*)categoryHeaderView categoryOpened:(NSInteger)sectionOpen;
-(void)categoryHeaderView:(CategoryCellView*)categoryHeaderView categoryClosed:(NSInteger)sectionClose;
@end



