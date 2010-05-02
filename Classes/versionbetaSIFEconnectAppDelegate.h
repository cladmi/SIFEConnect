//
//  versionbetaSIFEconnectAppDelegate.h
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AsyncSocket;



@interface versionbetaSIFEconnectAppDelegate : NSObject <UIApplicationDelegate, UITextViewDelegate, UITextFieldDelegate> 
{
    UIWindow *window;
	
	AsyncSocket *socket;
	UINavigationController *sifeNavigationController;
	NSString *query;
	UINavigationController *caller;
	NSString *result;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSString *query;


- (void)contactServer:(id)caller;






@end

