//
//  HelloWorldLayer.mm
//  levelHelperHello
//
//  Created by karta on 2/10/12.
//  Copyright karta 2012. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "LevelHelperLoader.h"
#import "GameConstants.h"
#import "GameObjectGoal.h"

#import "b2WorldCallbacks.h"
#import "Trajectories.h"

//-------------------
// Class TrajectoryRayCastClosestCallback
//-------------------
#ifndef DEGTORAD
#define DEGTORAD 0.0174532925199432957f
#define RADTODEG 57.295779513082320876f
#endif

// This callback finds the closest hit, optionally ignoring one particular body
class TrajectoryRayCastClosestCallback : public b2RayCastCallback
{
public:
    TrajectoryRayCastClosestCallback(b2Body* ignoreBody) : m_hit(false), m_ignoreBody(ignoreBody) {}
    TrajectoryRayCastClosestCallback() : m_hit(false) {}
    
    float32 ReportFixture(b2Fixture* fixture, const b2Vec2& point, const b2Vec2& normal, float32 fraction)
    {
        if ( fixture->GetBody() == m_ignoreBody )
            return -1;
        
        m_hit = true;
        m_point = point;
        m_normal = normal;
        return fraction;
    }
    
    b2Body* m_ignoreBody;
    bool m_hit;
    b2Vec2 m_point;
    b2Vec2 m_normal;
};
//-------------------
// End of Class TrajectoryRayCastClosestCallback
//-------------------

enum {
	kTagParentNode = 1,
};

#pragma mark - spawn touches

@interface SpawnTouches: NSObject
{
    UITouch*    touch;
    CGPoint     startPoint;
    CGPoint     endPoint;
}
@property (nonatomic, retain) UITouch* touch;
@property (nonatomic, readwrite) CGPoint startPoint;
@property (nonatomic, readwrite) CGPoint endPoint;
@end



NSMutableArray* allStars;

@implementation SpawnTouches
@synthesize touch, startPoint, endPoint;

@end

#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
@end

@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
//		CGSize s = [CCDirector sharedDirector].winSize;
		
		// init physics
		[self initPhysics];
    
        
        //create a LevelHelperLoader object that has the data of the specified level
        loader = [[LevelHelperLoader alloc] initWithContentOfFile:@"Levels/level06"];
        
        //create all objects from the level file and adds them to the cocos2d layer (self)
        [loader addObjectsToWorld:world cocos2dLayer:self];
        
        //checks if the level has physics boundaries
        if([loader hasPhysicBoundaries])
        {
            //if it does, it will create the physic boundaries
            [loader createPhysicBoundaries:world]; 
        }
        
        // Setup collision detection
        [loader useLevelHelperCollisionHandling];//necessary or else collision in LevelHelper will not be performed
        
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:BALL andTagB:BLOCK_BLACK idListener:self selListener:@selector(beginEndCollisionBetweenBallAndBlackBlock:)];
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:BALL andTagB:BLOCK_RED idListener:self selListener:@selector(beginEndCollisionBetweenBallAndRedBlock:)];
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:BALL andTagB:BLOCK_YELLOW idListener:self selListener:@selector(beginEndCollisionBetweenBallAndYellowBlock:)];
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:BALL andTagB:BLOCK_GREEN idListener:self selListener:@selector(beginEndCollisionBetweenBallAndGreenBlock:)];
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:BALL andTagB:BLOCK_BLUE idListener:self selListener:@selector(beginEndCollisionBetweenBallAndBlueBlock:)];
        
        // Setup goal collision
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:BALL andTagB:GOAL_YELLOW idListener:self selListener:@selector(collisionBallAndGoalYellow:)];
        
        // Setup star collision
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:BALL andTagB:STAR_YELLOW idListener:self selListener:@selector(collisionBallAndStar:)];
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:BALL andTagB:STAR_RED idListener:self selListener:@selector(collisionBallAndStar:)];
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:BALL andTagB:STAR_GREEN idListener:self selListener:@selector(collisionBallAndStar:)];
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:BALL andTagB:STAR_BLUE idListener:self selListener:@selector(collisionBallAndStar:)];
        [loader registerBeginOrEndCollisionCallbackBetweenTagA:BALL andTagB:STAR_BLACK idListener:self selListener:@selector(collisionBallAndStar:)];
        
        // do level setup
        [self setupLevel];
		
