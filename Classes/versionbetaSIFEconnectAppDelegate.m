//
//  versionbetaSIFEconnectAppDelegate.m
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "versionbetaSIFEconnectAppDelegate.h"
#import "homeViewController.h"
#import "loginViewController.h"
#import "JSON.h"

@implementation versionbetaSIFEconnectAppDelegate

@synthesize window;
@synthesize query;



/*
 UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"caller == nill" message:@"Problem while passing the sender" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
 // optional - add more buttons:
 [alert addButtonWithTitle:@"Yes"];
 [alert show];
 */



- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	sifeNavigationController = [[UINavigationController alloc] init];
	
	homeViewController *hviewcontroller = [[homeViewController alloc] initWithNibName:@"homeView" bundle:nil];
	
	
	
	[sifeNavigationController pushViewController:hviewcontroller animated:NO];
	[hviewcontroller release];
	
	[window addSubview:sifeNavigationController.view];

	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}



- (void)dealloc {
	[sifeNavigationController release];
	[query release];
    [window release];
    [super dealloc];
}


- (void)contactServer:(id)caller {
	NSString *result = @"{\"STATUS\":\"CONNECTION_ERROR\"}";	
	if ([query isEqualToString:@"login"]) {
		
		result = @"{\"STATUS\":\"CONNECTION_ACCEPTED\",\"id\":1,\"sessionId\":\"coucoutuveuxvoirmabite\",\"name\":\"tartouille\"}";
	} else if ([query isEqualToString:@"listCountries"]) {
	
	    result = @"{\"section\":[{\"id\":1,\"name\":\"Africa\",\"rows\":[{\"id\":0,\"name\":\"No teams for the moment\"}]}, {\"id\":2,\"name\":\"America\",\"rows\":[{\"id\":0,\"name\":\"No teams for the moment\"}]}, {\"id\":3,\"name\":\"Asia\",\"rows\"{\"id\":0,\"name\":\"No teams for the moment\"}]}, {\"id\":4,\"name\":\"Europe\",\"rows\"[{\"id\":33,\"name\":\"France\"}]}, {\"id\":5,\"name\":\"Oceania\",\"rows\"[{\"id\":0,\"name\":\"No teams for the moment\"}]}], \"header\":\"World\"}";	
	}
	
	sleep(1);

	[caller performSelectorOnMainThread:@selector(queryResult:) withObject:result waitUntilDone:NO];
	[result release];
}
@end
