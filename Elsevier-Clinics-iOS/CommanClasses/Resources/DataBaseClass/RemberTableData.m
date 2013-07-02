
#import "RemberTableData.h"


@implementation RemberTableData

@synthesize buttonIndex;
@synthesize hederIndex;
@synthesize rowIndex;
@synthesize sectionIndex;


- (id)init 
{
    self = [super init];
	if(self)
	{
        self.buttonIndex = 0;
		self.hederIndex = 0;
        self.rowIndex = 0;
        self.sectionIndex = 0;
       
	}	
	return self;
}



#pragma mark - Memory management

- (void)dealloc
{
       
    
    [super dealloc];
}


@end
