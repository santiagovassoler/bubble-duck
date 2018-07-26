//
//  MovingPlatform.h
//  Bubble Duck
//
//  Created by Santiago Vassoler on 19/10/2011.
//  Copyright Santiago Vassoler 2011. All rights reserved.
//

#import "cocos2d.h"
#import "Constants.h"

@interface MovingPlatform : CCSprite {
    CGSize winSize;
    CCArray *_platforms1;
    CCArray *_platforms2;
    CCArray *_platforms3;
    
    CCArray *_imagePlatformLeft;
    CCArray *_imagePlatformMid;
    CCArray *_imagePlatformRight;
    
    int _nextPlatformLeft;
    int _nextPlatformMid;
    int _nextPlatformRight;
    
    BOOL isPlatform1InAction;
    BOOL isPlatform2InAction;
    BOOL isPlatform3InAction;
    BOOL isGap;
        
    //important settings
    BOOL isPaused;
    double platformWidth;
    double platformHeight;
    float platformSpeed;
    int maximumPlatformIteration;
    int numPlatformArray;
    //images variables
    NSString *leftImageName;
    NSString *middleImageName;
    NSString *rightImageName;
    
    CGPoint targetCoordinate;
    CGPoint returnCoordinate;
    CGPoint pointZero;
    
	
}

@property BOOL isPaused;
@property double platformWidth;
@property double platformHeight;
@property float platformSpeed;
@property int maximumPlatformIteration;
@property int numPlatformArray; 
@property CGFloat targetCoorX;
@property CGPoint targetCoordinate;
@property (nonatomic, retain) NSString *leftImageName;
@property (nonatomic, retain) NSString *middleImageName;
@property (nonatomic, retain) NSString *rightImageName;

- (id)initWithSpeed:(float)speed andPause:(BOOL)pause andImages:(CCArray*)images;
- (void)paused:(BOOL)yesno;
- (CGPoint)getYCoordinateAt:(CGPoint)coorX;
//---
- (void)initImagesIntoArray;
- (void)initPlatformWithId:(int)Id andWithNum:(int)max andCoordinateY:(float)coorY;
- (float)randomValueBetween:(float)low andValue:(float)high;
- (float)randomPlatformHeight;
- (void)getImageSize;
- (float)calculateGapFactor;

//- (void) initEnemy;
//- (void) appearEnemyRandomlyWithCoorY:(CGFloat)coorY;

@end
