#import <Foundation/Foundation.h>


@interface ReferenceData : NSObject 
{
    NSInteger Ref_id;
	NSString  *section_Title;
	NSString  *Section_id;
	NSString  *aritcle_info_id;
	NSInteger  isSubTitle;
	
}

@property(nonatomic, assign)NSInteger Ref_id;
@property(nonatomic, assign)NSInteger isSubTitle;
@property(nonatomic,retain)NSString  *section_Title;
@property(nonatomic,retain)NSString  *Section_id;
@property(nonatomic,retain)NSString  *aritcle_info_id;



@end
