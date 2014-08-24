//
//  main.m
//  XYJSON
//
//  Created by mxy on 14-8-23.
//  Copyright (c) 2014年 mxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYJSON.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        NSString *str = @"{\"a\":1.2,\"b\":\"this is dictionary\",\"c\":{\"c1\":\"this is nest dictionary\"},\"d\":[1,2,3]}";
        XYJSON *json = [str objectFromJSONString];
        NSLog([json getStringWithKey:@"a"]);
        NSLog(@"%d",[json getIntWithKey:@"a"]);
        NSLog(@"%d",[json getBoolWithKey:@"a"]);
        NSLog(@"%f",[json getDoubleWithKey:@"a"]);
        NSLog(@"--%d",[[json getObject:@"d"] getIntAtIndex:2]);
        NSLog([[json getObject:@"c"] getStringWithKey:@"c1"]);
        
        if ([json isContainKey:@"f"]) {
            NSLog(@"xxxxxxxxx");
        }
        
        
        
    }
    return 0;
}

