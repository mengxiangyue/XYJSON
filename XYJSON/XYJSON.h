//
//  XYJSON.h
//  XYJSON
//
//  Created by mxy on 14-8-23.
//  Copyright (c) 2014年 mxy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  扩展处理json的类
 */
@interface XYJSON : NSObject {
    id sourceObject;
}
- (instancetype)initWithObject:(id)object;

// Dictionary
- (NSString *)getStringWithKey:(NSString *)key;
- (int)getIntWithKey:(NSString *)key;
- (double)getDoubleWithKey:(NSString *)key;
- (BOOL)getBoolWithKey:(NSString *)key;

// Array
- (NSString *)getStringAtIndex:(int)index;
- (int)getIntAtIndex:(int)index;
- (double)getDoubleAtIndex:(int)index;
- (BOOL)getBoolAtIndex:(int)index;

// Object
- (XYJSON *)getObject:(NSString *)key;

- (BOOL)isDictionary;
- (BOOL)isArray;
- (BOOL)isContainKey:(NSString *)key;
@end

/**
 *  扩展NSString
 */
@interface NSString (XYJSON)
- (XYJSON *)objectFromJSONString;
@end

/**
 *  扩展NSData 用于处理json
 */
@interface NSData (XYJSON)
- (XYJSON *)objectFromJSONData;
@end