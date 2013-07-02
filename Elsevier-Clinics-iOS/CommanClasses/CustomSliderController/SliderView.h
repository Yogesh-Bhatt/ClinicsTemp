//
//  SliderView.h
//  SRPS
//
//  Created by Subhash on 24/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SliderViewDelegate
-(void)moveToSlide;
-(void)onTaponSlider:(BOOL)isHidden;
@end

@interface SliderView : UISlider{
	BOOL isTouchEnabled;
	id< SliderViewDelegate,NSObject> callerDelegate;
}
@property(nonatomic,assign)BOOL isTouchEnabled;
@property(retain)	id< SliderViewDelegate,NSObject> callerDelegate;
@end
