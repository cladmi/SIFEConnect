//
//  homeViewController.h
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "msgViewController.h"


@interface homeViewController : UIViewController {
	
	IBOutlet UIButton *loginButton;
	IBOutlet UIButton *addNewsButton;
	IBOutlet UIButton *chooseTeamButton;
	
	IBOutlet msgViewController *homeTableController;
	IBOutlet UITableView *homeTableView;
	
	IBOutlet UIActivityIndicatorView *loginWait;
	
	IBOutlet UILabel *teamName;
	IBOutlet NSString *loginString;
	
	
}

@property(nonatomic, retain) UIButton *loginButton;
@property(nonatomic, retain) UIButton *addNewsButton;
@property(nonatomic, retain) UIButton *chooseTeamButton;
@property(nonatomic, retain) UIActivityIndicatorView *loginWait;
@property(nonatomic, retain) UILabel *teamName;
@property(nonatomic, retain) NSString *loginString;
@property(nonatomic, retain) UITableView *homeTableView;


- (IBAction)homeButtonPressed:(id)sender;

- (void)logout;


- (void)log:(BOOL)connected byteam:(NSString *)name; 

@end
