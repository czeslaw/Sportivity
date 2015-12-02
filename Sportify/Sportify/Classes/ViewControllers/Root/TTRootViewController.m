//
//  TTRootViewController.m
//  Sportify
//
//  Created by czeslaw on 01.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "TTRootViewController.h"
#import <Parse/Parse.h>
#import "TTProgressHUD.h"
#import "TTActivitiesDatasource.h"
#import "TTActivityTypesDatasource.h"
#import "TTNetworkingEngine.h"

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
		
		[self refreshData];
	}
	else {
		
		[self performSegueWithIdentifier:kIdentifierSegueRootToAuthenticate sender:self];
	}
}

#pragma mark - Data Refresh

- (void)refreshData {

//TODO: hardcoded strings
	__block TTProgressHUD *progressHUD = [TTProgressHUD showProgressHUDWithTitle:@"Synchronizing..."
																inViewController:self.navigationController];
	
	[[TTNetworkingEngine sharedInstance] synchronizeWithProgressHandler:^(CGFloat progress) {
	
		[progressHUD setProgressTo:progress];
	}
													  completionHandler:^(NSError *error) {
		
														  if (error) {
															  
															  [[[UIAlertView alloc] initWithTitle:@"Something went wrong..."
																						  message:error.localizedDescription
																						 delegate:nil
																				cancelButtonTitle:@"OK"
																				otherButtonTitles:nil]
															   show];
														  }
														  
														  NSLog(@"activities: ");
														  for (TTActivity *activity in [[TTActivitiesDatasource sharedInstance] arrayObjects]) {
															  
															  NSLog(@"%@",activity.parseObject);
														  }
														  NSLog(@"activity types: ");
														  for (TTActivityType *activityType in [[TTActivityTypesDatasource sharedInstance] arrayObjects]) {
															  
															  NSLog(@"%@",activityType.parseObject);
														  }
														  
														  [progressHUD hide];
													  }];
}

#pragma mark - Action handling

- (IBAction)tapButtonLogout:(id)sender {

	__weak typeof (self) weakSelf = self;
	
	__block TTProgressHUD *progressHUD = [TTProgressHUD showProgressHUDWithTitle:@"Logging out..."
																inViewController:self.navigationController];
	
	[PFUser logOutInBackgroundWithBlock:^(NSError *error){
	
		[progressHUD hide];
		
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
		
			[weakSelf cleanUpAfterLogout];
		}
	}];
}

#pragma mark - Clean Up

- (void)cleanUpAfterLogout {
	
	[[TTActivityTypesDatasource sharedInstance] populateWithObjects:nil];
	[[TTActivitiesDatasource sharedInstance] populateWithObjects:nil];
	[self performSegueWithIdentifier:kIdentifierSegueRootToAuthenticate sender:self];
}

@end
