//
//  ClinicDetailPrefaceCellView.m
//  Clinics
//
//  Created by Kiwitech on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClinicDetailPrefaceCellView.h"


@implementation ClinicDetailPrefaceCellView

@synthesize m_lblPrefaceTitle;
@synthesize m_lblPreface;

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
    RELEASE(m_lblPrefaceTitle);
    RELEASE(m_lblPreface);
    
    [super dealloc];
}

@end
