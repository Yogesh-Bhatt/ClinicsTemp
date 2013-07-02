//
//  PersistenceDataStore.h
//  SocialNetWork
//
//  Created by Ashish Awasthi on 12/13/12.
//  Copyright (c) 2012 Ashish Awasthi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersistenceDataStore : NSObject{

}
+(PersistenceDataStore *)sharedManager;
-(void)setData:(NSString *) value
       withKey:(NSString *) keyString;
-(NSString *)getDatawithKey:(NSString *) keyString;
@property(nonatomic,retain) NSMutableDictionary     *_dataDictionary;
@end
