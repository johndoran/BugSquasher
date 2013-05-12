//
//  JDBugSquasher.m
//  JiraApp
//
//  Created by John Doran on 11/05/2013.
//  Copyright (c) 2013 John Doran. All rights reserved.
//

#import "JDBugSquasher.h"
#import "JDJiraApiClient.h"

@implementation JDBugSquasher

static JDBugSquasher *_sharedClient = nil;

+(JDBugSquasher*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JDBugSquasher alloc]init];
    });
    return _sharedClient;
}


-(void)setupWithBaseApiUrl:(NSString*)url andProjectKey:(NSString*)key
{
#ifdef DEBUG        
    if(self){
        [JDJiraApiClient initSharedClientWithUrl:url];
        _buttonStealer = [[RBVolumeButtons alloc] init];
        [_buttonStealer startStealingVolumeButtonEvents];

        __block JDBugSquasher *squasher = self;
        _buttonStealer.upBlock = ^{
            [squasher showBugReporterWithKey:key];
        };
        _buttonStealer.downBlock = ^{
            [squasher showBugReporterWithKey:key];
        };
    }
#endif
}

-(void)showBugReporterWithKey:(NSString*)key
{
    JDBugReporterViewController *reporter = [[JDBugReporterViewController
                                              alloc]initWithNibName:@"JDBugReporterViewController" bundle:nil];
    reporter.projCodeLabel.text = key;
    [reporter setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal]
    ;
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];

    BOOL isShowingReporter = [window.rootViewController.presentingViewController isMemberOfClass:NSClassFromString(@"JDBugReporterViewController")];
    
    if (!isShowingReporter){
        [window.rootViewController presentViewController:reporter animated:YES completion:^{
        }];
    }
}

@end
