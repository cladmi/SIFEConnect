//
//  Global.h
//  SIFEConnect
//
//  Created by Ta Soeur on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Global : NSObject {
	
	int myId;
	NSString *sessionId;
	NSString *teamName;
	NSString *query;
	BOOL isLogged;

}

@property(nonatomic) int myId;
@property(nonatomic, retain) NSString *sessionId;
@property(nonatomic, retain) NSString *teamName;
@property(nonatomic, retain) NSString *query;
@property(nonatomic) BOOL isLogged;

+ (Global *)sharedInstance;
@end
