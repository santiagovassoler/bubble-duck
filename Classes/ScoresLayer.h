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

@interface ScoresLayer : CCLayer <UITextFieldDelegate> {
	
	
	CCSprite *panel,*title;
	
	
	
	CCMenu *menu;
	CCMenuItemSprite *back;
	
	NSString *currentPlayer;
	int currentScore;
	int currentScorePosition;
	NSMutableArray *highscores;
	UIAlertView *changePlayerAlert;
	UITextField *changePlayerTextField;
	
	
	float start_y ;
	float step ;

	ALuint soundEffects;
	
	CCLabelBMFont *label1;
	CCLabelBMFont *label2;
	CCLabelBMFont *label3;

}
- (id)initWithScore:(int)lastScore;

//+(CCScene *) scene;
//- (id)initWithScore:(int)lastScore;
@end