#if 1
		// Use batch node. Faster
		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:100];
		spriteTexture_ = [parent texture];
#else
		// doesn't use batch node. Slower
		spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"blocks.png"];
		CCNode *parent = [CCNode node];
#endif
		[self addChild:parent z:0 tag:kTagParentNode];
		
		[self scheduleUpdate];
	}
	return self;
}


#pragma mark -- 
#pragma mark Handle collision
/*
 -----------------------------
    Handle collision start
 --------------------------------
 */
-(void) beginEndCollisionBetweenBallAndBlackBlock:(LHContactInfo*)contact
{
    
    LHSprite* ballSprite = [contact spriteA];
    [ballSprite setFrame:1];
}

-(void) beginEndCollisionBetweenBallAndGreenBlock:(LHContactInfo*)contact{
    
    LHSprite* ballSprite = [contact spriteA];
    [ballSprite setFrame:2];
}

-(void) beginEndCollisionBetweenBallAndBlueBlock:(LHContactInfo*)contact{
    
    LHSprite* ballSprite = [contact spriteA];
    [ballSprite setFrame:0];
}

-(void) beginEndCollisionBetweenBallAndYellowBlock:(LHContactInfo*)contact
{

    LHSprite* ballSprite = [contact spriteA];
    [ballSprite setFrame:4];
}


-(void) beginEndCollisionBetweenBallAndRedBlock:(LHContactInfo*)contact{

    LHSprite* ballSprite = [contact spriteA];
    [ballSprite setFrame:3];
}

-(void) collisionBallAndGoalYellow:(LHContactInfo*)contact
{
    // If same color, increment goal ball count
    // otherwise decrease
    // change goal yellow frame according the the ball count
    LHSprite* ballSprite = [contact spriteA];
    LHSprite* goalSprite = [contact spriteB];
    
    [self goalHitBySprite:ballSprite andGoalSprite:goalSprite];
}

- (void)collisionBallAndStar:(LHContactInfo*)contact
{
    // If same color, increment goal ball count
    // otherwise decrease
    // change goal yellow frame according the the ball count
    LHSprite* ballSprite = [contact spriteA];
    LHSprite* goalSprite = [contact spriteB];
    
    [self starHitBySprite:ballSprite andGoalSprite:goalSprite];
}
/*
 -----------------------------
 Handle collision start
 -----------------------------
 */

#pragma mark --
#pragma mark Setup level stuffs

NSMutableArray      *goalsArray;
NSMutableDictionary *goalInfo;


-(void) setupLevel
{
    // set all goal frame to 4
//    NSArray* spritesGoalYellow = [loader spritesWithTag:GOAL_YELLOW];
//    
//    for (LHSprite *sprite in spritesGoalYellow) {
//        [sprite setFrame:GOAL_NEUTRAL_FRAME_INDEX];
//        [self goalAddSprite:sprite];
//    }
    [self findStars];
    
    
    // setup physics boundary
    if([loader hasPhysicBoundaries])
    {
        [loader createPhysicBoundaries:world];
    }
    
    // gravity 0.6 times
    world->SetGravity(b2Vec2(world->GetGravity().x * gravityMult, world->GetGravity().y * gravityMult));
}


