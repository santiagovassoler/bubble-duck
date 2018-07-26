//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble

@synthesize hp = _curHp;
@synthesize minMoveDuration = _minMoveDuration;
@synthesize maxMoveDuration = _maxMoveDuration;
@synthesize runAction = _runAction;

@end

@implementation BadFastBubble

+ (id)bubble {
 
    BadFastBubble *bubble = nil;
    if ((bubble = [[[super alloc] initWithSpriteFrameName:@"badbubble-1.png"] autorelease])) {
        bubble.hp = 1;
        bubble.minMoveDuration = 5;
        bubble.maxMoveDuration = 8;
	
		
		NSMutableArray *runAnimFrames = [NSMutableArray array];
		for (int i = 1 ; i <= 14 ; i++) {
			[runAnimFrames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:@"badbubble-%d.png", i ]]];
		}
	//	self.hero = [CCSprite spriteWithSpriteFrameName:@"duck-1.png"];
	//	_hero.anchorPoint = CGPointZero;
	//	_hero.position = self.heroRunningPosition;
	//	_hero.tag = 1;
		
		CCAnimation *runAnim = [CCAnimation animationWithFrames:runAnimFrames delay:0.07f];
		CCAction  *teste = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:FALSE]];
		
		[bubble runAction:teste];
	
    }
    return bubble;
    
}
//[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
@end

@implementation GoodSlowBubble

+ (id)bubble {
    
   GoodSlowBubble  *bubble = nil;
	
   
	if ((bubble = [[[super alloc]initWithSpriteFrameName:@"bubble-1.png"] autorelease])) { 
		bubble.hp = 0;
        bubble.minMoveDuration = 9;
        bubble.maxMoveDuration = 12;
		
		
		NSMutableArray *runAnimFrames = [NSMutableArray array];
		for (int i = 1 ; i <= 13 ; i++) {
			[runAnimFrames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:@"bubble-%d.png", i ]]];
		}
		//	self.hero = [CCSprite spriteWithSpriteFrameName:@"duck-1.png"];
		//	_hero.anchorPoint = CGPointZero;
		//	_hero.position = self.heroRunningPosition;
		//	_hero.tag = 1;
		
		CCAnimation *runAnim = [CCAnimation animationWithFrames:runAnimFrames delay:0.07f];
		CCAction  *teste = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:FALSE]];
		
		[bubble runAction:teste];
		
    
	
    }
    return bubble;
    
}

@end