//
//  loginViewController.h
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface loginViewController : UIViewController {

	IBOutlet UITextField *teamLogin;
	IBOutlet UITextField *teamPassword;
	IBOutlet UIActivityIndicatorView *loginIndicator;
	UIViewController *homeController;
	
}

@property(nonatomic, retain) UITextField *teamLogin;
@property(nonatomic, retain) UITextField *teamPassword;
@property(nonatomic, retain) UIViewController *homeController;

- (IBAction)startConnection:(id)sender;
- (IBAction)queryResult:(id)sender;



- (IBAction)textFieldDoneEditing:(id)sender;

@end
