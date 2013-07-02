//
//  FBShareManager.m
//  Advertising
//
//  Created by Usha Goyal on 01/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBShareManager.h"

@interface FBShareManager (privateMethod)

-(void)fbLogin;
-(void)publishFBPost;

@end


@implementation FBShareManager

@synthesize titleName;
@synthesize linkUrl;
@synthesize description;
@synthesize iconUrl;
@synthesize caption;
@synthesize msg;
@synthesize devName;
@synthesize devUrl;
@synthesize delegate;

static FBShareManager* _sharedManager; // self


+ (FBShareManager *)sharedManager
{
	@synchronized(self) {
		
        if (_sharedManager == nil) {
			
            [[self alloc] init]; // assignment not done here
        }
    }
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        
        facebook = [[Facebook alloc] initWithAppId:[[[[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"]  
                                                       objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] 
                                                     objectAtIndex:0] substringFromIndex:2]];
        
        self.titleName = @"";
        self.linkUrl = @"";
        self.description = @"";
        self.iconUrl = @"";
        self.caption = @"";
        self.msg = @"";
        self.devName = @"";
        self.devUrl = @"";
    }
    return self;
}


#pragma mark -
#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{	
    @synchronized(self) {
		
        if (_sharedManager == nil) {
			
            _sharedManager = [super allocWithZone:zone];			
            return _sharedManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}

- (void)dealloc {

	if (facebook) {
		[facebook release];
		facebook = nil;
	}
	
	self.titleName = nil;
	self.linkUrl = nil;
	self.description = nil;
	self.iconUrl = nil;
	self.caption = nil;
	self.msg = nil;
	self.devName = nil;
	self.devUrl = nil;
	
    [super dealloc];
}

-(void)loginFacebook{
	
	onlyLogin = TRUE;
	[self fbLogin];
	
}

-(void)fbLogin{
    
	NSArray *permissions =  [NSArray arrayWithObjects:@"read_stream",@"publish_stream",nil];
    [facebook authorize:permissions delegate:self];
}


-(void)publishStream{
	
	isFBDialog = TRUE;
	onlyLogin = FALSE;
    if([facebook isSessionValid]){
        [self publishFBPost];
    } else {
        [self fbLogin];
    }
}


-(void)publishStreamWithoutDialogBox{
	
	isFBDialog = FALSE;
	onlyLogin = FALSE;
	if([facebook isSessionValid]){
        [self publishFBPost];
    } else {
        [self fbLogin];
    }
}


-(void)publishFBPost{
	
	NSMutableDictionary *fbArguments = [[NSMutableDictionary alloc] init];
	//NSLog(@" = %@",self.msg);
	[fbArguments setObject:self.titleName forKey:@"name"];
	[fbArguments setObject:self.caption forKey:@"caption"];
	[fbArguments setObject:self.description forKey:@"description"];
	[fbArguments setObject:self.linkUrl forKey:@"link"];
	[fbArguments setObject:self.iconUrl forKey:@"picture"];
	[fbArguments setObject:self.msg forKey:@"message"];
	
	if(![self.devName isEqualToString:@""] && ![self.devUrl isEqualToString:@""]){
		
		[fbArguments setObject:[NSString stringWithFormat:@"{\"Developed By\":{\"text\":\"%@\",\"href\":\"%@\"}}",
								self.devName,self.devUrl] forKey:@"properties"];
	} 
	
	if(isFBDialog == TRUE){
		
		[facebook dialog:@"feed"
			   andParams:fbArguments
			 andDelegate:self];
		
	} else {
		
		[facebook requestWithGraphPath:@"me/feed" 
                             andParams:fbArguments
                         andHttpMethod:@"POST"
                           andDelegate:self];
	}
}




#pragma mark FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	
	if(onlyLogin == TRUE){
		
		return;
	}
	
	[self publishFBPost];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	//NSLog(@"did not login");
}


/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	
}

#pragma mark FBRequestDelegate Methods

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest *)request{
	
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response{
	
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
	
	//NSLog(@"%@",[error localizedDescription]);
    
    if ([delegate respondsToSelector: @selector(facebookPostDidFail)]){
        
        [delegate facebookPostDidFail];
    }
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result{
    
    if([result objectForKey:@"id"] == nil || [[result objectForKey:@"id"] isEqualToString:@""]){
        
        if ([delegate respondsToSelector: @selector(facebookPostDidFail)]){
            
            [delegate facebookPostDidFail];
        }
    } else {
        
        if ([delegate respondsToSelector: @selector(facebookPostDidSuccess)]){
            
            [delegate facebookPostDidSuccess];
        }
    }
}


#pragma mark FBDialogDelegate Methods
/**
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)dialogDidComplete:(FBDialog *)dialog{
    
}

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog{
	
}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error{
	
	//NSLog(@"Dialog Error : %@",[error localizedDescription]);
    if ([delegate respondsToSelector: @selector(facebookPostDidFail)]){
        
        [delegate facebookPostDidFail];
    }
}
- (void)dialogCompleteWithUrl:(NSURL *)url
{
	if([url query] != nil || [[url query] isEqualToString:@""]){
		
		if ([delegate respondsToSelector: @selector(facebookPostDidSuccess)]){
			[delegate facebookPostDidSuccess];
		}
	}
}


@end
