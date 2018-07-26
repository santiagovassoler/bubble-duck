//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//


#import "GameLayer.h"
#import "MovingPlatform.h"
#import "Bubble.h"
#import "HelloWorldLayer.h"
#import "GameOverLayer.h"
#import "MenuLayer.h"
#import "SimpleAudioEngine.h"
#import "CCParticleSystemManager.h"

@interface GameLayer ()
-(void)CreateSprites;
-(void)initPlatform;
-(void)createHero;
-(void)changeHeroImageDuringJump;
-(void)createParallax;
-(void)addTarget;
-(void)increaseDifficulty;
-(void)initScore;
-(void)BubblesCollecteds;
-(void)addBadTarget;
-(void)CallSecondUpdate;
-(void)AddGoodTargetToScene;
-(void)addBadTargetToScene;
-(void)saveScore;
-(void)resumeButton;
-(void)retryButton;
-(void)menuButton;
-(void)CreateLayerGo;
-(void)pauseButtonPressed;
@end



@implementation GameLayer
@synthesize hero = _hero;
@synthesize runAction = _runAction;
@synthesize heroRunningPosition;
@synthesize isJumping;
@synthesize isGap;
@synthesize jumpVelocity;
@synthesize scoreVelocity = _scoreVelocity;
@synthesize scoreBubble = _scoreBubble;
@synthesize called;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];

		
		 called = NO;
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(pauseButtonPressed)
													 name:UIApplicationDidBecomeActiveNotification object:nil];
												
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(pausedonGameLayer)
													 name:UIApplicationWillResignActiveNotification object:nil];
		
		
		
		if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"funhouse.aifc" loop:YES];
		
		NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
		if ([usrDef boolForKey:@"sound"] == YES){
			[[SimpleAudioEngine sharedEngine]stopEffect:jumpSoundEffectID];
		}
		if ([usrDef boolForKey:@"music"] == YES){
			[[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
			
		}
		
		
		
		pauseButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pausebutton.png"] 
											  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"pausebutton.png"]
													  target:self
													selector:@selector(pauseButtonPressed)];
		menuPauseInit = [CCMenu menuWithItems:pauseButton, nil ];
		menuPauseInit.position = ccp (pauseButton.contentSize.width, winSize.height - 25);
		[self addChild:menuPauseInit];
		

		_targets = [[NSMutableArray alloc] init];
		
		CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(207,243,255, 255)];
		[self addChild:colorLayer z:-1];
		
		_scoreBubble = -1;
		score = 0;		

		self.isTouchEnabled = YES;
		isJumping = NO;
        isGap = NO;
        jumpVelocity = CGPointZero;
		
	
		
		BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
		iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
		if (iPad) {
			heroRunningPosition = ccp(winSize.width * 0.25, winSize.height/2.66  - kPlatformHeadSize);
				}
		else
		{
			heroRunningPosition = ccp(winSize.width * 0.25, winSize.height * 0.39 - kPlatformHeadSize);
		}
		
		[self CreateSprites];
		[self createHero];
		[self initPlatform];
		[self createParallax];
		[self initScore];
		[self BubblesCollecteds];
		[self CallSecondUpdate];
		[self AddGoodTargetToScene];
		[self addBadTargetToScene];
		[self CreateLayerGo];
			
	}
	return self;
}


-(void)AddGoodTargetToScene{
	[self schedule:@selector(gameLogicGoodTarget:) interval:0.8f];	
}
-(void)addBadTargetToScene{
	[self schedule:@selector(gameLogicBadTarget:) interval:8.0f];
}

-(void)gameLogicGoodTarget:(ccTime)dt {
	[self addTarget];
}
-(void)gameLogicBadTarget:(ccTime)dt {
	[self addBadTarget];
}

-(void)CallSecondUpdate{
	[self schedule:@selector(update2:)];
}

