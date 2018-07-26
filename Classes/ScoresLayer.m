//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//


#import "OptionsLayer.h"
#import "ScoresLayer.h"
#import "GameLayer.h"

@interface ScoresLayer ()
-(void)back;
-(void)scaleDOWNTOUP;
-(void)createCloud;
-(void)resetCloudWithNode:(id)node;
-(void)saveHighscores;
-(void)loadCurrentPlayer;
-(void)loadHighscores;


@end

@implementation ScoresLayer
   

- (id)initWithScore:(int)lastScore
{

	if( (self=[super init])) {
			CGSize winSize = [[CCDirector sharedDirector] winSize];

		currentScore = lastScore;
		
			
		[self loadCurrentPlayer];
		[self loadHighscores];
		BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
		iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
		if (iPad) {
			start_y = 480.0f;
			step = 27.0f;

		}
		else
		{
			 start_y = (200);
			 step =  14.0f;
		}
		
		int count = 0;
		for(NSMutableArray *highscore in highscores) {
			NSString *player = [highscore objectAtIndex:0];
			int score = [[highscore objectAtIndex:1] intValue];

			label1 = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",(count+1)] fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
			label1.position = ccp(winSize.width/3.8,start_y-count*step-2.0f);
			[self addChild:label1 z:99];
			
			label2 = [CCLabelBMFont labelWithString:player fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
			label2.position = ccp(winSize.width/2,start_y-count*step);
			[self addChild:label2 z:99];

			label3 = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",score] fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
			label3.position = ccp(winSize.width/1.4,start_y-count*step);
			[self addChild:label3 z:99];
			
					
					
			count++;
			if(count == 10) break;
		}	
				
		srandom(time(NULL));
		self.isTouchEnabled = YES;
		CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(175, 226, 228, 255)];
		[self addChild:colorLayer z:-1];
			
		back = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"backbutton.png"] 
									   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"backbutton2.png"]
											   target:self
											selector:@selector(back)];
										
			
		menu = [CCMenu menuWithItems:back, nil];
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
	
	[[CCDirector sharedDirector]replaceScene:[OptionsLayer scene]];
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
	
	
	title = [CCSprite spriteWithSpriteFrameName:@"scores.png"];
	title.position = HD_CCP((winSize.width/3.5) , (winSize.height/1.58)));
	[panel addChild:title z:9];
	
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
	[self reorderChild:cloud z:newZOrder];
}
-(void)createCloud {
    int cloudToDraw = random() % 5; // 0 to 4
    NSString *cloudFileName = [NSString stringWithFormat:@"cloud-%d.png",cloudToDraw];
    CCSprite *cloudSprite = [CCSprite spriteWithSpriteFrameName:cloudFileName];
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
- (void)saveHighscores {
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:highscores forKey:@"highscores"];
}


- (void) dealloc
{
	
	[highscores release];
	[super dealloc];
}

@end

