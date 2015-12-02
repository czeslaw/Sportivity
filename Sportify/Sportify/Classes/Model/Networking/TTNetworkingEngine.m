//
//  TTNetworkingEngine.m
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import "TTNetworkingEngine.h"
#import <Parse/Parse.h>
#import "TTActivitiesDatasource.h"
#import "TTActivityTypesDatasource.h"

@implementation TTNetworkingEngine

+ (TTNetworkingEngine *)sharedInstance {
	
	static TTNetworkingEngine *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		if (sharedInstance == nil) {
			
			sharedInstance = [[TTNetworkingEngine alloc] init];
		}
	});
	
	return sharedInstance;
}

- (void)synchronizeWithProgressHandler:(TTNetworkingEngineProgressBlock)paramProgressBlock completionHandler:(TTNetworkingEngineCompletionBlock)paramCompletionBlock {

//TODO: improve the progress handling...
	if (paramProgressBlock != NULL) {

		paramProgressBlock(0.5f);
	}
	
	PFQuery *queryActivityTypes = [PFQuery queryWithClassName:kKeyParseClassNameActivityType];
	[queryActivityTypes findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
		
		if (paramProgressBlock != NULL) {
			
			paramProgressBlock(1.0f);
		}
		
		if (error) {
			
			if (paramCompletionBlock != NULL) {
    
				paramCompletionBlock(error);
			}
		}
		else {
		
			NSMutableArray *arrayActivityTypes = [[NSMutableArray alloc] init];
			for (PFObject *objectActivityType in array) {
    
				TTActivityType *activityType = [TTActivityType objectWithParseObject:objectActivityType];
				[arrayActivityTypes addObject:activityType];
			}
			[[TTActivityTypesDatasource sharedInstance] populateWithObjects:arrayActivityTypes];
			
			PFQuery *queryActivities = [PFQuery queryWithClassName:kKeyParseClassNameActivity];
			[queryActivities whereKey:kKeyParseActivityUser equalTo:[PFUser currentUser]];
			[queryActivities findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
			
				if (error) {
					
					if (paramCompletionBlock != NULL) {
						
						paramCompletionBlock(error);
					}
				}
				else {
					
					NSMutableArray *arrayActivities = [[NSMutableArray alloc] init];
					for (PFObject *objectActivity in array) {
						
						TTActivity *activity = [TTActivity objectWithParseObject:objectActivity];
						[arrayActivities addObject:activity];
					}
					[[TTActivitiesDatasource sharedInstance] populateWithObjects:arrayActivities];
					
					paramCompletionBlock(nil);
				}
			}];
		}
	}];
}

- (void)addActivity:(TTActivity *)paramActivity withCompletionHandler:(TTNetworkingEngineCompletionBlock)paramCompletionBlock {

	PFObject *object = [PFObject objectWithClassName:kKeyParseClassNameActivity];
	object[kKeyParseActivityTypeType] = paramActivity.type.parseObject;
	object[kKeyParseActivityUser] = [PFUser currentUser];
	[object saveInBackgroundWithBlock:^(BOOL success, NSError *error){
		
		paramCompletionBlock(error);
	}];
}

@end
