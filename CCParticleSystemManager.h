//
//  CCParticleSystemManager.h
//  Bubble Duck
//
//  Created by Santiago Vassoler on 04/08/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//New copy creation, this may need updating for Cocos 2.0...
@interface CCParticleSystemQuad (MichaelBurford)
+(id)systemByCopyingParticleSystem:(CCParticleSystemQuad*)copy;
-(id)initByCopyingParticleSystem:(CCParticleSystemQuad*)copy;
@end

@interface CCParticleSystemManager : NSObject {
	NSMutableDictionary		*theCache;
}

+ (CCParticleSystemManager *)sharedParticleSystemManager;
+ (CCParticleSystemManager *)sharedManager;

-(void)preloadCacheWithType:(NSString*)type;
-(id)particleWithFile:(NSString*)type;
-(void)emptyCache;

@end