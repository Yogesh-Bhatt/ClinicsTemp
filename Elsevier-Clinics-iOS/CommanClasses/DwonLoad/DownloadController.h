//
//  DownloadController.h
//  AR
//
//  Created by Subhash Chand on 3/1/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadingLoaderView.h"
#import "ClinicsAppDelegate.h"

@interface DownloadController : NSObject {
	double expectedRecivingData;
	double downloadedData;
	DownloadingLoaderView *loaderView;
	int currentDownloadIndex;
	NSArray *downloadQueDataList;
    
	id sender;
	SEL callBackFuntion;
    
    NSString *choiceString;
     BOOL      isAbstract;

}

@property(nonatomic,retain)	NSString *choiceString;

@property(nonatomic,retain)	NSArray *downloadQueDataList;
@property(nonatomic,assign)id sender;
@property(nonatomic,assign)SEL callBackFuntion;

+ (DownloadController*)sharedController;
-(BOOL)stopLoadingFile;
-(void)setExpectedData:(double_t)expectedData;
-(void)appendDataWithDownloadedData:(double)byteData;
- (BOOL)doesConnectedToNetworkWithErrorMassage:(NSString*)massage;
-(void)addLoaderForView;
//- (BOOL)DownloadFilesForArticle:(NSString*)sourceUrl:(NSString *)zipFileName;
//-(void)downloadArticalFromServerwithArticleId:(NSString*)articleId;
//-(void)createDownloadQueForQueData:(NSArray*)queData:(NSString*)choiceStr;
-(void)ChangeFramewhenRootateDwonloadingStart;
-(void)createDownloadQueForQueData:(NSString*)choiceStr;
- (BOOL) DownloadFilesForArticle:(NSString*)sourceUrl;
@end
