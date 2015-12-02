//
//  TTSerializable.h
//  Sportify
//
//  Created by czeslaw on 02.12.2015.
//  Copyright (c) 2015 Tooploox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol TTParseSerializable <NSObject>

@property (nonatomic, strong) PFObject *parseObject;

+ (id<TTParseSerializable>)objectWithParseObject:(PFObject *)paramObject;

@end
