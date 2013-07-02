//
//  HighlightObject.h
//  Elsevier
//
//  Created by Subhash Chand on 5/11/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HighlightObject : NSObject {
	NSInteger recordId;
	NSInteger articleId;
	NSString *noteId;
	NSString *selectedText;
	NSString *myNotes;
	
}
@property(nonatomic,assign)NSInteger recordId;
@property(nonatomic,assign)NSInteger articleId;
@property(nonatomic,retain)NSString *noteId;
@property(nonatomic,retain)NSString *selectedText;
@property(nonatomic,retain)NSString *myNotes;

@end
