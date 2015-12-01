//
//  AppDelegate.m
//  Sportify
//
//  Created by czeslaw on 01.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

static NSString *const kKeyParseApplicationID = @"YtWxcjSmh3AepKhdjM30r88w6ZDm4q7VPOlHyBhJ";
static NSString *const kKeyParseClientKey = @"A46RfvkCTbsGzEzWsDBeEGEuieFBa1WwqtTJlHZH";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
	[Parse setApplicationId:kKeyParseApplicationID
				  clientKey:kKeyParseClientKey];
	
    return YES;
}

@end
