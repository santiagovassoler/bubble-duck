//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//

#import "MenuLayer.h"
#import "GameOverLayer.h"
#import "GameLayer.h"
#import "SimpleAudioEngine.h"


@interface GameOverLayer (Private)
-(void)back;
-(void)scaleDOWNTOUP;
-(void)createCloud;
-(void)resetCloudWithNode:(id)node;

- (void)loadCurrentPlayer;
- (void)loadHighscores;
- (void)updateHighscores;
- (void)saveCurrentPlayer;
- (void)saveHighscores;
- (void)changePlayerDone;
- (void)button2Callback:(id)sender;



-(void)saveHighscores;
-(void)loadCurrentPlayer;
-(void)loadHighscores;



@end

@implementation GameOverLayer

+ (CCScene *)sceneWithScore:(int)lastScore
{
    CCScene *scene = [CCScene node];
    
    GameOverLayer *layer = [[[GameOverLayer alloc]initWithScore:lastScore] autorelease];
    [scene addChild:layer];
    
    return scene;
}


- (id)initWithScore:(int)lastScore
{
	
	 if( (self=[super init])) {
	
	
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menumusic.aifc" loop:YES];
		
		NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
		if ([usrDef boolForKey:@"sound"] == YES){
			
		}
		if ([usrDef boolForKey:@"music"] == YES){
			[[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
			
		}
		
		currentScore = lastScore;
		
		 
		[self loadCurrentPlayer];
		[self loadHighscores];
		[self updateHighscores];
		if(currentScorePosition >= 0) {
			[self saveHighscores];
			GameKitHelper *gkHelper = [GameKitHelper sharedGameKitHelper];
			[gkHelper submitScore:currentScore category:@"bdl"];
			
		}
		
		//float start_y = 480.0f;
		//float step = 27.0f;
		int count = 0;
		for(NSMutableArray *highscore in highscores) {
		//	NSString *player = [highscore objectAtIndex:0];
			int score = [[highscore objectAtIndex:1] intValue];
			
			
			count++;
						
			if(count == 2) break;
			CCLabelBMFont *labelName = [CCLabelBMFont labelWithString:@"your name:" fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
			labelName.position = ccp(winSize.width/2.8,winSize.height/1.9);
			[self addChild:labelName z:99];
			
			
			CCLabelBMFont *label2 = [CCLabelBMFont labelWithString:currentPlayer fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
			label2.position = ccp(winSize.width/1.72,winSize.height/1.9);
			[self addChild:label2 z:99];
			
			
			CCLabelBMFont *labelScore = [CCLabelBMFont labelWithString:@"your score:" fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
			labelScore.position = ccp(winSize.width/2.8,winSize.height/2.2);
			[self addChild:labelScore z:99];
			
			
			label4 = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",currentScore] fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
			label4.position = ccp(winSize.width/1.8,winSize.height/2.2);
			[self addChild:label4 z:99];
			
			
			CCLabelBMFont *labelHighScore = [CCLabelBMFont labelWithString:@"High score:" fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
			labelHighScore.position = ccp(winSize.width/2.8,winSize.height/2.7);
			[self addChild:labelHighScore z:99];
			
			
			CCLabelBMFont *label5 = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",score] fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
			label5.position = ccp(winSize.width/1.8,winSize.height/2.7);
			[self addChild:label5 z:99];
			
			
			}
		srandom(time(NULL));
		self.isTouchEnabled = YES;
		CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(175, 226, 228, 255)];
		[self addChild:colorLayer z:-1];
		
		back = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"backbutton.png"] 
									   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"backbutton2.png"]
											   target:self
											 selector:@selector(back)];
			
		CCMenuItemFont *button2 = [CCMenuItemFont itemFromString:@"             " target:self selector:@selector(button2Callback:)];
		button2.position = ccp(winSize.width/1.7,winSize.height/1.73);
		
		
		menu = [CCMenu menuWithItems:back,button2, nil];
		menu.position = CGPointZero;//ccp (winSize.width/8 , winSize.height/8);
		back.position = ccp (winSize.width/14 , winSize.height/16);
		
	   [self addChild:menu z:12];
				
		for (int a=0; a < 10; a++) {
			[self createCloud];
		}
		
		[self scaleDOWNTOUP]; 
}
	return self;
}	
-(void)back{
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	if ([usrDef boolForKey:@"sound"] == YES){
		[[SimpleAudioEngine sharedEngine]stopEffect:soundEffects];
	} else {
		[[SimpleAudioEngine sharedEngine]playEffect:@"click.caf"];
	}
	
	NSArray *subviews = [[[CCDirector sharedDirector]openGLView] subviews];
	for (id sv in subviews)
	{
		[((UIView *)sv) removeFromSuperview];
		[sv release];
	}

	[[CCDirector sharedDirector]replaceScene:[MenuLayer scene]];

	
 }

-(void)scaleDOWNTOUP {
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	panel = [CCSprite spriteWithSpriteFrameName:@"panel.png"];
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
	
	title = [CCSprite spriteWithSpriteFrameName:@"gameover.png"];
	title.position = HD_CCP((winSize.width/3.5) , (winSize.height/1.58)));
	[panel addChild:title z:9];
	
	CCLabelBMFont *taptochange = [CCLabelBMFont labelWithString:@"tap to\nchange" fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
	taptochange.position = HD_CCP((winSize.width/2.2) , (winSize.height/2)));//ccp (winSize.width/2.2 , winSize.height/2.4);
	taptochange.rotation = -45;
	taptochange.scale = 0.5;
	[panel addChild:taptochange z:9];
	
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
    int cloudToDraw = random() % 5; // 0 to 4
    NSString *cloudFileName = [NSString stringWithFormat:@"cloud-%d.png",cloudToDraw];
    CCSprite *cloudSprite = [CCSprite spriteWithSpriteFrameName:cloudFileName];
	//  [spriteNode addChild:cloudSprite ];
	[self addChild:cloudSprite];
    [self resetCloudWithNode:cloudSprite];
}

- (void)loadCurrentPlayer {
	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	currentPlayer = nil;
	currentPlayer = [defaults objectForKey:@"player"];
	if(!currentPlayer) {
		currentPlayer = @"Bubbly";
	}
	
	
}

- (void)loadHighscores {
	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	highscores = nil;
	highscores = [[NSMutableArray alloc] initWithArray: [defaults objectForKey:@"highscores"]];
	
	
	
#ifdef RESET_DEFAULTS	
	[highscores removeAllObjects];
#endif
	
	if([highscores count] == 0) {
		[highscores addObject:[NSArray arrayWithObjects:@"--",[NSNumber numberWithInt:0],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"--",[NSNumber numberWithInt:0],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"--",[NSNumber numberWithInt:0],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"--",[NSNumber numberWithInt:0],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"--",[NSNumber numberWithInt:0],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"--",[NSNumber numberWithInt:0],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"--",[NSNumber numberWithInt:0],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"--",[NSNumber numberWithInt:0],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"--",[NSNumber numberWithInt:0],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"--",[NSNumber numberWithInt:0],nil]];
		
	}
#ifdef RESET_DEFAULTS	
	[self saveHighscores];
#endif
}

- (void)updateHighscores {
	
	
	currentScorePosition = -1;
	int count = 0;
	for(NSMutableArray *highscore in highscores) {
		int score = [[highscore objectAtIndex:1] intValue];
		
		if(currentScore >= score) {
			currentScorePosition = count;
		 break;
		}
		count++;
	}
	
	if(currentScorePosition >= 0) {
		[highscores insertObject:[NSArray arrayWithObjects:currentPlayer,[NSNumber numberWithInt:currentScore],nil] atIndex:currentScorePosition];
		[highscores removeLastObject];
	}
}

- (void)saveCurrentPlayer {
	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:currentPlayer forKey:@"player"];
}

