//
//  TTDatasource.m
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "TTDatasource.h"

@implementation TTDatasource

+ (TTDatasource *)sharedInstance {
	
	NSAssert(NO, @"this should be overriden");
	
	return nil;
}

- (NSArray *)arrayObjects {
	
	NSAssert(NO, @"this should be overriden");
	
	return nil;
}

- (void)populateWithObjects:(NSArray *)paramArray {
	
	NSAssert(NO, @"this should be overriden");
}

@end
