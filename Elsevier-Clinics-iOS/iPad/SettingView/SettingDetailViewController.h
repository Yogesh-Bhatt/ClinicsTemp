//
//  SettingDetailViewController.h
//  Clinics
//
//  Created by Ashish Awasthi on 09/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableCellView.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeEditorView.h"
#import "ViewWebPageClinic.h"
#import "InstructionView.h"

@interface SettingDetailViewController : BaseViewController<UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate,InstructionViewDelegate> 
{
    id m_parentRootVC;
	
    UIPopoverController         *m_popoverController; 
    IBOutlet UITableView *m_tblClinics;
    NSMutableArray *m_arrCategory;
	TableCellView *cell;
	NSInteger  sectionIndex;
    
	HomeEditorView  *homeEditorView;
	ViewWebPageClinic  *webview;
	UIView  *instructionView;
    InstructionView  *m_instructionView;
   	
	}

@property(nonatomic,retain)HomeEditorView  *homeEditorView;
@property (nonatomic, assign) id                m_parentRootVC;
-(void)clickOnCheckButton:(id)sender;

-(void) doneButtonPressed;
-(void) dismissPopoover;
-(void) showPopOver;
-(void) loadData;
-(void)selectClinicSection:(NSInteger )Section;
-(void)CheckUpdate;
- (void) didRotate:(id)sender;
-(void)showDescriptionView;
-(void)pushToWebView:(id)sender;
-(void)cancelButtonpress:(id)sender;
-(void)changeSizeNavigationBarTitle;

@end
