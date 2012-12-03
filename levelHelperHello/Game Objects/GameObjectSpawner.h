//
//  GameObjectGoal.h
//  levelHelperHello
//
//  Created by karta on 13/11/12.
//  Copyright (c) 2012 karta. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LHSprite;
@interface GameObjectSpawner : NSObject {
    int nSpawnMax;
    LHSprite* sprite;
}

@property(nonatomic, readwrite) int nSpawnMax;
@property(nonatomic, retain) LHSprite* sprite;

@end
