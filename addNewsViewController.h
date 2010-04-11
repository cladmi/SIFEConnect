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
	
}

@property (nonatomic, retain) UITextView *messageTextView;
@property (nonatomic, retain) UITextView *lastStatus;
@property (nonatomic, retain) UILabel *charleft;
@property (nonatomic, retain) UIButton *updateButton;

- (IBAction)updateStatus:(id)sender;



@end
