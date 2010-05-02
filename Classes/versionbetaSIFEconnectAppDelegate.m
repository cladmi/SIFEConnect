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
	homeViewController *hviewcontroller = [[homeViewController alloc] initWithNibName:@"homeView" bundle:nil];
	[sifeNavigationController pushViewController:hviewcontroller animated:NO];
	[hviewcontroller release];
	[window addSubview:sifeNavigationController.view];

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

/*  
 @implementation AppController
 
 - (id)init
 {
 if(self = [super init])
 {
 asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
 }
 return self;
 }
 
 - (void)applicationDidFinishLaunching:(NSNotification *)aNotification
 {
 NSLog(@"Ready");
 
 NSError *err = nil;
 if(![asyncSocket connectToHost:@"paypal.com" onPort:443 error:&err])
 {
 NSLog(@"Error: %@", err);
 }
 }
 
 - (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
 {
 NSLog(@"onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);
 
 // Configure SSL/TLS settings
 NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
 // For your regular security checks, use only this setting 

[settings setObject:@"www.paypal.com"
			 forKey:(NSString *)kCFStreamSSLPeerName];

// To connect to a test server, with a self-signed certificate, use settings similar to this 

//	// Allow expired certificates
//	[settings setObject:[NSNumber numberWithBool:YES]
//				 forKey:(NSString *)kCFStreamSSLAllowsExpiredCertificates];
//	
//	// Allow self-signed certificates
//	[settings setObject:[NSNumber numberWithBool:YES]
//				 forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
//	
//	// In fact, don't even validate the certificate chain
//	[settings setObject:[NSNumber numberWithBool:NO]
//				 forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];

[sock startTLS:settings];
}

- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag
{
	if(flag)
		NSLog(@"onSocket:%p didSecure:YES", sock);
	else
		NSLog(@"onSocket:%p didSecure:NO", sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	NSLog(@"onSocket:%p willDisconnectWithError:%@", sock, err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	NSLog(@"onSocketDidDisconnect:%p", sock);
}

- (IBAction)printCert:(id)sender
{
	NSDictionary *cert = [X509Certificate extractCertDictFromAsyncSocket:asyncSocket];
	NSLog(@"X509 Certificate: \n%@", cert);
}

   */

































- (void)contactServer:(id)caller {
	NSString *result = @"{\"STATUS\":\"CONNECTION_ERROR\"}";	
	if ([query isEqualToString:@"login"]) {
		
		result = @"{\"STATUS\":\"CONNECTION_ACCEPTED\",\"id\":1,\"sessionId\":\"coucoutuveuxvoirmabite\",\"name\":\"tartouille\"}";
	} else if ([query isEqualToString:@"listCountries"]) {
		
	    result = @"{\"section\":[{\"id\":1,\"name\":\"Africa\",\"rows\":[{\"id\":0,\"name\":\"No teams for the moment\"}]}, {\"id\":2,\"name\":\"America\",\"rows\":[{\"id\":0,\"name\":\"No teams for the moment\"}]}, {\"id\":3,\"name\":\"Asia\",\"rows\":[{\"id\":0,\"name\":\"No teams for the moment\"}]}, {\"id\":4,\"name\":\"Europe\",\"rows\":[{\"id\":33,\"name\":\"France\"}]}, {\"id\":5,\"name\":\"Oceania\",\"rows\":[{\"id\":0,\"name\":\"No teams for the moment\"}]}], \"header\":\"World\"}";	
	} else if ([query isEqualToString:@"listTeams"]) {
		result =@"{\"idCountry\":33,\"rows\":[{\"id\":1,\"name\":\"TheDeveloper\"}],\"header\":\"France\"}";
	}

	
	sleep(1);

	[caller performSelectorOnMainThread:@selector(queryResult:) withObject:result waitUntilDone:NO];
	[result release];
}


- (void)dealloc {
	[sifeNavigationController release];
	[query release];
    [window release];
    [super dealloc];
}
@end
