//
//  AddNotes_iPhone.h
//  Clinics
//
//  Created by Ashish Awasthi on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol AddNotesView_iPhoneDelegate

-(void)deleteNoteForId:(NSString*)noteId;
-(void)reloadWebView;
-(void)updateNotesInAtricleTable;
@end

@interface AddNotesView_iPhone : UIView {
	UITextView *textView;
	NSString *noteId;
	NSString *highlightedText;
	NSString *filePath;
	NSInteger articleId;
	NSString *selectionInnerHtmlString;
	BOOL isNeedtodelete;
	UIButton *saveBtn;
	id  callerDelegate_iphone;
	UIButton *deleteBtn;
    UIButton *editButton;
	UITextView *selectedTextLbl;
}
@property (nonatomic, assign) NSInteger articleId;
@property (nonatomic, retain) UIButton *deleteBtn;
@property (nonatomic, retain) UIButton *m_saveBtn;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSString *selectionInnerHtmlString;
@property (nonatomic, assign) id <AddNotesView_iPhoneDelegate> callerDelegate_iphone;
@property (nonatomic, assign) BOOL isNeedtodelete;
@property (nonatomic, retain) NSString *noteId;
@property (nonatomic, retain) NSString *highlightedText;
@property (nonatomic, retain) UIButton *editButton;

-(void)showText:(NSString*)text;
-(void)showUserNote:(NSString*)text;
-(void)saveNoteInHTML;
@end