- (void) findStars {
    NSArray* blueStars = [loader spritesWithTag:STAR_BLUE];
    NSArray* blackStars = [loader spritesWithTag:STAR_BLACK];
    NSArray* greenStars = [loader spritesWithTag:STAR_GREEN];
    NSArray* redStars = [loader spritesWithTag:STAR_RED];
    NSArray* yellowStars = [loader spritesWithTag:STAR_YELLOW];
    
    if (!allStars) {
        allStars = [[NSMutableArray alloc] init];
    }
    
    for (LHSprite* sprite in blueStars) {
        [sprite setFrame:0];
        [allStars addObject:sprite];
    }
    
    for (LHSprite* sprite in blackStars) {
        [sprite setFrame:1];
        [allStars addObject:sprite];
    }
    
    for (LHSprite* sprite in greenStars) {
        [sprite setFrame:2];
        [allStars addObject:sprite];
    }
    
    for (LHSprite* sprite in redStars) {
        [sprite setFrame:3];
        [allStars addObject:sprite];
    }
    
    for (LHSprite* sprite in yellowStars) {
        [sprite setFrame:4];
        [allStars addObject:sprite];
    }
}

#pragma mark --
#pragma mark Goal helper functions

/*
 -----------------------------
 -----------------------------
 Start of Goal helper functions
 */

-(void) goalAddSprite:(LHSprite*)spriteGoal
{
    // add goal sprite into array
    if (!goalsArray) {
        goalsArray = [[NSMutableArray alloc] init];
    }
    
    GameObjectGoal* goalObject = [[GameObjectGoal alloc] init];
    
    switch (spriteGoal.tag) {
        case GOAL_YELLOW:
            goalObject.goalColor = GoalTypeYellow;
            break;
        default:
            break;
    }
    
    goalObject.nRainCollectedCount = 0;
    goalObject.nRainTargetCount = GOAL_TARGET_COUNT;
    goalObject.goalSprite = spriteGoal;
    
    [goalsArray addObject:goalObject];
}

-(void)goalRemoveSprite:(LHSprite*)spriteGoal
{
    GameObjectGoal *goalObject;
    for (GameObjectGoal *gog in goalsArray) {
        if ([gog.goalSprite isEqual:spriteGoal]) {
            goalObject = gog;
            break;
        }
    }
    
    [goalsArray removeObject:goalObject];
}

-(void) goalHitBySprite:(LHSprite*)spriteBall andGoalSprite:(LHSprite*)spriteGoal
{
    // remove the ball
    // check goal same color or not
    if ([goalsArray count] <=0) {
        return;
    }
    
    int nBallColor = [spriteBall currentFrame];
    
    //get goal info
    GameObjectGoal* goalInfo;
    for (GameObjectGoal *gog in goalsArray) {
        if ([gog.goalSprite isEqual:spriteGoal]) {
            goalInfo = gog;
            break;
        }
    }
    
    NSAssert(goalInfo, @"must have goalinfo object");
    
    if (!goalInfo) {
        return;
    }
    
    if (goalInfo.goalColor == nBallColor) {
        //happier
        goalInfo.nRainCollectedCount++;
    }
    else {
        //sadder
        goalInfo.nRainCollectedCount--;
    }
    
    // make goal happier or sadder by changing the frame
    float fPercentageComplete = (float)goalInfo.nRainCollectedCount / (float)goalInfo.nRainTargetCount;
    int nGoalRange = GOAL_SUCCESS_FRAME_INDEX  - GOAL_NEUTRAL_FRAME_INDEX;
    int nDelta = fPercentageComplete * nGoalRange;
    int nCalculatedFrame = GOAL_NEUTRAL_FRAME_INDEX + nDelta;
    
    [spriteGoal setFrame: nCalculatedFrame];
    
    if (goalInfo.nRainCollectedCount >= goalInfo.nRainTargetCount) {
        [spriteGoal setPosition:CGPointMake(99999, 99999)];
//        [spriteGoal removeBodyFromWorld];
        [spriteGoal removeSelf];
        [spriteGoal removeFromParentAndCleanup:YES];
        [self goalRemoveSprite:spriteGoal];
    }
    
    [self performSelector:@selector(removeBall:) withObject:spriteBall afterDelay:0.04];
}

-(void)removeBall:(LHSprite*)spriteBall
{
    [spriteBall removeBodyFromWorld];
    [spriteBall removeSelf];
    [spriteBall removeFromParentAndCleanup:YES];
}

