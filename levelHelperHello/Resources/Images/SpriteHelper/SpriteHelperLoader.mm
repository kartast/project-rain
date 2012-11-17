//  This file was generated with SpriteHelper
//  http://spritehelper.wordpress.com
//
//  SpriteHelperLoader.mm
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

#import "SpriteHelperLoader.h"
#import "LHSettings.h"
#import "LHContactNode.h"
#import "SHDocumentLoader.h"
////////////////////////////////////////////////////////////////////////////////
@interface SpriteHelperLoader (Private)

@end

@implementation SpriteHelperLoader
////////////////////////////////////////////////////////////////////////////////

+(void) setBox2dWorld:(b2World*)world{
    [[LHSettings sharedInstance] setActiveBox2dWorld:world];
}
//------------------------------------------------------------------------------
+(LHSprite*) createSpriteWithName:(NSString*)name 
                        fromSheet:(NSString*)sheetName
                       fromSHFile:(NSString*)sceneName{
    
    return [SpriteHelperLoader createSpriteWithName:name
                                          fromSheet:sheetName
                                         fromSHFile:sceneName
                                             parent:nil];
}
//------------------------------------------------------------------------------
+(LHSprite*) createSpriteWithName:(NSString*)name 
                        fromSheet:(NSString*)sheetName
                       fromSHFile:(NSString*)SH_FileName
                      customClass:(Class)lhSpriteSubclass{
 
    return [SpriteHelperLoader createSpriteWithName:name 
                                          fromSheet:sheetName 
                                         fromSHFile:SH_FileName 
                                             parent:nil
                                        customClass:lhSpriteSubclass];
}
//------------------------------------------------------------------------------
+(LHSprite*) createSpriteWithName:(NSString*)name 
                        fromSheet:(NSString*)sheetName
                       fromSHFile:(NSString*)SH_FileName
                           parent:(CCNode*)node{
    
    return [SpriteHelperLoader createSpriteWithName:name 
                                          fromSheet:sheetName
                                         fromSHFile:SH_FileName
                                             parent:node
                                        customClass:[LHSprite class]];    
}
//------------------------------------------------------------------------------
+(LHSprite*) createSpriteWithName:(NSString*)name 
                        fromSheet:(NSString*)sheetName
                       fromSHFile:(NSString*)SH_FileName
                           parent:(CCNode*)node
                      customClass:(Class)lhSpriteSubclass{
    
    
    NSDictionary* dictionary = [[SHDocumentLoader sharedInstance] dictionaryForSpriteNamed:name 
                                                                              inSheetNamed:sheetName 
                                                                                inDocument:SH_FileName];

#ifndef LH_ARC_ENABLED
    LHSprite* sprite = [[[lhSpriteSubclass alloc] initWithDictionary:dictionary] autorelease];
#else
    LHSprite* sprite = [[lhSpriteSubclass alloc] initWithDictionary:dictionary];
#endif 
    
    if(sprite){      
        [sprite setShSceneName:SH_FileName];
    }

    if(sprite && node)
        [node addChild:sprite];
    return sprite;
    
}
//------------------------------------------------------------------------------
+(LHBatch*) createBatchWithSheetName:(NSString*)sheetName
                          fromSHFile:(NSString*)SH_FileName
{
    return [SpriteHelperLoader createBatchWithSheetName:sheetName 
                                             fromSHFile:SH_FileName parent:nil];
}
//------------------------------------------------------------------------------
+(LHBatch*) createBatchWithSheetName:(NSString*)sheetName
                          fromSHFile:(NSString*)SH_FileName
                              parent:(CCNode*)node
{
   LHBatch* batch = [LHBatch batchWithSheetName:sheetName 
                                         shFile:SH_FileName];
    
    if(batch && node)
        [node addChild:batch];
    return batch;
}


+(LHSprite*) createBatchSpriteWithName:(NSString*)spriteName batch:(LHBatch*)batch{
    return [SpriteHelperLoader createBatchSpriteWithName:spriteName 
                                                   batch:batch 
                                             customClass:[LHSprite class]];
}

+(LHSprite*) createBatchSpriteWithName:(NSString*)spriteName 
                                 batch:(LHBatch*)batch                      
                           customClass:(Class)lhSpriteSubclass{
    
    NSAssert(spriteName!=nil, @"Sprite name  must not be nil");
    NSAssert(batch!=nil, @"Batch must not be nil");
    
    NSDictionary* dictionary = [[SHDocumentLoader sharedInstance] dictionaryForSpriteNamed:spriteName 
                                                                              inSheetNamed:[batch uniqueName]
                                                                                inDocument:[batch shFile]];
#ifndef LH_ARC_ENABLED
    LHSprite* sprite = [[[lhSpriteSubclass alloc] initBatchSpriteWithDictionary:dictionary batch:batch] autorelease];
#else
    LHSprite* sprite = [[lhSpriteSubclass alloc] initBatchSpriteWithDictionary:dictionary batch:batch];
#endif     
    
    if(sprite){
        [sprite setShSceneName:[batch shFile]];
    }
    return sprite;
}


////////////////////////////////////////////////////////////////////////////////

