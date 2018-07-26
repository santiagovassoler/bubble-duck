//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//

#import "cocos2d.h"

@interface Bubble : CCSprite {
    int _curHp;
    int _minMoveDuration;
    int _maxMoveDuration;
	CCAction *_runAction;
}

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;
@property (nonatomic, retain) CCAction *runAction;

@end

@interface BadFastBubble : Bubble {
}
+(id)bubble;
@end

@interface GoodSlowBubble : Bubble {
}
+(id)bubble;
@end