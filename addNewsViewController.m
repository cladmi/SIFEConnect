//
//  addNewsViewController.m
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "addNewsViewController.h"
#import "versionbetaSIFEconnectAppDelegate.h"
#define MSG_LENGTH 140




@implementation addNewsViewController

@synthesize messageTextView;
@synthesize lastStatus;
@synthesize charleft;
@synthesize updateButton;
@synthesize uploadButton;
@synthesize rotatumsnart;



- (IBAction)sendMessage:(id)sender
{
	
 [rotatumsnart startAnimating];
 
	updateButton.enabled = NO;
	updateButton.titleLabel.enabled = NO;
	uploadButton.enabled = NO;
	uploadButton.titleLabel.enabled = NO;
	
	NSString *query;
	NSMutableDictionary *queryDictionary;
	queryDictionary = [[NSMutableDictionary alloc] init];
	[queryDictionary setValue:[NSNumber numberWithInt:POST] forKey:@"action"];
	[queryDictionary setValue:[NSNumber numberWithInt:[Global sharedInstance].myId] forKey:@"id"];
	[queryDictionary setValue:[Global sharedInstance].sessionId forKey:@"sessionId"];
	[queryDictionary setValue:lastStatus.text forKey:@"text"];
	
	query = [queryDictionary JSONRepresentation];
	((versionbetaSIFEconnectAppDelegate *)[[UIApplication sharedApplication] delegate]).query = query;
	
	[(versionbetaSIFEconnectAppDelegate *)[[UIApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(contactServer:) withObject:self 
																									 waitUntilDone:NO];
	[queryDictionary release]; 
}	


- (void)queryResult:(NSString *)result 
{
	
	NSDictionary *results = [result JSONValue];
	
	NSString *status = [results objectForKey:@"STATUS"];
	if (status != nil && [status isEqualToString:@"MESSAGE_POSTED"]) {
		
		[rotatumsnart stopAnimating];
		updateButton.enabled = YES;
		updateButton.titleLabel.enabled = YES;
		uploadButton.enabled = NO;
		uploadButton.titleLabel.enabled = NO;
		messageTextView.text = @"";
		/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your message has been posted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];*/
		
	} else {
		updateButton.enabled = YES;
		updateButton.titleLabel.enabled = YES;
		[rotatumsnart stopAnimating];
		lastStatus.text = @"";
		NSLog(@"Failed to send message"); 
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Server error." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}	
}






 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title = @"Add News";
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	messageTextView.delegate = self;
	charleft.text = [NSString stringWithFormat:@"Character left : %d", MSG_LENGTH - [[messageTextView text] length]];
	updateButton.enabled = YES;
	updateButton.titleLabel.enabled = YES;
	uploadButton.enabled = NO;
	uploadButton.titleLabel.enabled = NO;
}




- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
	int count = [[messageTextView text] length];
	charleft.text = [NSString stringWithFormat:@"Character left : %d", MSG_LENGTH - count];
    // Any new character added is passed in as the "text" parameter
	if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
	    // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    } else if ([text isEqualToString:@"\b"]) {
		return TRUE;
	// text.length - range.length is to handle backspace when maximum character number is reached	
    } else if (count + text.length  - range.length> MSG_LENGTH) {
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (IBAction)updateStatus:(id)sender {
		
	if (messageTextView.text != nil && ![messageTextView.text isEqualToString: @""]) {
		[lastStatus setText:messageTextView.text];
		uploadButton.enabled = YES;
		uploadButton.titleLabel.enabled = YES;
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
	[messageTextView release];
	[lastStatus release];
	[charleft release];
	[updateButton release];
    [super dealloc];
}


@end
