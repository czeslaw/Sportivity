//
//  TTActivity.h
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTActivityType.h"

extern NSString *const kKeyParseClassNameActivity;

extern NSString *const kKeyParseActivityStartsAt;
extern NSString *const kKeyParseActivityEndsAt;
extern NSString *const kKeyParseActivityType;
extern NSString *const kKeyParseActivityUser;

@interface TTActivity : NSObject <TTParseSerializable>

@property (nonatomic, strong) TTActivityType *type;
@property (nonatomic, copy) NSDate *dateStart;
@property (nonatomic, copy) NSDate *dateEnd;

- (NSString *)period;

@end
