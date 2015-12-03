//
//  TTActivitiesDatasource.m
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "TTActivitiesDatasource.h"

@interface TTActivitiesDatasource ()

@property (nonatomic, strong) NSMutableArray *arrayActivities;

@end

@implementation TTActivitiesDatasource

+ (TTActivitiesDatasource *)sharedInstance {
	
	static TTActivitiesDatasource *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		if (sharedInstance == nil) {
			
			sharedInstance = [[TTActivitiesDatasource alloc] init];
		}
	});
	
	return sharedInstance;
}

- (NSArray *)arrayObjects {
	
	return [NSArray arrayWithArray:self.arrayActivities];
}

- (void)populateWithObjects:(NSArray *)paramArray {
	
	[self.arrayActivities removeAllObjects];
	
	if (paramArray) {

		[self.arrayActivities addObjectsFromArray:paramArray];
	}
}

#pragma mark - Lazy Getters

- (NSMutableArray *)arrayActivityTypes{
	
	if (_arrayActivities == nil) {
		
		_arrayActivities = [[NSMutableArray alloc] init];
	}
	
	return _arrayActivities;
}

@end
