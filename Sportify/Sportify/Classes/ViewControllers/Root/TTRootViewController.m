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

@interface TTRootViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *barButtonItemLogout;

@end

@implementation TTRootViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
//TODO: hardcoded strings
	self.barButtonItemLogout.title = @"Logout";
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if ([PFUser currentUser].isAuthenticated) {
		
//TODO: perform data fetch
	}
	else {
		
		[self performSegueWithIdentifier:kIdentifierSegueRootToAuthenticate sender:self];
	}
}

#pragma mark - Action handling

- (IBAction)tapButtonLogout:(id)sender {

	__weak typeof (self) weakSelf = self;
	
//TODO: add preogress handler
	[PFUser logOutInBackgroundWithBlock:^(NSError *error){
	
		if (error) {
//TODO: hardcoded strings
			[[[UIAlertView alloc] initWithTitle:@"Something went wrong"
										message:error.localizedDescription
									   delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil]
			 show];
		}
		else {
		
			[weakSelf performSegueWithIdentifier:kIdentifierSegueRootToAuthenticate sender:weakSelf];
		}
	}];
}

@end
