//
//  addNewsViewController.m
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "addNewsViewController.h"
#define MSG_LENGTH 140




@implementation addNewsViewController

@synthesize messageTextView;
@synthesize lastStatus;
@synthesize charleft;
@synthesize updateButton;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title = @"Add news";
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
	[lastStatus setText:messageTextView.text];	
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
