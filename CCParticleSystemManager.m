//
//  CCParticleSystemManager.m
//  Bubble Duck
//
//  Created by Santiago Vassoler on 04/08/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCParticleSystemManager.h"

@implementation CCParticleSystemQuad (MichaelBurford) 

+(id)systemByCopyingParticleSystem:(CCParticleSystemQuad*)copy {
	return [[[self alloc] initByCopyingParticleSystem:copy] autorelease];
}

-(id)initByCopyingParticleSystem:(CCParticleSystemQuad*)copy {
	// self, not super
	// this may need updating for Cocos2d 2.0...
	if ((self=[self initWithTotalParticles:copy.totalParticles])) {
		
		// angle
		angle = copy.angle;
		angleVar = copy.angleVar;
		
		// duration
		duration = copy.duration;
		
		// blend function
		blendFunc_.src = copy.blendFunc.src;
		blendFunc_.dst = copy.blendFunc.dst;
		
		// color
		startColor = copy.startColor;
		startColorVar = copy.startColorVar;
		endColor = copy.endColor;
		endColorVar = copy.endColorVar;		
		
		// particle size
		startSize = copy.startSize;
		startSizeVar = copy.startSizeVar;
		endSize = copy.endSize;
		endSizeVar = copy.endSizeVar;
		
		// position
		self.position = copy.position;
		posVar = copy.posVar;
		
		// Spinning
		startSpin = copy.startSpin;
		startSpinVar = copy.startSpinVar;
		endSpin = copy.endSpin;
		endSpinVar = copy.endSpinVar;
		
		emitterMode_ = copy.emitterMode;
		
		// Mode A: Gravity + tangential accel + radial accel
		if (emitterMode_==kCCParticleModeGravity) {
			// gravity
			mode.A.gravity = copy->mode.A.gravity;
			//
			// speed
			mode.A.speed = copy->mode.A.speed;
			mode.A.speedVar = copy->mode.A.speedVar;
			
			// radial acceleration
			mode.A.radialAccel = copy->mode.A.radialAccel;
			mode.A.radialAccelVar = copy->mode.A.radialAccelVar;
			
			// tangential acceleration
			mode.A.tangentialAccel = copy->mode.A.tangentialAccel;
			mode.A.tangentialAccelVar = copy->mode.A.tangentialAccelVar;
		}
		
		// or Mode B: radius movement
		else if( emitterMode_ == kCCParticleModeRadius ) {
			mode.B.startRadius = copy->mode.B.startRadius;
			mode.B.startRadiusVar = copy->mode.B.startRadiusVar;
			mode.B.endRadius = copy->mode.B.endRadius;
			mode.B.endRadiusVar = copy->mode.B.endRadiusVar;
			mode.B.rotatePerSecond = copy->mode.B.rotatePerSecond;
			mode.B.rotatePerSecondVar = copy->mode.B.rotatePerSecondVar;
			
		} else {
			NSAssert( NO, @"Invalid emitterType in config file");
		}
		
		// life span
		life = copy.life;
		lifeVar = copy.lifeVar;				
		
		// emission Rate
		emissionRate = totalParticles/life;
		
		// texture
		self.texture = copy.texture;
	}
	
	return self;
}

@end

@implementation CCParticleSystemManager

static CCParticleSystemManager *theCCParticleSystemManager=nil;

+ (CCParticleSystemManager *)sharedParticleSystemManager {
	if (!theCCParticleSystemManager) {
		theCCParticleSystemManager = [[CCParticleSystemManager alloc] init];
	}
	
	return theCCParticleSystemManager;
}
+ (CCParticleSystemManager *)sharedManager {
	if (!theCCParticleSystemManager) {
		theCCParticleSystemManager = [[CCParticleSystemManager alloc] init];
	}
	
	return theCCParticleSystemManager;
}

- (void)preloadCacheWithType:(NSString*)type {
	if (theCache==nil) theCache = [[NSMutableDictionary alloc] init];
	
	if ([theCache objectForKey:type]!=nil) return;
	
	CCParticleSystemQuad *psAdd = [CCParticleSystemQuad particleWithFile:type];
	[psAdd stopSystem];
	[psAdd unscheduleUpdate];
	[psAdd stopAllActions];
	[psAdd unscheduleAllSelectors];
	[theCache setObject:psAdd forKey:type];
}
- (id)particleWithFile:(NSString*)type {
	if (theCache==nil) theCache = [[NSMutableDictionary alloc] init];
	
	CCParticleSystemQuad*	item = [theCache objectForKey:type];
	
	if (item==nil) {
		//Cache miss, add it.
		item = [CCParticleSystemQuad particleWithFile:type];
		[theCache setObject:item forKey:type];
	}
	return [CCParticleSystemQuad systemByCopyingParticleSystem:item];
}
- (void)emptyCache {
	[theCache removeAllObjects];
}
- (void)dealloc {
	[theCache release];
	[super dealloc];
}

@end