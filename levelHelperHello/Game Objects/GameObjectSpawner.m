//
//  GameObjectGoal.m
//  levelHelperHello
//
//  Created by karta on 13/11/12.
//  Copyright (c) 2012 karta. All rights reserved.
//

#import "GameObjectSpawner.h"

@implementation GameObjectSpawner
@synthesize nSpawnMax, sprite;

-(id)init {
    if (self = [super init])  {
        self.nSpawnMax = 3;
    }
    return self;
}

@end
