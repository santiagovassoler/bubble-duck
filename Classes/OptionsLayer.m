//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//

#import "OptionsLayer.h"
#import "MenuLayer.h"
#import "ScoresLayer.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldLayer.h"


@interface OptionsLayer ()
-(void)resetCloudWithNode:(id)node;
-(void)createCloud;
-(void)scores;
-(void)credits;
-(void)resetGame;
-(void)scaleDOWNTOUP;
-(void)CreateMenu;
-(void)soundDisabledButtonTapped:(CCMenuItemToggle *)sender;
-(void)musicDisabledButtonTapped:(CCMenuItemToggle *)sender;
@end

@implementation OptionsLayer

+(CCScene *) scene
{
	
	CCScene *scene = [CCScene node];
	
	OptionsLayer *layer = [OptionsLayer node];
	
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
				srandom(time(NULL));
		self.isTouchEnabled = YES;
		
		
		CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(175, 226, 228, 255)];
		[self addChild:colorLayer z:-1];
		
			
		for (int a=0; a < 10; a++) {
			[self createCloud];
		}
		
		
		[self CreateMenu];
		
		[self scaleDOWNTOUP];		
	}
	return self;
}

-(void)scaleDOWNTOUP {
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	panel = [CCSprite spriteWithSpriteFrameName:@"panel.png"];
	///panel = [CCSprite spriteWithFile:@"panelt.png"];
	panel.position = ccp ( winSize.width/2 , winSize.height/2);
//	[spriteNode addChild:panel z:8];
	[self addChild:panel z:8];
	
	panel.scale = 0.1;
	
	id a = [CCScaleBy actionWithDuration:0.2f scale:10];
	CCEaseOut *squeze1 = [CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:.02f scaleX:1 scaleY:1]];
	CCEaseIn *expand1 = [CCEaseElasticIn actionWithAction:[CCScaleTo actionWithDuration:.5f scaleX:.8  scaleY:1.5]];
	CCEaseOut *squeze2 = [CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:.5f scaleX:1 scaleY:1]];
	
	id s = [CCSequence actions:a,squeze1,expand1,squeze2, nil];
	[panel runAction:s];
	
	
	title = [CCSprite spriteWithSpriteFrameName:@"options.png"];
	title.position =HD_CCP((winSize.width/3.5) , (winSize.height/1.60))); //ccp (winSize.width/3.5 , winSize.height/1.75);
	[panel addChild:title z:9];
	
	titleResetGame = [CCSprite spriteWithSpriteFrameName:@"resetgame.png"];
	titleResetGame.position = HD_CCP((winSize.width/3.5) , (winSize.height/1.58)));
	[panel addChild:titleResetGame z:9];
	titleResetGame.visible = NO;
	
}

-(void)CreateMenu{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	
	
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
	
	
	scoresButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"scoresbutton.png"] 
									 selectedSprite:[CCSprite spriteWithSpriteFrameName:@"scoresbutton2.png"]
											 target:self
										   selector:@selector(scores)];
	
	creditsButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"creditsbutton.png"] 
									  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"creditsbutton2.png"]
											  target:self
											selector:@selector(credits)];
										
					 
	resetGameButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"resetgamebutton.png"] 
										  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"resetgamebutton2.png"]
												  target:self
												selector:@selector(resetGame)];
	
	backButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"backbutton.png"] 
								   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"backbutton2.png"]
										   target:self
										 selector:@selector(back)];
	
	scoresButton.position = ccp (winSize.width/2,winSize.height/1.9);
	creditsButton.position = ccp (winSize.width/2,winSize.height/3.1);
	resetGameButton.position = ccp (winSize.width/2, winSize.height/2.35);
	backButton.position = ccp (winSize.width/14 , winSize.height/16);
	toggleItem.position = ccp (winSize.width/2.4 , winSize.height/1.6);
	toggleItem2.position = ccp (winSize.width/1.73 , winSize.height/1.6);
	
	menuOptions = [CCMenu menuWithItems:scoresButton,creditsButton,resetGameButton,backButton,toggleItem,toggleItem2, nil];
	menuOptions.position = CGPointZero;//ccp (winSize.width/8 , winSize.height/8);
	
	[self addChild:menuOptions z:10];
	
	
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
		[[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"menumusic.aifc"];
		
		if ([usrDef boolForKey:@"sound"] == NO){
			[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
		}
	}
}


