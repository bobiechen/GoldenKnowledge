//
//  KnowledgeTableViewController.m
//  GoldenKnowledge
//
//  Created by BobieAir on 13/1/28.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import "KnowledgeTableViewController.h"
#import "MainViewController.h"
#import "KnowledgeDetailViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "KnowledgeDetails.h"


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
    if (!m_bLoaded)
    {
        [self performSelector:@selector(fetchKnowledgeFromDB) withObject:nil afterDelay:0.0f];
        //[self performSelector:@selector(fetchKnowledgePosts) withObject:nil afterDelay:0.5];
    }
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
        return 1;
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
        
        KnowledgeDetails* knowledgeDetails = [m_arrayKnowledgePosts objectAtIndex:indexPath.row];
        //cell.textLabel.text = [[m_arrayKnowledgePosts objectAtIndex:indexPath.row] objectForKey:@"title"];
        //cell.detailTextLabel.text = [[m_arrayKnowledgePosts objectAtIndex:indexPath.row] objectForKey:@"date"];
        cell.textLabel.text = knowledgeDetails.title;
        cell.detailTextLabel.text = knowledgeDetails.date;
        
        return cell;
    }
    else if (!m_bLoaded)
    {
        static NSString* CellIdentifier = @"CellLoading";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    KnowledgeDetailViewController* detailViewController = [[KnowledgeDetailViewController alloc]
                                                           initWithNibName:@"KnowledgeDetailViewController" bundle:nil];
    
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    //*/
    
    NSLog(@"didSelectRowAtIndexPath, indexPath section: %d, row: %d", indexPath.section, indexPath.row);
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([[cell reuseIdentifier] isEqualToString:@"CellNoPost"])
    {
        [self fetchKnowledgePosts];
    }
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
                                                    [post objectForKey:@"title_plain"], [post objectForKey:@"date"],
                                                    [post objectForKey:@"content"], [post objectForKey:@"excerpt"] ];
                        NSArray* arrayKeys = @[ @"id", @"title", @"title_plain", @"date", @"content", @"excerpt" ];
                        NSDictionary* dictKnowledge = [NSDictionary dictionaryWithObjects:arrayValues forKeys:arrayKeys];
                        
                        [m_arrayKnowledgePosts addObject:dictKnowledge];
                    }
                }
                
                [self refreshDBKnowledges:m_arrayKnowledgePosts];
                [self fetchKnowledgeFromDB];
                [self performSelectorOnMainThread:@selector(fetchComplete) withObject:nil waitUntilDone:NO];
            }
        }];
    
    [queue release];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueIdKnowledgeDetail"])
    {
        KnowledgeDetailViewController* knowledgeDetailViewController = segue.destinationViewController;
        
        // Pass the detailed data to KnowledgeDetailViewController
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        //NSDictionary* dictKnowledge = [m_arrayKnowledgePosts objectAtIndex:indexPath.row];
        KnowledgeDetails* knowledgeDetails = [m_arrayKnowledgePosts objectAtIndex:indexPath.row];
        
        //NSArray* arrayValue = @[ [dictKnowledge objectForKey:@"date"], [dictKnowledge objectForKey:@"content"] ];
        NSArray* arrayValue = @[ knowledgeDetails.date, knowledgeDetails.content ];
        NSArray* arrayKey = @[ @"date", @"content" ];
        NSDictionary* dictKnowledgeDetails = [NSDictionary dictionaryWithObjects:arrayValue forKeys:arrayKey];
        
        [knowledgeDetailViewController prepareKnowledge:dictKnowledgeDetails];
    }
}

- (void)showFirstTimeLoadingView
{
    //[self.indicatorLoading startAnimating];
}

- (void)firstTimeLoadingComplete
{
    //[self.indicatorLoading stopAnimating];
    //[self.viewLoading removeFromSuperview];
}

- (void)fetchComplete
{
    m_bLoaded = YES;
    //[self firstTimeLoadingComplete];
    [self.tableView reloadData];
}

// Refresh knowledge posts in DB with HTTP return data (if any)
- (void)refreshDBKnowledges:(NSMutableArray*)posts
{
    if (![posts count])
    {
        return;
    }
    
    UIApplication * sharedApplication = [UIApplication sharedApplication];
    for (NSDictionary *item in posts)
    {
        KnowledgeDetails* knowledgePost =
        (KnowledgeDetails*) [NSEntityDescription insertNewObjectForEntityForName:@"KnowledgeDetails"
                                                       inManagedObjectContext:[(AppDelegate*)[sharedApplication delegate] managedObjectContext]];
        
        knowledgePost.post_id = [item objectForKey:@"id"];
        knowledgePost.title = [item objectForKey:@"title"];
        knowledgePost.excerpt = [item objectForKey:@"excerpt"];
        knowledgePost.date = [item objectForKey:@"date"];
        knowledgePost.content = [item objectForKey:@"content"];
        
        NSError* error = nil;
        if (![((AppDelegate*)[sharedApplication delegate]).managedObjectContext save:&error]) {
            NSLog(@"GoldenKnowledge Debug, KnowledgeTableViewController refreshDBKnowledges, Failed to add new knowledge posts into DB");
            break;
        }
    }
}

- (void)fetchKnowledgeFromDB
{
    if (!m_arrayKnowledgePosts)
    {
        m_arrayKnowledgePosts = [[NSMutableArray alloc] init];
    }
    
    [m_arrayKnowledgePosts removeAllObjects];
    
    UIApplication * sharedApplication = [UIApplication sharedApplication];
    NSFetchRequest* requestFetch = [[NSFetchRequest alloc] init];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray* arraySortDesc = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [requestFetch setSortDescriptors:arraySortDesc];
    [sortDescriptor release];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"KnowledgeDetails"
                                              inManagedObjectContext:[(AppDelegate*)[sharedApplication delegate] managedObjectContext]];
    [requestFetch setEntity:entity];
    NSError* error = nil;
    NSMutableArray* returnObjs = [[[(AppDelegate*)[sharedApplication delegate] managedObjectContext] executeFetchRequest:requestFetch error:&error] mutableCopy];
    
    [requestFetch release];
    
    // update table view
    for (KnowledgeDetails* currentKnowledge in returnObjs)
    {
        NSLog(@"fetchLayersFromDB, id: %@ title: %@", currentKnowledge.post_id, currentKnowledge.title);
        [m_arrayKnowledgePosts insertObject:currentKnowledge atIndex:0];
    }
    
    [returnObjs release];
    
    [self fetchComplete];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scroll offset: %f", scrollView.contentOffset.y);
    
    float fTopBarNavBarHeight = 416.0f;
    float fCellHeight = 44.0f;
    float fScrollNearBottomOffset = 22.0f;
    float fNearBottomPosition = [m_arrayKnowledgePosts count]*fCellHeight - fTopBarNavBarHeight + fScrollNearBottomOffset;
    
    if (scrollView.contentOffset.y > fNearBottomPosition)
    {
        NSLog(@"Scroll near bottom");
    }
}


- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
