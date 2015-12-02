//
//  NSDate+TTCalculations.m
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "NSDate+TTCalculations.h"

@implementation NSDate (TTCalculations)

- (NSString *)stringPeriodBetweenDate:(NSDate *)paramDate {
	
	NSTimeInterval timeInterval = [self timeIntervalSinceDate:paramDate];
/*
	explanation for the magic numbers below:
	60 seconds in minute, 60 minutes in a hour, 24 hours in a day
	I'll also just assume, that no one is working out more than days...
*/
	
	NSInteger totalSeconds = (NSInteger)timeInterval;
	
	NSInteger days = totalSeconds / (60 * 60 * 24);
	totalSeconds %= days;
	
	NSInteger hours = totalSeconds / (60 * 60);
	totalSeconds %= hours;
	
	NSInteger minutes = totalSeconds / 60;
	totalSeconds %= minutes;
	
//TODO: hardcoded string
	NSMutableString *string = [[NSMutableString alloc] init];
	if (days > 0) {
		
		[string appendFormat:@"%ld %@",(long)days,(days == 1 ? @"day" : @"days")];
	}
	if (days > 0) {
		
		[string appendFormat:@"%ld %@",(long)hours,(hours == 1 ? @"hour" : @"hours")];
	}
	if (days > 0) {
		
		[string appendFormat:@"%ld %@",(long)minutes,(minutes == 1 ? @"minute" : @"minutes")];
	}
	[string appendFormat:@"%ld %@",(long)totalSeconds,(totalSeconds == 1 ? @"second" : @"seconds")];
	
	return [NSString stringWithString:string];
}

@end
