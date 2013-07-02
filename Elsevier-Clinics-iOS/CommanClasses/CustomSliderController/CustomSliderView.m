//
//  CustomSliderView.m
//  SRPS
//
//  Created by Subhash on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define THUMB_VIEW_HEIGHT 127.0
#define THUMB_VIEW_WIDTH 184.0

#define CUSTOM_SLIDER_X_OFFSET 20
#define CUSTOM_SLIDER_WIDTH 600
#define CUSTOM_SLIDER_Y_OFFSET CUSTOM_SLIDER_WIDTH*0.37
#define CUSTOM_SLIDER_HEIGHT 17.0

#import "SliderView.h"
#import "CustomSliderView.h"


@implementation CustomSliderView
@synthesize callerDelegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        
        UIImage* image = [UIImage imageNamed:@"pop-box.png"];
		descriptionView=[[SliderDescriptionView alloc]initWithFrame:CGRectMake(-image.size.width-7, -25, image.size.width, image.size.height)];
		[self addSubview:descriptionView];
        descriptionView.hidden = YES;
		previoiusPageValue=1;
		[self setBackgroundColor:[UIColor clearColor]];
		CGRect frame = CGRectMake(-CUSTOM_SLIDER_WIDTH*0.488,CUSTOM_SLIDER_Y_OFFSET+67.0,CUSTOM_SLIDER_WIDTH,CUSTOM_SLIDER_HEIGHT);
        
		customSlider = [[SliderView alloc] initWithFrame:frame];
		customSlider.backgroundColor = [UIColor clearColor];
		[customSlider setUserInteractionEnabled:YES];
        customSlider.transform = CGAffineTransformRotate(customSlider.transform,90/180.0*M_PI);
        
		UIImage *stetchLeftTrack = [[UIImage imageNamed:@"bar.png"]
									stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
		
		UIImage *stetchRightTrack = [[UIImage imageNamed:@"bar.png"]
									 stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
		
		[customSlider setThumbImage: [UIImage imageNamed:@"sliderbtn.png"] forState:UIControlStateNormal];
        
		
		[customSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
		[customSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
		customSlider.continuous = YES;
		[customSlider setCallerDelegate:self];
        
		customSlider.minimumValue=0;
		customSlider.maximumValue= 0;
		customSlider.value=1;
		
		[customSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchDragInside];
		[self addSubview:customSlider];				
    }
    return self;
}


-(void)setCallerDelegateValue:(id)delegateValue
{
	[self setCallerDelegate:delegateValue];
	[customSlider setCallerDelegate:self];
}

-(void)initSlider:(NSArray*)sliderValueList
{
	if(sliderDataList){
        RELEASE(sliderDataList);
	    sliderDataList=nil;
	}
	if([sliderValueList count]>0)
	{  
	
		sliderDataList = [sliderValueList retain];
		customSlider.maximumValue=[sliderValueList count]-1;
		customSlider.minimumValue=0;
        customSlider.value=0;
		[descriptionView setLabelText:[[sliderDataList objectAtIndex:0]section_Title] :[NSString stringWithFormat:@"%d",[[sliderDataList objectAtIndex:0]isSubTitle]]];
	}	
}

-(void)onTaponSlider:(BOOL)isHidden {
    descriptionView.hidden = isHidden;
    
}

-(void)onTapOutsideSlider {
    descriptionView.hidden = NO;
}

-(void)moveToSlide
{
    @try {
        if(previoiusPageValue < [sliderDataList count])
        {// *****************jump To next Scetion Heading *****************
            if([self.callerDelegate respondsToSelector:@selector(jumpToSectionTag:)])
                [self.callerDelegate jumpToSectionTag:[[sliderDataList objectAtIndex:previoiusPageValue]Section_id]];
        }
    }
    @catch (NSException *exception) {
        //NSLog(@"Exception Generated ---> %@",exception);
    }
}


-(IBAction)sliderAction:(id)sender
{
	UISlider *slider=(UISlider*)sender;
	NSInteger currentValue=(int)slider.value;
    
	if ([sliderDataList count] == 0) {
		UIAlertView *alert=[[[UIAlertView alloc]initWithTitle:@"Section" message:@"Section data are not available for this article." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease];
		[alert show];
		return;
	}
	if ([sliderDataList count] == 1) {
		UIAlertView *alert=[[[UIAlertView alloc]initWithTitle:@"Section" message:@"Section data have only value for this article." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease];
		[alert show];
		return;
	}
	
	if(previoiusPageValue < currentValue || previoiusPageValue > currentValue)
	{
		if(currentValue < [sliderDataList count])
			[descriptionView setLabelText:[[sliderDataList objectAtIndex:currentValue]section_Title] :[NSString stringWithFormat:@"%d",[[sliderDataList objectAtIndex:currentValue]isSubTitle]]];		
	}	
	
    CGFloat val = (slider.value/slider.maximumValue)*100;
    float xoffset;
    if(val < 30.0){
        xoffset = ((slider.value*(slider.frame.size.height/slider.maximumValue))) - 30;
    }else if (val < 80.0){
        xoffset = ((slider.value*(slider.frame.size.height/slider.maximumValue))) - 40;
    }else  {
        xoffset = ((slider.value*(slider.frame.size.height/slider.maximumValue))) - 50;
    }
	descriptionView.frame=CGRectMake(descriptionView.frame.origin.x, xoffset, descriptionView.frame.size.width, descriptionView.frame.size.height);
	
	previoiusPageValue = currentValue;	
}


- (void)dealloc {
    //NSLog(@"CustomSliderView -> Enter -> Dealloc");
    self.callerDelegate = nil;
    RELEASE(descriptionView);
    RELEASE(sliderDataList);
    RELEASE(customSlider);
    //NSLog(@"CustomSliderView -> Exit -> Dealloc");
    [super dealloc];
}
@end
