//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "CCMenuItemFontWithStroke.h"
#import "SimpleAudioEngine.h"
#import <GameKit/GameKit.h>
#import "GameKitHelper.h"

@interface GameOverLayer : CCLayer <UITextFieldDelegate, UITextViewDelegate,GameKitHelperProtocol> {
	

	CCSprite *panel;
	CCSprite *title;
	
	
	CCMenu *menu;
	CCMenuItemSprite *back;
	
	NSString *currentPlayer;
	int currentScore;
	int currentScorePosition;
	NSMutableArray *highscores;
	UIAlertView *changePlayerAlert;
	UITextField *changePlayerTextField;
	
	CCLabelBMFont *label4;
	int express;
	
	ALuint soundEffects;
}

+ (CCScene *)sceneWithScore:(int)lastScore;
- (id)initWithScore:(int)lastScore;
@end