-(void)scores{	
	

	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:soundEffects];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
	
	
	CCScene *scene = [CCScene node];
	ScoresLayer *layer = [[[ScoresLayer alloc]initWithScore:score]autorelease];
	[scene addChild:layer];	
	[[CCDirector sharedDirector] replaceScene:scene];
	
}
-(void)createMenuResetGame{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	text = [CCLabelBMFont labelWithString:@"ALL YOUR LOCAL\nSCORES WILL BE\nRESET. ARE YOU\nSURE YOU WANT\nTO DO THIS?" fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
		text.position = HD_CCP((winSize.width/3.5) , (winSize.height/2.3)));
	[panel addChild:text z:99];
	
		
	
	back = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"backbutton.png"] 
								   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"backbutton2.png"]
										   target:self
										 selector:@selector(back)];
	
	yesButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"yesbutton.png"] 
										selectedSprite:[CCSprite spriteWithSpriteFrameName:@"yesbutton2.png"]
												target:self
											  selector:@selector(yesButton)];
	
	noButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"nobutton.png"] 
									   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"nobutton2.png"]
											   target:self
											 selector:@selector(noButton)];
	
	
	menu = [CCMenu menuWithItems:back,yesButton,noButton, nil];
	menu.position = CGPointZero;
	back.position = ccp (winSize.width/14 , winSize.height/16);
	yesButton.position = ccp (winSize.width/2 , winSize.height/2.6);
	noButton.position = ccp (winSize.width/2 , winSize.height/3.5);
	
	[self addChild:menu z:12];
	
}
-(void)credits{
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:soundEffects];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
	
	[[CCDirector sharedDirector]replaceScene:[HelloWorld scene]];
}
-(void)resetGame{
	//[[CCDirector sharedDirector]replaceScene:[ResetGameLayer scene]];
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:soundEffects];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
	
	[self removeChild:panel cleanup:YES];
	[self removeChild:menuOptions cleanup:YES];
	[self scaleDOWNTOUP];
	[self createMenuResetGame];
	resetGame.visible = YES;
	titleResetGame.visible=YES;
	title.visible = NO;
}
-(void)back{
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:soundEffects];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
	
	[[CCDirector sharedDirector]replaceScene:[MenuLayer scene]];
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
 //   [spriteNode reorderChild:cloud z:newZOrder]; 
	[self reorderChild:cloud z:newZOrder];
}
-(void)createCloud {
    int cloudToDraw = random() % 5; 
    NSString *cloudFileName = [NSString stringWithFormat:@"cloud-%d.png",cloudToDraw];
    CCSprite *cloudSprite = [CCSprite spriteWithSpriteFrameName:cloudFileName];
  //  [spriteNode addChild:cloudSprite ];
	[self addChild:cloudSprite];
    [self resetCloudWithNode:cloudSprite];
}
-(void)yesButton{
	//panel.visible = NO;
	//[self removeChild:panel cleanup:YES];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bubbleduck"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"player"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"highscores"];
	
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:soundEffects];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
	
	
	[self removeChild:panel cleanup:YES];
	[self removeChild:menu cleanup:YES];
	[self removeChild:text cleanup:YES];
	[self scaleDOWNTOUP];
	[self CreateMenu];
	
}
-(void)noButton{
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:soundEffects];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
	
	[self removeChild:panel cleanup:YES];
	[self removeChild:menu cleanup:YES];
	[self removeChild:text cleanup:YES];
	[self scaleDOWNTOUP];
	[self CreateMenu];

}

- (void) dealloc
{
	
	[super dealloc];
}



@end
