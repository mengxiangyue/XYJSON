//
//  XYJSON.m
//  XYJSON
//
//  Created by mxy on 14-8-23.
//  Copyright (c) 2014年 mxy. All rights reserved.
//  支持int double NSString BOOL

#import "XYJSON.h"
#define EXCEPTION_FLAG YES

@implementation XYJSON
/**
 *  初始化XYJSON
 *  默认情况下NSMutableDictionary，NSMutableArray
 *
 *  @param object
 *
 *  @return
 */
- (instancetype)initWithObject:(id)object {
    if (self = [super init]) {
        sourceObject = object;
    }
    return self;
}

#pragma mark Dictionary
- (NSString *)getStringWithKey:(NSString *)key {
    [self confirmGetTypeWithKeyException:key];
    return [self convertToStringWithKey:key];
}
- (int)getIntWithKey:(NSString *)key {
    [self confirmGetTypeWithKeyException:key];
    return [self convertToIntWithKey:key];
}
- (double)getDoubleWithKey:(NSString *)key {
    [self confirmGetTypeWithKeyException:key];
    return [self convertToDoubleWithKey:key];
}
- (BOOL)getBoolWithKey:(NSString *)key {
    [self confirmGetTypeWithKeyException:key];
    return [self convertToBoolWithKey:key];;
}

#pragma mark Array
- (NSString *)getStringAtIndex:(int)index {
    [self confirmGetTypeAtIndexException:index];
    return [self convertToStringAtIndex:index];
}
- (int)getIntAtIndex:(int)index {
    [self confirmGetTypeAtIndexException:index];
    return [self convertToIntAtIndex:index];
}
- (double)getDoubleAtIndex:(int)index {
    [self confirmGetTypeAtIndexException:index];
    return [self convertToDoubleAtIndex:index];
}
- (BOOL)getBoolAtIndex:(int)index {
    [self confirmGetTypeAtIndexException:index];
    return [self convertToBoolAtIndex:index];
}

#pragma mark Object
- (XYJSON *)getObject:(NSString *)key {
    [self throwSelfIsNotDictionaryException];
    [self throwKeyNotFoundExceptionWithKey:key];
    id object = [sourceObject objectForKey:key];
    return [[XYJSON alloc]initWithObject:object];
}

/**
 *  用于判断当前对象是否是Dictionary
 *
 *  @return
 */
- (BOOL)isDictionary {
    if ([sourceObject isKindOfClass:[NSMutableDictionary class]]) {
        return YES;
    }
    return NO;
}

/**
 *  用于判断当前对象是否是Array
 *
 *  @return
 */
