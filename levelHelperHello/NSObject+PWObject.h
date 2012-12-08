//
//  NSObject+PWObject.h
//  levelHelperHello
//
//  Created by karta on 8/12/12.
//  Copyright (c) 2012 karta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PWObject)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
