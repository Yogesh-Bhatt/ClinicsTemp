//
//  CustomSliderView.h
//  SRPS
//
//  Created by Subhash on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderView.h"
#import "SliderDescriptionView.h"
@protocol CustomsliderDelegate;
@interface CustomSliderView : UIView<SliderViewDelegate> {
	SliderView	*customSlider;
	int previoiusPageValue;
	SliderDescriptionView *descriptionView;
	id < CustomsliderDelegate ,NSObject> callerDelegate;
	NSArray *sliderDataList;
}

@property(retain) id< CustomsliderDelegate ,NSObject> callerDelegate;

-(void)moveToSlide;
-(void)initSlider:(NSArray*)sliderValueList;
-(IBAction)sliderAction:(id)sender;
@end

@protocol CustomsliderDelegate <NSObject>
-(void)jumpToSectionTag:(NSString*)tagValue;
@end