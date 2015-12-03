//
//  UIColor+TTColor.m
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "UIColor+TTColor.h"

static const CGFloat kTTColorAlphaLow = 0.85f;
static const CGFloat kTTColorAlphaMedium = 0.65f;
static const CGFloat kTTColorAlphaHigh = 0.35f;

@implementation UIColor (TTColor)

+ (UIColor *)colorBlackWithAlpha:(CGFloat)paramAlpha {
	
	return [UIColor colorWithRed:0.0f
						   green:0.0f
							blue:0.0f
						   alpha:paramAlpha];
}

+ (UIColor *)colorBlackWithAlphaLow {
	
	return [UIColor colorBlackWithAlpha:kTTColorAlphaLow];
}

+ (UIColor *)colorBlackWithAlphaMedium {
	
	return [UIColor colorBlackWithAlpha:kTTColorAlphaMedium];
}

+ (UIColor *)colorBlackWithAlphaHigh {
	
	return [UIColor colorBlackWithAlpha:kTTColorAlphaHigh];
}

@end
