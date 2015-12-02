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
static NSString *const kIdentifierCellRootActivity = @"kIdentifierCellRootActivity";

@interface TTRootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *barButtonItemLogout;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

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

	__weak typeof (self) weakSelf = self;
	
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
														  
														  [weakSelf.tableView reloadData];
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

#pragma mark - UITableView Datasource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [TTActivitiesDatasource sharedInstance].arrayObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierCellRootActivity
															forIndexPath:indexPath];
	
	TTActivity *activity = [TTActivitiesDatasource sharedInstance].arrayObjects[indexPath.row];
	
	cell.textLabel.text = activity.type.type;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateStyle = NSDateFormatterShortStyle;
	dateFormatter.timeStyle = NSDateFormatterShortStyle;
	
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ (%@)",activity.dateStart,activity.dateEnd,activity.period];
	
	return cell;
}

#pragma mark - Clean Up

- (void)cleanUpAfterLogout {
	
	[[TTActivityTypesDatasource sharedInstance] populateWithObjects:nil];
	[[TTActivitiesDatasource sharedInstance] populateWithObjects:nil];
	[self performSegueWithIdentifier:kIdentifierSegueRootToAuthenticate sender:self];
}

@end
