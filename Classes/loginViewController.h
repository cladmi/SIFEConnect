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
	UIViewController *homeController;
}

@property(nonatomic, retain) UITextField *teamLogin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil homeview:(UIViewController *)homeControl;
- (IBAction)connect:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;

@end
