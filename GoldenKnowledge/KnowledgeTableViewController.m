//
//  KnowledgeTableViewController.m
//  GoldenKnowledge
//
//  Created by BobieAir on 13/1/28.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import "KnowledgeTableViewController.h"
#import "MainViewController.h"

const NSString* JSON_SITE_BASEURL =             @"http://zootheband.com/home/?json=";
const NSString* JSON_API_GET_CATEGORY_POSTS =   @"get_category_posts=3";    // GoldenKnowledge category id: 3
const NSString* JSON_API_KEYWORD_POSTS =        @"posts";

@interface KnowledgeTableViewController ()

@end

@implementation KnowledgeTableViewController {
    NSMutableArray* m_arrayKnowledgePosts;
    BOOL m_bLoaded;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        m_bLoaded = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self showFirstTimeLoadingView];
    [self performSelector:@selector(fetchKnowledgePosts) withObject:nil afterDelay:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMain:(id)sender {
    [self.parentMainViewController backToMain];
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
    if (!m_bLoaded)
        return 0;
    else if ([m_arrayKnowledgePosts count])
        return [m_arrayKnowledgePosts count];
    else if (![m_arrayKnowledgePosts count] && m_bLoaded)
        return 1;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([m_arrayKnowledgePosts count])
    {
        static NSString *CellIdentifier = @"CellKnowledgeTitle";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        cell.textLabel.text = [[m_arrayKnowledgePosts objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.detailTextLabel.text = [[m_arrayKnowledgePosts objectAtIndex:indexPath.row] objectForKey:@"date"];
        
        return cell;
    }
    else
    {
        static NSString* CellIdentifier = @"CellNoPost";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return cell;
    }
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

- (void)fetchKnowledgePosts
{
    if (!m_arrayKnowledgePosts)
    {
        m_arrayKnowledgePosts = [[NSMutableArray alloc] init];
    }
    
    [m_arrayKnowledgePosts removeAllObjects];
    
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", JSON_SITE_BASEURL, JSON_API_GET_CATEGORY_POSTS]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            // Completion handler
            if (error)
            {
                NSLog(@"KnowledgeTableViewController, failed to fetch knowledge posts");
            }
            else
            {
                if (data)
                {
                    NSDictionary* dictData = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingMutableLeaves
                                                                               error:nil];
                    NSDictionary* dictPosts = [dictData objectForKey:JSON_API_KEYWORD_POSTS];
                    for (NSDictionary* post in dictPosts)
                    {
                        NSArray* arrayValues = @[ [post objectForKey:@"id"], [post objectForKey:@"title"],
                                                    [post objectForKey:@"title_plain"], [post objectForKey:@"date"] ];
                        NSArray* arrayKeys = @[ @"id", @"title", @"title_plain", @"date" ];
                        NSDictionary* dictKnowledge = [NSDictionary dictionaryWithObjects:arrayValues forKeys:arrayKeys];
                        
                        [m_arrayKnowledgePosts addObject:dictKnowledge];
                    }
                }
                
                [self fetchComplete];
            }
        }];
    
    [queue release];
}

- (void)showFirstTimeLoadingView
{
    [self.indicatorLoading startAnimating];
}

- (void)firstTimeLoadingComplete
{
    [self.indicatorLoading stopAnimating];
    [self.viewLoading removeFromSuperview];
}

- (void)fetchComplete
{
    m_bLoaded = YES;
    [self firstTimeLoadingComplete];
    [self.tableView reloadData];
}


- (void)dealloc {
    [_indicatorLoading release];
    [_viewLoading release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setIndicatorLoading:nil];
    [self setViewLoading:nil];
    [super viewDidUnload];
}
@end
