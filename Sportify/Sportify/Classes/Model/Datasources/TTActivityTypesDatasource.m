//
//  TTActivityTypesDatasource.m
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "TTActivityTypesDatasource.h"

@interface TTActivityTypesDatasource ()

@property (nonatomic, strong) NSMutableArray *arrayActivityTypes;

@end

@implementation TTActivityTypesDatasource

+ (TTActivityTypesDatasource *)sharedInstance {
	
	static TTActivityTypesDatasource *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		if (sharedInstance == nil) {
			
			sharedInstance = [[TTActivityTypesDatasource alloc] init];
		}
	});
	
	return sharedInstance;
}

- (NSArray *)arrayObjects {
	
	return [NSArray arrayWithArray:self.arrayActivityTypes];
}

- (void)populateWithObjects:(NSArray *)paramArray {
	
	[self.arrayActivityTypes removeAllObjects];

	if (paramArray) {
		
		[self.arrayActivityTypes addObjectsFromArray:paramArray];
	}
}

#pragma mark - Lazy Getters

- (NSMutableArray *)arrayActivityTypes{
	
	if (_arrayActivityTypes == nil) {
		
		_arrayActivityTypes = [[NSMutableArray alloc] init];
	}
	
	return _arrayActivityTypes;
}

@end
