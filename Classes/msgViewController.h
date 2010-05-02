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
	int idCountry;
	int idContinent;
	NSString *teamName;
}


@property(nonatomic, retain) NSDictionary *newsDictionary;
@property(nonatomic, retain) NSString *teamName;
@property(nonatomic) int idTeam;
@property(nonatomic) int idCountry;
@property(nonatomic) int idContinent;


@end
