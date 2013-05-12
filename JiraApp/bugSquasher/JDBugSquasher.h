//
//  JDBugSquasher.h
//  JiraApp
//
//  Created by John Doran on 11/05/2013.
//  Copyright (c) 2013 John Doran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBVolumeButtons.h"
#import "JDBugReporterViewController.h"

@interface JDBugSquasher : NSObject
{
    RBVolumeButtons *_buttonStealer;
    BOOL _showingReporter;
}

+(JDBugSquasher*)sharedInstance;

-(void)setupWithBaseApiUrl:(NSString*)url andProjectKey:(NSString*)key;

@end
