//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"
#import "OptionsLayer.h"

@interface HelloWorld ()
-(void)resetCloudWithNode:(id)node;
-(void)createCloud;
-(void)scaleDOWNTOUP;
@end
// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init] )) {
	
		CGSize winSize = [CCDirector sharedDirector].winSize;
		
		CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(175, 226, 228, 255)];
		[self addChild:colorLayer z:-1];
		
		CCSprite *block = [CCSprite spriteWithSpriteFrameName:@"block.png"];
		block.position = ccp (winSize.width/2, winSize.height/14);
		[self addChild:block z:99];
		
		
		
		
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
		
		
		[self scaleDOWNTOUP];
		
		self.isTouchEnabled = YES;
		isDragging = NO;
		lasty = 0.0f;
		xvel = 0.0f;
		contentHeight = 2000.0f;
		direction = BounceDirectionStayingStill;
		
		
		scrollLayer = [CCLayerColor layerWithColor:ccc4(0,0,0,0)];
		scrollLayer.contentSize = CGSizeMake(480.f,contentHeight);
		scrollLayer.anchorPoint = ccp(0,0);
		scrollLayer.isRelativeAnchorPoint = YES;
		//scrollLayer.position = ccp(0,0);
		scrollLayer.position = HD_CCP((winSize.width/3.3),(-winSize.height*2)));//ccp(winSize.width/3, -900);
		
		
		[self addChild: scrollLayer z:-1];
		
		CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"BUBBLE DUCK V 1.0.1\n\n\n\n\nDESIGN CODE & ART\nSANTIAGO VASSOLER\n\n\n\n\n        MUSIC\nDORIANCHARNIS.COM\n\n\n\n\n     THANKS TO\nSAMIA DUARTE FOR\nDESIGNING THE DUCK\nMY FAMILY, MY WIFE\n\n\n\n\n     POWERED BY\n       COCOS2D\n\n\n\n\nCOPYRIGHT 2011-2012\nSANTIAGO VASSOLER\n\n\n\n\n" fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
		
		label.anchorPoint = CGPointZero;
		//label.position = ccp(winSize.width/2, winSize.height/2);
		///label.position = ccp(0,200);
		label.position = HD_CCP((0) , (200)));
		
		[scrollLayer addChild:label];
		
		
		[self scheduleUpdate];
		
		id move = [CCMoveTo actionWithDuration:25 position:HD_CCP((winSize.width/3.3) , (label.contentSize.height - 700)))];
		[scrollLayer runAction: move];
		
				
		
		back = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"backbutton.png"] 
									   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"backbutton2.png"]
											   target:self
											 selector:@selector(back)];
		
		
		menuBack = [CCMenu menuWithItems:back, nil];
		menuBack.position = CGPointZero;//ccp (winSize.width/8 , winSize.height/8);
		back.position = ccp (winSize.width/14 , winSize.height/16);
		
		[self addChild:menuBack z:12];
		
		for (int a=0; a < 10; a++) {
			[self createCloud];
		}                           
		
	}
	return self;
}

