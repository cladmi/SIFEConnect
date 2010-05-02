//
//  msgViewController.m
//  SIFEConnect
//
//  Created by Ta Soeur on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "msgViewController.h"
#import "versionbetaSIFEconnectAppDelegate.h"



@implementation msgViewController

@synthesize newsDictionary;
@synthesize idTeam;
@synthesize idCountry;
@synthesize idContinent;
@synthesize teamName;

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
	
	newsDictionary = [result JSONValue];
	[newsDictionary retain];
	
	[self.tableView reloadData];
}


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
	idTeam = 0;
	idCountry = 0;
	idContinent = 0;
    return self;
}


/*
- (void)viewDidLoad {
    [super viewDidLoad];

	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if ([Global sharedInstance].isLogged) {
		[self downloadTeamList];
	}
}


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
		return [[[newsDictionary objectForKey:@"sections"] objectAtIndex:section] objectForKey:@"name"];
	} else {
		return @"Downloading data";
	}
	//return [continent objectAtIndex:section];
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (newsDictionary != nil) {
		return [[[newsDictionary objectForKey:@"sections"] objectAtIndex:section] objectForKey:@"name"];
	} else {
		return @"";
	}
	//return [continent objectAtIndex:section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
	cell.textLabel.text = [[[[[newsDictionary objectForKey:@"sections"] objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row] objectForKey:@"text"];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:indexPath];
	[tableCell setSelected:NO animated:YES];
	//UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:indexPath];	
	//[tableCell setSelected:NO animated:YES];
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
	[newsDictionary release];
    [super dealloc];
}


@end

