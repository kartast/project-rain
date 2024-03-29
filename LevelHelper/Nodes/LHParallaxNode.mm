//  This file was generated by LevelHelper
//  http://www.levelhelper.org
//
//  LevelHelperLoader.mm
//  Created by Bogdan Vladu
//  Copyright 2011 Bogdan Vladu. All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//  The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//  Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//  This notice may not be removed or altered from any source distribution.
//  By "software" the author refers to this code file and not the application 
//  that was used to generate this file.
//
////////////////////////////////////////////////////////////////////////////////
#import "LHParallaxNode.h"
#import "LHSettings.h"
#import "LHSprite.h"
#import "LevelHelperLoader.h"
#import "LHDictionaryExt.h"
//#import <time.h>
////////////////////////////////////////////////////////////////////////////////

@interface LHSprite (LH_PARALLAX_SPRITE_EXT) 
-(void)setParallaxFollowingThisSprite:(LHParallaxNode*)par;
-(void)setSpriteIsInParallax:(LHParallaxNode*)node;
@end
@implementation LHSprite (LH_PARALLAX_SPRITE_EXT)
-(void)setParallaxFollowingThisSprite:(LHParallaxNode*)par{
    parallaxFollowingThisSprite = par;
}
-(void)setSpriteIsInParallax:(LHParallaxNode*)node{
    spriteIsInParallax = node;
}
@end

@interface LHParallaxPointObject : NSObject
{
    //CGPoint virtualPosition;
	CGPoint position;
	CGPoint	ratio;
	//CGPoint offset;
    bool isLHSprite;
	CGPoint initialPosition;
#ifndef LH_ARC_ENABLED
	CCNode *ccsprite;	//weak ref
    
#endif
}
//@property (readwrite) CGPoint virtualPosition;
@property (readwrite) CGPoint ratio;
//@property (readwrite) CGPoint offset;
@property (readwrite) bool isLHSprite;
@property (readwrite) CGPoint initialPosition;
@property (readwrite) CGPoint position;
@property (readwrite,assign) CCNode *ccsprite;
//@property (readwrite,assign) b2Body *body;

+(id) pointWithCGPoint:(CGPoint)point;
-(id) initWithCGPoint:(CGPoint)point;
@end

@implementation LHParallaxPointObject
//@synthesize virtualPosition;
@synthesize ratio;
@synthesize isLHSprite;
@synthesize initialPosition;
//@synthesize offset;
@synthesize position;
@synthesize ccsprite;
//@synthesize body;

-(void) dealloc{
	
//	NSLog(@"LH PARALLAX POINT OBJ DEALLOC");
#ifndef LH_ARC_ENABLED
	[super dealloc];
#endif
}
+(id) pointWithCGPoint:(CGPoint)_ratio{
#ifndef LH_ARC_ENABLED
	return [[[self alloc] initWithCGPoint:_ratio] autorelease];
#else
    return [[self alloc] initWithCGPoint:_ratio];
#endif
}
-(id) initWithCGPoint:(CGPoint)_ratio{
	if( (self=[super init])) {
		ratio = _ratio;
	}
	return self;
}
@end

////////////////////////////////////////////////////////////////////////////////
@interface LHParallaxNode (Private)

@end

@implementation LHParallaxNode

@synthesize isContinuous;
@synthesize direction;
@synthesize speed;
@synthesize paused;

