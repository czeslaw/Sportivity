//
//  TTDatasource.h
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTDatasource : NSObject

+ (TTDatasource *)sharedInstance;

- (NSArray *)arrayObjects;
- (void)populateWithObjects:(NSArray *)paramArray;

@end