-(void) update:(ccTime)delta
{
	CGPoint pos = scrollLayer.position;
	// positions for scrollLayer
	
	float right = pos.y + [self boundingBox].origin.y + scrollLayer.contentSize.height;
	float left = pos.y + [self boundingBox].origin.y;
	
	
	
	// Bounding area of scrollview
	float minX = [self boundingBox].origin.y;
	float maxX = [self boundingBox].origin.y + [self boundingBox].size.height;	
	
	if(!isDragging) {
		static float friction = 0.96f;
		
		if(left > minX && direction != BounceDirectionGoingLeft) {
			
			xvel = 0;
			direction = BounceDirectionGoingLeft;
			
		}
		else if(right < maxX && direction != BounceDirectionGoingRight)	{
			
			xvel = 0;
			direction = BounceDirectionGoingRight;
		}
		
		if(direction == BounceDirectionGoingRight)
		{
			
			if(xvel >= 0)
			{
				float delta = (maxX - right);
				float yDeltaPerFrame = (delta / (BOUNCE_TIME * FRAME_RATE));
				xvel = yDeltaPerFrame;
			}
			
			if((right + 0.5f) == maxX)
			{
				
				pos.y = right -  scrollLayer.contentSize.height;
				xvel = 0;
				direction = BounceDirectionStayingStill;
			}
		}
		else if(direction == BounceDirectionGoingLeft)
		{
			
			if(xvel <= 0)
			{
				float delta = (minX - left);
				float yDeltaPerFrame = (delta / (BOUNCE_TIME * FRAME_RATE));
				xvel = yDeltaPerFrame;
			}
			
			if((left + 0.5f) == minX) {
				
				pos.y = left - [self boundingBox].origin.y;
				xvel = 0;
				direction = BounceDirectionStayingStill;
			}
		}
		else
		{
			xvel *= friction;
		}
		
		pos.y += xvel;
		
		scrollLayer.position = pos;
	}
	else
	{
		if(left <= minX || right >= maxX) {
			
			direction = BounceDirectionStayingStill;
		}
		
		if(direction == BounceDirectionStayingStill) {
			xvel = (pos.y - lasty)/2;
			lasty = pos.y;
		}
	}
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{
	isDragging = YES;
	
	return YES;
}

-(void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event
{
	
	CGPoint preLocation = [touch previousLocationInView:[touch view]];
	CGPoint curLocation = [touch locationInView:[touch view]];
	
	CGPoint a = [[CCDirector sharedDirector] convertToGL:preLocation];
	CGPoint b = [[CCDirector sharedDirector] convertToGL:curLocation];
	
	CGPoint nowPosition = scrollLayer.position;
	nowPosition.y += ( b.y - a.y );
	scrollLayer.position = nowPosition;
}

-(void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event
{
	isDragging = NO;
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
    
    int newZOrder = kMaxCloudMoveDuration *50 - moveDuration;     
	[self reorderChild:cloud z:newZOrder];
}
-(void)createCloud {
    int cloudToDraw = random() % 5; // 0 to 4
    NSString *cloudFileName = [NSString stringWithFormat:@"cloud-%d.png",cloudToDraw];
    CCSprite *cloudSprite = [CCSprite spriteWithSpriteFrameName:cloudFileName];
	[self addChild:cloudSprite];
    [self resetCloudWithNode:cloudSprite];
}
-(void)scaleDOWNTOUP {
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];

	CCSprite *panel = [CCSprite spriteWithSpriteFrameName:@"panel.png"];
	///panel = [CCSprite spriteWithFile:@"panelt.png"];
	panel.position = ccp ( winSize.width/2 , winSize.height/2);
	//	[spriteNode addChild:panel z:8];
//	[self addChild:panel z:8];
    [self addChild:panel z:-1];

	panel.scale = 0.1;
	
	id a = [CCScaleBy actionWithDuration:0.2f scale:10];
	CCEaseOut *squeze1 = [CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:.02f scaleX:1 scaleY:1]];
	CCEaseIn *expand1 = [CCEaseElasticIn actionWithAction:[CCScaleTo actionWithDuration:.5f scaleX:.8  scaleY:1.5]];
	CCEaseOut *squeze2 = [CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:.5f scaleX:1 scaleY:1]];
	
	id s = [CCSequence actions:a,squeze1,expand1,squeze2, nil];
	[panel runAction:s];
	

	
	CCSprite *creditspanel = [CCSprite spriteWithSpriteFrameName:@"panelcredits.png"];//spriteWithFile:@"r.png"];
	creditspanel.position = ccp (winSize.width/2 , winSize.height/2);
///	[self addChild:creditspanel z:10];
	[spriteNode addChild:creditspanel z:99];
	creditspanel.scale = 0.1;
		
	id ab = [CCScaleBy actionWithDuration:0.2f scale:10];
	CCEaseOut *squeze1b = [CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:.02f scaleX:1 scaleY:1]];
	CCEaseIn *expand1b = [CCEaseElasticIn actionWithAction:[CCScaleTo actionWithDuration:.5f scaleX:.8  scaleY:1.5]];
	CCEaseOut *squeze2b = [CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:.5f scaleX:1 scaleY:1]];
	
	id sb = [CCSequence actions:ab,squeze1b,expand1b,squeze2b, nil];
	[creditspanel runAction:sb];
	
	CCSprite *title = [CCSprite spriteWithSpriteFrameName:@"credits.png"];
	title.position = HD_CCP((winSize.width/3.5) , (winSize.height/1.2))); //ccp (winSize.width/3.5 , winSize.height/1.75);
	[creditspanel addChild:title];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}
@end