-(void) dealloc{	

//    NSLog(@"LHParallaxNode DEALLOC %p", self);
    
    for(LHParallaxPointObject* pt in sprites){
        if(pt.ccsprite){
            if([pt.ccsprite isKindOfClass:[LHSprite class]])
                [(LHSprite*)pt.ccsprite setSpriteIsInParallax:nil];            
            if(removeSpritesOnDelete)
            {
                if(NULL != lhLoader)
                {
                    [(LHSprite*)pt.ccsprite removeSelf];
                    //[lhLoader removeSprite:(LHSprite*)pt.ccsprite];
                }
            }

        }
	}
    
	
#ifndef LH_ARC_ENABLED
    [uniqueName release];
	[sprites release];
	[super dealloc];
#endif
}
////////////////////////////////////////////////////////////////////////////////
-(id) initWithDictionary:(NSDictionary*)parallaxDict loader:(LevelHelperLoader*)loader;
{
	if( (self=[super init])) {

		//sprites = [[NSMutableArray alloc] init];
        sprites = [[CCArray alloc] init];
		isContinuous = [parallaxDict boolForKey:@"ContinuousScrolling"];
		direction = [parallaxDict intForKey:@"Direction"];
		speed = [parallaxDict floatForKey:@"Speed"];
		
        lastPosition = CGPointMake(0,0);
        self.position = CGPointMake(0, 0);
        
        paused = false;
		winSize = [[CCDirector sharedDirector] winSize];
		screenNumberOnTheRight = 1;
		screenNumberOnTheLeft = 0;
		screenNumberOnTheTop = 0;
        
        movedEndListenerObj = nil;
        movedEndListenerSEL = nil;
        
        removeSpritesOnDelete = false;
        
        lhLoader = loader;
        
        uniqueName  = [[NSString alloc] initWithString:[parallaxDict stringForKey:@"UniqueName"]];
		if(!isContinuous)
			speed = 1.0f;
        
        //time = [[NSDate date] timeIntervalSince1970];
        
        
        //[self scheduleUpdate];
        
        [self schedule: @selector(tick:) interval:1.0f/90.0f];
        
	}
	return self;
}
////////////////////////////////////////////////////////////////////////////////
+(id) nodeWithDictionary:(NSDictionary*)properties loader:(LevelHelperLoader*)loader
{
#ifndef LH_ARC_ENABLED
	return [[[self alloc] initWithDictionary:properties loader:loader] autorelease];
#else
    return [[self alloc] initWithDictionary:properties loader:loader];
#endif
}
////////////////////////////////////////////////////////////////////////////////
-(LHParallaxPointObject *) createParallaxPointObjectWithNode:(CCNode*)node
                                                       ratio:(CGPoint)ratio{
    NSAssert( node != NULL, @"Argument must be non-nil");
	
	LHParallaxPointObject *obj = [LHParallaxPointObject pointWithCGPoint:ratio];
	obj.ccsprite = node;
	obj.position = [node position];
//    obj.virtualPosition = obj.ccsprite.position;
//	obj.offset = [node position];
	obj.initialPosition = [node position];
	[sprites addObject:obj];
	//[sprite setSpriteIsInParallax:self];
	
	int scrRight = (int)(obj.initialPosition.x/winSize.width);
	
	if(screenNumberOnTheRight <= scrRight)
		screenNumberOnTheRight = scrRight+1;
    
	int scrLeft = (int)(obj.initialPosition.x/winSize.width);
    
	if(screenNumberOnTheLeft >= scrLeft)
		screenNumberOnTheLeft = scrLeft-1;
    
    
	int scrTop = (int)(obj.initialPosition.y/winSize.height);
	
	if(screenNumberOnTheTop <= scrTop)
		screenNumberOnTheTop = scrTop + 1;
	
	int scrBottom = (int)(obj.initialPosition.y/winSize.height);
    
	if(screenNumberOnTheBottom >= scrBottom)
		screenNumberOnTheBottom = scrBottom-1;
    
    return obj;
}
////////////////////////////////////////////////////////////////////////////////
-(void) addSprite:(LHSprite*)sprite 
   parallaxRatio:(CGPoint)ratio
{
    NSAssert( sprite != NULL, @"Argument must be non-nil");
    LHParallaxPointObject *obj = [self createParallaxPointObjectWithNode:sprite 
                                                                   ratio:ratio];
    
    obj.isLHSprite = true;
	[sprite setSpriteIsInParallax:self];
}
////////////////////////////////////////////////////////////////////////////////
-(void) addNode:(CCNode*)node parallaxRatio:(CGPoint)ratio{
    if([node isKindOfClass:[LHSprite class]]){
        [self addSprite:(LHSprite*)node parallaxRatio:ratio];
    }
    else{
        [self createParallaxPointObjectWithNode:node ratio:ratio];
    }
}
////////////////////////////////////////////////////////////////////////////////
-(void) removeChild:(LHSprite*)sprite{
    
    if(nil == sprite) 
        return;
        
    for(int i = 0; i < (int)[sprites count]; ++i)
    {        
        LHParallaxPointObject* pt = [sprites objectAtIndex:(NSUInteger)i];
	
        if(pt.ccsprite == sprite)
        {
			[sprites removeObjectAtIndex:(NSUInteger)i];
            break;
        }
	}
    
    if([sprites count] == 0){
        if(lhLoader)[lhLoader removeParallaxNode:self];                     
    }
}
////////////////////////////////////////////////////////////////////////////////
-(void) registerSpriteHasMovedToEndListener:(id)object selector:(SEL)method{
    movedEndListenerObj = object;
    movedEndListenerSEL = method;
}
////////////////////////////////////////////////////////////////////////////////
-(NSString*)uniqueName{
    return uniqueName;
}
////////////////////////////////////////////////////////////////////////////////
-(void) followSprite:(LHSprite*)sprite 
   changePositionOnX:(bool)xChange 
   changePositionOnY:(bool)yChange{
    
    if(NULL == sprite)
    {
        if(NULL != followedSprite)
            [followedSprite setParallaxFollowingThisSprite:NULL];
    }
    
    followedSprite = sprite;
    
    followChangeX = xChange;
    followChangeY = yChange;
    
    if(NULL != sprite)
    {
        lastFollowedSpritePosition = [sprite position];
        [sprite setParallaxFollowingThisSprite:self];
    }
}
////////////////////////////////////////////////////////////////////////////////
-(NSArray*)spritesInNode{
	
#ifndef LH_ARC_ENABLED
	NSMutableArray* sprs = [[[NSMutableArray alloc] init] autorelease];
#else
    NSMutableArray* sprs = [[NSMutableArray alloc] init];
#endif
	for(LHParallaxPointObject* pt in sprites){
		if(pt.ccsprite != nil)
			[sprs addObject:pt.ccsprite];
	}
	
	return sprs;
}
////////////////////////////////////////////////////////////////////////////////
-(CGSize) getBounds:(float)rw height:(float)rh angle:(float)radians
{
    float x1 = -rw/2;
    float x2 = rw/2;
    float x3 = rw/2;
    float x4 = -rw/2;
    float y1 = rh/2;
    float y2 = rh/2;
    float y3 = -rh/2;
    float y4 = -rh/2;
    
    float x11 = x1 * cosf(radians) + y1 * sinf(radians);
    float y11 = -x1 * sinf(radians) + y1 * cosf(radians);
    float x21 = x2 * cosf(radians) + y2 * sinf(radians);
    float y21 = -x2 * sinf(radians) + y2 * cosf(radians);
    float x31 = x3 * cosf(radians) + y3 * sinf(radians);
    float y31 = -x3 * sinf(radians) + y3 * cosf(radians);
    float x41 = x4 * cosf(radians) + y4 * sinf(radians);
    float y41 = -x4 * sinf(radians) + y4 * cosf(radians);

    float x_minim = MIN(MIN(x11,x21),MIN(x31,x41));
    float x_max = MAX(MAX(x11,x21),MAX(x31,x41));
    
    float y_minim = MIN(MIN(y11,y21),MIN(y31,y41));
    float y_max = MAX(MAX(y11,y21),MAX(y31,y41));
 
    return CGSizeMake(x_max-x_minim, y_max-y_minim);
}
////////////////////////////////////////////////////////////////////////////////
-(void)repositionPoint:(LHParallaxPointObject*)point frameTime:(double)frameTime
{
#pragma unused(frameTime)
    
    CGSize spriteContentSize = [point.ccsprite contentSize];
    CGPoint spritePosition = [point.ccsprite position];
    float angle = [point.ccsprite rotation];
    float rotation = CC_DEGREES_TO_RADIANS(angle);
	float scaleX = [point.ccsprite scaleX];
	float scaleY = [point.ccsprite scaleY];
    
    CGSize contentSize = [self getBounds:spriteContentSize.width//*2.0f
                                  height:spriteContentSize.height//*2.0f
                                   angle:rotation];

//    CGSize contentSize = [self getBounds:spriteContentSize.width*2.0f
//                                  height:spriteContentSize.height*2.0f
//                                   angle:rotation];
        
	switch (direction) {
		case 1: //right to left
		{
            if(spritePosition.x + contentSize.width/2.0f*scaleX <= 0)
                            
//			if(spritePosition.x + contentSize.width*scaleX <= 0)
			{
                if(nil != point.ccsprite){
                    float difX = spritePosition.x;
                                        
                    CGPoint newPos = CGPointMake(winSize.width*screenNumberOnTheRight + difX,
                                                 spritePosition.y);

             
                    if(point.isLHSprite)
                    {
                        [(LHSprite*)point.ccsprite transformPosition:newPos];
                    }
                    else {
                        [point.ccsprite setPosition:newPos];
                    }
                }
                    
                
                if(nil != movedEndListenerObj && nil != movedEndListenerSEL){
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [movedEndListenerObj performSelector:movedEndListenerSEL withObject:point.ccsprite];
                    #pragma clang diagnostic pop
                }
			}
		}	
			break;
			
		case 0://left to right
		{
            if(spritePosition.x - contentSize.width/2.0f*scaleX >= winSize.width)
//			if(spritePosition.x - contentSize.width*scaleX >= winSize.width)
			{
				float difX = spritePosition.x - winSize.width;
				
                CGPoint newPos = CGPointMake(winSize.width*screenNumberOnTheLeft + difX,
                                             spritePosition.y);

                if(point.isLHSprite)
                {
                    [(LHSprite*)point.ccsprite transformPosition:newPos];
                }
                else {
                    [point.ccsprite setPosition:newPos];
                }
                
                if(nil != movedEndListenerObj && nil != movedEndListenerSEL){
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [movedEndListenerObj performSelector:movedEndListenerSEL withObject:point.ccsprite];
                     #pragma clang diagnostic pop
                }
			}
		}
			break;
			
		case 2://up to bottom
		{
            if(spritePosition.y + contentSize.height/2.0f*scaleY <= 0)
//			if(spritePosition.y + contentSize.height*scaleY <= 0)
			{
				float difY = spritePosition.y;
				
                CGPoint newPos = CGPointMake(spritePosition.x,
                                             winSize.height*screenNumberOnTheTop +difY);
                
                
                if(point.isLHSprite)
                {
                    [(LHSprite*)point.ccsprite transformPosition:newPos];
                }
                else {
                    [point.ccsprite setPosition:newPos];
                }
                                
                if(nil != movedEndListenerObj && nil != movedEndListenerSEL){
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [movedEndListenerObj performSelector:movedEndListenerSEL withObject:point.ccsprite];
                    #pragma clang diagnostic pop
                }
			}
		}
			break;
			
		case 3://bottom to top
		{
            if(spritePosition.y - contentSize.height/2.0f*scaleY >= winSize.height)
//			if(spritePosition.y - contentSize.height*scaleY >= winSize.height)
			{
				float difY = spritePosition.y - winSize.height;
				               
                CGPoint newPos = CGPointMake(spritePosition.x,
                                             winSize.height*screenNumberOnTheBottom + difY);
                
                if(point.isLHSprite)
                {
                    [(LHSprite*)point.ccsprite transformPosition:newPos];
                }
                else {
                    [point.ccsprite setPosition:newPos];
                }
                                
                if(nil != movedEndListenerObj && nil != movedEndListenerSEL){
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [movedEndListenerObj performSelector:movedEndListenerSEL withObject:point.ccsprite];
                    #pragma clang diagnostic pop
                }
			}
		}
			break;
		default:
			break;
	}
}

