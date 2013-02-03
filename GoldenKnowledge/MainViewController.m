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
    NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], nil];
    for (int i = 0; i < 3; ++i)
    {
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = self.scrollKnowledge.frame.size.height * i;
        frame.size = self.scrollKnowledge.frame.size;
        
        UIView* subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = [colors objectAtIndex:i];
        [self.scrollKnowledge addSubview:subview];
        [subview release];
    }
    
    self.scrollKnowledge.contentSize = CGSizeMake(self.scrollKnowledge.frame.size.width, self.scrollKnowledge.frame.size.height*[colors count]);
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
    [super viewDidUnload];
}
@end