- (void)saveHighscores {
	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:highscores forKey:@"highscores"];

}

- (void)button2Callback:(id)sender {
	
	changePlayerAlert = [UIAlertView new];
	changePlayerAlert.title = @"Change Player";
	changePlayerAlert.message = @"\n";
	changePlayerAlert.delegate = self;
	[changePlayerAlert addButtonWithTitle:@"Save"];
	[changePlayerAlert addButtonWithTitle:@"Cancel"];
	
	changePlayerTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 45, 245, 27)];
	changePlayerTextField.borderStyle = UITextBorderStyleRoundedRect;
	[changePlayerAlert addSubview:changePlayerTextField];
	//	changePlayerTextField.placeholder = @"Enter your name";
	//	changePlayerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	changePlayerTextField.keyboardType = UIKeyboardTypeDefault;
	changePlayerTextField.returnKeyType = UIReturnKeyDone;
	changePlayerTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	changePlayerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	changePlayerTextField.delegate = self;
	[changePlayerTextField becomeFirstResponder];
	
	[changePlayerAlert show];
	
}
- (void)changePlayerDone {
	if ([changePlayerTextField.text length] == 0) {
		[changePlayerTextField setText: [NSMutableString stringWithString:[[NSString alloc]initWithFormat:@"%@",currentPlayer]]];
	}
	currentPlayer = [changePlayerTextField.text retain];
	[self saveCurrentPlayer];
	if(currentScorePosition >= 0) {
		[highscores removeObjectAtIndex:currentScorePosition];
		[highscores addObject:[NSArray arrayWithObjects:@"tweejump",[NSNumber numberWithInt:0],nil]];
		[self saveHighscores];
		
		CCScene *scene = [CCScene node];
		GameOverLayer *layer = [[GameOverLayer alloc]initWithScore:currentScore];
		[scene addChild:layer];	
		[[CCDirector sharedDirector]replaceScene:scene];
		
		
		
		
		
		NSArray *subviews = [[[CCDirector sharedDirector]openGLView] subviews];
		for (id sv in subviews)
		{
			[((UIView *)sv) removeFromSuperview];
			[sv release];
		}
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 10) ? NO : YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	if(buttonIndex == 0) {
		[self changePlayerDone];
	} else {
		
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[changePlayerAlert dismissWithClickedButtonIndex:0 animated:YES];
	[self changePlayerDone];
	return YES;
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

- (void) dealloc
{
	
	[highscores release];
	[super dealloc];
}

@end

