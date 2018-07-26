//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//
#import "MenuLayer.h"
#import "HelloWorldLayer.h"
#import "OptionsLayer.h"
#import "GameLayer.h"
#import "SimpleAudioEngine.h"

@interface MenuLayer ()
-(void)resetCloudWithNode:(id)node;
-(void)createCloud;
-(void)playButton;
-(void)optionsButton;
-(void)gameCenter;
-(void)CreateSprites;
-(void)createParallax;
-(void)createHero;
@end


@implementation MenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {

		
	
		
		GameKitHelper *gkHelper = [GameKitHelper sharedGameKitHelper];
		gkHelper.delegate = self;
		[gkHelper authenticateLocalPlayer];
		
		
		
		if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menumusic.aifc" loop:YES];
		
		NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
		if ([usrDef boolForKey:@"sound"] == YES){
			
		}
		if ([usrDef boolForKey:@"music"] == YES){
			[[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
			
		}
			
		[self createParallax];
		[self createHero];
			
		
		CGSize winSize = [[CCDirector sharedDirector]winSize];
		
		
		CCLayerColor *layerColor = [CCLayerColor layerWithColor:ccc4(175, 226, 228, 255)];
		[self addChild:layerColor z:-1];
		
		
		BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
		iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
		if (iPad) {
		
			[[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"Options-ipad.plist"];
			spriteNode = [CCSpriteBatchNode batchNodeWithFile:@"Options-ipad.pvr.ccz"];
			[self addChild:spriteNode];
			
		}
		else
		{
		
			[[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"Options.plist"];
			spriteNode = [CCSpriteBatchNode batchNodeWithFile:@"Options.pvr.ccz"];
			[self addChild:spriteNode];
			
		}

			
		
		playGame = [ CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"playbutton.png"]
											selectedSprite:[CCSprite spriteWithSpriteFrameName:@"playbutton2.png"]
													target:self selector:@selector (playButton)];
		
		optionsButton = [ CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"optionsbutton.png"]
											selectedSprite:[CCSprite spriteWithSpriteFrameName:@"optionsbutton2.png"]
													target:self selector:@selector (optionsButton)];
		
		gameCenterButton = [ CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"gamecenterbutton.png"]
											selectedSprite:[CCSprite spriteWithSpriteFrameName:@"gamecenterbutton2.png"]
													target:self selector:@selector (gameCenter)];
		
		
		optionsButton.position = ccp (winSize.width/1.12,winSize.height/16);
		gameCenterButton.position = ccp (winSize.width/1.04,winSize.height/16);
		playGame.position = ccp (winSize.width/1.215, winSize.height/16);		
		
		mainMenu = [CCMenu menuWithItems:optionsButton,playGame,gameCenterButton, nil];
		mainMenu.position = CGPointZero;
		[self addChild:mainMenu];
		
		
		[self CreateSprites];
		
		for(int a=0; a<10; a++){
			[self createCloud];
			
		}
	}
	return self;
}

-(void)playButton{
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:soundEffects];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
	[[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
	[[CCDirector sharedDirector]replaceScene:[GameLayer scene]];
}
-(void)optionsButton{
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:soundEffects];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
	
	[[CCDirector sharedDirector]replaceScene:[OptionsLayer scene]];	
}
-(void)gameCenter{
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:soundEffects];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
	
	
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];

	UIAlertView *ResourceManager = [UIAlertView new];
	
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	if (localPlayer.authenticated == NO){
			ResourceManager.title = @"GameCenter Disabled";
			ResourceManager.message = @"Sign in with Game Center application to enable";
			ResourceManager.delegate = self;
			[ResourceManager addButtonWithTitle:@"Ok"];
			[ResourceManager addButtonWithTitle:@"Cancel"];
			[ResourceManager show];
		
	}
	else {
		[gkHelper showLeaderboard];
	}
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:/me/account"]];
	} else {
	}
}

