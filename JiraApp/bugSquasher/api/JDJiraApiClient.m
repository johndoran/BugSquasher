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
    [self setDefaultHeader:@"X-Atlassian-Token" value:@"nocheck"];
    
    self.parameterEncoding = AFJSONParameterEncoding;

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

- (void)createIssueWithIssue:(JDJiraIssue*)issue andSuccess:(void (^)(id))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, id responseObject))failure
{
    NSDictionary *params = [self buildBugParamsWithIssue:issue];
    [[JDJiraApiClient sharedClient] postPath:@"issue/"
                                 parameters:params
                                    success:^(AFHTTPRequestOperation *operation, id responseObject){
                                        NSDictionary *response = (NSDictionary*)responseObject;
                                        
                                        [self uploadImage:(UIImage*)issue.image forIssue:[response objectForKey:@"key"]];
                                        [self uploadLogs:issue.logs forIssue:[response objectForKey:@"key"]];
                                        
                                        success(responseObject);
                                    }
                                    failure:failure];
}

-(void)uploadLogs:(NSMutableArray*)logs forIssue:(NSString*)issue{
    NSMutableURLRequest *request = [[JDJiraApiClient sharedClient] multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"issue/%@/attachments", issue] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *data = [[NSString stringWithFormat:@"%@", [logs description]] dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFileData:data name:@"file" fileName:@"ios-logs" mimeType:@"text/plain"];
    }];
   
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation start];
}

-(void)uploadImage:(UIImage*)image forIssue:(NSString*)issue{
    NSMutableURLRequest *request = [[JDJiraApiClient sharedClient] multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"issue/%@/attachments", issue] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:[NSData dataWithData:UIImagePNGRepresentation(image)] name:@"file" fileName:@"ios-attachment" mimeType:@"image/png"];
    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];    
    [operation start];
}


-(NSDictionary*)buildBugParamsWithIssue:(JDJiraIssue*)issue
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *description = [NSString stringWithFormat:@"Bundle Version: %@ \n%@", bundleVersion, issue.description];
    
    [params setValue:@{@"key": issue.projectKey} forKey:@"project"];
    [params setValue:issue.summary forKey:@"summary"];
    [params setValue:description forKey:@"description"];
    [params setValue:@{@"name": @"Bug"} forKey:@"issuetype"];
    
    return @{@"fields": params};
}



@end
