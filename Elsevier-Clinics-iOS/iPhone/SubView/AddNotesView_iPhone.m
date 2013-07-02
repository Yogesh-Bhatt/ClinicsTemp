    //
//  AddNotes_iPhone.m
//  Clinics
//
//  Created by Ashish Awasthi on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddNotesView_iPhone.h"


@implementation AddNotesView_iPhone
@synthesize noteId;
@synthesize highlightedText;
@synthesize isNeedtodelete;
@synthesize  callerDelegate_iphone;
@synthesize filePath;
@synthesize deleteBtn;
@synthesize articleId;
@synthesize m_saveBtn;
@synthesize selectionInnerHtmlString, editButton;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code.
        
  //****************************** here Add SubView On This View ************************************
        
		[self setBackgroundColor:[UIColor clearColor]];
        UIImage   *imageName ;
        imageName = [UIImage imageNamed:@"iPhone_AddNoteBox.png"];
		UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, imageName.size.width,  imageName.size.height)];
		[bgImageView setImage:imageName];
		[self addSubview:bgImageView];
        
        UILabel  *headerLbl = [[UILabel alloc] init];
       headerLbl.backgroundColor = [UIColor clearColor];
        headerLbl.frame = CGRectMake(4, 0 , 220, 20);
        headerLbl.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        headerLbl.font = [UIFont boldSystemFontOfSize:12.0];
        headerLbl.textAlignment = UITextAlignmentCenter;
        headerLbl.textColor = [UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1.0];
        headerLbl.text = @"Notes";
        [bgImageView addSubview:headerLbl];
        RELEASE(headerLbl);
        RELEASE(bgImageView);
        
         imageName = [UIImage imageNamed:@"iPhone_Cancel_btnNote.png"];
		UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-55, self.frame.size.height-35.0,imageName.size.width, imageName.size.height)];
		[closeBtn setImage:imageName forState:UIControlStateNormal];
		[closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:closeBtn];
		[closeBtn release];

		selectedTextLbl=[[UITextView alloc]initWithFrame:CGRectMake(15.0, 40.0, self.frame.size.width-30.0, 40.0)];
		[selectedTextLbl setEditable:FALSE];
		[self addSubview:selectedTextLbl];

		textView=[[UITextView alloc]initWithFrame:CGRectMake(15.0, 110.0, self.frame.size.width-33.0, 45.0)];
		[self addSubview:textView];
       
        m_saveBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
		self.m_saveBtn.frame  = CGRectMake(10,self.frame.size.height-35.0, 44,  imageName.size.height);
		[self.m_saveBtn setImage:[UIImage imageNamed:@"iPhone_Save_Notes.png"] forState:UIControlStateNormal];
		[self.m_saveBtn addTarget:self action:@selector(saveNote) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.m_saveBtn];
     
        deleteBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
		self.deleteBtn.frame = CGRectMake(10,self.frame.size.height-35.0,  imageName.size.width,  imageName.size.height);
		[self.deleteBtn setImage:[UIImage imageNamed:@"iPhone_Delete_btn.png"] forState:UIControlStateNormal];
		[self.deleteBtn addTarget:self action:@selector(deleteNote) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.deleteBtn];
		self.deleteBtn.hidden=TRUE;
      
        editButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editButton.frame  = CGRectMake(100,self.frame.size.height-35.0,  imageName.size.width,  imageName.size.height);
		[self.editButton setBackgroundImage: imageName = [UIImage imageNamed:@"iPhone_Update_btn.png"] forState:UIControlStateNormal];
     
        [self.editButton.titleLabel setTextColor:[UIColor whiteColor]];
        self.editButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
		[self.editButton addTarget:self action:@selector(editNote) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.editButton];
		self.editButton.hidden=TRUE;		
	}
    return self;
}

  //****************************** Here Show selected Add Note Text ************************************

-(void)showText:(NSString*)text 
{
	[selectedTextLbl setText:text];
	[textView becomeFirstResponder];	
	if (isNeedtodelete) {
		
		[self setIsNeedtodelete:FALSE];
	}
}

//****************************** Here User Add Note Text ************************************

-(void)showUserNote:(NSString*)text
{
	[textView setText:text];
}

//****************************** Here Close Note View  ************************************

