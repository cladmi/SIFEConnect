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
#import "msgViewController.h"



@implementation homeViewController

@synthesize loginButton;
@synthesize addNewsButton;
@synthesize chooseTeamButton;

@synthesize loginWait;
@synthesize teamName;
@synthesize loginString;

@synthesize newsDictionary;



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
			
			[newsDictionary release];
			newsDictionary = nil;
			[homeTableView reloadData];

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
		self.title = @"SIFE Connect";
		[Global sharedInstance].isLogged = FALSE;
		loginString = @"<none>";
    }

	idTeam = 0;
	idCountry = 0;
	idContinent = 0;
	
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad]; 
	homeTableView.backgroundColor = [UIColor whiteColor];
}



- (void)viewWillAppear:(BOOL)animated {
	if ([Global sharedInstance].isLogged) {
		[self downloadTeamList];
	}
	
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
	[homeTableView release];
	[loginWait release];
	

    [super dealloc];
}






/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * IMPLÉMENTATION DES PROTOCOLES UITABLEVIEWDATASOURCE ET UITABLVIEWDELEGATE * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 */

- (void) downloadTeamList {
	
	NSString *query;
	NSMutableDictionary *queryDictionary;
	queryDictionary = [[NSMutableDictionary alloc] init];
	[queryDictionary setValue:[NSNumber numberWithInt:NEWS] forKey:@"action"];
	[queryDictionary setValue:[NSNumber numberWithInt:[Global sharedInstance].myId] forKey:@"id"];
	[queryDictionary setValue:[Global sharedInstance].sessionId forKey:@"sessionId"];
	[queryDictionary setValue:[NSNumber numberWithInt:idTeam] forKey:@"team"];
	[queryDictionary setValue:[NSNumber numberWithInt:idCountry] forKey:@"country"];
	[queryDictionary setValue:[NSNumber numberWithInt:idContinent] forKey:@"continent"];
	
	
	query = [queryDictionary JSONRepresentation];
	
	((versionbetaSIFEconnectAppDelegate *)[[UIApplication sharedApplication] delegate]).query = query;
	
	[(versionbetaSIFEconnectAppDelegate *)[[UIApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(contactServer:)																										withObject:self waitUntilDone:NO];
	[queryDictionary release];
	
}



- (void)queryResult:(NSString *)result 
{
	[newsDictionary release];
	newsDictionary = nil;
	newsDictionary = [result JSONValue];
	[newsDictionary retain];
	
	[homeTableView reloadData];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (newsDictionary != nil) {
		return [[newsDictionary objectForKey:@"sections"] count];
	} else {
		return 1;
	}
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (newsDictionary != nil) {
		return 1;
	} else {
		return 0;
	}
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (newsDictionary != nil) {
		return [[[[newsDictionary objectForKey:@"sections"] objectAtIndex:section] objectForKey:@"name"] stringByAppendingFormat:@" - %@",[[[newsDictionary objectForKey:@"sections"] objectAtIndex:section] objectForKey:@"country"]];
	} else {
		return @"";
	/*	
		if ([Global sharedInstance].isLogged) {
			return @"Downloading data";
		} else {
			return @"Log in to see new messages";
		}
	 */
	}
	//return [continent objectAtIndex:section];
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (newsDictionary != nil) {
		double timestamp = [[[[newsDictionary objectForKey:@"sections"] objectAtIndex:section] objectForKey:@"date"] doubleValue];
		long interval = (timestamp / 1000);
		return [[NSDate dateWithTimeIntervalSince1970:interval] description];
	} else {
		
		if ([Global sharedInstance].isLogged) {
			return @"Downloading data";
		} else {
			return @"Log in to see new messages";
		}
		//return @"";
	}
	//return [continent objectAtIndex:section];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSString *cellText = [[[[[newsDictionary objectForKey:@"sections"] objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row] objectForKey:@"text"];
	UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
	CGSize constraintSize = CGSizeMake(tableView.frame.size.width -50, MAXFLOAT);
	CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
	return labelSize.height + 25;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NewsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    }
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	cell.textLabel.text = [[[[[newsDictionary objectForKey:@"sections"] objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row] objectForKey:@"text"];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//UITableViewCell *tableCell = [homeTableView cellForRowAtIndexPath:indexPath];
	//[tableCell setSelected:NO animated:YES];
		
	msgViewController *anotherViewController = [[msgViewController alloc] initWithNibName:@"msgViewController" bundle:nil];
	anotherViewController.teamName = [[[newsDictionary objectForKey:@"rows"] objectAtIndex:indexPath.row] objectForKey:@"name"]; 
	anotherViewController.idTeam = [[[[newsDictionary objectForKey:@"rows"] objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
	
	anotherViewController.title = anotherViewController.teamName;
	[self.navigationController pushViewController:anotherViewController animated:YES];
	
	[anotherViewController release];
}














@end