/*
  END OF GOAL HELPER FUNCTIONS
 -----------------------------
 -----------------------------
 */

-(void) starHitBySprite:(LHSprite*)spriteBall andGoalSprite:(LHSprite*)spriteGoal
{
    // remove the ball
    // check goal same color or not
    if ([allStars count] <=0) {
        return;
    }
    
    int nBallColor = [spriteBall currentFrame];

    
    if ([spriteGoal currentFrame] == [spriteBall currentFrame]) {
        // Hit !!
        // do animation
        // hide star
//        [spriteGoal removeBodyFromWorld];
        [spriteGoal removeFromParentAndCleanup:YES];
            [allStars removeObject:spriteGoal];
    }
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}	

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
//	
//	// Do we want to let bodies sleep?
//	world->SetAllowSleeping(true);
//	
//	world->SetContinuousPhysics(true);
//	
//	m_debugDraw = new GLESDebugDraw( PTM_RATIO ;
//	world->SetDebugDraw(m_debugDraw);
//	

}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();	
	
	kmGLPopMatrix();
}


-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 10;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt*1.4, velocityIterations, positionIterations);
    
    
    //Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL)
        {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
            
            if(myActor != 0)
            {
                //THIS IS VERY IMPORTANT - GETTING THE POSITION FROM BOX2D TO COCOS2D
                myActor.position = [LevelHelperLoader metersToPoints:b->GetPosition()];
                myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            }
            
        }
	}
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    for (int n = 0; n<[ballSprites count]; ++n) {
        LHSprite* mySprite = [ballSprites objectAtIndex:n];
        if (mySprite.position.x < 0 || mySprite.position.x > s.width || mySprite.position.y < 0 || mySprite.position.y>s.height){
            [mySprite removeBodyFromWorld];
            [mySprite removeFromParentAndCleanup:YES];
            [ballSprites removeObject:mySprite];

        }
    }
}

#pragma mark --
#pragma mark trajectory prediction
static int nMaxTrajectoryPoints = 10;
NSMutableArray *trajectorySprites;

b2Vec2 getTrajectoryPoint( b2Vec2& startingPosition, b2Vec2& startingVelocity, float n , b2World* world)
{
    //velocity and gravity are given per second but we want time step values here
    float t = 10 / 60.0f; // seconds per time step (at 60fps)
    b2Vec2 stepVelocity = 6.0 * t * startingVelocity; // m/s
    b2Vec2 stepGravity = t * t * world->GetGravity(); // m/s/s
    
    return startingPosition + n * stepVelocity + 0.5f * (n*n+n) * stepGravity;
}

float originalOpacity;
- (void) drawTrajectory:(CGPoint)startPos andVel:(CGPoint)startingVelocity {
    
    if (!trajectorySprites) {
        trajectorySprites = [[NSMutableArray alloc] init];
        
        for (int i = 0 ; i<nMaxTrajectoryPoints; i++) {
            LHSprite* sprite  = [loader createSpriteWithName:@"trajectory" fromSheet:@"UntitledSheet" fromSHFile:@"game_images" tag:BALL];
            [sprite setScale:0.2];
            originalOpacity = [sprite opacity];
            [trajectorySprites addObject:sprite];
        }
    }
    
    
    for (int i = 0; i < nMaxTrajectoryPoints; i++) { // three seconds at 60fps
        b2Vec2 startposition = b2Vec2(startPos.x, startPos.y);
        b2Vec2 endposition = b2Vec2(startingVelocity.x, startingVelocity.y);
        b2Vec2 trajectoryPosition = getTrajectoryPoint( startposition, endposition, i , world);
        
        
        // show sprite at pos
        LHSprite *sprite = [trajectorySprites objectAtIndex:i];
        [sprite transformPosition:CGPointMake(trajectoryPosition.x, trajectoryPosition.y)];
        
        if ( i > 0 && [self isTrajectoryCollideAtPos:CGPointMake(trajectoryPosition.x, trajectoryPosition.y) andSprite:sprite ]) {
            break;
        }
        
        
        [sprite setOpacity:originalOpacity];
    }
}

