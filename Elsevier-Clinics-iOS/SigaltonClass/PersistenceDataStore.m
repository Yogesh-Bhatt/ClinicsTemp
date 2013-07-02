//
//  PersistenceDataStore.m
//  SocialNetWork
//
//  Created by Ashish Awasthi on 12/13/12.
//  Copyright (c) 2012 Ashish Awasthi. All rights reserved.
//

#import "PersistenceDataStore.h"

#define   KPersistenceDataKey   @"PersistenceData"

@implementation PersistenceDataStore

@synthesize _dataDictionary;




static PersistenceDataStore* _sharedManager; // self

#pragma mark Singleton Methods

+(PersistenceDataStore *)sharedManager{
    
	@synchronized(self) {
		
        if (_sharedManager == nil) {
			
            [[self alloc] init]; // assignment not done here
        }
    }
    
    return _sharedManager;
}


-(id)init{
    self = [super init];
    
    if (self) {
        
         _dataDictionary = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
}


+ (id)allocWithZone:(NSZone *)zone{
    
    @synchronized(self) {
		
        if (_sharedManager == nil) {
			
            _sharedManager = [super allocWithZone:zone];
            
           
            return _sharedManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone{
    
    return self;
}


- (id)retain{
	
    return self;
}

- (unsigned)retainCount{
    
    return UINT_MAX;  //denotes an object that cannot be released
}



-(void)setData:(NSString *) value
       withKey:(NSString *) keyString{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KPersistenceDataKey]) {
      _dataDictionary  = [[[NSUserDefaults standardUserDefaults] objectForKey:KPersistenceDataKey] mutableCopy];
     }
    [_dataDictionary setObject:value forKey:keyString];
    
    [[NSUserDefaults standardUserDefaults] setObject:_dataDictionary forKey:KPersistenceDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSString *)getDatawithKey:(NSString *) keyString{
    
   NSMutableDictionary   *dataDict =  (NSMutableDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:KPersistenceDataKey];
    NSString   *valueOfkey = [dataDict valueForKey:keyString];
    
    return valueOfkey;
}

-(void)dealloc{
    
    [_dataDictionary release];
    [super dealloc];
}
@end
