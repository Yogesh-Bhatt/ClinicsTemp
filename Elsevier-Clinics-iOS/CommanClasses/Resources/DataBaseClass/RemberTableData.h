#import <Foundation/Foundation.h>


@interface RemberTableData : NSObject 
{
    NSInteger buttonIndex;
    NSInteger hederIndex;
    NSInteger  rowIndex ;
    NSInteger sectionIndex;
  }

@property(nonatomic, assign)NSInteger buttonIndex;
@property(nonatomic, assign)NSInteger hederIndex;
@property(nonatomic, assign)NSInteger rowIndex;

@property(nonatomic, assign)NSInteger sectionIndex;



@end
