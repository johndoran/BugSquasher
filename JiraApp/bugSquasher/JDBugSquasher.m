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

+(void)setupWithBaseApiUrl:(NSString*)url andProjectKey:(NSString*)key;
{
#ifdef DEBUG        
        [JDJiraApiClient initSharedClientWithUrl:url];
        RBVolumeButtons *buttonStealer = [[RBVolumeButtons alloc] init];
        [buttonStealer startStealingVolumeButtonEvents];

        buttonStealer.upBlock = ^{
            [self showBugReporterWithKey:key];
        };
        buttonStealer.downBlock = ^{
            [self showBugReporterWithKey:key];
        };
#endif
}

+(void)showBugReporterWithKey:(NSString*)key
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

-(void)viewClosed
{
    _showingReporter = NO;
}

@end
