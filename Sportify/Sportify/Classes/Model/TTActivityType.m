//
//  TTActivityType.m
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "TTActivityType.h"

NSString *const kKeyParseClassNameActivityType = @"ActivityType";
NSString *const kKeyParseActivityTypeType = @"type";

@implementation TTActivityType

@synthesize parseObject;

+ (TTActivityType *)objectWithParseObject:(PFObject *)paramObject {

	TTActivityType *activityType = [[TTActivityType alloc] init];
	activityType.parseObject = paramObject;
	
	activityType.type = paramObject[kKeyParseActivityTypeType];
	
	return activityType;
}

@end
