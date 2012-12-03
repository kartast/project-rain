//
//  GameObjectGoal.h
//  levelHelperHello
//
//  Created by karta on 13/11/12.
//  Copyright (c) 2012 karta. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GoalTypeBlue=0,
    GoalTypeBlack,
    GoalTypeGreen,
    GoalTypeRed,
    GoalTypeYellow
} GoalType;

@class LHSprite;
@interface GameObjectGoal : NSObject {
    GoalType goalColor;
    int nRainCollectedCount;
    int nRainTargetCount;
    LHSprite* goalSprite;
}

@property(nonatomic, readwrite) GoalType goalColor;
@property(nonatomic, readwrite) int nRainCollectedCount;
@property(nonatomic, readwrite) int nRainTargetCount;
@property(nonatomic, retain) LHSprite* goalSprite;

@end
