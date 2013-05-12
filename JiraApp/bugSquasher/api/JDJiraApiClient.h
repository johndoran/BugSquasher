//
//  JDJiraApiClient.h
//  JiraApp
//
//  Created by John Doran on 11/05/2013.
//  Copyright (c) 2013 John Doran. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"
#import "JDJiraIssue.h"

@interface JDJiraApiClient : AFHTTPClient

@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) NSString *avatarUrl;

+(void)initSharedClientWithUrl:(NSString*)url;
+ (JDJiraApiClient *)sharedClient;

- (void)currentUserWithSuccess:(void (^)(NSDictionary*))success
                       failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (void)createIssueWithIssue:(JDJiraIssue*)issue andSuccess:(void (^)(id JSON))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, id responseObject))failure;

@end
