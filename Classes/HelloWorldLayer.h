//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"

#define FRAME_RATE 60
#define BOUNCE_TIME 0.2f

typedef enum
{
	BounceDirectionGoingUp = 1,
	BounceDirectionStayingStill = 0,
	BounceDirectionGoingDown = -1,
	BounceDirectionGoingLeft = 2,
	BounceDirectionGoingRight = 3
} BounceDirection;

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	BounceDirection direction;
	CCLayer *scrollLayer;
	BOOL isDragging;
	float lasty;
	float xvel;
	float contentHeight;
	CCMenu *menuBack;
	CCMenuItemSprite *back;
	ALuint soundEffects;
	
	CCSpriteBatchNode *spriteNode;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
