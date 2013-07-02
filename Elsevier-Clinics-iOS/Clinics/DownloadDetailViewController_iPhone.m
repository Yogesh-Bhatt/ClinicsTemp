//
//  DownloadDetailViewController_iPhoneViewController.m
//  Clinics
//
//  Created by Kiwitech International on 29/06/13.
//
//

#import "DownloadDetailViewController_iPhone.h"
#import "DownloadDeatilView_iPhoneCell.h"
#import "ArticleDataHolder.h"
#import "ClinicsAppDelegate.h"

@interface DownloadDetailViewController_iPhone ()

@end

ClinicsAppDelegate *appDel;
@implementation DownloadDetailViewController_iPhone

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDel = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [arr release];
    [super dealloc];
    
}

-(void)refreshTblWith:(NSArray *)a_articleArr{
    
    m_articleArr = [[NSArray arrayWithArray:a_articleArr] retain];
    

    ClinicsAppDelegate *appDelT = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    for(int i =0;i<[m_articleArr count];i ++){
        
        DownloadDeatilView_iPhoneCell *cell;
        
        ArticleDataHolder *obj = (ArticleDataHolder *)[m_articleArr objectAtIndex:i];
        
        cell = [[DownloadDeatilView_iPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil downloadedCustomViewWithFrame:CGRectMake(0,0,200,40) withDownloadUrl:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,obj.sArticleInfoId] withTitle:obj.sArticleTitle withSubTitle:obj.sArticleDescription];
         //[arr addObject:cell];
         [appDelT.m_downloadArticlesArr addObject:cell];
        
    }
    NSLog(@"[arr count]== %d",[arr count]);
    [m_tableView reloadData];
    
    
    
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [appDel.m_downloadArticlesArr count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier_%d%d",
                                indexPath.section, indexPath.row];
    DownloadDeatilView_iPhoneCell *cell = (DownloadDeatilView_iPhoneCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSLog(@"indexPath.row %d",indexPath.row);
        cell = [appDel.m_downloadArticlesArr objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    // Configure the cell...
    
    return cell;
}



-(IBAction)clearAllDownloads:(id)sender{
    
    //    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    //    NSString *documentsDirectory = [(NSString *)[paths objectAtIndex:0] stringByAppendingPathComponent:zipFileName];
    //    NSString *fileDocPath = [NSString stringWithFormat:@"%@/",documentsDirectory];
    //
    //
    //    NSFileManager *filemanager=[NSFileManager defaultManager];
    //    NSError *error;
    //
    //    NSString  *file=  [fileDocPath substringToIndex:[fileDocPath length] - 1];
    //    //NSLog(@" file %@",file);
    //    if([filemanager fileExistsAtPath:file]){
    //        //NSLog(@"rohit removeItemAtPath4");
    //        [filemanager removeItemAtPath:file error:&error];
    //
    //    }
    //}
    
    
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end