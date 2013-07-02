//
//  PdfLoader.h
//  SRPS
//
//  Created by Subhash on 17/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PdfLoader : UIView {
	UIActivityIndicatorView *indicatorView;
}
-(void)chnageOnOrientationChange;
-(void)chnageOnOrientationChangeLandScape;
@end
