//
//  TTProgressHUD.m
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "TTProgressHUD.h"
#import "UIColor+TTColor.h"

static const CGFloat kProgressHUDMinimumScale = 0.01f;
static const CGFloat kProgressHUDContainerCornerRadius = 12.0f;
static const CGFloat kProgressHUDMinimumProgress = 0.01f;

@interface TTProgressHUD ()

@property (nonatomic, weak) IBOutlet UIView *viewContainer;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;

@property (nonatomic, weak) UIViewController *parentViewController;

@end

@implementation TTProgressHUD

- (void)awakeFromNib{
	[super awakeFromNib];
	
	self.backgroundColor = [UIColor colorBlackWithAlphaHigh];
	
	self.viewContainer.layer.cornerRadius = kProgressHUDContainerCornerRadius;
	self.viewContainer.layer.masksToBounds = YES;
	self.viewContainer.backgroundColor = [UIColor blackColor];
	
	[self setProgressTo:0.0f];
	
	[self.activityIndicator startAnimating];
}

#pragma mark - Public Methods

+ (TTProgressHUD *)showProgressHUDWithTitle:(NSString *)paramTitle inViewController:(UIViewController *)paramViewController{

	TTProgressHUD *progressHUD = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TTProgressHUD class])
																owner:nil
															  options:nil]
								  firstObject];
	
	progressHUD.title = paramTitle;
	
	progressHUD.parentViewController = paramViewController;
	[progressHUD.parentViewController.view addSubview:progressHUD];
	progressHUD.frame = progressHUD.parentViewController.view.bounds;
	
	progressHUD.transform = CGAffineTransformScale(progressHUD.transform,
												   kProgressHUDMinimumScale,
												   kProgressHUDMinimumScale);
	progressHUD.alpha = 0.0f;
	[UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 
//TODO: potential enhancement: make the animation bounce
						 progressHUD.transform = CGAffineTransformIdentity;
						 progressHUD.alpha = 1.0f;
					 }
					 completion:NULL];
	
	return progressHUD;
}

- (void)hide{
	
	[self.activityIndicator stopAnimating];
	
	[UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 
						 self.alpha = 0.0f;
						 self.transform = CGAffineTransformScale(self.transform,
																 kProgressHUDMinimumScale,
																 kProgressHUDMinimumScale);
					 }
					 completion:^(BOOL finished) {
						 
						 self.parentViewController = nil;
						 [self removeFromSuperview];
					 }];
}

#pragma mark - Custom Setters

- (void)setProgressTo:(CGFloat)paramProgress{

	self.progressView.progress = paramProgress;
	self.progressView.hidden = (paramProgress < kProgressHUDMinimumProgress);
}

- (void)setTitle:(NSString *)paramTitle {
	
	self.labelTitle.text = [paramTitle copy];
}

- (NSString *)title {
	
	return [self.labelTitle.text copy];
}

@end
