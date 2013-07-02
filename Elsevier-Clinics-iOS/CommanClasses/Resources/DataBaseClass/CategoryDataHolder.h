//
//  CategoryDataHolder.h
//  Clinics
//
//  Created by Kiwitech on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CategoryDataHolder : NSObject 
{
    NSInteger nCategoryID;
    NSString *sCategoryName;
    NSString *sCategoryImageName;
    NSInteger   checked;
    NSMutableArray *arrClinics;
}
@property(nonatomic,assign)NSInteger   checked;
@property(nonatomic, assign)NSInteger nCategoryID;
@property(nonatomic, retain)NSString *sCategoryName;
@property(nonatomic, retain)NSString *sCategoryImageName;
@property(nonatomic, retain)NSMutableArray *arrClinics;


@end
