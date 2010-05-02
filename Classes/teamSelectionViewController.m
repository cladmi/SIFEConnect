//
//  teamSelectionViewController.m
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "homeViewController.h"
#import "teamSelectionViewController.h"
#import "versionbetaSIFEconnectAppDelegate.h"
#import "schoolSelectionController.h"
#import "sqlite3.h"

/*static int MyCallback(void *context, int count, char **values, char **colums)
{
	NSMutableArray *result = (NSMutableArray *)context;
	for (int i = 0; i < count; i++) {
		const char *nameCString = values[i];
		[result addObject:[NSString stringWithUTF8String:nameCString]];
	}
	return SQLITE_OK;
}

*/
@implementation teamSelectionViewController
/*

- (void) loadNamesFromDatabase
{
	NSString *query;
	NSMutableArray *section;
	
	NSString *file = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"db"];
	sqlite3 *database = NULL;

	if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
		if (sqlite3_exec(database, "select name from continent", MyCallback, continent, NULL) != SQLITE_OK) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error while executing query" delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
		
		/////////////////// For test 
		[continent addObject:@"ZuperContinent"];
	    /////////////////////////////////
		
		
		for (int i = 1; i <= [continent count]; i++) {
			// section is the the array of country for the section i
			section = [[NSMutableArray alloc] init];
			query = [NSString stringWithFormat:@"select name from country where idC = %d", i];
			sqlite3_exec(database,[query UTF8String], MyCallback, section, NULL);
			if ([section count] == 0) {
				[section addObject:@"No teams for the moment"];
			}
			[country addObject:section];
		}
 
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error opening file" delegate:self cancelButtonTitle:@"OK"  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}

	sqlite3_close(database);
}		*/	


- (void) downloadCountryList {
	
	NSString *query;
	NSMutableDictionary *queryDictionary;
	queryDictionary = [[NSMutableDictionary alloc] init];
	[queryDictionary setValue:[NSNumber numberWithInt:LIST_COUNTRIES] forKey:@"action"];
	[queryDictionary setValue:[NSNumber numberWithInt:[Global sharedInstance].myId] forKey:@"id"];
	[queryDictionary setValue:[Global sharedInstance].sessionId forKey:@"sessionId"];
	
	query = [queryDictionary JSONRepresentation];
	
	((versionbetaSIFEconnectAppDelegate *)[[UIApplication sharedApplication] delegate]).query = query;
	
	[(versionbetaSIFEconnectAppDelegate *)[[UIApplication 	sharedApplication] delegate] performSelectorOnMainThread:@selector(contactServer:) withObject:self waitUntilDone:NO];
	[queryDictionary release];
	
}



- (void)queryResult:(NSString *)result 
{
	tableDictionary = [result JSONValue];
	[tableDictionary retain];
	
	[self.tableView reloadData];
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
	if (self = [super initWithStyle:style]) {
		country = [[NSMutableArray alloc] init];
		continent = [[NSMutableArray alloc] init];
		[self loadNamesFromDatabase];
    }
    return self;
}
 */




- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Team Selection";

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



 - (void)viewWillAppear:(BOOL)animated {
	 [super viewWillAppear:animated];
	 if ([Global sharedInstance].isLogged) {
		 	[self downloadCountryList];
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
	if (tableDictionary != nil) {
		return [[tableDictionary objectForKey:@"section"] count];
	} else {
		return 1;
	}
	//return [continent count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (tableDictionary != nil) {
		return [[[tableDictionary objectForKey:@"section"] objectAtIndex:section] objectForKey:@"name"];
	} else {
		return @"Downloading data";
	}
	//return [continent objectAtIndex:section];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (tableDictionary != nil) {
		return [[[[tableDictionary objectForKey:@"section"] objectAtIndex:section] objectForKey:@"rows"] count];
	} else {
		return 0;
	}
	//return [[country objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
    // Set up the cell...
	NSDictionary *countryCell = [[[[tableDictionary objectForKey:@"section"] objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row];
	cell.textLabel.text = [countryCell objectForKey:@"name"];
	//cell.textLabel.text = [[country objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//	if ([cell.textLabel.text isEqualToString:@"No teams for the moment"]) {
	if ([[countryCell objectForKey:@"id"] intValue] == 0) {
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.enabled = NO;
	} else {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.enabled = YES;
	}	
    return cell;
}
	


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
	UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:indexPath];
	if (tableCell.accessoryType == UITableViewCellAccessoryNone) {  
		// It's a row with nothing after, we just deselect it
		[tableCell setSelected:NO animated:YES];
	} else {
		// Navigation logic may go here. Create and push another view controller.
		schoolSelectionController *anotherViewController = [[schoolSelectionController alloc] initWithNibName:@"schoolSelection" bundle:nil];
		anotherViewController.countryName = tableCell.textLabel.text; 
		anotherViewController.idCountry = [[[[[[tableDictionary objectForKey:@"section"] objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];

		anotherViewController.title = tableCell.textLabel.text;
		[self.navigationController pushViewController:anotherViewController animated:YES];
	
		[anotherViewController release];
	}

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
	[country release];
	[continent release];
    [super dealloc];
}


@end

