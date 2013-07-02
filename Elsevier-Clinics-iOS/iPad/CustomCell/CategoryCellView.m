//
//  CategoryCellView.m
//  Clinics
//
//  Created by Ashish Awasthi on 03/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryCellView.h"
#import <QuartzCore/QuartzCore.h>



@implementation CategoryCellView

@synthesize m_lblTitle;
@synthesize m_btnNumber;
@synthesize delegate;
@synthesize section;
@synthesize disclosureButton;
@synthesize m_imgView;
@synthesize m_imgAccessoryImage;

+ (Class)layerClass {
    
    return [CAGradientLayer class];
}

- (void) initData
{
    if (self.delegate)
    {
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        disclosureButton.frame = CGRectMake(0.0, 30.0, 35.0, 35.0);
        [disclosureButton addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disclosureButton];
    }
}


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
    RELEASE(m_imgAccessoryImage);
    RELEASE(m_imgView);
    RELEASE(m_btnNumber);
    RELEASE(m_lblTitle);
    
    [super dealloc];
}

-(IBAction)toggleOpen:(id)sender 
{    
    [self toggleOpenWithUserAction:YES];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction 
{
    // Toggle the disclosure button state.
    disclosureButton.selected = !disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction)
    {
        if (disclosureButton.selected) 
        {
            if ([self.delegate respondsToSelector:@selector(categoryHeaderView:categoryOpened:)]) 
                [self.delegate categoryHeaderView:self categoryOpened:section];
        }
        else 
        {
            if ([self.delegate respondsToSelector:@selector(categoryHeaderView:categoryClosed:)]) 
                [self.delegate categoryHeaderView:self categoryClosed:section];
        }
    }
}


@end
