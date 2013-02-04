//
//  KnowledgeDetailViewController.h
//  GoldenKnowledge
//
//  Created by BobieAir on 13/1/29.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KnowledgeDetailViewController : UIViewController {
    IBOutlet UIImageView *m_imageKnowledgePicture;
    IBOutlet UIView *m_viewKnowledge;
    IBOutlet UILabel *m_labelDate;
    IBOutlet UITextView *m_textKnowledgeContent;
}

// Properties
//
@property (nonatomic, retain) NSString* strDate;
@property (nonatomic, retain) NSString* strContent;
@property (nonatomic, retain) NSString* strPicURL;

// IBOutlets
//
//@property (retain, nonatomic) IBOutlet UIView *viewKnowledge;
//@property (retain, nonatomic) IBOutlet UILabel *labelDate;
//@property (retain, nonatomic) IBOutlet UITextView *textKnowledgeContent;


// Methods
//
- (void)prepareKnowledge:(NSDictionary*)dictKnowledge;
- (void)retrieveKnowledgePic;

@end
