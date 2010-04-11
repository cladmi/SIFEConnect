//
//  versionbetaSIFEconnectAppDelegate.m
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "versionbetaSIFEconnectAppDelegate.h"
#import "homeViewController.h"

@implementation versionbetaSIFEconnectAppDelegate

@synthesize window;




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
    [window release];
    [super dealloc];
}


@end
