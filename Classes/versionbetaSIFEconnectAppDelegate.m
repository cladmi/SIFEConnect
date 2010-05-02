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
#import "AsyncSocket.h"




@implementation versionbetaSIFEconnectAppDelegate

@synthesize window;
@synthesize query;



/*
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"caller == nill" message:@"Problem while passing the sender" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
 [alert show];
 [alert release];
 */



- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	sifeNavigationController = [[UINavigationController alloc] init];
	homeViewController *hviewcontroller = [[homeViewController alloc] initWithNibName:@"homeViewNew" bundle:nil];
	[sifeNavigationController pushViewController:hviewcontroller animated:NO];
	[hviewcontroller release];
	[window addSubview:sifeNavigationController.view];
	
	socket = [[AsyncSocket alloc] initWithDelegate:self];

    // Override point for customization after application launch
    [window makeKeyAndVisible];
	
}


 
 
 
 - (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
 {	 
	 sleep(1);
	 NSLog(@"onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);
		  
	 [sock readDataToData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
 }
 
 
 /*
 -(BOOL)onSocketWillConnect:(AsyncSocket *)sock {
 // if we need to prepare the data to send 
	 NSLog(@"onSocketWillConnect:%p", sock);
	 return YES;
 }
  */
 


- (void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *coucou;
	result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"onSocket:%p didReadData:%@ WithTag:%d", sock, result, tag);
	
	if (tag == 0) {
		coucou = [query stringByAppendingString:@"\n"];
		[sock writeData:[coucou dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:(tag +1)];
	} else if (tag == 2) {
		[sock writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:(tag +1)];
		[sock disconnectAfterWriting];
	}
	[pool release];
		
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	NSLog(@"onSocket:%p didWriteDataWithTag:%d", sock, tag);
	[sock readDataToData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:(tag + 1)];
		// [sock readDataWithTimeout:10 tag:1];
	
}



- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	NSLog(@"onSocket:%p willDisconnectWithError:%@", sock, err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	NSLog(@"onSocketDidDisconnect:%p", sock); 
	[caller performSelectorOnMainThread:@selector(queryResult:) withObject:result waitUntilDone:NO];
	[result release];
	[query release];
	query = nil;
}



- (void)contactServer:(id)sender {
	caller = sender;
	NSLog(query);
	NSError *err = nil;
	[socket initWithDelegate:self];
	if(![socket connectToHost:@"localhost" onPort:4242 error:&err])
	{
		NSLog(@"Error: %@", err);
	}

}


- (void)dealloc {
	[sifeNavigationController release];
	[query release];
    [window release];
	[socket release];
    [super dealloc];
}
@end
