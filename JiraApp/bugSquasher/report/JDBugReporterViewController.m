//
//  JDBugReporterViewController.m
//  JiraApp
//
//  Created by John Doran on 11/05/2013.
//  Copyright (c) 2013 John Doran. All rights reserved.
//

#import "JDBugReporterViewController.h"
#import "JDLoginAlert.h"
#import "JDBugSquasherUtil.h"
#import "MBProgressHud.h"
#import "asl.h"
#import "JDJiraApiClient.h"
#import "AFHTTPRequestOperation.h"
#import <QuartzCore/QuartzCore.h>

@implementation JDBugReporterViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.loadingIcon startAnimating];
    self.descriptionArea.layer.borderWidth = 1;
    self.descriptionArea.layer.borderColor = [[UIColor grayColor] CGColor];
    self.descriptionArea.layer.cornerRadius = 8;
    self.projCodeLabel.text = self.projectCode;
    if([JDBugSquasherUtil getUsername] == nil || [[JDBugSquasherUtil getUsername]isEqualToString:@""]||[[JDBugSquasherUtil getPassword]isEqualToString:@""]){
        [self showLogin];
    }else{
        [self refreshUserView];
    }
    [self collectLogs];
}

#pragma mark - user login handling
-(void)refreshUserView
{
    if([JDBugSquasherUtil getUsername] == nil){
        [self showLogin];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[JDJiraApiClient sharedClient]currentUserWithSuccess:^(NSDictionary *user) {
        //NSLog([user description]);

        NSString *avatatUrl = [[user objectForKey:@"avatarUrls"]objectForKey:@"48x48"];
        self.usernameLabel.text = [user objectForKey:@"displayName"];
        
        NSURL *imageURL = [NSURL URLWithString:avatatUrl];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loadingIcon stopAnimating];
                self.loadingIcon.hidden = YES;
                self.avatarImage.image = [UIImage imageWithData:imageData];
            });
        });
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(AFHTTPRequestOperation *op, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showLogin];
    }];
}
-(void)showLogin
{
    JDLoginAlert *loginPrompt = [[JDLoginAlert alloc] initWithTitle:@"Sign in to Jira" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Sign In"];
    [loginPrompt show];
}


- (void)didPresentAlertView:(UIAlertView *)alertView {
    if ([alertView isKindOfClass:[JDLoginAlert class]]) {
        JDLoginAlert *loginPrompt = (JDLoginAlert *)alertView;
        [loginPrompt.plainTextField becomeFirstResponder];
        [loginPrompt setNeedsLayout];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]&&[alertView isKindOfClass:[JDLoginAlert class]]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"You must be logged into jira to report an issue" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        if ([alertView isKindOfClass:[JDLoginAlert class]]) {
            JDLoginAlert *loginPrompt = (JDLoginAlert *)alertView;
            [JDBugSquasherUtil setPassword:loginPrompt.secretTextField.text];
            [JDBugSquasherUtil setUsername:loginPrompt.plainTextField.text];
            
            if([loginPrompt.plainTextField.text isEqualToString:@""]||
               [loginPrompt.secretTextField.text isEqualToString:@""]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"You must fill in all details to report an issue" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                [self refreshUserView];
            }
        }
    }
}

#pragma mark - text area delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    [txtView resignFirstResponder];
    return NO;
}

#pragma mark - orientation
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - close reporter
- (IBAction)closedTaped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - photo picket reporter
- (IBAction)attachImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)sendBugToJira:(id)sender {
    
    
    if([self.summaryTextField.text isEqualToString:@""]||[self.descriptionArea.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"You should fill out enough details for the bug to be meaningful!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        JDJiraIssue *issue = [[JDJiraIssue alloc]init];
        issue.summary = self.summaryTextField.text;
        issue.description = self.descriptionArea.text;
        issue.image = _chosenImage;
        issue.projectKey = self.projectCode;
        issue.logs = _logEntries;
            
        [[JDJiraApiClient sharedClient]createIssueWithIssue:issue andSuccess:^(id JSON) {

            NSDictionary *response = (NSDictionary*)JSON;
            [self dismissViewControllerAnimated:YES completion:nil];
           /* UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Bug Logged" message:[NSString stringWithFormat:@"Your bug has been logged successfully, the issue number is %@", [response objectForKey:@"key"]] delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
            [alert show];*/
        } failure:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"An error occurred loggin your bug." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
    
}

-(void)collectLogs{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        aslmsg q, m;
        int i;
        const char *key, *val;
        
        q = asl_new(ASL_TYPE_QUERY);
      //  asl_set_query(q, ASL_KEY_SENDER, "Logger", ASL_QUERY_OP_EQUAL);
        
        aslresponse r = asl_search(NULL, q);
        NSMutableArray *allLogEntries = [NSMutableArray new];
        
        while (NULL != (m = aslresponse_next(r))){
            NSMutableDictionary *logEntry = [NSMutableDictionary dictionary];
            
            for (i = 0; (NULL != (key = asl_key(m, i))); i++){
                NSString *keyString = [NSString stringWithUTF8String:(char *)key];
                
                val = asl_get(m, key);
                
                NSString *string = [NSString stringWithUTF8String:val];
                [logEntry setObject:string forKey:keyString];
            }
            [allLogEntries addObject:logEntry];
        }
        
        aslresponse_free(r);
        NSLog(@"%i", allLogEntries.count);
        _logEntries = allLogEntries;
    });
    
}


- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    _chosenImage = image;
    self.imageAttachedLabel.text = @"Image attached";
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
