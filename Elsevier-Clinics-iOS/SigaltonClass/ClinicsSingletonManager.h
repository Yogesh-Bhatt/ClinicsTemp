//
//  MCSingletonManager.h
//  MusicChoice
//
//  Created by Ashish Awasthi on 14/01/13.
//  Copyright (c) 2013 Kiwitech International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
//#import "Controller.h"
@protocol ClinicsSingletonManagerDelegate <NSObject>

@optional

-(void)dismissPopOverNotification;
-(void)tabOnNowPlayingButton:(id)sender;
-(void)chechIPAuthentication;
@end

@interface ClinicsSingletonManager : NSObject<UIPopoverControllerDelegate>{
    
   }

@property(nonatomic,assign) id delegate;
@property(nonatomic,assign) NSMutableArray    *m_arrLatestIssues;

//@property(nonatomic,retain)Controller    *_parseDataController;

+ (ClinicsSingletonManager*)sharedManager;

- (void)showAlert:(NSString*)a_titleStr 
          message:(NSString*)a_messageStr 
          withTag:(NSUInteger)a_tag 
    withDelegate:(UIViewController*)a_delegate;

- (void)showAlertWithOption:(NSString*)a_titleStr 
                    message:(NSString*)a_messageStr 
                    withTag:(NSUInteger)a_tag 
                 withOption:(NSArray *)OptionArr
               withDelegate:(UIViewController*)a_delegate;

- (void)getAlertViewForMailResultComposeController:(MFMailComposeResult)a_result;

- (float)setHeightOfLbl:(NSString *)a_lblText 
                 withLblFont:(UIFont *)a_fontStr 
                withLblWidth:(float)a_lblWidth;

- (CGSize)getExpectedLabelSizeForText:(NSString *)a_textStr 
                                 fontName:(NSString*)a_fontStr 
                                fontSize:(NSInteger)a_fontSize 
                         maxLabelSize:(CGSize)a_maxSize
                        lineBreakMode:(UILineBreakMode)a_lineBreakMode;

- (UIImage*)getImageObjectFromName:(NSString *)a_imgNameStr;

- (NSString*)trimString:(NSString*)a_str;

-(BOOL)checkNetworkReachability;
-(BOOL)checkNetworkReachableViaWiFi;
-(BOOL)checkNetworkReachableViaMobileNetwork;

-(BOOL)checkNetworkReachabilityWithAlert;

-(void)animationWithFrame:(CGRect)a_frame
                 withView:(UIView*)a_view 
             withSelector:(SEL)a_selector 
             withDuration:(float)a_duration 
             withDelegate:(id)a_delegate;

-(void)hideWithAlphaAnimation:(BOOL)a_flag
                     withView:(UIView*)a_view 
                 withSelector:(SEL)a_selector 
                 withDuration:(float)a_duration 
                 withDelegate:(id)a_delegate;

-(void)animationWithFrame:(CGRect)a_frame
                 withView:(UIView*)a_view
              withSubView:(NSArray*)subViewArr
                withAlpha:(float )a_alpha
             withSelector:(SEL)a_selector
             withDuration:(float)a_duration
             withDelegate:(id)a_delegate;

-(void)drawViewBorder:(float)a_radius
     withMaskToBounds:(BOOL)a_flagB 
          borderColor:(UIColor *)a_color 
          borderWidth:(float)a_borderWidth
             withView:(UIView *)a_view;

-(UIImage*)getImgFromDocumentDirWithName:(NSString*)a_name;

- (NSString *)getLibraryPath;

- (void)setImageFromCache:(UIImageView *)a_imageView 
           imageURLstring:(NSString *)a_strImgURL;

- (NSString *)getWiFiConnIPAddress;
- (NSString *)getExternalIPAddress;

- (void)getActivityOnView:(UIView *)a_view style:(UIActivityIndicatorViewStyle)a_style;
- (void)removeActivityFromView:(UIView *)a_view;
- (BOOL)isCameraAvilable;

-(NSString *)parseDateInMCFormte:(NSString *)jsonDate;
-(NSString*)getFormattedUTCDate:(NSString *)a_strJsonDate;

-(NSString*)getFormattedLocalDate:(NSString *)a_strJsonDate
                   currentFormate:(NSString *)currentFormate
                      wantFormate:(NSString *)wantFormate;

- (double)getCurrentTime;
- (BOOL)validateEmail: (NSString *) email;
- (NSInteger)getDateDifference:(NSDate*)birthDate;
- (BOOL)iSiPhoneDevice;
- (NSUInteger) getImageSize: (UIImage *)image
        imageExtension:(NSString *)imageExtension;

-(UIView*) wrapSiblingViews:(NSArray*)theSiblings ofSuperview:(UIView*)theSuperview;

-(void)setAppBadgeNumberTo:(NSInteger)number;

@end
