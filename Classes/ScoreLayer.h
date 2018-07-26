//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCMenuItemFontWithStroke.h"
#import "Constants.h"

@interface ScoreLayer : CCLayer {
   
	CCLabelBMFont *_bubbleLabel;
	CCLabelTTF *textdistance;
	CCLabelBMFont *_velocityLabel;
	CCLabelTTF *textBubbles;
}

//@property (retain, nonatomic) CCLabelTTF *label;
@property (retain, nonatomic) CCLabelBMFont *label;
@property (retain, nonatomic) CCLabelBMFont *label2;
@property (retain, nonatomic) CCLabelTTF *textdistance;
@property (retain, nonatomic) CCLabelTTF *textBubbles;
@end
