//
//  msgViewController.h
//  SIFEConnect
//
//  Created by Ta Soeur on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface msgViewController : UITableViewController {

	
	NSDictionary *newsDictionary;
	int idTeam;
	NSString *teamName;
}


@property(nonatomic, retain) NSDictionary *newsDictionary;
@property(nonatomic, retain) NSString *teamName;
@property(nonatomic) int idTeam;
@end
