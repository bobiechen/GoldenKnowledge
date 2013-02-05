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
    
    [self performSelector:@selector(loadKnowledge) withObject:nil afterDelay:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [m_imageKnowledgePicture release];
    [m_textKnowledgeContent release];
    [m_labelDate release];
    [m_viewKnowledge release];
    [m_scrollView release];
    [super dealloc];
}

- (void)prepareKnowledge:(NSDictionary*)dictKnowledge
{
    if (dictKnowledge)
    {
        self.strDate = [dictKnowledge objectForKey:@"date"];
        self.strContent = [dictKnowledge objectForKey:@"excerpt"];
    }
}

- (void)loadKnowledge
{
    if (!m_labelDate)
        m_labelDate = [[UILabel alloc] initWithFrame:CGRectMake(160, 25, 170, 22)];
    
    if (!m_textKnowledgeContent)
        m_textKnowledgeContent = [[UITextView alloc] initWithFrame:CGRectMake(20, 45, 240, 75)];
    
    m_labelDate.text = [self.strDate substringWithRange:NSMakeRange(0, 10)];
    m_textKnowledgeContent.text = self.strContent;
    m_textKnowledgeContent.textColor = [UIColor blackColor];
    CGRect frame = m_textKnowledgeContent.frame;
    frame.size.height = m_textKnowledgeContent.contentSize.height;
    m_textKnowledgeContent.frame = frame;
    
    if (!m_viewKnowledge)
        m_viewKnowledge = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 600)];
    
    [m_viewKnowledge addSubview:m_textKnowledgeContent];
    
    CGRect frame2 = m_viewKnowledge.frame;
    frame2.size.height = m_textKnowledgeContent.frame.origin.y + m_textKnowledgeContent.frame.size.height;
    m_viewKnowledge.frame = frame2;
    
    if (!m_scrollView)
        m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 800)];
    
    [m_scrollView addSubview:m_viewKnowledge];
    CGSize size = m_scrollView.contentSize;
    size.height = m_viewKnowledge.frame.origin.y + m_viewKnowledge.frame.size.height;
    m_scrollView.contentSize = size;
    
    [self retrieveKnowledgePic];
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
    [m_textKnowledgeContent release];
    m_textKnowledgeContent = nil;
    [m_labelDate release];
    m_labelDate = nil;
    [m_viewKnowledge release];
    m_viewKnowledge = nil;
    [m_scrollView release];
    m_scrollView = nil;
    [super viewDidUnload];
}
@end