- (void) clearTrajectory
{
    for (int i = 0; i < nMaxTrajectoryPoints; i++) {
        // show sprite at pos
        LHSprite *sprite = [trajectorySprites objectAtIndex:i];
        [sprite setOpacity:0.0];
    }
}

- (BOOL) isTrajectoryCollideAtPos:(CGPoint)trajectoryPos andSprite:(LHSprite*)trajectorySprite{
    /// Check against all block
    int nStartBlock = BLOCK_START + 1;
    int nEndBlock   = BLOCK_END;
    
    // Reiterate all kind of blocks
    for (int n = nStartBlock; n < nEndBlock; n++) {
        NSArray *spritesBlock = [loader spritesWithTag:(LevelHelper_TAG)n];
        for (LHSprite* sprite in spritesBlock) {
            CGRect frame = [sprite boundingBox];
            CGRect frame2 = [trajectorySprite boundingBox];
//            if (CGRectContainsRect(frame, frame2)) {
            if (CGRectContainsPoint(frame, trajectoryPos)) {
                return YES;
            }
        }
    }
    
    return false;
}

#pragma mark --
#pragma mark Handle touches

static int nColorIndex = 0;
NSMutableArray* ballSprites;

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for( UITouch *touch in touches ) {
        [self spawnTouchStart:touch];
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for( UITouch *touch in touches ) {
        [self spawnTouchEnd:touch isEnded:false];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
	for( UITouch *touch in touches ) {
        [self spawnTouchEnd:touch isEnded:YES];
	}

}

NSMutableArray* pendingSpawners = nil;
static const float fMultiplier = 0.05;
static const int nMax = 1;
static const float fDelay = 0.2;

CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};

- (CGPoint)getStartAreaCenterNearest:(CGPoint)touchPt
{
    NSArray* startAreas = [loader spritesWithTag:START_AREA];
    touchPt = [[CCDirector sharedDirector] convertToGL: touchPt];
    
    for (LHSprite *startAreaSprite in startAreas ) {
        CGRect boundingBox = [startAreaSprite boundingBox];
        if (CGRectContainsPoint(boundingBox, touchPt)) {
            return [[CCDirector sharedDirector] convertToUI:startAreaSprite.position];
            break;
        }
    }
    return CGPointMake(-1, -1);
}

- (void)spawnTouchStart:(UITouch*)touch
{
    if (!pendingSpawners) {
        pendingSpawners = [[NSMutableArray alloc] init];
    }

    // Should ignore touch?
    CGPoint startAreaTouched = [self getStartAreaCenterNearest:[touch locationInView: [touch view]]];
    if (startAreaTouched.x == -1 && startAreaTouched.y == -1) {
        return;
    }
    
    SpawnTouches* spawnTouch = [[SpawnTouches alloc] init];
    [spawnTouch setTouch:touch];
    [spawnTouch setStartPoint:startAreaTouched];
    [pendingSpawners addObject:spawnTouch];
}

