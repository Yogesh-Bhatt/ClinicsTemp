
#import "LodingHomeView.h"
#define LoadingLblKey 5555 
@implementation LodingHomeView

static UIActivityIndicatorView *loadingIndicator;
static UIView *panelView;
 

+(void)displayLoadingIndicator:(UIView *)parentView :(UIInterfaceOrientation)toOrentation
{
	
	panelView = [[UIView alloc] initWithFrame:CGRectMake(230, 700, 300, 100)];
	panelView.backgroundColor = [UIColor clearColor];
	
	if(loadingIndicator == nil){
		loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		
	}
	
	loadingIndicator.frame = CGRectMake(135, 40, 37, 37);
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-20, 75, 450.0, 60.0)];
	titleLabel.textAlignment=UITextAlignmentLeft;
	titleLabel.numberOfLines = 2;
    titleLabel.tag = LoadingLblKey;
	titleLabel.text=nil;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:18];
	titleLabel.backgroundColor = [UIColor clearColor];
	[panelView addSubview:titleLabel];
    RELEASE(titleLabel);
	
	[panelView addSubview:loadingIndicator];
	if ([CGlobal isOrientationLandscape])
    {
		[self inSideIpadLandScape];
	}
    else
    {  
		[self inSideIpadPortrait];
	}
	
    [parentView addSubview:panelView];
	[loadingIndicator startAnimating];
}

+(void)chagengeMessageLoadingView:(ComeFromLoadingView)viewType{
    
    UILabel   *titleLabel = (UILabel *)[panelView viewWithTag:LoadingLblKey];
    
    if (titleLabel) {
    switch (viewType) {
            
        case addClinics:
                                       
            titleLabel.text=@"         Saving your followed Clinics...";
            break;
        case dwonloadissue:
                                                   
            titleLabel.text= @"                        Loading...";
            break;

        case dwonloadupdateissue:
            
            titleLabel.text= @"                        Loading...";
            break;

        case dwonloadArticle:
            titleLabel.text= @"                        Loading...";
            break;
            
         case dwonloadArticleInPress:
            titleLabel.text  = @"                        Loading...";
             break;
        case dwonloadAbstruct:
            
            titleLabel.text=@"                 Loading  abstracts....";
            break;

            
        default:
            break;
    }
     
    }
}
+(void)setTitle:(NSString*)title {
     UILabel   *titleLabel = (UILabel *)[panelView viewWithTag:LoadingLblKey];
	titleLabel.text = title;
}

+(void)removeLoadingIndicator
{
	if(loadingIndicator != nil){
		[loadingIndicator removeFromSuperview];
		[loadingIndicator stopAnimating];
		[loadingIndicator release];
		loadingIndicator = nil;
	}
	
	if (panelView) {
		[panelView removeFromSuperview];
		[panelView release];
		 panelView = nil;
	}
}

+(void)inSideIpadPortrait
{
	panelView.frame = CGRectMake(250, 420, 300, 100);
	
}

+(void)inSideIpadLandScape
{
	panelView.frame = CGRectMake(380, 300, 400, 100);
	
}


@end
