//
//  TTProgressHUD.h
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTProgressHUD : UIView

@property (nonatomic, copy) NSString *title;

+ (TTProgressHUD *)showProgressHUDWithTitle:(NSString *)paramTitle inViewController:(UIViewController *)paramViewController;

- (void)setProgressTo:(CGFloat)paramProgress;
- (void)hide;

@end
