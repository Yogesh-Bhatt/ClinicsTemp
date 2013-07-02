//
//  AddNotesView.h
//  NoteHeightLightAppDemo
//
//  Created by Ashish Awasthi on 4/27/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNotesViewDelegate

-(void)deleteNoteForId:(NSString*)noteId;
-(void)reloadWebView;
-(void)updateNotesInAtricleTable;
@end

@interface AddNotesView : UIView {
	UITextView *textView;
	NSString *noteId;
	NSString *highlightedText;
	NSString *filePath;
	NSInteger articleId;
	NSString *selectionInnerHtmlString;
	BOOL isNeedtodelete;
	UIButton *saveBtn;
	id callerDelegate;
	UIButton *deleteBtn;
	UIButton *saveBtn1;
    UIButton *editButton;
	UITextView *selectedTextLbl;
}
@property (nonatomic, assign) NSInteger articleId;
@property (nonatomic, retain) UIButton *deleteBtn;
@property (nonatomic, retain) UIButton *saveBtn1;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSString *selectionInnerHtmlString;
@property (nonatomic, assign) id <AddNotesViewDelegate> callerDelegate;
@property (nonatomic, assign) BOOL isNeedtodelete;
@property (nonatomic, retain) NSString *noteId;
@property (nonatomic, retain) NSString *highlightedText;
@property (nonatomic, retain) UIButton *editButton;

-(void)showText:(NSString*)text;
-(void)showUserNote:(NSString*)text;
-(void)saveNoteInHTML;
@end
