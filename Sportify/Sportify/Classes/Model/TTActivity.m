//
//  TTActivity.m
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "TTActivity.h"
#import "NSDate+TTCalculations.h"

NSString *const kKeyParseClassNameActivity = @"Activity";

NSString *const kKeyParseActivityStartsAt = @"startsAt";
NSString *const kKeyParseActivityEndsAt = @"endsAt";
NSString *const kKeyParseActivityType = @"type";
NSString *const kKeyParseActivityUser = @"user";

@implementation TTActivity

@synthesize parseObject;

+ (TTActivity *)objectWithParseObject:(PFObject *)paramObject {

	TTActivity *activity = [[TTActivity alloc] init];
	
	activity.parseObject = paramObject;
	
	activity.dateStart = paramObject[kKeyParseActivityStartsAt];
	activity.dateEnd = paramObject[kKeyParseActivityEndsAt];
	
	TTActivityType *activityType = [TTActivityType objectWithParseObject:paramObject[kKeyParseActivityType]];
	activity.type = activityType;
	
	return activity;
}

- (NSString *)period {
	
	return [self.dateEnd stringPeriodBetweenDate:self.dateStart];
}

@end
