//
//  
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011-2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCMenuItemFontWithStroke : CCMenuItemFont  {
    int stokeSize;
    ccColor3B strokeColor;
	
	
}

@property (nonatomic) int stokeSize;
@property (nonatomic)ccColor3B strokeColor;

-(id) initFromString: (NSString*) value target:(id) rec selector:(SEL) cb  strokeSize:(int)strokeSize stokeColor:(ccColor3B)color;
+(CCRenderTexture*) createStroke: (CCLabelTTF*) label   size:(float)size   color:(ccColor3B)cor;
@end