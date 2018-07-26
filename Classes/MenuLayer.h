//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "OptionsLayer.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "CCParallaxScrollNode.h"
#import <GameKit/GameKit.h>
#import "GameKitHelper.h"

@interface MenuLayer : CCLayer <GameKitHelperProtocol>{
	
	CCSpriteBatchNode *spriteNode;
	
	CCSprite *arvore, *montanha, *mato, *logo;
	
	CCMenuItemSprite  *playGame;
	CCMenuItemSprite  *optionsButton;
	CCMenuItemSprite  *gameCenterButton;
	
	CCMenu *mainMenu;

	ALuint soundEffects;
	
	CCParallaxScrollNode *parallax;
	
	CCSprite *backwater , *backwater2, *frontwater, *frontwater2,*agua;
	
}
+(CCScene *) scene;
@end