-(void) tick: (ccTime) dt
{    
    if([[LHSettings sharedInstance] levelPaused] || paused) //level is paused
    {
       // time = [[NSDate date] timeIntervalSince1970];
        return;
    }
        
    if(NULL != followedSprite)
    {
        CGPoint spritePos = [followedSprite position];
        float deltaFX = lastFollowedSpritePosition.x - spritePos.x;
        float deltaFY = lastFollowedSpritePosition.y - spritePos.y;
        lastFollowedSpritePosition = spritePos;
        
        CGPoint lastNodePosition = [self position];        
        if(followChangeX && !followChangeY){
            [super setPosition:ccp(lastNodePosition.x + deltaFX, 
                                   lastNodePosition.y)];
        }
        else if(!followChangeX && followChangeY){
            [super setPosition:ccp(lastNodePosition.x, 
                                   lastNodePosition.y + deltaFY)];
        }
        else if(followChangeX && followChangeY){
            [super setPosition:ccp(lastNodePosition.x + deltaFX, 
                                   lastNodePosition.y + deltaFY)];
        }
    }
    
    double i = -1.0f; //direction left to right //bottom to up
	CGPoint pos = [self position];
    
    CGPoint deltaPos = CGPointMake(pos.x - lastPosition.x,
                                   pos.y - lastPosition.y);
    
	if(isContinuous || ! CGPointEqualToPoint(pos, lastPosition)) 
	{
        float   frameTime = dt;//[[NSDate date] timeIntervalSince1970] - time;
        
		for(LHParallaxPointObject *point in sprites){
            i = -1.0f; //direction left to right //bottom to up
            if(direction == 1 || direction == 2) //right to left //up to bottom
                i = 1.0f;
            
            LHSprite* spr = (LHSprite*)point.ccsprite;
            CGPoint oldPos = [spr position];
            
            
            if(isContinuous)
            {
                [spr transformPosition:CGPointMake((float)(oldPos.x - i*point.ratio.x*speed*frameTime),
                                                   (float)(oldPos.y - i*point.ratio.y*speed*frameTime))];
            
                [self repositionPoint:point frameTime:frameTime];
            }
            else {
                
                [spr transformPosition:CGPointMake(oldPos.x + point.ratio.x*deltaPos.x/*2.0f*frameTime*/,
                                                   oldPos.y + point.ratio.y*deltaPos.y/*2.0f*frameTime*/)];
                
                
            }
		}
	}
    lastPosition = pos;
//	time = [[NSDate date] timeIntervalSince1970];
}
				   
@end
