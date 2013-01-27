//
//  MainViewController.m
//  GoldenKnowledge
//
//  Created by BobieAir on 13/1/27.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import "MainViewController.h"

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
@end
