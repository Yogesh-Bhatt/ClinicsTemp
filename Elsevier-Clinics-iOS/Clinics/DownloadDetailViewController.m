//
//  DownloadDetailViewController.m
//  Clinics
//
//  Created by Rohit Dhawan on 27/06/13.
//
//

#import "DownloadDetailViewController.h"
#import "DownloadDeatilView.h"
#import "ClinicsAppDelegate.h"


@interface DownloadDetailViewController ()

@end

ClinicsAppDelegate *appDel;
@implementation DownloadDetailViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentSizeForViewInPopover = CGSizeMake(320, 768);
    
    appDel = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTblWith:(NSArray *)a_articleArr{
    
    m_articleArr = [[NSArray arrayWithArray:a_articleArr] retain];
    

    ClinicsAppDelegate *appDelT = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    for(int i =0;i<[m_articleArr count];i ++){
        
        DownloadDeatilView *cell;
        
            ArticleDataHolder *obj = (ArticleDataHolder *)[m_articleArr objectAtIndex:i];
            
            cell = [[DownloadDeatilView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil downloadedCustomViewWithFrame:CGRectMake(0,0,320,120) withDownloadUrl:[NSString stringWithFormat:@"%@%@",dwonlodaUrl,obj.sArticleInfoId] withTitle:obj.sArticleTitle withSubTitle:obj.sArticleDescription];
            [appDelT.m_downloadArticlesArr addObject:cell];
            
    }
    NSLog(@"[arr count]== %d ",[appDel.m_downloadArticlesArr count]);
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
    return [appDel.m_downloadArticlesArr count] ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"SimpleTableIdentifier_%d%d",
                                       indexPath.section, indexPath.row];
    DownloadDeatilView *cell = (DownloadDeatilView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSLog(@"indexPath.row %d",indexPath.row);
        cell = [appDel.m_downloadArticlesArr objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    // Configure the cell...
    
    return cell;
}



-(IBAction)clearAllDownloads:(id)sender{
    
 ClinicsAppDelegate *appDelT = (ClinicsAppDelegate *)[UIApplication sharedApplication].delegate;
    
    for(int i =0;i<[appDel.m_downloadedConnectionArr count];i++){
        
        NSURLConnection *conn = [appDel.m_downloadedConnectionArr objectAtIndex:i];
        [conn cancel];
        conn = nil;

    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [appDel.m_downloadedConnectionArr removeAllObjects];
    [appDelT.m_downloadArticlesArr removeAllObjects];
    [m_tableView reloadData];
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