-(void)spriteMoveFinished:(id)sender {
    
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
	
	if (sprite.tag == 1) { // target
		[_targets removeObject:sprite];
		
//	} else if (sprite.tag == 2) { // projectile
//		[_projectiles removeObject:sprite];
	}
	
}
-(void)createParallax{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
//	parallax = [[[CCParallaxScrollNode alloc] init] retain];	
	BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
	iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
	if (iPad) {
					parallax = [CCParallaxScrollNode makeWithBatchFile:@"Options-ipad"];
	}
	else
	{
						parallax = [CCParallaxScrollNode makeWithBatchFile:@"Options"];
			}
	
	
//	parallax = [CCParallaxScrollNode makeWithBatchFile:@"Options"];
	
	cogumelo = [CCSprite spriteWithSpriteFrameName:@"matocomcogumelo.png"];
	cogumelo2 = [CCSprite spriteWithSpriteFrameName:@"matocomcogumelo.png"];
	[parallax addInfiniteScrollXWithZ:1 Ratio:ccp(0.5,0.5) Pos:ccp(0, winSize.height/3.8) Objects:cogumelo, cogumelo2, nil];
	
	predios = [CCSprite spriteWithSpriteFrameName:@"building.png"];
	predios2 = [CCSprite spriteWithSpriteFrameName:@"building.png"];
	[parallax addInfiniteScrollXWithZ:0 Ratio:ccp(0.05,0.1) Pos:ccp(0,winSize.height/2.2) Objects:predios,predios2, nil];
	
	montanha = [CCSprite spriteWithSpriteFrameName:@"montanha.png"];
	montanha2 = [CCSprite spriteWithSpriteFrameName:@"montanha.png"];
	[parallax addInfiniteScrollXWithZ:0 Ratio:ccp(0.15,0.1) Pos:ccp(0,winSize.height/2.6) Objects:montanha,montanha2, nil]; 
	
	backwater = [CCSprite spriteWithSpriteFrameName:@"backwater.png"]; 
	backwater2 = [CCSprite spriteWithSpriteFrameName:@"backwater.png"];
	[parallax addInfiniteScrollXWithZ:2 Ratio:ccp(-0.2,-0.2) Pos:ccp(0,winSize.height/4.7) Objects:backwater,backwater2, nil]; 
	
	frontwater = [CCSprite spriteWithSpriteFrameName:@"frontwater.png"];
	frontwater2 = [CCSprite spriteWithSpriteFrameName:@"frontwater.png"];
	[parallax addInfiniteScrollXWithZ:3 Ratio:ccp(0.4,0.4) Pos:ccp(0,winSize.height/4.7)Objects:frontwater,frontwater2, nil]; 
	
	
	[self addChild:parallax z:-1];
	[self schedule:@selector(updateParallax:)];
	
}
-(void) updateParallax:(ccTime)dt {
	[parallax updateWithVelocity:ccp(-4,0) AndDelta:dt];
}

-(void)CreateSprites {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	agua = [CCSprite spriteWithSpriteFrameName:@"water.png"];
	agua.position = ccp (winSize.width/2 , winSize.height/6.5);
	[self addChild:agua z:-1];
	
	
}

