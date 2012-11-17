//  This file was generated with SpriteHelper
//  http://www.spritehelper.org
//
//  SpriteHelperLoader.h
//  Created by Bogdan Vladu
//  Copyright 2011 Bogdan Vladu. All rights reserved.
//
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
//
//  Version history
//  v1.0 first draft for SpriteHelper 1.7
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

#import "LHBatch.h"
#import "LHSprite.h"
#import "LHContactInfo.h"

#define SPRITE_HELPER_LOADER 0x18


@interface SpriteHelperLoader : NSObject {
	
}

+(void) setBox2dWorld:(b2World*)world;

+(LHSprite*) createSpriteWithName:(NSString*)name 
                        fromSheet:(NSString*)sheetName
                       fromSHFile:(NSString*)SH_FileName;

+(LHSprite*) createSpriteWithName:(NSString*)name 
                        fromSheet:(NSString*)sheetName
                       fromSHFile:(NSString*)SH_FileName
                      customClass:(Class)lhSpriteSubclass;

+(LHSprite*) createSpriteWithName:(NSString*)name 
                        fromSheet:(NSString*)sheetName
                       fromSHFile:(NSString*)SH_FileName
                           parent:(CCNode*)node;

+(LHSprite*) createSpriteWithName:(NSString*)name 
                        fromSheet:(NSString*)sheetName
                       fromSHFile:(NSString*)SH_FileName
                           parent:(CCNode*)node
                      customClass:(Class)lhSpriteSubclass;

+(LHBatch*) createBatchWithSheetName:(NSString*)sheetName
                          fromSHFile:(NSString*)SH_FileName;

+(LHBatch*) createBatchWithSheetName:(NSString*)sheetName
                          fromSHFile:(NSString*)SH_FileName
                              parent:(CCNode*)node;


//necessary info is taking from the LHBatch instance
//make sure the batch belongs to the same SH Sheet as the sprite name
+(LHSprite*) createBatchSpriteWithName:(NSString*)spriteName
                                 batch:(LHBatch*)batch;

+(LHSprite*) createBatchSpriteWithName:(NSString*)spriteName 
                                 batch:(LHBatch*)batch                      
                           customClass:(Class)lhSpriteSubclass;

////////////////////////////////////////////////////////////////////////////////

+(void) setMeterRatio:(float)ratio;
+(float) meterRatio;
+(float) pixelsToMeterRatio;
+(float) pointsToMeterRatio;
+(b2Vec2) pixelToMeters:(CGPoint)point;
+(b2Vec2) pointsToMeters:(CGPoint)point;
+(CGPoint) metersToPoints:(b2Vec2)vec;
+(CGPoint) metersToPixels:(b2Vec2)vec;

////////////////////////////////////////////////////////////////////////////////

//COLLISION HANDLING
//see API Documentation on the website to see how to use this
+(void) useSpriteHelperCollisionHandling;

//method will be called twice per fixture, once at start and once at end of the collision".
//because bodies can be formed from multiple fixture method may be called as many times as different fixtures enter in contact.

//e.g. a car enters in collision with a stone, the stone first touched the bumper, (triggers collision 1)
//then the stone enters under the car and touches the under part of the car (trigger collision 2)
+(void) registerBeginOrEndCollisionCallbackBetweenTagA:(int)tagSpriteA
                                               andTagB:(int)tagSpriteB
                                            idListener:(id)obj
                                           selListener:(SEL)selector;

+(void) cancelBeginOrEndCollisionCallbackBetweenTagA:(int)tagSpriteA
                                             andTagB:(int)tagSpriteB;


//this methods will be called durring the lifetime of the collision - many times
+(void) registerPreCollisionCallbackBetweenTagA:(int)tagSpriteA 
                                        andTagB:(int)tagSpriteB 
                                     idListener:(id)obj 
                                    selListener:(SEL)selector;

+(void) cancelPreCollisionCallbackBetweenTagA:(int)tagSpriteA 
                                      andTagB:(int)tagSpriteB;

+(void) registerPostCollisionCallbackBetweenTagA:(int)tagSpriteA 
                                         andTagB:(int)tagSpriteB 
                                      idListener:(id)obj 
                                     selListener:(SEL)selector;

+(void) cancelPostCollisionCallbackBetweenTagA:(int)tagSpriteA 
                                       andTagB:(int)tagSpriteB;

@end

