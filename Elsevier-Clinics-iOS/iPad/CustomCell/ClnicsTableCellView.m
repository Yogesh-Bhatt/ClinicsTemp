//
//  ClnicsTableCellView.m
//  Clinics
//
//  Created by Kiwitech on 10/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClnicsTableCellView.h"


@implementation ClnicsTableCellView

@synthesize m_lblTitle;
@synthesize backImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
	RELEASE(backImage);
    RELEASE(m_lblTitle);
    
    [super dealloc];
}

@end
