//This header file was generated automatically by LevelHelper
//based on the class template defined by the user.
//For more info please visit: www.levelhelper.org


@interface SpriteInfo : NSObject
{


	BOOL isAbsorb;
	BOOL isRotating;
	BOOL isAmplify;
	float spawnMax;
	BOOL isMoving;


#if __has_feature(objc_arc) && __clang_major__ >= 3

#else


#endif // __has_feature(objc_arc)

}
@property BOOL isAbsorb;
@property BOOL isRotating;
@property BOOL isAmplify;
@property float spawnMax;
@property BOOL isMoving;

+(SpriteInfo*) customClassInstance;

-(NSString*) className;

-(void) setPropertiesFromDictionary:(NSDictionary*)dictionary;

@end