-(IBAction)closeBtnClicked
{
	[textView resignFirstResponder];
	if ([((NSObject*)self. callerDelegate_iphone) respondsToSelector:@selector(reloadWebView)]) {
		[self. callerDelegate_iphone reloadWebView];
	}
	[UIView beginAnimations:@"animationStart" context:nil];
	[UIView setAnimationDuration:0.5];
	
	self.frame=CGRectMake(self.frame.origin.x, -400.0, self.frame.size.width, self.frame.size.height);
	[UIView commitAnimations];
}

//****************************** Here Tab On Save Note ************************************

-(void)saveNote
{
	if (noteId && highlightedText) {
		DatabaseConnection *database = [DatabaseConnection sharedController];
        [database saveNotesInNoteTable:[NSString stringWithFormat:@"insert into tblNotes(NoteID,SelectedText,ArticleId,MyNotes)values('%@','%@',%i,'%@')",[noteId stringByReplacingOccurrencesOfString:@"'" withString:@"''"],[highlightedText stringByReplacingOccurrencesOfString:@"'" withString:@"''"],articleId,[textView.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
		[self saveNoteInHTML];
		if ([((NSObject*)self. callerDelegate_iphone) respondsToSelector:@selector(updateNotesInAtricleTable)]) {
			[self. callerDelegate_iphone updateNotesInAtricleTable];
			
		}
		
		[self closeBtnClicked];
	}
}

//****************************** Here Tab On Delete  Note ************************************

-(void)deleteNote
{      DatabaseConnection *database = [DatabaseConnection sharedController];
	[database deleteNotedInNoteTable:[NSString stringWithFormat:@"delete from tblNotes where noteID = '%@'",noteId]];
	if ([((NSObject*)self.callerDelegate_iphone) respondsToSelector:@selector(deleteNoteForId:)]) {
		[self.callerDelegate_iphone deleteNoteForId:noteId];
		[self.callerDelegate_iphone updateNotesInAtricleTable];
		[self closeBtnClicked];	
	}
}

//****************************** Here Tab On Edit   Note ************************************

-(void)editNote {
	DatabaseConnection *database = [DatabaseConnection sharedController];
	[NSString stringWithFormat:@"update tblNotes Set MyNotes = '%@' where noteID = '%@'",textView.text,noteId];
	BOOL result =[database updateNotesInNoteTable:[NSString stringWithFormat:@"update tblNotes Set MyNotes = '%@' where noteID = '%@'",textView.text,noteId]];
    if(result){
        UIAlertView *alert=[[[UIAlertView alloc]initWithTitle:@"Notes" message:@"Notes have been updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]autorelease];
        [alert show];
    }
    [self closeBtnClicked];
}

//****************************** Here Change Color HTML yellow Add   Note ************************************

-(void)saveNoteInHTML
{
	NSArray *htmlComponenets=[[NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil] componentsSeparatedByString:@"<body"];
	
	NSString *headerComponet=@"";
	NSString *bodyComponent=@"";
	NSString *footerComponent=@"";
	
	if ([htmlComponenets count]>0) {
		headerComponet=[htmlComponenets objectAtIndex:0];
		
		if ([htmlComponenets count]>1) {
			NSArray *bodyStyleComp=[[htmlComponenets objectAtIndex:1] componentsSeparatedByString:@">"];
			if ([bodyStyleComp count]>0) {
				bodyComponent=[bodyStyleComp objectAtIndex:0];
			}
		}
	}
	
	NSArray *htmlFooterComponents=[[NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil] componentsSeparatedByString:@"</body"];
	if ([htmlFooterComponents count]>1) {
		footerComponent=[htmlFooterComponents objectAtIndex:1];
	}
	
	NSError *error;
	
	NSString *finalHTML=[headerComponet stringByAppendingFormat:@"<body %@>",bodyComponent];
	finalHTML=[finalHTML stringByAppendingString:selectionInnerHtmlString];
	finalHTML=[finalHTML stringByAppendingFormat:@"</body %@",footerComponent];
	
	[finalHTML writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:&error];	
}

//****************************** Here Change Color HTML yellow Add   Note ************************************

- (void)dealloc {
	
    self.editButton = nil;
    self.deleteBtn = nil;
    self.m_saveBtn = nil;
    self.callerDelegate_iphone = nil;
    self.filePath = nil;
    self.selectionInnerHtmlString = nil;
    self.noteId = nil;
    self.highlightedText = nil;    
    RELEASE(selectedTextLbl);
    RELEASE(textView);
    [super dealloc];
}


@end
