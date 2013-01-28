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

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self.view sendSubviewToBack:self.viewBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_viewBackground release];
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

- (void)backToMain
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
