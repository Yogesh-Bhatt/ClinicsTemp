#import <Foundation/Foundation.h>
//#import "LancetAppDelegate.h"



@interface LodingHomeView : NSObject

{
    
}


+(void)displayLoadingIndicator:(UIView *)parentView :(UIInterfaceOrientation)toOrentation;
+(void)removeLoadingIndicator;
+(void)inSideIpadPortrait;
+(void)inSideIpadLandScape;
+(void)setTitle:(NSString*)title;

+(void)chagengeMessageLoadingView:(ComeFromLoadingView)viewType;
@end
