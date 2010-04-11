//
//  homeViewController.h
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface homeViewController : UIViewController {
	
	IBOutlet UIButton *loginButton;
	IBOutlet UIButton *addNewsButton;
	IBOutlet UIButton *chooseTeamButton;
	
	IBOutlet UIActivityIndicatorView *loginWait;
	
	IBOutlet UILabel *teamName;
	IBOutlet NSString *loginString;
	IBOutlet BOOL isLogged;
	
}

@property(nonatomic, retain) UIButton *loginButton;
@property(nonatomic, retain) UIButton *addNewsButton;
@property(nonatomic, retain) UIButton *chooseTeamButton;
@property(nonatomic, retain) UIActivityIndicatorView *loginWait;
@property(nonatomic) BOOL isLogged;
@property(nonatomic, retain) UILabel *teamName;
@property(nonatomic, retain) NSString *loginString;


- (IBAction)homeButtonPressed:(id)sender;

- (void)logout;


- (void)log:(BOOL)connected byteam:(NSString *)name; 

@end
