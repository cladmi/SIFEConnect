//
//  versionbetaSIFEconnectAppDelegate.h
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface versionbetaSIFEconnectAppDelegate : NSObject <UIApplicationDelegate, UITextViewDelegate, UITextFieldDelegate> 
{
    UIWindow *window;
	
		
	UINavigationController *sifeNavigationController;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;






@end

