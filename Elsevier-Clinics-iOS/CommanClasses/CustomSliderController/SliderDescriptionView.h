//
//  SliderDescriptionView.h
//  Elsevier
//
//  Created by Subhash Chand on 3/16/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SliderDescriptionView : UIView {
	UILabel *sliderTextLbl;
}
-(void)setLabelText:(NSString*)txtString:(NSString*)flag;
@end
