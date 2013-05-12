//
//  JDJiraApiClient.m
//  JiraApp
//
//  Created by John Doran on 11/05/2013.
//  Copyright (c) 2013 John Doran. All rights reserved.
//

#import "JDJiraApiClient.h"
#import "AFJSONRequestOperation.h"
#import "FXKeychain.h"
#import "JDBugSquasherUtil.h"

@implementation JDJiraApiClient
static JDJiraApiClient *_sharedClient = nil;

+(void)initSharedClientWithUrl:(NSString*)url {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JDJiraApiClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    });
}

+ (JDJiraApiClient *)sharedClient {
    assert(_sharedClient!=nil);
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
        
    if ([JDBugSquasherUtil getUsername] != nil){
        [self setAuthorizationHeaderWithUsername:[JDBugSquasherUtil getUsername]
                                        password:[JDBugSquasherUtil getPassword]];
    }    
    
    return self;
}

- (void)currentUserWithSuccess:(void (^)(NSDictionary*))success
                       failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [[JDJiraApiClient sharedClient] getPath:@"user"
                                 parameters:@{@"username": [JDBugSquasherUtil getUsername], @"expand": @"groups"}
                                    success:^(AFHTTPRequestOperation *operation, id responseObject){ success(responseObject); }
                                    failure:failure];
}

- (void)getAssignedIssuesWithSuccess:(void (^)(NSArray*))success
                             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *query = [NSString stringWithFormat:@"assignee=%@ and resolution=Unresolved", [JDBugSquasherUtil getUsername]];
    [self searchIssuesWithQuery:query success:success failure:failure];
}

- (void)searchIssuesWithQuery:(NSString*)query  success:(void (^)(NSArray*))success
                      failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    
    void (^searchFailure)(AFHTTPRequestOperation*, NSError*) = ^(AFHTTPRequestOperation *operation, NSError *error)
    {
        failure(operation, error);
    };
    
    void (^searchSuccess)(AFHTTPRequestOperation*, id) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        __block NSMutableArray *issues = [NSMutableArray array];
        
        [[responseObject objectForKey:@"issues"]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [issues addObject:obj];
            NSLog(obj[@"key"]);
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(){           
            NSLog(@"issues: %@", issues);
            success([NSArray arrayWithArray:issues]);
        });
    };
    
    [[JDJiraApiClient sharedClient] getPath:@"search"
                                 parameters:@{@"jql": query, @"startAt": @0, @"maxResults": @1000}
                                    success:searchSuccess
                                    failure:searchFailure];
}


@end
