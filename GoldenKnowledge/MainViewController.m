//
//  MainViewController.m
//  GoldenKnowledge
//
//  Created by BobieAir on 13/1/27.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import "MainViewController.h"
#import "KnowledgeTableViewController.h"
#import "WheresEditorViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "KnowledgeDetails.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self.view sendSubviewToBack:self.viewBackground];
    
    [self prepareKnowledgeScrollView];
    [self prepareButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_viewBackground release];
    [_btnWheresEditor release];
    [_btnKnowledgeList release];
    [_scrollKnowledge release];
    [_imageEditor release];
    [super dealloc];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueIdWheresEditor"])
    {
        WheresEditorViewController* wheresEditorViewController = segue.destinationViewController;
        wheresEditorViewController.parentMainViewController = self;
    }
    else if ([segue.identifier isEqualToString:@"segueIdList"])
    {
        UINavigationController* navController = segue.destinationViewController;
        KnowledgeTableViewController* knowledgeTableViewController = [navController.viewControllers objectAtIndex:0];
        knowledgeTableViewController.parentMainViewController = self;
    }
}

- (void)prepareKnowledgeScrollView
{
//    NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], nil];
//    for (int i = 0; i < 3; ++i)
//    {
//        CGRect frame;
//        frame.origin.x = 0;
//        frame.origin.y = self.scrollKnowledge.frame.size.height * i;
//        frame.size = self.scrollKnowledge.frame.size;
//        
//        UIView* subview = [[UIView alloc] initWithFrame:frame];
//        UILabel* labelText = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 170, 22)];
//        labelText.text = @"hahahaha";
//        labelText.backgroundColor = [UIColor clearColor];
//        [subview addSubview:labelText];
//        //subview.backgroundColor = [colors objectAtIndex:i];
//        subview.backgroundColor = [UIColor clearColor];
//        [self.scrollKnowledge addSubview:subview];
//        [subview release];
//    }
//    
//    self.scrollKnowledge.contentSize = CGSizeMake(self.scrollKnowledge.frame.size.width, self.scrollKnowledge.frame.size.height*[colors count]);
    
    UIApplication * sharedApplication = [UIApplication sharedApplication];
    NSFetchRequest* requestFetch = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"KnowledgeDetails"
                                              inManagedObjectContext:[(AppDelegate*)[sharedApplication delegate] managedObjectContext]];
    [requestFetch setEntity:entity];
    NSError* error = nil;
    NSMutableArray* returnObjs = [[[(AppDelegate*)[sharedApplication delegate] managedObjectContext] executeFetchRequest:requestFetch error:&error] mutableCopy];
    
    [requestFetch release];
    
    int index = 0;
    for (KnowledgeDetails* currentKnowledge in returnObjs)
    {
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = self.scrollKnowledge.frame.size.height * index;
        frame.size = self.scrollKnowledge.frame.size;
        
        UIView* subview = [[UIView alloc] initWithFrame:frame];
        UILabel* labelText = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 170, 80)];
        labelText.lineBreakMode =  NSLineBreakByTruncatingTail;
        labelText.numberOfLines = 0;
        labelText.text = currentKnowledge.excerpt;
        labelText.backgroundColor = [UIColor clearColor];
        [subview addSubview:labelText];
        subview.backgroundColor = [UIColor clearColor];
        [self.scrollKnowledge addSubview:subview];
        [subview release];
        
        ++index;
    }
    
    self.scrollKnowledge.contentSize = CGSizeMake(self.scrollKnowledge.frame.size.width, self.scrollKnowledge.frame.size.height*[returnObjs count]);
    
    [returnObjs release];
}

- (void)prepareEditorAvatar
{
    UIImage* image = [UIImage imageNamed:@"main_jameslin.png"];
    self.imageEditor.image = image;
}

- (void)prepareButtons
{
    UIImage* imageWheresEditorPressed = [UIImage imageNamed:@"main_btn_editortracking.png"];
    [self.btnWheresEditor setImage:imageWheresEditorPressed forState:UIControlStateHighlighted];
    
    
    UIImage* imageKnowledgeListPressed = [UIImage imageNamed:@"main_btn_knowledgelist.png"];
    [self.btnKnowledgeList setImage:imageKnowledgeListPressed forState:UIControlStateHighlighted];
}

- (void)backToMain
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setBtnWheresEditor:nil];
    [self setBtnKnowledgeList:nil];
    [self setScrollKnowledge:nil];
    [self setImageEditor:nil];
    [super viewDidUnload];
}
@end
