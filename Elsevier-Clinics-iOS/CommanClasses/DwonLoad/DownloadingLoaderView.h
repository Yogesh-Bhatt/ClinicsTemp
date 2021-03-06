//
//  DownloadingLoaderView.h
//  AR
//
//  Created by Subhash Chand on 3/1/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DownloadingLoaderView : UIView {
	UIActivityIndicatorView *indicatorView;
	UILabel *downloadlbl;
	UILabel *downloadArticle;
	UIImageView *processBgImage;
	UIImageView *processFillImage;
	UIButton   *cencelBtn;
    BOOL      isAbstract;
	
}
//-(void)resetOrientation;
-(void)ChangeFramedwonloadingSubView;
-(void)setDisplayMassage:(NSString*)massageString;
-(void)setDownloadedArticle:(NSString*)massageString;
-(void)fillProcessImageForValue:(NSInteger)value;

//-(void)hideProcessBar;
@end