-(void)createHero{
		
	NSMutableArray *runAnimFrames = [NSMutableArray array];
		for (int i = 1 ; i <= 7 ; i++) {
			[runAnimFrames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:@"duck-%d.png", i ]]];
		}
	self.hero = [CCSprite spriteWithSpriteFrameName:@"duck-1.png"];
	_hero.anchorPoint = CGPointZero;
    _hero.position = self.heroRunningPosition;
	_hero.tag = 1;
    
    CCAnimation *runAnim = [CCAnimation animationWithFrames:runAnimFrames delay:0.15f];
	self.runAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:FALSE]];
    
    [_hero runAction:_runAction];
	[self addChild:_hero z:1];
}
-(void)addBadTarget{
	Bubble *target = nil;
    target = [BadFastBubble bubble];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
		
	int minY = target.contentSize.height/2;
	int maxY = winSize.height - target.contentSize.height/2;
	
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
	
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	[self addChild:target z:1];
	
	
	int minDuration = target.minMoveDuration; 
	int maxDuration = target.maxMoveDuration; 
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	
	id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	[_targets addObject:target];

	
	
	
}
-(void)addTarget {
    
    Bubble *target = nil;
	target = [GoodSlowBubble bubble];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int minY = target.contentSize.height/2;
	int maxY = winSize.height - target.contentSize.height/2;

	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
	
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	[self addChild:target z:1];
	

	int minDuration = target.minMoveDuration; 
	int maxDuration = target.maxMoveDuration; 
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	

	id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	

	target.tag = 1;
	[_targets addObject:target];
	
}
- (void)update2:(ccTime)dt {
	NSMutableArray *targetpradeletar = [[NSMutableArray alloc] init];
	for (CCSprite *target in _targets) {
		
		CGRect targetRect = CGRectMake(
									   target.position.x + (target.contentSize.width/2),
									   target.position.y + (target.contentSize.height/2),
									   target.contentSize.width,
									   target.contentSize.height/6);
		CGRect heroRect = CGRectMake(
									 _hero.position.x + (_hero.contentSize.width/2),
									 _hero.position.y + (_hero.contentSize.height/2),
									 _hero.contentSize.width,
									 _hero.contentSize.height);
		
		if(CGRectIntersectsRect(targetRect, heroRect)){
		
			Bubble *bubble = (Bubble *)target;
			
				if (bubble.hp <=0) {
					[self BubblesCollecteds];
					
					CCParticleSystemQuad *particles = [[CCParticleSystemManager sharedManager]particleWithFile:@"popping.plist"];//[CCParticleSystemQuad particleWithFile:@"estrelas.plist"];
					[particles setPosition:target.position];
					 particles.autoRemoveOnFinish = YES;
					 [self addChild:particles];
				
								
					
					
					NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
					if ([usrDef boolForKey:@"sound"] == YES){
						[[SimpleAudioEngine sharedEngine]stopEffect:jumpSoundEffectID];
					} else {
						jumpSoundEffectID = [[SimpleAudioEngine sharedEngine]playEffect:@"chime.caf"];
					}
			        [targetpradeletar addObject:target];
				}else {
					[self saveScore];
				
				}

			break;
		}
	}
	
	for (CCSprite *target in targetpradeletar) {
		[_targets removeObject:target];
		
		[self removeChild:target cleanup:YES];
		
	}
	[targetpradeletar release];
	
}
- (void) initPlatform
{
    CCArray *images = [[CCArray alloc] initWithCapacity:3];
	
	[images addObject:@"platform.png"];
    [images addObject:@"platform.png"];
	[images addObject:@"platform.png"];
//	[images addObject:[CCSprite spriteWithSpriteFrameName:@"platform.png"]];
//  [images addObject:[CCSprite spriteWithSpriteFrameName:@"platform.png"]];
//	[images addObject:[CCSprite spriteWithSpriteFrameName:@"platform.png"]];
	
    platform = [[MovingPlatform alloc] initWithSpeed:kInitialSpeed andPause:NO andImages:images];
    [images autorelease];
    [self addChild:platform z:0];
//	[spriteNode.parent addChild:platform z:0];
	[self scheduleUpdate];
	
}
-(void)saveScore{
	
	[[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
	_hero.visible = NO;
    [platform paused:YES];
    [_hero stopAllActions];
    [self unscheduleAllSelectors];
	score = _scoreBubble+_scoreVelocity;
	
		
		CCScene *scene = [CCScene node];
		GameOverLayer *layer = [[GameOverLayer alloc]initWithScore:score];
		[scene addChild:layer];	
	
		[[CCDirector sharedDirector]replaceScene:scene];
	 
	}

-(void) update:(ccTime)dt
{
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
    CGPoint returnedCoordinate = [platform getYCoordinateAt:heroRunningPosition];    
    if (heroRunningPosition.y != returnedCoordinate.y) {
        heroRunningPosition = ccp(heroRunningPosition.x, returnedCoordinate.y - kPlatformHeadSize);
    }
    
    if (returnedCoordinate.x <= 0 && returnedCoordinate.y <= 0) {
        isGap = YES;
        heroRunningPosition = ccp(heroRunningPosition.x, -_hero.textureRect.size.height);
        if (isJumping == NO) {
            jumpVelocity = ccpAdd(jumpVelocity, ccp(0,kGravityFactor));
            _hero.position = ccpAdd(_hero.position, jumpVelocity);
            if (_hero.position.y < heroRunningPosition.y) {
				[self saveScore];
		            }
        }
    } else {
        isGap = NO;
    }
    
    if (_hero.position.y < heroRunningPosition.y) {
        if (jumpVelocity.y >= 0) {
            _hero.position = ccp(heroRunningPosition.x - _hero.textureRect.size.width*2, 
                                 heroRunningPosition.y);
        }
        jumpVelocity = ccpAdd(jumpVelocity, ccp(0,kGravityFactor));
        _hero.position = ccpAdd(_hero.position, jumpVelocity);
        [platform paused:YES];
        [_hero stopAllActions];
        if (_hero.position.y < -winSize.height) {
			[self saveScore];		
        }
    }
}


-(void)jump:(ccTime)delta 
{	
	if (isJumping == YES) {
        if (jumpVelocity.y < 0 && 
            _hero.position.y > heroRunningPosition.y &&
            _hero.position.y < heroRunningPosition.y + _hero.textureRect.size.height) {
            //hero landed
            _hero.position = heroRunningPosition;
            jumpVelocity = CGPointZero;
            
            [self unschedule:@selector(jump:)];
            isJumping = NO;
            //NSLog(@"run action.");
            if (_hero.position.y <= heroRunningPosition.y) [_hero runAction:_runAction];
            
        } else {
			//make the hero jump with gravity=-1
            jumpVelocity = ccpAdd(jumpVelocity, ccp(0,kGravityFactor));
            _hero.position = ccpAdd(_hero.position, jumpVelocity);
            //change jumping image
            [_hero stopAllActions];
            [self changeHeroImageDuringJump];
		}
	}
}
-(void)BubblesCollecteds{
	self.scoreBubble++;
	[scoreLayer.label2 setString:[NSString stringWithFormat:@"%d", _scoreBubble]];
}

- (void) increaseDifficulty
{
	platform.platformSpeed += kDifficultySpeed;
}
-(void)pausedonGameLayer{
	[self removeChild:colorPauseLayer cleanup:YES];
	[self removeChild:panel cleanup:YES];
	[self removeChild:menuPause cleanup:YES];
	
}
-(void)pauseButtonPressed{
	NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
	if ([usr boolForKey:@"sound"] == NO){
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
		
	self.isTouchEnabled = NO;
	menuPauseInit.visible = NO;
	[self pauseSchedulerAndActions];
	[platform pauseSchedulerAndActions];
	[_hero stopAllActions];
	
	Bubble *target;
	target = nil;
	
	for (target in _targets) {
		[[CCActionManager sharedManager]pauseTarget:target];
	}
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	panel = [CCSprite spriteWithSpriteFrameName:@"panel.png"];
	panel.position = ccp ( winSize.width/2 , winSize.height/2);

	[self addChild:panel z:99];
	panel.scale = 0.1;
	
	id a = [CCScaleBy actionWithDuration:0.2f scale:10];
	CCEaseOut *squeze1 = [CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:.02f scaleX:1 scaleY:1]];
	CCEaseIn *expand1 = [CCEaseElasticIn actionWithAction:[CCScaleTo actionWithDuration:.5f scaleX:.8  scaleY:1.5]];
	CCEaseOut *squeze2 = [CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:.5f scaleX:1 scaleY:1]];
	
	id s = [CCSequence actions:a,squeze1,expand1,squeze2, nil];
	[panel runAction:s];
	
	title = [CCSprite spriteWithSpriteFrameName:@"paused.png"];
	title.position = HD_CCP((winSize.width/3.5) , (winSize.height/1.58)));
	[panel addChild:title z:9];
	
		
	colorPauseLayer = [CCLayerColor layerWithColor:ccc4(150, 150, 150, 115)];
	[self addChild:colorPauseLayer z:98];
	
	
	
	soundButton = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"sound.png"]
										   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"sound2.png"] 
												   target:nil selector:nil] retain];
	
	
	soundDisabledButton = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"soundoff.png"]
												   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"soundoff.png"] 
														   target:nil selector:nil] retain];
	
	
	
	musicButton = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"music.png"]
										   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"music2.png"] 
												   target:nil selector:nil] retain];
	
	
	musicDisabledButton = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"musicoff.png"]
												   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"musicoff.png"] 
														   target:nil selector:nil] retain];
	
	
	toggleItem = [CCMenuItemToggle itemWithTarget:
				  self selector:@selector(soundDisabledButtonTapped:) items:soundButton, soundDisabledButton,nil];
	
	toggleItem2 = [CCMenuItemToggle itemWithTarget:
				   self selector:@selector(musicDisabledButtonTapped:) items:musicButton, musicDisabledButton, nil]; 
	
	
	retryButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"retrybutton.png"] 
										  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"retrybutton2.png"]
												  target:self
												selector:@selector(retryButton)];
	
	menuButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"mainmenubutton.png"] 
										 selectedSprite:[CCSprite spriteWithSpriteFrameName:@"mainmenubutton2.png"]
												 target:self
											   selector:@selector(menuButton)];
	
	resumeButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"continuebutton.png"] 
										   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"continuebutton2.png"]
												   target:self
												 selector:@selector(resumeButton)];
	
	
	resumeButton.position = ccp (winSize.width/2,winSize.height/1.9);
	menuButton.position = ccp (winSize.width/2,winSize.height/3.1);
	retryButton.position = ccp (winSize.width/2, winSize.height/2.35);
	toggleItem.position = ccp (winSize.width/2.4 , winSize.height/1.6);
	toggleItem2.position = ccp (winSize.width/1.73 , winSize.height/1.6);
	
	menuPause = [CCMenu menuWithItems:retryButton,menuButton,resumeButton,toggleItem,toggleItem2, nil];
	menuPause.position = ccp (winSize.width/-4.8	, winSize.height/-5);
	
	[panel addChild:menuPause z:99];
	
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == NO) {
		toggleItem.selectedIndex = 0;
	} else if ([usrDef boolForKey:@"sound"] == YES) {
		toggleItem.selectedIndex = 1;
	}
	if ([usrDef boolForKey:@"music"] == NO){
		toggleItem2.selectedIndex = 0;
	}
	else if ([usrDef boolForKey:@"music"] == YES){
		toggleItem2.selectedIndex = 1;
	}
}
- (void)soundDisabledButtonTapped:(CCMenuItemToggle *)sender{
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if (sender.selectedIndex == 1) {		
		[usrDef setBool:YES forKey:@"sound"];
		[[SimpleAudioEngine sharedEngine]stopEffect:jumpSoundEffectID];
		
		
    } else if (sender.selectedIndex == 0) {
		[usrDef setBool:NO forKey:@"sound"];
		
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
}
- (void)musicDisabledButtonTapped:(CCMenuItemToggle *)sender{
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if (sender.selectedIndex == 1) {		
		[usrDef setBool:YES forKey:@"music"];
		[[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
		if ([usrDef boolForKey:@"sound"] == NO){
			[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
		}
		
    } else if (sender.selectedIndex == 0) {
		[usrDef setBool:NO forKey:@"music"];
		[[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"funhouse.aifc"];
		if ([usrDef boolForKey:@"sound"] == NO){
			[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
		}
	}
}


-(void)retryButton{

	
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:jumpSoundEffectID];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}

	[[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
	[self unscheduleAllSelectors];
	[self removeChild:colorPauseLayer cleanup:YES];
	[self removeChild:panel cleanup:YES];
	[self removeChild:menuPause cleanup:YES];
	[[CCDirector sharedDirector]resume];
	[[CCDirector sharedDirector]replaceScene:[GameLayer scene]];

}
-(void)menuButton{
		NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:jumpSoundEffectID];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
	
	[self unscheduleAllSelectors];
	[self removeChild:colorPauseLayer cleanup:YES];
	[self removeChild:panel cleanup:YES];
	[self removeChild:menuPause cleanup:YES];
	[[CCDirector sharedDirector]resume];
	[[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
	[[CCDirector sharedDirector]replaceScene:[MenuLayer scene]];
	
}
-(void)resumeButton{
	
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:jumpSoundEffectID];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
	
	menuPauseInit.visible = YES;
	self.isTouchEnabled = YES;
	[_hero runAction:_runAction];

	[self removeChild:colorPauseLayer cleanup:YES];
	[self removeChild:panel cleanup:YES];
	[self removeChild:menuPause cleanup:YES];
	[[CCDirector sharedDirector]resume];
	
	
	[platform resumeSchedulerAndActions];
	[self resumeSchedulerAndActions];
	
	Bubble *target;
	target = nil;
	
	for (target in _targets) {
		[[CCActionManager sharedManager]resumeTarget:target];
		
	}
	
	
}

- (void) initScore
{
    
	_scoreVelocity = 0;
    scoreLayer = [ScoreLayer node];
    [scoreLayer.label setString:[NSString stringWithFormat:@"%05d", _scoreVelocity]];
		
	[self addChild:scoreLayer];
    
    [self schedule:@selector(updateScore:) interval:(5.0 / 60.0)];
}
- (void) updateScore:(ccTime)dt
{
	
    _scoreVelocity += 1;
	[scoreLayer.label setString:[NSString stringWithFormat:@"%05d", _scoreVelocity]];
    
	
    //increase difficulty every 200m run
    if (_scoreVelocity % kDifficultyScore == 0) {
        [self increaseDifficulty];
		
    }
	
}

	- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
  	
		
	if (isJumping == NO && isGap == NO) {
		//[_hero stopAllActions];
		//[self changeHeroImageDuringJump];
		isJumping = YES;
		
        jumpVelocity = ccp(0, kJumpHigh(kh));
		[self schedule:@selector(jump:) interval:(2.0 / 60.0)];
		
		NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
		if ([usrDef boolForKey:@"sound"] == YES){
			[[SimpleAudioEngine sharedEngine]stopEffect:jumpSoundEffectID];
		} else {
			[[SimpleAudioEngine sharedEngine]playEffect:@"boing.caf"];
		}
	}
	return YES;
}
-(void)changeHeroImageDuringJump 
{
	[_hero setTextureRect:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                           spriteFrameByName:@"duck-7.png"].rect];
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event 

{
	
	if (jumpVelocity.y > kJumpShort) {
		jumpVelocity = ccp(0, kJumpShort);
	}
	
}
-(void) registerWithTouchDispatcher 
{

	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

}
-(void)CreateLayerGo{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	texto = [CCSprite spriteWithSpriteFrameName:@"go.png"];
	texto.position = ccp (winSize.width/2 , winSize.height);
	[self addChild:texto z:29];

	id move = [CCMoveTo actionWithDuration:2 position:ccp(winSize.width/2 , winSize.height/1.20)];
	id action = [CCEaseElasticOut actionWithAction:move period:0.2f];	
	
	CCEaseOut *squeze1 = [CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:.02f scaleX:1 scaleY:1]];
	CCEaseIn *expand1 = [CCEaseElasticIn actionWithAction:[CCScaleTo actionWithDuration:.5f scaleX:.8  scaleY:1.5]];
	CCEaseOut *squeze2 = [CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:.5f scaleX:1 scaleY:1]];
	CCFadeOut *fade = [CCFadeOut actionWithDuration:1];
	
	
	id s = [CCSequence actions:action,squeze1,expand1,squeze2,fade,nil];
	[texto runAction:s];
	CCParticleSystemQuad *particles = [[CCParticleSystemManager sharedManager]particleWithFile:@"intro.plist"];
	[particles setPosition:ccp(winSize.width/2 , winSize.height/1.20)];
	[self addChild:particles];
	
	[self performSelector:@selector(removeLayerGo:) withObject:self afterDelay:5];
	
}
-(void)removeLayerGo:(ccTime)dt{
	[self removeChild:texto cleanup:YES];
}


- (void) dealloc
{
	 [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
	
	self.hero = nil;
	self.runAction = nil;
    
    [self.hero release];
    [self.runAction release];
    [platform release];
//	[parallax release];
	[super dealloc];
}
@end