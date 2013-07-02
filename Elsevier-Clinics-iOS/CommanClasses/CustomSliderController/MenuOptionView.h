//
//  MenuOptionView.h
//  Elsevier
//
//  Created by Yogesh Bhatt on 03/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MenuViewcallerDelegate<NSObject>
@optional
-(void)jumpToSectionTag:(NSString*)tagValue;
@end

@interface MenuOptionView : UIView {

	UIButton *btnMenuOptions;
		NSArray *arrList;

}
@property(nonatomic, assign,readwrite)id <MenuViewcallerDelegate,NSObject> delegate;


- (id)initWithFrame:(CGRect)frame Buttons:(NSMutableArray*)arr;
- (void) addOptions:(NSArray*)arr;
- (void)checkOrientation:(UIInterfaceOrientation)interfaceOrientation;


@end
