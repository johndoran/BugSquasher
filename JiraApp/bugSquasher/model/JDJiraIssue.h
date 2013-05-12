//
//  JDJiraIssue.h
//  JiraApp
//
//  Created by John Doran on 12/05/2013.
//  Copyright (c) 2013 John Doran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDJiraIssue : NSObject

@property(nonatomic, weak)UIImage *image;
@property(nonatomic, weak)NSString *summary, *description, *projectKey;
@property(nonatomic, weak)NSMutableArray *logs;

@end
