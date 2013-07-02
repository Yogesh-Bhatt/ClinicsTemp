#import "ReferenceData.h"


@implementation ReferenceData

@synthesize Ref_id;
@synthesize isSubTitle;
@synthesize section_Title;
@synthesize Section_id;
@synthesize aritcle_info_id;

- (id)init 
{
    self = [super init];
	if(self)
	{
        self.Ref_id = 0;
		self.isSubTitle=0;
		
	}	
	return self;
}



#pragma mark - Memory management

- (void)dealloc
{
	[Section_id release];
	[section_Title release];
	[aritcle_info_id release];
    
    [super dealloc];
}


@end
