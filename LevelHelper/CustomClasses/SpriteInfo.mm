//This source file was generated automatically by LevelHelper
//based on the class template defined by the user.
//For more info please visit: www.levelhelper.org


#import "SpriteInfo.h"

@implementation SpriteInfo


@synthesize isAbsorb;
@synthesize isRotating;
@synthesize isAmplify;
@synthesize isMoving;


-(void) dealloc{
#if __has_feature(objc_arc) && __clang_major__ >= 3

#else


[super dealloc];

#endif // __has_feature(objc_arc)
}

+(SpriteInfo*) customClassInstance{
#if __has_feature(objc_arc) && __clang_major__ >= 3
return [[SpriteInfo alloc] init];
#else
return [[[SpriteInfo alloc] init] autorelease];
#endif
}

-(NSString*) className{
return NSStringFromClass([self class]);
}
-(void) setPropertiesFromDictionary:(NSDictionary*)dictionary
{

	if([dictionary objectForKey:@"isAbsorb"])
		[self setIsAbsorb:[[dictionary objectForKey:@"isAbsorb"] boolValue]];

	if([dictionary objectForKey:@"isRotating"])
		[self setIsRotating:[[dictionary objectForKey:@"isRotating"] boolValue]];

	if([dictionary objectForKey:@"isAmplify"])
		[self setIsAmplify:[[dictionary objectForKey:@"isAmplify"] boolValue]];

	if([dictionary objectForKey:@"isMoving"])
		[self setIsMoving:[[dictionary objectForKey:@"isMoving"] boolValue]];

}

@end
