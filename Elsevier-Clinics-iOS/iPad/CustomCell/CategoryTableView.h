//
//  CategoryTableView.h
//  Clinics
//
//  Created by Kiwitech on 03/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClnicsTableSectionView.h"
#import "CategoryInfo.h"



@interface CategoryTableView : UITableView <TableCellViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *sectionInfoArray;
    NSMutableArray *arrClinic;

    NSInteger openSectionIndex;   
    
    BOOL m_bOPEN;
}

@property (nonatomic, assign) NSInteger         openSectionIndex;
@property (nonatomic, retain) NSMutableArray    *sectionInfoArray;
@property (nonatomic, assign) BOOL         m_bOPEN;


- (void) initData:(CategoryInfo *)categoryInfoObj;

@end
