//
//  TTAuthenticateViewController.m
//  Sportify
//
//  Created by czeslaw on 01.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "TTAuthenticateViewController.h"
#import <Parse/Parse.h>
#import "TTProgressHUD.h"

static const CGFloat kAdditionalViewOffsetOverKeyboard = 10.0f;

typedef NS_ENUM(NSInteger, TTAuthenticationState){

	TTAuthenticationStateUnknown = -1,
	TTAuthenticationStateLogin = 1,
	TTAuthenticationStateRegister = 2,
};

@interface TTAuthenticateViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIView *viewContainer;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITextField *textFieldUsername;
@property (nonatomic, weak) IBOutlet UITextField *textFieldPassword;
@property (nonatomic, weak) IBOutlet UITextField *textFieldPasswordRepeat;
@property (nonatomic, weak) IBOutlet UIButton *buttonProceed;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *barButtonItemChangeState;

@property (nonatomic, assign) TTAuthenticationState state;

@property (nonatomic, assign) CGRect keyboardFrame;

@end

@implementation TTAuthenticateViewController

#pragma mark - Object lifecycle

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.state = TTAuthenticationStateLogin;
	
//TODO: hardcoded strings
	self.textFieldUsername.placeholder = @"username";
	self.textFieldPassword.placeholder = @"password";
	self.textFieldPasswordRepeat.placeholder = @"repeat password";
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidHide:)
												 name:UIKeyboardDidHideNotification
											   object:nil];
}

