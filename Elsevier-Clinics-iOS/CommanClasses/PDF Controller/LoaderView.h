//
//  LoaderView.h
//  AR
//
//  Created by Subhash Chand on 1/20/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoaderView : UIView {
	UILabel *titleLbl;
	UIActivityIndicatorView	*indicatorView;
}
-(void)showTitleLableForLoader:(NSString*)title;
@end
