//
//  MainViewController.h
//  GoldenKnowledge
//
//  Created by BobieAir on 13/1/27.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

- (void)backToMain;

@property (retain, nonatomic) IBOutlet UIImageView *viewBackground;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollKnowledge;
@property (retain, nonatomic) IBOutlet UIButton *btnWheresEditor;
@property (retain, nonatomic) IBOutlet UIButton *btnKnowledgeList;

@end
