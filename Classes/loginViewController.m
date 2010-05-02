//
//  loginViewController.m
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "loginViewController.h"
#import "homeViewController.h"
#import "versionbetaSIFEconnectAppDelegate.h"
#import "Global.h"
#import "JSON.h"



@implementation loginViewController

@synthesize teamLogin;
@synthesize teamPassword;
@synthesize homeController;
@synthesize loginButton;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title = @"Login";
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/



- (IBAction)startConnection:(id)sender
{

	
	if ([teamLogin.text isEqualToString:@""] || [teamPassword.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty fields" message:@"Please enter your login and password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		loginButton.enabled = NO;
		loginButton.titleLabel.enabled = NO;
		NSString *query;
		NSMutableDictionary *queryDictionary;
		queryDictionary = [[NSMutableDictionary alloc] init];
		
		[queryDictionary setValue:[NSNumber numberWithInt:LOGIN] forKey:@"action"];
		[queryDictionary setValue:[teamLogin.text lowercaseString] forKey:@"login"];
		[queryDictionary setValue:teamPassword.text forKey:@"passwd"];
		
		query = [queryDictionary JSONRepresentation];
		
		((versionbetaSIFEconnectAppDelegate *)[[UIApplication sharedApplication] delegate]).query = query;
		[loginIndicator startAnimating];
		[(versionbetaSIFEconnectAppDelegate *)[[UIApplication 	sharedApplication] delegate] performSelectorOnMainThread:@selector(contactServer:) withObject:self waitUntilDone:NO];
		[queryDictionary release]; 
	}	
}

- (void)queryResult:(NSString *)result 
{
	
	//NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *results = [result JSONValue];
	
	NSString *status = [results objectForKey:@"STATUS"];
	if (status != nil && [status isEqualToString:@"CONNECTION_ACCEPTED"]) {
		
		[[Global sharedInstance] setMyId:[[results objectForKey:@"id"] intValue]];
		[[Global sharedInstance] setSessionId:[results objectForKey:@"sessionId"]];
		[[Global sharedInstance] setTeamName:[results objectForKey:@"name"]];

		
		[loginIndicator stopAnimating];
		[(homeViewController *) homeController log:TRUE byteam:[[Global sharedInstance] teamName]];
		[self.navigationController popToRootViewControllerAnimated:YES];
		
	} else {
		loginButton.enabled = YES;
		loginButton.titleLabel.enabled = YES;
		[loginIndicator stopAnimating];
		NSLog(@"Connection échouée");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"The login or password you entered is incorrect." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}	
		
	
}



- (IBAction)textFieldDoneEditing:(id)sender
{   
	
	[sender resignFirstResponder];
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
    [super dealloc];
	[teamLogin release];
	[teamPassword release];
	[loginIndicator release];
}


@end
