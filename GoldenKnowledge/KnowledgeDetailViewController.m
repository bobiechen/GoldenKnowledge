//
//  KnowledgeDetailViewController.m
//  GoldenKnowledge
//
//  Created by BobieAir on 13/1/29.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import "KnowledgeDetailViewController.h"

static NSString* KNOWLEDGE_PIC_URL = @"http://blogberbagibersama.files.wordpress.com/2011/04/fucking-austria-roadsign1.jpg";
static int KNOWLEDGE_DETAILVIEW_TOPMARGIN = 65;
static int KNOWLEDGE_DETAILVIEW_WIDTH = 320;
static int KNOWLEDGE_DETAILVIEW_SHADOW_HEIGHT = 8;

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
    
    m_scrollView.delegate = self;
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
        self.strContent = [dictKnowledge objectForKey:@"content"];
    }
}

- (void)loadKnowledge
{
    if (!m_labelDate)
        m_labelDate = [[UILabel alloc] initWithFrame:CGRectMake(160, 25, 170, 22)];
    
    if (!m_textKnowledgeContent)
        m_textKnowledgeContent = [[UITextView alloc] initWithFrame:CGRectMake(20, 45, 240, 75)];
    
    m_labelDate.text = [self.strDate substringWithRange:NSMakeRange(0, 10)];
    m_textKnowledgeContent.text = [self htmlFlatten:self.strContent];
    m_textKnowledgeContent.textColor = [UIColor blackColor];
    CGRect frame = m_textKnowledgeContent.frame;
    frame.size.height = m_textKnowledgeContent.contentSize.height;
    frame.origin.y = 45;
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
    size.height = m_viewKnowledge.frame.origin.y + m_viewKnowledge.frame.size.height + 10;
    m_scrollView.contentSize = size;
    
    [self retrieveKnowledgePic];
}

- (NSString*)htmlFlatten:(NSString*)html
{
    NSScanner* scanner;
    NSString* tag = nil;
    scanner = [NSScanner scannerWithString:html];
    
    m_strKnowledgePicURL = @"";
    
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&tag];
        
        if ([tag isEqualToString:@"<knowledge_pic"])
        {
            [scanner scanUpToString:@"h" intoString:nil];  // "h" for "http" of the pic URL
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", tag] withString:@""];
            [scanner scanUpToString:@"</" intoString:&m_strKnowledgePicURL];
            html = [html stringByReplacingOccurrencesOfString:m_strKnowledgePicURL withString:@""];
            [scanner scanUpToString:@">" intoString:&tag];
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", tag] withString:@""];
        }
        else if ([tag isEqualToString:@"</p"])
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", tag] withString:@"\n"];
        else if ([tag isEqualToString:@"<br /"])
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", tag] withString:@"\n"];
        else
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", tag] withString:@""];
    }
    
    return html;
}

- (void)rearrangeKnowledgeViewAfterPicLoaded
{
    //int nKnowledgePageTopMargin = 45;
    
    CGRect frame = m_imageKnowledgePicture.frame;
    frame.origin.y = 0;
    
    float fWidth = KNOWLEDGE_DETAILVIEW_WIDTH;
    float fHeight = KNOWLEDGE_DETAILVIEW_WIDTH * m_imageKnowledgePicture.image.size.height / m_imageKnowledgePicture.image.size.width;
    frame.size = CGSizeMake(fWidth, fHeight);
    
    m_imageKnowledgePicture.frame = frame;
    [m_scrollView addSubview:m_imageKnowledgePicture];
    
    UIImageView* imageShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                             m_imageKnowledgePicture.frame.size
                                                                            .height,
                                                                             KNOWLEDGE_DETAILVIEW_WIDTH,
                                                                             KNOWLEDGE_DETAILVIEW_SHADOW_HEIGHT)];
    
    UIImage* imgShadow = [UIImage imageNamed:@"detail_shadow.png"];
    imageShadow.image = imgShadow;
    [imgShadow release];
    [m_scrollView addSubview:imageShadow];
    
    CGRect frame2 = m_textKnowledgeContent.frame;
    frame2.origin.y =  KNOWLEDGE_DETAILVIEW_TOPMARGIN;
    m_textKnowledgeContent.frame = frame2;
    
    CGRect frame3 = m_viewKnowledge.frame;
    frame3.origin.y = m_imageKnowledgePicture.frame.size.height;
    frame3.size.height = KNOWLEDGE_DETAILVIEW_TOPMARGIN + m_textKnowledgeContent.frame.size.height;
    m_viewKnowledge.frame = frame3;
//    UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_background.png"]];
//    [m_viewKnowledge addSubview:viewBackground];
//    [m_viewKnowledge sendSubviewToBack:viewBackground];
//    [viewBackground release];
    
    CGSize size = m_scrollView.contentSize;
    size.height = m_imageKnowledgePicture.frame.size.height + m_viewKnowledge.frame.size.height;
    m_scrollView.contentSize = size;
}

- (void)retrieveKnowledgePic
{
    // If editor does not provide pic-url for the knowledge, just return
    if ([m_strKnowledgePicURL isEqualToString:@""])
        return;
    
    if (!m_imageKnowledgePicture)
        m_imageKnowledgePicture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [m_viewKnowledge addSubview:m_imageKnowledgePicture];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:m_strKnowledgePicURL]];
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
                
                // Rearrange text-view position, container-view frame and scroll-view frame
                //
                // Important!! access UI elements like assigning size or frame, should be done in main thread
                // Else app will crash
                //
                [self performSelectorOnMainThread:@selector(rearrangeKnowledgeViewAfterPicLoaded) withObject:nil waitUntilDone:NO];
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

#pragma mark - UIScrollView delegate

/*
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //(KNOWLEDGE_DETAILVIEW_TOPMARGIN + m_imageKnowledgePicture.frame.size.height)
    if (targetContentOffset->y > m_nLastScrollOffset)
    {
        // Try to scroll down
        NSLog(@"scrolling down");
        
        if (m_nLastScrollOffset == (KNOWLEDGE_DETAILVIEW_TOPMARGIN + m_imageKnowledgePicture.frame.size.height))
        {
            // Let it scroll
            NSLog(@"Let it scroll");
        }
        else
        {
            targetContentOffset->y = KNOWLEDGE_DETAILVIEW_TOPMARGIN + m_imageKnowledgePicture.frame.size.height;
        }
    }
    else
    {
        // Try to scroll up
        NSLog(@"scrolling up");
        targetContentOffset->y = 0;
    }
    
    //m_nLastScrollOffset = scrollView.contentOffset.y;
    m_nLastScrollOffset = targetContentOffset->y;
    NSLog(@"end dragging, velocity: %f", velocity.y);
}
//*/
@end
