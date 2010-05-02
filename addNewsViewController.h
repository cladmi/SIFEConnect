//
//  addNewsViewController.h
//  versionbetaSIFEconnect
//
//  Created by Ta Soeur on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface addNewsViewController : UIViewController <UITextViewDelegate> {
	IBOutlet UITextView *messageTextView;
	IBOutlet UITextView *lastStatus;
	IBOutlet UILabel *charleft;
	IBOutlet UIButton *updateButton;
	IBOutlet UIButton *uploadButton;
	IBOutlet UIActivityIndicatorView *rotatumsnart;

	
}

@property (nonatomic, retain) UITextView *messageTextView;
@property (nonatomic, retain) UITextView *lastStatus;
@property (nonatomic, retain) UILabel *charleft;
@property (nonatomic, retain) UIButton *updateButton;
@property (nonatomic, retain) UIButton *uploadButton;
@property (nonatomic, retain) UIActivityIndicatorView *rotatumsnart;

- (IBAction)updateStatus:(id)sender;
- (IBAction)sendMessage:(id)sender;



@end