- (void)dismissAuthentication {
	
	[self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Adjusting View Offset

- (void)keyboardDidShow:(NSNotification *)paramNotification {
	
	UIView *activeTextField = nil;
	
	if (self.textFieldUsername.isFirstResponder) {
		
		activeTextField = self.textFieldUsername;
	}
	else
		if (self.textFieldPassword.isFirstResponder) {
		
			activeTextField = self.textFieldPassword;
		}
		else
			if (self.textFieldPasswordRepeat.isFirstResponder) {
			
				activeTextField = self.textFieldPasswordRepeat;
			}
	
	if (activeTextField) {
		
		NSValue *keyboardRectValue = paramNotification.userInfo[UIKeyboardFrameEndUserInfoKey];
		
		CGRect keyboardRect = [keyboardRectValue CGRectValue];
		
		self.keyboardFrame = keyboardRect;
		
		[self scrollToMakeViewVisible:activeTextField];
	}
}

- (void)keyboardDidHide:(NSNotification *)paramNotification {

	[self scrollViewToOffsetZero];
}

- (void)scrollToMakeViewVisible:(UIView *)paramView {
	
	CGRect adjustedRect = [paramView.superview convertRect:paramView.frame toView:self.view];
	
	if (CGRectIntersectsRect(adjustedRect, self.keyboardFrame)) {
		
		CGFloat viewOffset = CGRectGetMaxY(adjustedRect);
		CGFloat keyboardOffset = CGRectGetMinY(self.keyboardFrame);
		
		CGFloat offsetToAdjust = keyboardOffset - viewOffset - kAdditionalViewOffsetOverKeyboard;
		
		[self scrollViewToOffset:offsetToAdjust];
	}
}

- (void)scrollViewToOffset:(CGFloat)paramOffset {
	
	[UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 
						 self.view.frame = CGRectMake(self.view.frame.origin.x,
													  paramOffset,
													  self.view.frame.size.width,
													  self.view.frame.size.height);
					 }
					 completion:NULL];
}

- (void)scrollViewToOffsetZero {
	
	[self scrollViewToOffset:CGPointZero.y];
	[self.view endEditing:YES];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	[self scrollToMakeViewVisible:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	if (textField == self.textFieldUsername) {
		
		[self.textFieldPassword becomeFirstResponder];
	}
	else
		if (textField == self.textFieldPassword &&
			self.state == TTAuthenticationStateRegister){
		
			[self.textFieldPasswordRepeat becomeFirstResponder];
		}
		else {
			
			[textField resignFirstResponder];
		}
	
	return YES;
}

#pragma mark - Action Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	
	[self scrollViewToOffsetZero];
}

- (IBAction)tapButtonChangeState:(id)paramSender {
	
	if (self.state == TTAuthenticationStateRegister) {
		
		self.state = TTAuthenticationStateLogin;
	}
	else if (self.state == TTAuthenticationStateLogin) {
		
		self.state = TTAuthenticationStateRegister;
	}
	
	[self scrollViewToOffsetZero];
}

- (IBAction)tapButtonProceed:(id)paramSender {
	
//TODO: hardcoded strings
	if (![self verifyUsername]) {
		
		[[[UIAlertView alloc] initWithTitle:@"Something went wrong..."
									message:@"Username should not be empty."
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil]
		 show];
	}
	else
		if (![self verifyPassword]) {

			[[[UIAlertView alloc] initWithTitle:@"Something went wrong..."
										message:@"Invalid password."
									   delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil]
			 show];
		}
		else if (![self verifyPasswordRepeat]) {
			
			[[[UIAlertView alloc] initWithTitle:@"Something went wrong..."
										message:@"Passwords do not match."
									   delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil]
			 show];
		}
		else {
			
			if (self.state == TTAuthenticationStateLogin) {
    
				[self proceedWithLogin];
			}
			else
				if (self.state == TTAuthenticationStateRegister) {
				
					[self proceedWithRegister];
				}
		}
}

#pragma mark - Parse Authentication

- (void)proceedWithLogin {
	
	__weak typeof (self) weakSelf = self;

//TODO: hardcoded strings
	__block TTProgressHUD *progressHUD = [TTProgressHUD showProgressHUDWithTitle:@"Logging in..."
														inViewController:self.navigationController];
	
//TODO: add progress handler and block UI
	[PFUser logInWithUsernameInBackground:self.textFieldUsername.text
								 password:self.textFieldPassword.text
									block:^(PFUser *user, NSError *error) {
	
										[progressHUD hide];
										
										if (error) {
											
//TODO: hardcoded strings
											[[[UIAlertView alloc] initWithTitle:@"Something went wrong..."
																		message:error.localizedDescription
																	   delegate:nil
															  cancelButtonTitle:@"OK"
															  otherButtonTitles:nil]
											 show];
										}
										else {
											
											[weakSelf dismissAuthentication];
										}
									}];
}

- (void)proceedWithRegister {

	__weak typeof (self) weakSelf = self;
	
	PFUser *user = [PFUser user];
	user.username = self.textFieldUsername.text;
	user.password = self.textFieldPassword.text;
	
//TODO: hardcoded strings
	__block TTProgressHUD *progressHUD = [TTProgressHUD showProgressHUDWithTitle:@"Logging in..."
																inViewController:self.navigationController];
	
	[user signUpInBackgroundWithBlock:^(BOOL succeed, NSError *error) {
		
		if (error) {
			
//TODO: hardcoded strings
			[[[UIAlertView alloc] initWithTitle:@"Something went wrong..."
										message:error.localizedDescription
									   delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil]
			 show];
		}
		else
			if (succeed) {
			
				[weakSelf dismissAuthentication];
			}
	}];
}

#pragma mark - Custom Setters

- (void)setState:(TTAuthenticationState)paramState {
	
	_state = paramState;
	
//TODO: hardcoded strings
//TODO: add some nice animations
	if (_state == TTAuthenticationStateLogin) {
		
		self.textFieldPasswordRepeat.hidden = YES;
		self.labelTitle.text = @"Type your credentials to login!";
		[self.buttonProceed setTitle:@"Login!" forState:UIControlStateNormal];
		self.barButtonItemChangeState.title = @"Register";
	}
	else
		if (_state == TTAuthenticationStateRegister) {
		
			self.textFieldPasswordRepeat.hidden = NO;
			self.labelTitle.text = @"Type your credentials to register!";
			self.barButtonItemChangeState.title = @"Login";
			[self.buttonProceed setTitle:@"Register!" forState:UIControlStateNormal];
		}
}

#pragma mark - Convinience Methods

- (BOOL)verifyUsername {

	return self.textFieldUsername.text.length > 0;
}

- (BOOL)verifyPassword {

//TODO: add more validations
	return self.textFieldPassword.text.length > 0;
}

- (BOOL)verifyPasswordRepeat {
	
	if (self.state == TTAuthenticationStateRegister) {
		
		return [self.textFieldPassword.text isEqualToString:self.textFieldPasswordRepeat.text];
	}
	
	return YES;
}

@end
