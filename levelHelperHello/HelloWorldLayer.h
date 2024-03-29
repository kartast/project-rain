//
//  HelloWorldLayer.h
//  levelHelperHello
//
//  Created by karta on 2/10/12.
//  Copyright karta 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

// Custom alert view with table
#import "SBTableAlert.h"
#import "GameObjectSpawner.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

@class LevelHelperLoader;
@class GameObjectGoal;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, SBTableAlertDelegate, SBTableAlertDataSource>
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    LevelHelperLoader* loader;
    
    BOOL bTouched;
    b2Vec2* startingPos;
    b2Vec2* startingVel;
    
    NSString* levelName;
    NSMutableArray *trajectorySprites;
    NSArray *levelsList;

    NSMutableArray* allStars;
    NSMutableArray* allStartAreas;
}

@property (nonatomic, retain) NSString* levelName;

- (id) initWithName:(NSString*)name;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
+(CCScene *) sceneWithLevel:(NSString*) levelName;

@end

