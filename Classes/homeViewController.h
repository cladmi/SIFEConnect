//
//  homeViewController.h
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "msgViewController.h"


@interface homeViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate> {
	
	IBOutlet UIButton *loginButton;
	IBOutlet UIButton *addNewsButton;
	IBOutlet UIButton *chooseTeamButton;

	IBOutlet UIActivityIndicatorView *loginWait;
	IBOutlet UILabel *teamName;
	IBOutlet NSString *loginString;
	
	
	/* tableView variables */
	int idTeam;
	int idCountry;
	int idContinent;
	NSDictionary *newsDictionary;
	IBOutlet UITableView *homeTableView;
	
	
	
}

@property(nonatomic, retain) UIButton *loginButton;
@property(nonatomic, retain) UIButton *addNewsButton;
@property(nonatomic, retain) UIButton *chooseTeamButton;
@property(nonatomic, retain) UIActivityIndicatorView *loginWait;
@property(nonatomic, retain) UILabel *teamName;
@property(nonatomic, retain) NSString *loginString;

@property(nonatomic, retain) NSDictionary *newsDictionary;


- (IBAction)homeButtonPressed:(id)sender;

- (void)logout;

- (void) downloadTeamList;

- (void)log:(BOOL)connected byteam:(NSString *)name; 

@end
