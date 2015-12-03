//
//  TTActivityType.h
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSerializable.h"

extern NSString *const kKeyParseClassNameActivityType;
extern NSString *const kKeyParseActivityTypeType;

@interface TTActivityType : NSObject <TTParseSerializable>

@property (nonatomic, copy) NSString *type;

@end
