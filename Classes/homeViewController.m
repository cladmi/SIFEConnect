//
//  homeViewController.m
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "homeViewController.h"
#import "versionbetaSIFEconnectAppDelegate.h"

#import "loginViewController.h"
#import "teamSelectionViewController.h"
#import "addNewsViewController.h"


@implementation homeViewController

@synthesize loginButton;
@synthesize addNewsButton;
@synthesize chooseTeamButton;

@synthesize loginWait;
@synthesize teamName;
@synthesize loginString;

- (IBAction)homeButtonPressed:(id)sender
{
	UIButton *theButton = (UIButton *)sender;
	UIViewController *viewcontroller = nil;
	if (theButton.tag == 0) {
		//we clicked button login
		if ([Global sharedInstance].isLogged) {
			// we are logged in
			[Global sharedInstance].isLogged = FALSE;
			loginString = @"<none>";
		
			//sleep(1);
			[self viewWillAppear:TRUE];
			[loginWait stopAnimating];

		} else {
			// we are not logged in
			viewcontroller = [[loginViewController alloc] initWithNibName:@"loginView" bundle:nil];
			[(loginViewController *) viewcontroller setHomeController:self];
		}
	} else if (theButton.tag == 1) {		
		// we clicked button addNews
		viewcontroller = [[addNewsViewController alloc] initWithNibName:@"addNewsView" bundle:nil];
	} else if (theButton.tag == 2) {
		// we clicked button chooseTeam
		viewcontroller = [[teamSelectionViewController alloc] initWithNibName:@"teamSelectionView" bundle:nil];	
	} else {
		// default
		NSLog(@"Clicked button %d, not in the range", theButton.tag);
	}
	if (viewcontroller) {
		[self.navigationController pushViewController:viewcontroller animated:YES];
		[viewcontroller release];	
	}
		
}			

- (void)logout {
	[self viewWillAppear:TRUE];
	[loginWait stopAnimating];
}


- (void)log:(BOOL)connected byteam:(NSString *)name{
	[Global sharedInstance].isLogged = connected;
	if (name) {
		loginString = name;
	} else {
		loginString = @"<none>";
	}
}



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title = @"homeView";
		[Global sharedInstance].isLogged = FALSE;
		loginString = @"<none>";
    }
    return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad]; 
}
*/


- (void)viewWillAppear:(BOOL)animated {
	if ([Global sharedInstance].isLogged) {
		teamName.text = loginString;
		[loginButton setTitle:@"Logout" forState:0];  
		addNewsButton.enabled = TRUE;
		chooseTeamButton.enabled = TRUE;
	} else {
		teamName.text = loginString;
		[loginButton setTitle:@"Login" forState:0];  
		addNewsButton.enabled = FALSE;
		chooseTeamButton.enabled = FALSE;
	}
}




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[loginButton release];
	[addNewsButton release];
	[chooseTeamButton release];
	[loginWait release];
	[teamName release];
	[loginString release];
	
	
	[homeTableController release];
	
	[loginWait release];
	

    [super dealloc];
}


@end
