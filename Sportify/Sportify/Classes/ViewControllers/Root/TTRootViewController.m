//
//  TTRootViewController.m
//  Sportify
//
//  Created by czeslaw on 01.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "TTRootViewController.h"
#import <Parse/Parse.h>

static NSString *const kIdentifierSegueRootToAuthenticate = @"kIdentifierSegueRootToAuthenticate";

@implementation TTRootViewController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if ([PFUser currentUser].isAuthenticated) {
		
//		TODO: perform data fetch
	}
	else {
		
		[self performSegueWithIdentifier:kIdentifierSegueRootToAuthenticate sender:self];
	}
}

@end
