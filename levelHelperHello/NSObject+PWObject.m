//
//  NSObject+PWObject.m
//  levelHelperHello
//
//  Created by karta on 8/12/12.
//  Copyright (c) 2012 karta. All rights reserved.
//

#import "NSObject+PWObject.h"

@implementation NSObject (PWObject)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}

@end
