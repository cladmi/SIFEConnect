//
//  Global.m
//  SIFEConnect
//
//  Created by Ta Soeur on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Global.h"


@implementation Global
+ (Global *)sharedInstance
{
    // the instance of this class is stored here
    static Global *myInstance = nil;
	
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}

@synthesize myId;
@synthesize sessionId;
@synthesize teamName;
@synthesize query;
@synthesize isLogged;

@end