-(void)CreateSprites{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
//	arvore = [CCSprite spriteWithSpriteFrameName:@"arvore.png"];
//	arvore.position = ccp (winSize.width/2 , winSize.height/2.95);
//	[spriteNode addChild:arvore z:15];
	
	montanha = [CCSprite spriteWithSpriteFrameName:@"montanha.png"];
	montanha.position = ccp (winSize.width/2 , winSize.height/2);
	[spriteNode addChild:montanha z:12];
	
	mato = [CCSprite spriteWithSpriteFrameName:@"matocomcogumelo.png"];
	//mato.position =  ccp(winSize.width/2, winSize.height/3);
	mato.position = HD_CCP((winSize.width/2) , (winSize.height/2.9)));
	[spriteNode addChild:mato z:12];
	
	logo = [CCSprite spriteWithSpriteFrameName:@"logo.png"];
	logo.position = ccp (winSize.width/2 , winSize.height/4);
	[spriteNode addChild:logo z:13];
	
	agua = [CCSprite spriteWithSpriteFrameName:@"water.png"];
	agua.position = ccp (winSize.width/2 , winSize.height/6.5);
	[spriteNode addChild:agua z:11];
	
	
	id move = [CCMoveTo actionWithDuration:2 position:ccp(winSize.width/2 , winSize.height/1.20)];
	id action = [CCEaseElasticOut actionWithAction:move period:0.2f];
	[logo runAction: action];
	
}
-(void)resetCloudWithNode:(id)node {
    CGSize screenSize = [CCDirector sharedDirector].winSize; 
    CCNode *cloud = (CCNode*)node;
    float xOffSet = [cloud boundingBox].size.width /2;
    
    int xPosition = screenSize.width + 1 + xOffSet;
    int yPosition = random() % (int)screenSize.height;
	
    
    [cloud setPosition:ccp(xPosition,yPosition)];
    
    int moveDuration = random() % kMaxCloudMoveDuration;
	if (moveDuration < kMinCloudMoveDuration) {
		moveDuration = kMinCloudMoveDuration;
	}
    
    float offScreenXPosition = (xOffSet * -1) - 1;     
    
    id moveAction = [CCMoveTo actionWithDuration:moveDuration 
                                        position:ccp(offScreenXPosition,[cloud position].y)];
    
	id resetAction = [CCCallFuncN 
                      actionWithTarget:self selector:@selector(resetCloudWithNode:)];
    
	id sequenceAction = [CCSequence 
                         actions:moveAction,resetAction,nil];
    
    [cloud runAction:sequenceAction]; 
    
    int newZOrder = kMaxCloudMoveDuration - moveDuration;     
    [spriteNode reorderChild:cloud z:newZOrder]; 
}
-(void)createCloud {
    int cloudToDraw = random() % 5; // 0 to 4
    NSString *cloudFileName = [NSString stringWithFormat:@"cloud-%d.png",cloudToDraw];
    CCSprite *cloudSprite = [CCSprite spriteWithSpriteFrameName:cloudFileName];
    [spriteNode addChild:cloudSprite ];
    [self resetCloudWithNode:cloudSprite];
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
	
	
	
	backwater = [CCSprite spriteWithSpriteFrameName:@"backwater.png"]; 
	backwater2 = [CCSprite spriteWithSpriteFrameName:@"backwater.png"];
	[parallax addInfiniteScrollXWithZ:2 Ratio:ccp(-0.6,-0.6) Pos:HD_CCP((0) , (winSize.height/5.75))) Objects:backwater,backwater2, nil]; 
																	
	frontwater = [CCSprite spriteWithSpriteFrameName:@"frontwater.png"];
	frontwater2 = [CCSprite spriteWithSpriteFrameName:@"frontwater.png"];
	[parallax addInfiniteScrollXWithZ:3 Ratio:ccp(0.6,0.6) Pos:HD_CCP((0) , (winSize.height/5.75))) Objects:frontwater,frontwater2, nil]; 
	
	
	[self addChild:parallax z:5];
	[self schedule:@selector(updateParallax:)];
	

}
-(void) updateParallax:(ccTime)dt {
	[parallax updateWithVelocity:ccp(-4,0) AndDelta:dt];
}
-(void)createHero{//:(ccTime)dt {
	
	NSMutableArray *runAnimFrames = [NSMutableArray array];
	for (int i = 1 ; i <= 7 ; i++) {
		[runAnimFrames addObject:
		 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
		  [NSString stringWithFormat:@"duck-%d.png", i ]]];
	}
	
	CGSize winSize = [[CCDirector sharedDirector]winSize];
	

	
	CCSprite *hero = [CCSprite spriteWithSpriteFrameName:@"duck-1.png"];
    hero.position = ccp (winSize.width/- hero.contentSize.width , winSize.height/3.5 );
	
	CCAnimation *runAnim = [CCAnimation animationWithFrames:runAnimFrames delay:0.15f];
	CCAction *_runAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:FALSE]];
    
    [hero runAction:_runAction];
	[self addChild:hero z:100];
	
	id move = [CCMoveTo actionWithDuration:10 position:ccp(winSize.width + hero.contentSize.width , winSize.height/3.5)];
	[hero runAction: move];
	
	

}
#pragma mark GameKitHelper delegate methods
-(void) onLocalPlayerAuthenticationChanged
{
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
	
    if (localPlayer.authenticated)
    {
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
        [gkHelper getLocalPlayerFriends];
        //[gkHelper resetAchievements];
    }   
}
-(void) onFriendListReceived:(NSArray*)friends
{
    CCLOG(@"onFriendListReceived: %@", [friends description]);
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper getPlayerInfo:friends];
}
-(void) onPlayerInfoReceived:(NSArray*)players
{
    CCLOG(@"onPlayerInfoReceived: %@", [players description]);
	
	
}
-(void) onScoresSubmitted:(bool)success
{
    CCLOG(@"onScoresSubmitted: %@", success ? @"YES" : @"NO");
}
-(void) onScoresReceived:(NSArray*)scores
{
    CCLOG(@"onScoresReceived: %@", [scores description]);
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper showAchievements];
}
-(void) onAchievementReported:(GKAchievement*)achievement
{
    CCLOG(@"onAchievementReported: %@", achievement);
}
-(void) onAchievementsLoaded:(NSDictionary*)achievements
{
    CCLOG(@"onLocalPlayerAchievementsLoaded: %@", [achievements description]);
}
-(void) onResetAchievements:(bool)success
{
    CCLOG(@"onResetAchievements: %@", success ? @"YES" : @"NO");
}
-(void) onLeaderboardViewDismissed
{
    CCLOG(@"onLeaderboardViewDismissed");
	
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper retrieveTopTenAllTimeGlobalScores];
}
-(void) onAchievementsViewDismissed
{
    CCLOG(@"onAchievementsViewDismissed");
}
-(void) onReceivedMatchmakingActivity:(NSInteger)activity
{
    CCLOG(@"receivedMatchmakingActivity: %i", activity);
}
-(void) onMatchFound:(GKMatch*)match
{
    CCLOG(@"onMatchFound: %@", match);
}
-(void) onPlayersAddedToMatch:(bool)success
{
    CCLOG(@"onPlayersAddedToMatch: %@", success ? @"YES" : @"NO");
}
-(void) onMatchmakingViewDismissed
{
    CCLOG(@"onMatchmakingViewDismissed");
}
-(void) onMatchmakingViewError
{
    CCLOG(@"onMatchmakingViewError");
}
-(void) onPlayerConnected:(NSString*)playerID
{
    CCLOG(@"onPlayerConnected: %@", playerID);
}
-(void) onPlayerDisconnected:(NSString*)playerID
{
    CCLOG(@"onPlayerDisconnected: %@", playerID);
}
-(void) onStartMatch
{
    CCLOG(@"onStartMatch");
}
-(void) onReceivedData:(NSData*)data fromPlayer:(NSString*)playerID
{
    CCLOG(@"onReceivedData: %@ fromPlayer: %@", data, playerID);
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	
	[super dealloc];
}
@end

