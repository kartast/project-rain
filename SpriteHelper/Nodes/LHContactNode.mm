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
#import "LHContactNode.h"
#import "LHSettings.h"
#import "LHFixture.h"

@interface LHContactNodeInfo : NSObject
{
	int tagB;
    id listenerId;
    SEL listenerSel;
}

+(id) contactInfoWithTag:(int)tagB listenerId:(id)listId listenerSel:(SEL)listSel;
-(id) initContactInfoWithTag:(int)tagB listenerId:(id)listId listenerSel:(SEL)listSel;

-(int)tagB;
-(void)callListenerWithBodyA:(b2Body*)A 
                       bodyB:(b2Body*)B 
                     contact:(b2Contact*)contact
                 contactType:(int)type
                 oldManifold:(const b2Manifold*)oldManifold
                     impulse:(const b2ContactImpulse*)impulse;
@end

@implementation LHContactNodeInfo

-(void) dealloc{
//	NSLog(@"LH CONTACT INFO DEALLOC");
#ifndef LH_ARC_ENABLED
	[super dealloc];
#endif
}
+(id) contactInfoWithTag:(int)tagB listenerId:(id)listId listenerSel:(SEL)listSel
{
#ifndef LH_ARC_ENABLED
	return [[[self alloc] initContactInfoWithTag:tagB listenerId:listId listenerSel:listSel] autorelease];
#else
    return [[self alloc] initContactInfoWithTag:tagB listenerId:listId listenerSel:listSel];
#endif
}

-(id) initContactInfoWithTag:(int)_tagB listenerId:(id)listId listenerSel:(SEL)listSel{
	if( (self=[super init])) {
		tagB = _tagB;
        listenerId = listId;
        listenerSel = listSel;
	}
	return self;
}

-(int)tagB{
    return tagB;
}
-(void)callListenerWithBodyA:(b2Body*)A 
                       bodyB:(b2Body*)B 
                     contact:(b2Contact*)contact
                 contactType:(int)type
                 oldManifold:(const b2Manifold*)oldManifold
                     impulse:(const b2ContactImpulse*)impulse{

    if(NULL == A || NULL == B || NULL == contact)
        return;
    
    LHContactInfo* info = [LHContactInfo contactInfoWithBodyA:A 
                                                        bodyB:B
                                                      contact:contact
                                                  contactType:type
                                                     manifold:oldManifold
                                                      impulse:impulse];
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [listenerId performSelector:listenerSel withObject:info];
    #pragma clang diagnostic pop
}

@end
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
void lhContact_CallPreSolveMethod(void* object, 
                                  b2Contact* contact, 
                                  const b2Manifold* oldManifold)
{
#ifndef LH_ARC_ENABLED
    [(LHContactNode*)object preSolve:contact manifold:oldManifold];
#else
    [(__bridge LHContactNode*)object preSolve:contact manifold:oldManifold];
#endif
}
////////////////////////////////////////////////////////////////////////////////
void lhContact_CallPostSolveMethod(void* object, 
                                   b2Contact* contact, 
                                   const b2ContactImpulse* impulse)
{
#ifndef LH_ARC_ENABLED
    [(LHContactNode*)object postSolve:contact impulse:impulse];    
#else
    [(__bridge LHContactNode*)object postSolve:contact impulse:impulse];    
#endif
}

