//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//
#import "ScoreLayer.h"


@implementation ScoreLayer

@synthesize label = _velocityLabel;
@synthesize label2 = _bubbleLabel;
@synthesize textdistance = textdistance;
@synthesize textBubbles = textBubbles;

- (id) init
{
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
		textdistance = [CCLabelTTF labelWithString:@"DISTANCE:" fontName:@"PLUMP.TTF" fontSize:HD_TEXT (13)];
		textdistance.position = ccp(winSize.width*0.67, winSize.height*0.955);
		textdistance.color = ccc3(183, 213, 55);
		CCRenderTexture* stroked = [CCMenuItemFontWithStroke createStroke:textdistance size:2  color:ccWHITE];
		stroked.position = ccp(winSize.width*0.67, winSize.height*0.955);
		[self addChild:stroked];
		[self addChild:textdistance z:99];
		
		self.label = [CCLabelBMFont labelWithString:@"0000" fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
   		[_velocityLabel setAnchorPoint: ccp(0, 0.5f)];
		_velocityLabel.position = ccp(winSize.width/1.25 , winSize.height/1.045);
   	
		[self addChild:_velocityLabel z:99];
		
		
		textBubbles = [CCLabelTTF labelWithString:@"BUBBLES:" fontName:@"PLUMP.TTF" fontSize:HD_TEXT (13)];
		textBubbles.position = ccp (winSize.width*0.31, winSize.height*0.955);
		textBubbles.color = ccc3(183, 213, 55);
		CCRenderTexture* stroke = [CCMenuItemFontWithStroke createStroke:textBubbles size:2  color:ccWHITE];
		stroke.position = ccp(winSize.width*0.31, winSize.height*0.955);
		[self addChild:stroke];
		[self addChild:textBubbles z:99];
		
		
		self.label2 = [CCLabelBMFont labelWithString:@"0" fntFile:SD_HD_FONT(@"BubbleDuckFont.fnt")];
		_bubbleLabel.position = ccp (winSize.width/2.4 , winSize.height/1.045);
		[_bubbleLabel setAnchorPoint: ccp(0, 0.5f)];
		
		
		[self addChild:_bubbleLabel z:99];
		
		
    }
    return self;
}

- (void) dealloc
{
//	[self.textBubbles release];
//	[self.textdistance release];
    [self.label release];
	[self.label2 release];
    [super dealloc];
}

@end
