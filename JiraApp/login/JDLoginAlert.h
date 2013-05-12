//
//  JDLoginAlert.h
//  JiraApp
//
//  Created by John Doran on 11/05/2013.
//  Copyright (c) 2013 John Doran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDLoginAlert : UIAlertView <UITableViewDelegate, UITableViewDataSource> {
@private
	UITableView *tableView_;
	UITextField *plainTextField_;
	UITextField *secretTextField_;
}

@property(nonatomic, retain, readonly) UITextField *plainTextField;
@property(nonatomic, retain, readonly) UITextField *secretTextField;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitles;

@end