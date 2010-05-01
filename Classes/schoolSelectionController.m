//
//  schoolSelectionController.m
//  SIFEConnect
//
//  Created by Ta Soeur on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "schoolSelectionController.h"
#import "sqlite3.h"
#import "versionbetaSIFEconnectAppDelegate.h"


@implementation schoolSelectionController

@synthesize countryName;
@synthesize idCountry;
@synthesize teamDictionary;



- (void) downloadTeamList {
	
	NSString *query;
	NSMutableDictionary *queryDictionary;
	queryDictionary = [[NSMutableDictionary alloc] init];
	[queryDictionary setValue:@"listTeams" forKey:@"action"];
	[queryDictionary setValue:[NSNumber numberWithInt:[Global sharedInstance].myId] forKey:@"id"];
	[queryDictionary setValue:[Global sharedInstance].sessionId forKey:@"sessionId"];
	[queryDictionary setValue:[NSNumber numberWithInt:idCountry] forKey:@"country"];
	
	
	query = [queryDictionary JSONRepresentation];
	
	((versionbetaSIFEconnectAppDelegate *)[[UIApplication sharedApplication] delegate]).query = @"listTeams";
	
	[NSThread detachNewThreadSelector:@selector(contactServer:) 
							 toTarget:(versionbetaSIFEconnectAppDelegate *)[[UIApplication sharedApplication] delegate] 
						   withObject:self];
	[queryDictionary release];
	
}



- (void)queryResult:(NSString *)result 
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"caller == nill" message:@"Problem while passing the sender" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	teamDictionary = [result JSONValue];
	[teamDictionary retain];
	
	[self.tableView reloadData];
}


/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	[self downloadTeamList];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
 */

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (teamDictionary != nil) {
		return [[teamDictionary objectForKey:@"section"] count];

	} else {
		return 0;
	}
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (teamDictionary != nil) {
		return 0;
	} else {
		return 0;
	}
 
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
	cell.textLabel.text = countryName;
    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[countryName release];
	[teamDictionary release];
    [super dealloc];
}


@end

