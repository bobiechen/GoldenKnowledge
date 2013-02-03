//
//  KnowledgeDetailViewController.m
//  GoldenKnowledge
//
//  Created by BobieAir on 13/1/29.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import "KnowledgeDetailViewController.h"

static NSString* KNOWLEDGE_PIC_URL = @"http://blogberbagibersama.files.wordpress.com/2011/04/fucking-austria-roadsign1.jpg";

@interface KnowledgeDetailViewController ()

@end

@implementation KnowledgeDetailViewController {
    //IBOutlet UIImageView *m_imageKnowledgePicture;
}

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
	// Do any additional setup after loading the view.
    
    [self retrieveKnowledgePic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [m_imageKnowledgePicture release];
    [super dealloc];
}

- (void)retrieveKnowledgePic
{
    // If editor does not provide pic-url for the knowledge, just return
    //return;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:KNOWLEDGE_PIC_URL]];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
    {
        if (error)
        {
            NSLog(@"Cannot retrieve picture from URL");
        }
        else
        {
            if (data)
            {
                UIImage* image = [[UIImage alloc] initWithData:data];
                m_imageKnowledgePicture.image = image;
                [image release];
            }
        }
    }];
    
    [queue release];
}

- (void)viewDidUnload {
    [m_imageKnowledgePicture release];
    m_imageKnowledgePicture = nil;
    [super viewDidUnload];
}
@end
