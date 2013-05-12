
//
//  JDBugReporterViewController.h
//  JiraApp
//
//  Created by John Doran on 11/05/2013.
//  Copyright (c) 2013 John Doran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDBugReporterViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate>
{
    UIImage *_chosenImage;
}

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UITextView *descriptionArea;
@property (weak, nonatomic) IBOutlet UILabel *imageAttachedLabel;
@property (weak, nonatomic) IBOutlet UILabel *projCodeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIcon;

- (IBAction)closedTaped:(id)sender;
- (IBAction)attachImage:(id)sender;
- (IBAction)sendBugToJira:(id)sender;

@end