- (void)spawnTouchEnd:(UITouch*)touch isEnded:(BOOL)bEnded
{
    for ( SpawnTouches* spawnTouch in pendingSpawners ) {
        if (![spawnTouch.touch isEqual:touch]) {
            continue;
        }
        
        CGPoint start   = spawnTouch.startPoint;
        CGPoint end     = [touch locationInView:[touch view]];
        end = [[CCDirector sharedDirector] convertToGL: end];
        start = [[CCDirector sharedDirector] convertToGL: start];
        
        CGPoint direct ;
        if (ccpDistance(end, start) != 0) {
            direct  = ccpNormalize(ccpSub(end, start));
            direct = ccpMult(direct, ccpDistance(end, start)*fMultiplier);
        }else {
            direct = ccp(0, 0);
        }
        
        
		CGPoint location = start;

        NSMutableDictionary *loc = [[NSMutableDictionary alloc] init];
        [loc setValue:[NSNumber numberWithFloat:location.x] forKey:@"x"];
        [loc setValue:[NSNumber numberWithFloat:location.y] forKey:@"y"];
        [loc setValue:[NSNumber numberWithFloat:direct.x] forKey:@"velx"];
        [loc setValue:[NSNumber numberWithFloat:direct.y] forKey:@"vely"];
        [loc setValue:[NSNumber numberWithInteger:nColorIndex] forKey:@"colorIndex"];
        

        nColorIndex++;

        if(bEnded){
                NSLog(@"touch end called start:%f,%f end:%f,%f direction:%f,%f", start.x, start.y, end.x, end.y, direct.x, direct.y);
            [pendingSpawners removeObject:spawnTouch];
            [self trySpawnRainAtPosition:loc];
            
            [self clearTrajectory];
        }
        else {
            // draw trajectory
            [self clearTrajectory];
            [self drawTrajectory:location andVel:direct];
        }
    
    }
}

-(void) trySpawnRainAtPosition:(NSMutableDictionary*)loc
{
    // Check if spawn inside start area
    if (false == [self isSpawnInsideStartArea:loc]){
        
        return;
    }
    
    for (int nIndex = 0; nIndex < nMax; ++nIndex) {
        [self performSelector:@selector(addNewSpriteAtPosition:) withObject:loc afterDelay:nIndex*fDelay];
    }
}

-(void) addNewSpriteAtPosition:(NSMutableDictionary*)loc
{
    CGPoint pos = CGPointMake([[loc objectForKey:@"x"] floatValue], [[loc objectForKey:@"y"] floatValue]);
    CGPoint direct = CGPointMake([[loc objectForKey:@"velx"] floatValue], [[loc objectForKey:@"vely"] floatValue]);
    int color = [[loc objectForKey:@"colorIndex"] integerValue];
    
    LHSprite* mySprite;
    
    if ((color%3)==0) {
        mySprite = [loader createSpriteWithName:@"ball_red" fromSheet:@"UntitledSheet" fromSHFile:@"game_images" tag:BALL];
        [mySprite transformPosition:pos];
    }
    else if ((color%3)==1) {
        mySprite = [loader createSpriteWithName:@"ball_darkblue" fromSheet:@"UntitledSheet" fromSHFile:@"game_images" tag:BALL];
        [mySprite transformPosition:pos];
    }
    else if ((color%3)==2) {
        mySprite = [loader createSpriteWithName:@"ball_yellow" fromSheet:@"UntitledSheet" fromSHFile:@"game_images" tag:BALL];
        [mySprite transformPosition:pos];
    }
    
    [mySprite body]->SetLinearVelocity(b2Vec2(direct.x, direct.y));
    [mySprite body]->SetLinearDamping(-6.0);
    [mySprite prepareAnimationNamed:@"balls" fromSHScene:@"game_images"];
    
    NSLog(@"direction:%f,%f", [mySprite body]->GetLinearVelocity().x, [mySprite body]->GetLinearVelocity().y);
    
    if (!ballSprites) {
        ballSprites = [[NSMutableArray alloc]init];
    }
    
    [ballSprites addObject:mySprite];
    
}

// # Function to check whether spawn point is inside the start area
// - Doesn't support multiple start area yet

- (BOOL) isSpawnInsideStartArea:(NSMutableDictionary*)loc
{
    CGPoint spawnPos = CGPointMake([[loc objectForKey:@"x"] floatValue], [[loc objectForKey:@"y"] floatValue]);
    
    // Get the start area
    NSArray* startAreas = [loader spritesWithTag:START_AREA];
    LHSprite* spriteStartArea = [startAreas objectAtIndex:0];
    
    if (spriteStartArea == nil) {
        return false;
    }
    
    CGRect spriteBoundary = spriteStartArea.boundingBox;
    
    return CGRectContainsPoint(spriteBoundary, spawnPos);
}

#pragma mark GameKit delegate


@end
