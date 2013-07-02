//
//  AddNotesView.m
//  NoteHeightLightAppDemo
//
//  Created by Ashish Awasthi on 4/27/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import "AddNotesView.h"
#import "DatabaseConnection.h"

@implementation AddNotesView
@synthesize noteId;
@synthesize highlightedText;
@synthesize isNeedtodelete;
@synthesize callerDelegate;
@synthesize filePath;
@synthesize deleteBtn;
@synthesize articleId;
@synthesize saveBtn1;
@synthesize selectionInnerHtmlString, editButton;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        
              
        
        UIImage  *imageName ;
        imageName = [UIImage imageNamed:@"notePad.png"];
		[self setBackgroundColor:[UIColor clearColor]];
		UIImageView *bgImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0,imageName.size.width, imageName.size.height)]autorelease];
		[bgImageView setImage:imageName];
		[self addSubview:bgImageView];
        
        UILabel  *headerLbl = [[UILabel alloc] init];
        headerLbl.backgroundColor = [UIColor clearColor];
        headerLbl.frame = CGRectMake(10, 0 , 352, 44);
        headerLbl.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        headerLbl.font = [UIFont boldSystemFontOfSize:16.0];
        headerLbl.textAlignment = UITextAlignmentCenter;
        headerLbl.textColor = [UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1.0];
        headerLbl.text = @"Notes";
        [bgImageView addSubview:headerLbl];
        RELEASE(headerLbl);
		
        
        
		selectedTextLbl=[[UITextView alloc]initWithFrame:CGRectMake(25.0, 80.0, self.frame.size.width-50.0, 80.0)];
		[selectedTextLbl setEditable:FALSE];
		[self addSubview:selectedTextLbl];
		
		
		
		textView=[[UITextView alloc]initWithFrame:CGRectMake(25.0, 205.0, self.frame.size.width-50.0, 60.0)];
		[self addSubview:textView];
		
        imageName = [UIImage imageNamed:@"AlertSave.png"];
        saveBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
		self.saveBtn1.frame = CGRectMake(29,self.frame.size.height-20.0, imageName.size.width, imageName.size.height);
		[self.saveBtn1 setImage:imageName forState:UIControlStateNormal];
		[self.saveBtn1 addTarget:self action:@selector(saveNote) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.saveBtn1];
		
        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         imageName = [UIImage imageNamed:@"deleteNote_2.png"];
		self.deleteBtn.frame = CGRectMake(30,self.frame.size.height-20.0, imageName.size.width, imageName.size.height);
		[self.deleteBtn setImage:imageName forState:UIControlStateNormal];
		[self.deleteBtn addTarget:self action:@selector(deleteNote) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.deleteBtn];
		self.deleteBtn.hidden=TRUE;
        
        
        imageName = [UIImage imageNamed:@"cancelNote_2.png"];
		UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-80, self.frame.size.height-20.0, imageName.size.width, imageName.size.height)];
		[closeBtn setImage:imageName forState:UIControlStateNormal];
		[closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:closeBtn];
		[closeBtn release];

        imageName = [UIImage imageNamed:@"blackButton.png"];
         editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editButton.frame = CGRectMake(165,self.frame.size.height-20.0, imageName.size.width, imageName.size.height);
		[self.editButton setBackgroundImage:imageName forState:UIControlStateNormal];
        [self.editButton.titleLabel setTextColor:[UIColor whiteColor]];
        self.editButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
		[self.editButton addTarget:self action:@selector(editNote) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.editButton];
		self.editButton.hidden=TRUE;		
	}
    return self;
}
-(void)showText:(NSString*)text 
{
	[selectedTextLbl setText:text];
	[textView becomeFirstResponder];	
	if (isNeedtodelete) {
		
		[self setIsNeedtodelete:FALSE];
	}
}

-(void)showUserNote:(NSString*)text
{
	[textView setText:text];
}
-(IBAction)closeBtnClicked
{
	[textView resignFirstResponder];
	if ([((NSObject*)self.callerDelegate) respondsToSelector:@selector(reloadWebView)]) {
		[self.callerDelegate reloadWebView];
	}
	[UIView beginAnimations:@"animationStart" context:nil];
	[UIView setAnimationDuration:0.5];
	
	self.frame=CGRectMake(self.frame.origin.x, -400.0, self.frame.size.width, self.frame.size.height);
	[UIView commitAnimations];
}
-(void)saveNote
{
	if (noteId && highlightedText) {
		DatabaseConnection *database = [DatabaseConnection sharedController];
        [database saveNotesInNoteTable:[NSString stringWithFormat:@"insert into tblNotes(NoteID,SelectedText,ArticleId,MyNotes)values('%@','%@',%i,'%@')",[noteId stringByReplacingOccurrencesOfString:@"'" withString:@"''"],[highlightedText stringByReplacingOccurrencesOfString:@"'" withString:@"''"],articleId,[textView.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
		[self saveNoteInHTML];
		if ([((NSObject*)self.callerDelegate) respondsToSelector:@selector(updateNotesInAtricleTable)]) {
			[self.callerDelegate updateNotesInAtricleTable];
				
		}
	
		[self closeBtnClicked];
	}
}
-(void)deleteNote
{      DatabaseConnection *database = [DatabaseConnection sharedController];
       [database deleteNotedInNoteTable:[NSString stringWithFormat:@"delete from tblNotes where noteID = '%@'",noteId]];
	if ([((NSObject*)self.callerDelegate) respondsToSelector:@selector(deleteNoteForId:)]) {
		[self.callerDelegate deleteNoteForId:noteId];
		[self.callerDelegate updateNotesInAtricleTable];
		[self closeBtnClicked];	
	}
}

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


- (void)dealloc {
  
    self.editButton = nil;
    self.deleteBtn = nil;
    self.saveBtn1 = nil;
    self.callerDelegate = nil;
    self.filePath = nil;
    self.selectionInnerHtmlString = nil;
    self.callerDelegate = nil;
    self.noteId = nil;
    self.highlightedText = nil;    
    RELEASE(selectedTextLbl);
    RELEASE(textView);
    [super dealloc];
}


@end
