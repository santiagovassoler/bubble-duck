//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuLayer.h"
#import "Constants.h"
#import "CCMenuItemFontWithStroke.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldLayer.h"
@interface OptionsLayer : CCLayer {
	
	CCSprite *panel, *title, *titleResetGame;
	
	CCLabelTTF *options;
	CCLabelTTF *resetGame;
	
//	CCRenderTexture* stroke;
//	CCRenderTexture* stroke2;
//	CCRenderTexture* stroke3;
	
	CCMenu *menuOptions;
	CCMenuItemSprite *scoresButton;
	CCMenuItemSprite *creditsButton;
	CCMenuItemSprite *resetGameButton;
	CCMenuItemSprite *backButton;
	
	CCMenuItemSprite *soundButton;
	CCMenuItemSprite *soundDisabledButton;
	CCMenuItemSprite *musicButton;
	CCMenuItemSprite *musicDisabledButton;
	
	CCMenuItemToggle *toggleItem;
	CCMenuItemToggle *toggleItem2;	

	int score;
	
	
	ALuint soundEffects;

	CCLabelBMFont *text;
	
	CCMenu *menu;
	CCMenuItemSprite *back;
	CCMenuItemSprite *yesButton;
	CCMenuItemSprite *noButton;
	
}
+(CCScene *) scene;
@end
