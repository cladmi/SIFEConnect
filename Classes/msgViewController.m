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

- (void) downloadTeamList 
{
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
	[(versionbetaSIFEconnectAppDelegate *)[[UIApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(contactServer:)
													    withObject:self waitUntilDone:NO];
	[queryDictionary release];
}



- (void)queryResult:(NSString *)result 
{
	NSDictionary result = [result JSONValue];
	if ( la clé STATUS existe et le resultat est MSG_DELETED) {
		supprimer row at indexpath
			on va envoyer l'indexPath ! juste le row hein
	} else {
		non edit -> edit row, + alert view
	}
	newsDictionary = [result JSONValue];
	[newsDictionary retain];
	if 
	
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
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


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


/////////////////////////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////////////////////////

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (newsDictionary != nil) {
		return [[[[newsDictionary objectForKey:@"sections"] objectAtIndex:section] objectForKey:@"name"] stringByAppendingFormat:@" - %@",[[[newsDictionary objectForKey:@"sections"] objectAtIndex:section] objectForKey:@"country"]];
	} else {
		return @"Downloading data";
	}
	//return [continent objectAtIndex:section];
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (newsDictionary != nil) {
		//+ (id)dateWithTimeIntervalSince1970:(NSTimeInterval)seconds
		double timestamp = [[[[newsDictionary objectForKey:@"sections"] objectAtIndex:section] objectForKey:@"date"] doubleValue];
		long interval = (timestamp / 1000);
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, yyyy - HH:mm"];
		NSString *date = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
		
		[format release];
		return date;
	} else {
		return @"";
	}
	//return [continent objectAtIndex:section];
}


/////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellText = [[[[[newsDictionary objectForKey:@"sections"] objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row] objectForKey:@"text"];
	UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
	CGSize constraintSize = CGSizeMake(tableView.frame.size.width -40, MAXFLOAT);
	CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
	return labelSize.height + 25;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
	UITableViewCell *cell;
	
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
	}
	
	cell.textLabel.text = [[[[[newsDictionary objectForKey:@"sections"] objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row] objectForKey:@"text"];
	
	return cell;
}

////////////////////////////////////////////////////////////////////////////////////


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:indexPath];
	[tableCell setSelected:NO animated:YES];
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editabl.
    return YES;
}
*/
- (void) askDeleteEntryAtIndexPath:(NSIndexPath *)indexPath {
	NSString *query;
	NSMutableDictionary *queryDictionary;
	queryDictionary = [[NSMutableDictionary alloc] init];
	
	[queryDictionary setValue:[NSNumber numberWithInt:DEL] forKey:@"action"];
	[queryDictionary setValue:[NSNumber numberWithInt:[Global sharedInstance].myId] forKey:@"id"];
	[queryDictionary setValue:[Global sharedInstance].sessionId forKey:@"sessionId"];

	[queryDictionary setValue:[NSNumber numberWithInt:indexPath.row] forKey:@"path"];
	[queryDictionary setValue:[NSNumber numberWithInt:[[[[[newsDictionary objectForKey:@"sections"] objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row] objectForKey:@"id"] forKey:@"idMsg"];
	
	query = [queryDictionary JSONRepresentation];
	((versionbetaSIFEconnectAppDelegate *)[[UIApplication sharedApplication] delegate]).query = query;
	[(versionbetaSIFEconnectAppDelegate *)[[UIApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(contactServer:)
													    withObject:self waitUntilDone:NO];
	[queryDictionary release];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        // Delete the row from the data source
        [tableView askDeleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		if ([self deleteEntryAtIndexPath:indexPath]) {
			if (indexPath.section == 0) {
				[newlyAddedList removeObjectAtIndex:indexPath.row];
			} else {
				[selectionList removeObjectAtIndex:indexPath.row];
			}
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		} else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suppression impossible" message:@"L'évènement séléctionné est encore associé à des dettes" delegate:self cancelButtonTitle:@"OK"  otherButtonTitles: nil];
				[alert show];
				[alert release];
			
			[[tableView cellForRowAtIndexPath:indexPath] setEditing:NO animated:NO];
			[[tableView cellForRowAtIndexPath:indexPath] setEditing:YES animated:YES];
		}
		
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		if (indexPath.row == 0) {
			[tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
		} else {
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade] ; 
		}
		
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

