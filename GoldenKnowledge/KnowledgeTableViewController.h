//
//  KnowledgeTableViewController.h
//  GoldenKnowledge
//
//  Created by BobieAir on 13/1/28.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface KnowledgeTableViewController : UITableViewController

@property (nonatomic, assign) MainViewController* parentMainViewController;

@property (retain, nonatomic) IBOutlet UIView *viewLoading;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorLoading;


- (IBAction)backToMain:(id)sender;
@end
