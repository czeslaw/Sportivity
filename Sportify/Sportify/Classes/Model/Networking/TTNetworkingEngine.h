//
//  TTNetworkingEngine.h
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTActivity.h"

typedef void(^TTNetworkingEngineProgressBlock)(CGFloat progress);
typedef void(^TTNetworkingEngineCompletionBlock)(NSError *error);

@interface TTNetworkingEngine : NSObject

+ (TTNetworkingEngine *)sharedInstance;

- (void)synchronizeWithProgressHandler:(TTNetworkingEngineProgressBlock)paramProgressBlock completionHandler:(TTNetworkingEngineCompletionBlock)paramCompletionBlock;
- (void)addActivity:(TTActivity *)paramActivity withCompletionHandler:(TTNetworkingEngineCompletionBlock)paramCompletionBlock;

@end
