//
//  schoolSelectionController.h
//  SIFEConnect
//
//  Created by Ta Soeur on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface schoolSelectionController : UITableViewController {
	
	NSString *countryName;
	int idCountry;
	NSDictionary *teamDictionary;

}

@property(nonatomic, retain) NSString *countryName;
@property(nonatomic) int idCountry;
@property(nonatomic, retain) NSDictionary *teamDictionary;

@end
