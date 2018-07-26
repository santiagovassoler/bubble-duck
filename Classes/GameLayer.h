//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MovingPlatform.h"
#import "Constants.h"
#import "CCParallaxScrollNode.h"
#import "ScoreLayer.h"
#import "SimpleAudioEngine.h"
#import "Bubble_DuckAppDelegate.h"

@interface GameLayer : CCLayer {
	CCParallaxScrollNode *parallax;
	
	CCSprite *predios,*predios2, *montanha,*montanha2, *cogumelo, *cogumelo2, *agua, *platformImg, *backwater , *backwater2, *frontwater, *frontwater2;
	CCSprite *_hero;
	CCSprite *texto;
    CCAction *_runAction;

	MovingPlatform *platform;
	CGPoint heroRunningPosition;
	CGPoint jumpVelocity;
    
    BOOL isJumping;
    BOOL isGap;
	
	NSString *leftImageName;
    NSString *middleImageName;
    NSString *rightImageName;
	
	NSMutableArray *_targets;
	
	 int _scoreVelocity;
	 int _scoreBubble ;
	ScoreLayer *scoreLayer;
	
		
	int score;
		
	CCMenuItemSprite *resumeButton;
	CCMenuItemSprite *pauseButton;
	CCMenuItemSprite *retryButton;
	CCMenuItemSprite *menuButton;
	CCMenu *menu;
	
	CCMenuItemSprite *soundButton;
	CCMenuItemSprite *soundDisabledButton;
	CCMenuItemSprite *musicButton;
	CCMenuItemSprite *musicDisabledButton;
	
	CCMenuItemToggle *toggleItem;
	CCMenuItemToggle *toggleItem2;	
	
	
	CCLabelTTF *title;
	
	CCSprite *panel;
	CCMenu *menuPause;
	CCMenu *menuPauseInit;
	CCLayerColor* colorPauseLayer;
	
	ALuint jumpSoundEffectID;
	
	BOOL called;
	
}

@property (nonatomic, retain) CCSprite *hero;
@property (nonatomic, retain) CCAction *runAction;
@property CGPoint heroRunningPosition;
@property CGPoint jumpVelocity;
@property BOOL isJumping;
@property BOOL isGap;
@property int scoreVelocity;
@property int scoreBubble;
@property BOOL called;


+(CCScene *) scene;

@end