+(void) setMeterRatio:(float)ratio{
	[[LHSettings sharedInstance] setLhPtmRatio:ratio];
}
//------------------------------------------------------------------------------
+(float) meterRatio{
	return [[LHSettings sharedInstance] lhPtmRatio];
}
//------------------------------------------------------------------------------
+(float) pixelsToMeterRatio{
    return [[LHSettings sharedInstance] lhPtmRatio]*[[LHSettings sharedInstance] convertRatio].x;
}
//------------------------------------------------------------------------------
+(float) pointsToMeterRatio{
    return [[LHSettings sharedInstance] lhPtmRatio];
}
//------------------------------------------------------------------------------
+(b2Vec2) pixelToMeters:(CGPoint)point{
    return b2Vec2(point.x / [SpriteHelperLoader pixelsToMeterRatio], point.y / [SpriteHelperLoader pixelsToMeterRatio]);
}
//------------------------------------------------------------------------------
+(b2Vec2) pointsToMeters:(CGPoint)point{
    return b2Vec2(point.x / [[LHSettings sharedInstance] lhPtmRatio], point.y / [[LHSettings sharedInstance] lhPtmRatio]);
}
//------------------------------------------------------------------------------
+(CGPoint) metersToPoints:(b2Vec2)vec{
    return CGPointMake(vec.x*[[LHSettings sharedInstance] lhPtmRatio], vec.y*[[LHSettings sharedInstance] lhPtmRatio]);
}
//------------------------------------------------------------------------------
+(CGPoint) metersToPixels:(b2Vec2)vec{
    return ccpMult(CGPointMake(vec.x, vec.y), [SpriteHelperLoader pixelsToMeterRatio]);
}
////////////////////////////////////////////////////////////////////////////////
+(void) useSpriteHelperCollisionHandling{

    b2World* world = [[LHSettings sharedInstance] activeBox2dWorld];
    NSAssert(world!=nil, @"\n\nERROR: Box2d World must not be nil - Please call [SpriteHelperLoader setBox2dWorld:world]; before registering for collision.\n\n");
    
    if([[LHSettings sharedInstance] activeContactNode] != nil)
    {
#ifndef LH_ARC_ENABLED
        [[[LHSettings sharedInstance] activeContactNode] release];
#endif
        [[LHSettings sharedInstance] setActiveContactNode:nil];
    }
    
    
    if([[LHSettings sharedInstance] activeContactNode] == nil)
    {
        LHContactNode* contactNode = [[LHContactNode alloc] initContactNodeWithWorld:world];
        [[LHSettings sharedInstance] setActiveContactNode:contactNode];
    }
}
//------------------------------------------------------------------------------
+(void) registerBeginOrEndCollisionCallbackBetweenTagA:(int)tagA
                                               andTagB:(int)tagB
                                            idListener:(id)obj
                                           selListener:(SEL)selector{
    if(nil == [[LHSettings sharedInstance] activeContactNode]){
        NSLog(@"SpriteHelper WARNING: Please call registerPreColisionCallbackBetweenTagA after useSpriteHelperCollisionHandling");
    }
    [[[LHSettings sharedInstance] activeContactNode] registerBeginOrEndColisionCallbackBetweenTagA:(int)tagA 
                                                       andTagB:(int)tagB 
                                                    idListener:obj 
                                                   selListener:selector];
    
}
+(void) cancelBeginOrEndCollisionCallbackBetweenTagA:(int)tagA
                                             andTagB:(int)tagB{
    if(nil == [[LHSettings sharedInstance] activeContactNode]){
        NSLog(@"LevelHelper WARNING: Please call registerPreColisionCallbackBetweenTagA after useSpriteHelperCollisionHandling");
    }
    [[[LHSettings sharedInstance] activeContactNode] cancelBeginOrEndColisionCallbackBetweenTagA:(int)tagA 
                                                     andTagB:(int)tagB];
    
}

+(void) registerPreCollisionCallbackBetweenTagA:(int)tagA 
                                        andTagB:(int)tagB 
                                     idListener:(id)obj 
                                    selListener:(SEL)selector{
    
    if(nil == [[LHSettings sharedInstance] activeContactNode]){
        NSLog(@"LevelHelper WARNING: Please call registerPreColisionCallbackBetweenTagA after useSpriteHelperCollisionHandling");
    }
    [[[LHSettings sharedInstance] activeContactNode] registerPreColisionCallbackBetweenTagA:(int)tagA 
                                                andTagB:(int)tagB 
                                             idListener:obj 
                                            selListener:selector];
}
//------------------------------------------------------------------------------
+(void) cancelPreCollisionCallbackBetweenTagA:(int)tagA 
                                      andTagB:(int)tagB
{
    if(nil == [[LHSettings sharedInstance] activeContactNode]){
        NSLog(@"LevelHelper WARNING: Please call registerPreColisionCallbackBetweenTagA after useSpriteHelperCollisionHandling");
    }
    [[[LHSettings sharedInstance] activeContactNode] cancelPreColisionCallbackBetweenTagA:(int)tagA 
                                              andTagB:(int)tagB];
}
//------------------------------------------------------------------------------
+(void) registerPostCollisionCallbackBetweenTagA:(int)tagA 
                                         andTagB:(int)tagB 
                                      idListener:(id)obj 
                                     selListener:(SEL)selector{
    if(nil == [[LHSettings sharedInstance] activeContactNode]){
        NSLog(@"LevelHelper WARNING: Please call registerPostColisionCallbackBetweenTagA after useSpriteHelperCollisionHandling");
    }
    [[[LHSettings sharedInstance] activeContactNode] registerPostColisionCallbackBetweenTagA:(int)tagA 
                                                 andTagB:(int)tagB 
                                              idListener:obj 
                                             selListener:selector];
    
}
//------------------------------------------------------------------------------
+(void) cancelPostCollisionCallbackBetweenTagA:(int)tagA 
                                       andTagB:(int)tagB
{
    if(nil == [[LHSettings sharedInstance] activeContactNode]){
        NSLog(@"LevelHelper WARNING: Please call registerPreColisionCallbackBetweenTagA after useSpriteHelperCollisionHandling");
    }
    [[[LHSettings sharedInstance] activeContactNode] cancelPostColisionCallbackBetweenTagA:(int)tagA 
                                               andTagB:(int)tagB];
}

@end
