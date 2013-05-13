//
//  JDViewController.m
//  JiraApp
//
//  Created by John Doran on 10/05/2013.
//  Copyright (c) 2013 John Doran. All rights reserved.
//

#import "JDViewController.h"
#import "JDBugReporterViewController.h"

@interface JDViewController ()

@end

@implementation JDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTapped:(id)sender {    
    JDBugReporterViewController *reporter = [[JDBugReporterViewController
                                              alloc]initWithNibName:@"JDBugReporterViewController" bundle:nil];
    reporter.projectCode = @"TEST";
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
