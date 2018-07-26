/*
 *  Constants.h
 *  Bubble Duck
 *
 *  Created by Santiago Vassoler on 16/04/2012.
 *  Copyright 2012 Santiago Vassoler All rights reserved.
 *
 */

#ifdef UI_USER_INTERFACE_IDIOM()
#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else
#define IS_IPAD() (NO)
#endif

#define size_x 250
#define size_y 175

#define SD_FNT          @".fnt"
#define HD_FNT          @"-ipad.fnt"


#define SD_HD_FONT(__filename__)   \
(IS_IPAD() == YES ?     \
[__filename__ stringByReplacingOccurrencesOfString:SD_FNT withString:HD_FNT] :  \
__filename__)


#define HD_TEXT(__size__)   \
(IS_IPAD() == YES ?         \
( __size__ * 2.1333333333333333 ) :            \
__size__)

#define HD_CGSIZE(size_x,size_y)   \
(IS_IPAD() == YES ?         \
 CGSizeMake ((size_x * 2.1333333333333333 ),(size_y *2.1333333333333333)):\
CGSizeMake(size_x, size_y))


#define HD_SCROLL(rect_x,rect_y,rect_w , rect_z)   \
(IS_IPAD() == YES ?         \
CGRectMake ((rect_x * 1.0333333333333333),(rect_y *1.0333333333333333),(rect_w *2.1333333333333333),(rect_z *2.1333333333333333)):\
CGRectMake(rect_x, rect_y,rect_w,rect_z))


#define HD_CCP(j , s )\
(IS_IPAD()==YES? \
	ccp((j) , (s * 0.92)):\
ccp(j,s)

#define kh 1

#define kJumpHigh(_kh_)   \
(IS_IPAD() == YES ?         \
( _kh_ * 29 ) :            \
kh* 19)



#define kMaxCloudMoveDuration 10
#define kMinCloudMoveDuration 4

#define kInitialSpeed 4
#define kTagStepDistance 0
#define kJumpShort 13
#define kGravityFactor -1
#define kPlatformHeadSize 10 //era 50
#define kDifficultySpeed 0.8
#define kDifficultyScore 100