void lhContact_CallBeginEndSolveMethod(void* object, 
                                       b2Contact* contact, 
                                       bool isBegin)
{
#ifndef LH_ARC_ENABLED
    [(LHContactNode*)object beginEndContact:contact isBegin:isBegin];
#else
    [(__bridge LHContactNode*)object beginEndContact:contact isBegin:isBegin];
#endif
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface LHContactNode (Private)

@end
////////////////////////////////////////////////////////////////////////////////
@implementation LHContactNode

////////////////////////////////////////////////////////////////////////////////
-(void) dealloc{	
    delete lhContactListener;
#ifndef LH_ARC_ENABLED
	[preCollisionMap release];
    [postCollisionMap release];
    [beginEndCollisionMap release];    
	[super dealloc];
#endif
}
////////////////////////////////////////////////////////////////////////////////
-(id) initContactNodeWithWorld:(b2World*)world
{
    if(0 == world)
        return nil;
    
	self = [super init];
	if (self != nil)
	{
        preCollisionMap = [[NSMutableDictionary alloc] init];
        postCollisionMap = [[NSMutableDictionary alloc] init];
        beginEndCollisionMap = [[NSMutableDictionary alloc] init];
        lhContactListener = new LHContactListener();
        world->SetContactListener(lhContactListener);
        
#ifndef LH_ARC_ENABLED
        lhContactListener->nodeObject = self;
#else
        lhContactListener->nodeObject = (__bridge void*)self;
#endif
        
        lhContactListener->preSolveSelector = &lhContact_CallPreSolveMethod;
        lhContactListener->postSolveSelector = &lhContact_CallPostSolveMethod;
        lhContactListener->beginEndSolveSelector = &lhContact_CallBeginEndSolveMethod;
	}
	return self;
}
////////////////////////////////////////////////////////////////////////////////
+(id) contactNodeWithWorld:(b2World*)world{
#ifndef LH_ARC_ENABLED
	return [[[LHContactNode alloc] initContactNodeWithWorld:world] autorelease];
#else
    return [[LHContactNode alloc] initContactNodeWithWorld:world];
#endif
}
////////////////////////////////////////////////////////////////////////////////
-(void) registerPreColisionCallbackBetweenTagA:(int)tagA 
                                       andTagB:(int)tagB 
                                    idListener:(id)obj 
                                   selListener:(SEL)selector{
    
    NSMutableDictionary* tableA = [preCollisionMap objectForKey:[NSNumber numberWithInt:tagA]];
    
    if(nil == tableA){
        LHContactNodeInfo* info = [LHContactNodeInfo contactInfoWithTag:tagB listenerId:obj listenerSel:selector];
        
        NSMutableDictionary* map = [[NSMutableDictionary alloc] init];
        [map setObject:info forKey:[NSNumber numberWithInt:tagB]];
        
        [preCollisionMap setObject:map forKey:[NSNumber numberWithInt:tagA]];
        #ifndef LH_ARC_ENABLED
        [map release];
        #endif
    }
    else
    {
        LHContactNodeInfo* info = [LHContactNodeInfo contactInfoWithTag:tagB listenerId:obj listenerSel:selector];
        [tableA setObject:info forKey:[NSNumber numberWithInt:tagB]];        
    }
    
}
////////////////////////////////////////////////////////////////////////////////
-(void) cancelPreColisionCallbackBetweenTagA:(int)tagA 
                                     andTagB:(int)tagB{
 
    NSMutableDictionary* tableA = [preCollisionMap objectForKey:[NSNumber numberWithInt:tagA]];
    
    if(nil != tableA)
    {
        [tableA removeObjectForKey:[NSNumber numberWithInt:tagB]];
    }
}

-(void) registerBeginOrEndColisionCallbackBetweenTagA:(int)tagA 
                                              andTagB:(int)tagB 
                                           idListener:(id)obj 
                                          selListener:(SEL)selector{
    
    NSMutableDictionary* tableA = [beginEndCollisionMap objectForKey:[NSNumber numberWithInt:tagA]];
    
    if(nil == tableA){
        LHContactNodeInfo* info = [LHContactNodeInfo contactInfoWithTag:tagB listenerId:obj listenerSel:selector];
        
        NSMutableDictionary* map = [[NSMutableDictionary alloc] init];
        [map setObject:info forKey:[NSNumber numberWithInt:tagB]];
        
        [beginEndCollisionMap setObject:map forKey:[NSNumber numberWithInt:tagA]];
#ifndef LH_ARC_ENABLED
        [map release];
#endif
    }
    else
    {
        LHContactNodeInfo* info = [LHContactNodeInfo contactInfoWithTag:tagB listenerId:obj listenerSel:selector];
        [tableA setObject:info forKey:[NSNumber numberWithInt:tagB]];        
    }
}

-(void) cancelBeginOrEndColisionCallbackBetweenTagA:(int)tagA 
                                            andTagB:(int)tagB{
    NSMutableDictionary* tableA = [beginEndCollisionMap objectForKey:[NSNumber numberWithInt:tagA]];
    
    if(nil != tableA)
    {
        [tableA removeObjectForKey:[NSNumber numberWithInt:tagB]];
    }
    
}

////////////////////////////////////////////////////////////////////////////////
-(void) registerPostColisionCallbackBetweenTagA:(int)tagA 
                                        andTagB:(int)tagB 
                                     idListener:(id)obj 
                                    selListener:(SEL)selector{
    NSMutableDictionary* tableA = [postCollisionMap objectForKey:[NSNumber numberWithInt:tagA]];
    
    if(nil == tableA){
        LHContactNodeInfo* info = [LHContactNodeInfo contactInfoWithTag:tagB listenerId:obj listenerSel:selector];
        
        NSMutableDictionary* map = [[NSMutableDictionary alloc] init];
        [map setObject:info forKey:[NSNumber numberWithInt:tagB]];
        
        [postCollisionMap setObject:map forKey:[NSNumber numberWithInt:tagA]];
#ifndef LH_ARC_ENABLED
        [map release];
#endif
    }
    else
    {
        LHContactNodeInfo* info = [LHContactNodeInfo contactInfoWithTag:tagB listenerId:obj listenerSel:selector];
        [tableA setObject:info forKey:[NSNumber numberWithInt:tagB]];        
    }
}
////////////////////////////////////////////////////////////////////////////////
-(void) cancelPostColisionCallbackBetweenTagA:(int)tagA 
                                      andTagB:(int)tagB{
    NSMutableDictionary* tableA = [postCollisionMap objectForKey:[NSNumber numberWithInt:tagA]];
    if(nil != tableA){
        [tableA removeObjectForKey:[NSNumber numberWithInt:tagB]];        
    }
}

////////////////////////////////////////////////////////////////////////////////
-(void)preSolve:(b2Contact*)contact                     
       manifold:(const b2Manifold*) oldManifold
{
    b2Body *bodyA = contact->GetFixtureA()->GetBody();
	b2Body *bodyB = contact->GetFixtureB()->GetBody();
	
    if(NULL == bodyA || NULL == bodyB)
        return;
        
#ifndef LH_ARC_ENABLED
    CCNode* nodeA = (CCNode*)bodyA->GetUserData();
    CCNode* nodeB = (CCNode*)bodyB->GetUserData();
#else
    CCNode* nodeA = (__bridge CCNode*)bodyA->GetUserData();
    CCNode* nodeB = (__bridge CCNode*)bodyB->GetUserData();
#endif
    
    if(NULL == nodeA || NULL == nodeB)
        return;
    
    NSMutableDictionary* info = [preCollisionMap objectForKey:[NSNumber numberWithInt:[nodeA tag]]];
    bool found = false;
    if(nil != info){
        LHContactNodeInfo* contactInfo = [info objectForKey:[NSNumber numberWithInt:[nodeB tag]]];
        if(nil != contactInfo){
            found = false;
            [contactInfo callListenerWithBodyA:bodyA 
                                         bodyB:bodyB   
                                       contact:contact
                                   contactType:-1
                                   oldManifold:oldManifold
                                       impulse:nil];
        }
    }
    
    if(!found)
    {
        info = [preCollisionMap objectForKey:[NSNumber numberWithInt:[nodeB tag]]];
        
        if(nil != info){
            LHContactNodeInfo* contactInfo = [info objectForKey:[NSNumber numberWithInt:[nodeA tag]]];
            if(nil != contactInfo)
                [contactInfo callListenerWithBodyA:bodyB 
                                             bodyB:bodyA   
                                           contact:contact
                                       contactType:-1
                                       oldManifold:oldManifold
                                           impulse:nil];
        }
    }
}
////////////////////////////////////////////////////////////////////////////////
-(void)postSolve:(b2Contact*) contact
         impulse:(const b2ContactImpulse*) impulse
{
    b2Body *bodyA = contact->GetFixtureA()->GetBody();
	b2Body *bodyB = contact->GetFixtureB()->GetBody();
	
    if(NULL == bodyA || NULL == bodyB)
        return;
#ifndef LH_ARC_ENABLED
    CCNode* nodeA = (CCNode*)bodyA->GetUserData();
    CCNode* nodeB = (CCNode*)bodyB->GetUserData();
#else
    CCNode* nodeA = (__bridge CCNode*)bodyA->GetUserData();
    CCNode* nodeB = (__bridge CCNode*)bodyB->GetUserData();
#endif
    
    if(NULL == nodeA || NULL == nodeB)
        return;

    NSMutableDictionary* info = [postCollisionMap objectForKey:[NSNumber numberWithInt:[nodeA tag]]];
    bool found = false;
    if(nil != info){
        LHContactNodeInfo* contactInfo = [info objectForKey:[NSNumber numberWithInt:[nodeB tag]]];
        if(nil != contactInfo){
            found = true;
            [contactInfo callListenerWithBodyA:bodyA 
                                         bodyB:bodyB   
                                       contact:contact
                                   contactType:-2
                                   oldManifold:nil
                                       impulse:impulse];
        }
    }
    
    if(!found)
    {
        info = [postCollisionMap objectForKey:[NSNumber numberWithInt:[nodeB tag]]];
        
        if(nil != info){
            LHContactNodeInfo* contactInfo = [info objectForKey:[NSNumber numberWithInt:[nodeA tag]]];
            if(nil != contactInfo)
                [contactInfo callListenerWithBodyA:bodyB 
                                             bodyB:bodyA   
                                           contact:contact
                                       contactType:-2
                                       oldManifold:nil
                                           impulse:impulse];
        }
    }
}

-(void) beginEndContact:(b2Contact*)contact isBegin:(bool)isBegin{
    
    b2Fixture* fixA = contact->GetFixtureA();
    b2Fixture* fixB = contact->GetFixtureB();

    if(NULL == fixA || NULL == fixB)
        return;

    b2Body *bodyA = fixA->GetBody();
	b2Body *bodyB = fixB->GetBody();

    if(NULL == bodyA || NULL == bodyB)
        return;
    
#ifndef LH_ARC_ENABLED
    CCNode* nodeA = (CCNode*)bodyA->GetUserData();
    CCNode* nodeB = (CCNode*)bodyB->GetUserData();
#else
    CCNode* nodeA = (__bridge CCNode*)bodyA->GetUserData();
    CCNode* nodeB = (__bridge CCNode*)bodyB->GetUserData();
#endif
    
    if(NULL == nodeA || NULL == nodeB)
        return;
    
    NSMutableDictionary* info = [beginEndCollisionMap objectForKey:[NSNumber numberWithInt:[nodeA tag]]];
    bool found = false;
            
    if(nil != info){
        LHContactNodeInfo* contactInfo = [info objectForKey:[NSNumber numberWithInt:[nodeB tag]]];
        
        if(nil != contactInfo)
        {
            found = true;
            [contactInfo callListenerWithBodyA:bodyA 
                                         bodyB:bodyB   
                                       contact:contact
                                   contactType:(int)isBegin
                                   oldManifold:nil
                                       impulse:nil];
        }
    }
    
    if(!found)
    {
        info = [beginEndCollisionMap objectForKey:[NSNumber numberWithInt:[nodeB tag]]];
        
        if(nil != info){
            LHContactNodeInfo* contactInfo = [info objectForKey:[NSNumber numberWithInt:[nodeA tag]]];
            if(nil != contactInfo)
                [contactInfo callListenerWithBodyA:bodyB 
                                             bodyB:bodyA   
                                           contact:contact
                                       contactType:(int)isBegin
                                       oldManifold:nil
                                           impulse:nil];
        }
    }

}
////////////////////////////////////////////////////////////////////////////////
@end
