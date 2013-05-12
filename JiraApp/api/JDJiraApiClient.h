//
//  JDJiraApiClient.h
//  JiraApp
//
//  Created by John Doran on 11/05/2013.
//  Copyright (c) 2013 John Doran. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"

@interface JDJiraApiClient : AFHTTPClient

@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) NSString *avatarUrl;

+(void)initSharedClientWithUrl:(NSString*)url;
+ (JDJiraApiClient *)sharedClient;

- (void)currentUserWithSuccess:(void (^)(NSDictionary*))success
                       failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (void)getAssignedIssuesWithSuccess:(void (^)(NSArray*))success
                             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

@end
