//
//  KnowledgeDetails.h
//  GoldenKnowledge
//
//  Created by BobieAir on 13/2/11.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KnowledgeDetails : NSManagedObject

@property (nonatomic, retain) NSNumber * post_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * excerpt;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * content;

@end
