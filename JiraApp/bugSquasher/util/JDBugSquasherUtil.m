//
//  BugSquasherUtil.m
//  JiraApp
//
//  Created by John Doran on 11/05/2013.
//  Copyright (c) 2013 John Doran. All rights reserved.
//

#import "JDBugSquasherUtil.h"
#import "FXKeychain.h"

@implementation JDBugSquasherUtil

static NSString* const kUserName = @"username";
static NSString* const kPassword = @"password";

+(NSString*)getUsername
{
    return [[FXKeychain defaultKeychain]objectForKey:kUserName];
}

+(NSString*)getPassword
{
    return [[FXKeychain defaultKeychain]objectForKey:kPassword];
}

+(void)setUsername:(NSString*)username
{
    [[FXKeychain defaultKeychain]setObject:username forKey:kUserName];
}

+(void)setPassword:(NSString*)pw
{
    [[FXKeychain defaultKeychain]setObject:pw forKey:kPassword];
}


@end