- (BOOL)isArray {
    if ([sourceObject isKindOfClass:[NSMutableArray class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isContainKey:(NSString *)key {
    if ([sourceObject objectForKey:key] == nil) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark convertToXXXWithKey
- (NSString *)convertToStringWithKey:(NSString *)key {
    id value = [sourceObject objectForKey:key];
    if ([[[value class] description] isEqualToString:@"__NSCFNumber"]) {
        return ((NSNumber *)value).stringValue;
    } else if ([[[value class] description] isEqualToString:@"__NSCFBoolean"]) {
        return ((NSNumber *)value).stringValue;
    }else if ([[[value class] description] isEqualToString:@"__NSCFString"]) {
        return value;
    }
    return nil;
}

- (int)convertToIntWithKey:(NSString *)key {
    id value = [sourceObject objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [((NSNumber *)value) intValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        if ([self isPureInt:value] == NO) {
            @throw [NSException
                           exceptionWithName: @"JSON ConvertValueErrorException"
                           reason: [NSString stringWithFormat:@"key:%@ 对应的值转换为Int的时候发生错误",key]
                           userInfo: nil];
        }
        return [value intValue];
    }
    return 0;
}

- (double)convertToDoubleWithKey:(NSString *)key {
    id value = [sourceObject objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [((NSNumber *)value) doubleValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        if ([self isPureDouble:value] == NO) {
            @throw [NSException
                    exceptionWithName: @"JSON ConvertValueErrorException"
                    reason: [NSString stringWithFormat:@"key:%@ 对应的值转换为Double的时候发生错误",key]
                    userInfo: nil];
        }
        return [value doubleValue];
    }
    return 0.0;
}

- (BOOL)convertToBoolWithKey:(NSString *)key {
    int value = [self convertToIntWithKey:key];
    if (value == 1) {
        return YES;
    } else if (value == 0) {
        return NO;
    }
    return 0;
}

- (NSString *)convertToStringAtIndex:(int)index {
    id value = [sourceObject objectAtIndex:index];
    if ([[[value class] description] isEqualToString:@"__NSCFNumber"]) {
        return ((NSNumber *)value).stringValue;
    } else if ([[[value class] description] isEqualToString:@"__NSCFBoolean"]) {
        return ((NSNumber *)value).stringValue;
    }else if ([[[value class] description] isEqualToString:@"__NSCFString"]) {
        return value;
    }
    return nil;
}

- (int)convertToIntAtIndex:(int)index {
    id value = [sourceObject objectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [((NSNumber *)value) intValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        if ([self isPureInt:value] == NO) {
            @throw [NSException
                    exceptionWithName: @"JSON ConvertValueErrorException"
                    reason: [NSString stringWithFormat:@"index:%d 对应的值转换为Int的时候发生错误",index]
                    userInfo: nil];
        }
        return [value intValue];
    }
    return nil;
}

- (int)convertToDoubleAtIndex:(int)index {
    id value = [sourceObject objectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [((NSNumber *)value) doubleValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        if ([self isPureDouble:value] == NO) {
            @throw [NSException
                    exceptionWithName: @"JSON ConvertValueErrorException"
                    reason: [NSString stringWithFormat:@"index:%d 对应的值转换为Double的时候发生错误",index]
                    userInfo: nil];
        }
        return [value intValue];
    }
    return nil;
}

- (BOOL)convertToBoolAtIndex:(int)index {
    int value = [self convertToIntAtIndex:index];
    if (value == 1) {
        return YES;
    } else if (value == 0) {
        return NO;
    }
    return nil;
}


#pragma mark XYJSON辅助方法
/**
 *  判断是否是纯Int类型String
 *
 *  @param string
 *
 *  @return
 */
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  判断是否为Double
 *
 *  @param string
 *
 *  @return
 */
- (BOOL)isPureDouble:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    double val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
/**
 *  辅助方法 将其转换为Dictionary
 *
 *  @return
 */
- (NSMutableDictionary *)toDictionary {
    if ([self isDictionary]) {
        return (NSMutableDictionary *)sourceObject;
    }
    return nil;
}

/**
 *  辅助方法 将其转换为Array
 *
 *  @return
 */
- (NSMutableArray *)toArray {
    if ([self isArray]) {
        return (NSMutableArray *)sourceObject;
    }
    return nil;
}

/**
 *  简化验证getXXXWithKey的验证
 *
 *  @param key
 */
- (void)confirmGetTypeWithKeyException:(NSString *)key {
    [self throwSelfIsNotDictionaryException];
    [self throwKeyNotFoundExceptionWithKey:key];
    [self throwValueIsDictionaryExceptionWithkey:key];
    [self throwValueIsArrayExceptionWithkey:key];
}

/**
 *  简化验证getXXXAtIndex的验证
 *
 *  @param key
 */
- (void)confirmGetTypeAtIndexException:(int)index {
    [self throwSelfIsNotArrayException];
    [self throwIndexNotFoundExceptionAtIndex:index];
    [self throwValueIsDictionaryExceptionAtIndex:index];
    [self throwValueIsArrayExceptionAtIndex:index];
}

/**
 *  当key不存在的时候是否抛出异常，由EXCEPTION_FLAG控制
 *
 *  @param key
 *  @param value
 */
- (void)throwKeyNotFoundExceptionWithKey:(NSString *)key {
    id value = [sourceObject objectForKey:key];
    if (value == nil) {
        @throw [NSException
                exceptionWithName: @"JSON KeyNotFoundException"
                reason: [NSString stringWithFormat:@"key:%@ 不存在",key]
                userInfo: nil];
    }
}

- (void)throwValueIsNotDictionaryExceptionWithkey:(NSString *)key {
    id value = [sourceObject objectForKey:key];
    if (value == nil || [value isKindOfClass:[NSMutableDictionary class]] == NO) {
        @throw [NSException
                exceptionWithName: @"JSON ValueIsNotDictionaryException"
                reason: [NSString stringWithFormat:@"key:%@ 对应的值不是Dictionary",key]
                userInfo: nil];
    }
}

- (void)throwValueIsNotArrayExceptionWithkey:(NSString *)key {
    id value = [sourceObject objectForKey:key];
    if (value == nil || [value isKindOfClass:[NSMutableArray class]] == NO) {
        @throw [NSException
                exceptionWithName: @"JSON ValueIsNotArrayException"
                reason: [NSString stringWithFormat:@"key:%@ 对应的值不是Array",key]
                userInfo: nil];
    }
}

- (void)throwValueIsDictionaryExceptionWithkey:(NSString *)key {
    id value = [sourceObject objectForKey:key];
    if ([value isKindOfClass:[NSMutableDictionary class]] == YES) {
        @throw [NSException
                exceptionWithName: @"JSON ValueIsDictionaryException"
                reason: [NSString stringWithFormat:@"key:%@ 对应的值是Dictionary",key]
                userInfo: nil];
    }
}

- (void)throwValueIsArrayExceptionWithkey:(NSString *)key {
    id value = [sourceObject objectForKey:key];
    if ([value isKindOfClass:[NSMutableArray class]] == YES) {
        @throw [NSException
                exceptionWithName: @"JSON ValueIsArrayException"
                reason: [NSString stringWithFormat:@"key:%@ 对应的值是Array",key]
                userInfo: nil];
    }
}

- (void)throwIndexNotFoundExceptionAtIndex:(int)index {
    [sourceObject objectAtIndex:index];
}

- (void)throwValueIsNotDictionaryExceptionAtIndex:(int)index {
    id value = [sourceObject objectAtIndex:index];
    if (value == nil || [value isKindOfClass:[NSMutableDictionary class]] == NO) {
        @throw [NSException
                exceptionWithName: @"JSON ValueIsNotDictionaryException"
                reason: [NSString stringWithFormat:@"index:%d 对应的值不是Dictionary",index]
                userInfo: nil];
    }
}

- (void)throwValueIsNotArrayExceptionAtIndex:(int)index {
   id value = [sourceObject objectAtIndex:index];
    if (value == nil || [value isKindOfClass:[NSMutableArray class]] == NO) {
        @throw [NSException
                exceptionWithName: @"JSON ValueIsNotArrayException"
                reason: [NSString stringWithFormat:@"index:%d 对应的值不是Array",index]
                userInfo: nil];
    }
}

- (void)throwValueIsDictionaryExceptionAtIndex:(int)index {
    id value = [sourceObject objectAtIndex:index];
    if ([value isKindOfClass:[NSMutableDictionary class]] == YES) {
        @throw [NSException
                exceptionWithName: @"JSON ValueIsDictionaryException"
                reason: [NSString stringWithFormat:@"index:%d 对应的值是Dictionary",index]
                userInfo: nil];
    }
}

- (void)throwValueIsArrayExceptionAtIndex:(int)index {
    id value = [sourceObject objectAtIndex:index];
    if ([value isKindOfClass:[NSMutableArray class]] == YES) {
        @throw [NSException
                exceptionWithName: @"JSON ValueIsArrayException"
                reason: [NSString stringWithFormat:@"index:%d 对应的值是Array",index]
                userInfo: nil];
    }
}

- (void)throwSelfIsNotDictionaryException {
    if (sourceObject == nil || [sourceObject isKindOfClass:[NSMutableDictionary class]] == NO) {
        @throw [NSException
                exceptionWithName: @"JSON SelfIsNotDictionaryException"
                reason: [NSString stringWithFormat:@"XYJSON不是Dictionary"]
                userInfo: nil];
    }
}

- (void)throwSelfIsNotArrayException {
    if (sourceObject == nil || [sourceObject isKindOfClass:[NSMutableArray class]] == NO) {
        @throw [NSException
                exceptionWithName: @"JSON SelfIsNotArrayException"
                reason: [NSString stringWithFormat:@"XYJSON不是Array"]
                userInfo: nil];
    }
}

@end

#pragma mark - 扩展NSString
@implementation NSString (XYJSON)
- (XYJSON *)objectFromJSONString{
    NSError *error;
    XYJSON *json = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error == nil && jsonObj != nil) {
        json = [[XYJSON alloc] initWithObject:jsonObj];
    } else {
        NSLog(@"json格式有问题:%@",[error description]);
    }
    return json;
}
@end

#pragma mark - 扩展NSData
@implementation NSData (XYJSON)

- (XYJSON *)objectFromJSONData {
    NSError *error;
    XYJSON *json = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    if (error == nil && jsonObj != nil) {
        json = [[XYJSON alloc] initWithObject:jsonObj];
    } else {
        NSLog(@"json格式有问题:%@",[error description]);
    }
    return json;
}

@end