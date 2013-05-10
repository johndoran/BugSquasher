//
//  JDAppDelegate.h
//  JiraApp
//
//  Created by John Doran on 10/05/2013.
//  Copyright (c) 2013 John Doran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDViewController;

@interface JDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JDViewController *viewController;

@end
