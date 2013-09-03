//
//  DefineConst.h
//  Tetris
//
//  Created by Natasha on 29.09.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#ifndef Tetris_DefineConst_h
#define Tetris_DefineConst_h

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject;

#define isiPhone [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define isiPad [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#ifdef DEBUGGING
# define DBLog(fmt,...) NSLog(@"%@",[NSString stringWithFormat:(fmt), ##__VA_ARGS__]);
#else
# define DBLog(...)
#endif

//http://stackoverflow.com/questions/1902021/suppressing-is-deprecated-when-using-respondstoselector
#define DISABLE_DEPRICADETED_WARNINGS_BEGIN _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\" ")
#define DISABLE_DEPRICADETED_WARNINGS_END _Pragma("clang diagnostic pop")

//tetris const
#define boardBorderWidth 2
#define boardGridWidth 1
#define cellGridWidth 2.5

#define offSetBorderThin 3
#define borderThin 2
#define offsetBorderThick 8
#define borderThick 3

//buttons
#define settingSizeButton 40
#define manageSizeButton 45
#define moveSizeButton 70
#define rotateSizeButton 90
#define manageSizeButtoniPad 60
#define moveSizeButtoniPad 80
#define rotateSizeButtoniPad 120

#define distanceManageButtonAndLabel (manageSizeButton - 5)
#define distanceMoveButtonAndLabel (moveSizeButton - 5)
#define distanceRotateButtonAndLabel (rotateSizeButton - 5)

#define settingFont [UIFont fontWithName:@"American Typewriter" size:20]
#define tutorialFont [UIFont fontWithName:@"American Typewriter" size:15]
#define textButtonFont [UIFont fontWithName:@"American Typewriter" size:10]
#define textButtonFontIPad [UIFont fontWithName:@"American Typewriter" size:12]
#define scoreFont [UIFont fontWithName:@"DS-Digital" size:15]
#define scoreFontLarge [UIFont fontWithName:@"DS-Digital" size:20]
#define scoreFontiPad [UIFont fontWithName:@"DS-Digital" size:30]

#define scoreLabelWidth 50
#define scoreLabelHeigth 50
#define speedLabelWidth 50
#define speedLabelHeigth 50
#define labelPlayTextWidthIPad 45
#define labelPlayTextWidthIPhone 35
#define labelPlayTextHeigth 35
#define labelManageTextWidth 80
#define labelMoveTextWidth 60
#define labelRotateTextWidth 60
#define labelManageTextHeigth 20
#define labelTextHeigth 15
#define labelScoreWidth 50
#define labelScoreHeigth 50
#define labelManageOffset 15
#define labelMoveOffset 10
#define labelRotateOffset 10

#define labelOffsetHeight 10
#define imageOffsetHeight 10
#define imageOffsetHeightiPad 30
#define PointToObj(point) [NSValue valueWithCGPoint:point]
#define PointFromObj(value) [value CGPointValue]

#define delayForButtonPressed 0.2
#define delayForDownButtonPressed 0.1

#define kShowGrid @"grid"
#define kShowColor @"showColorShape"
#define kShowTutorial @"showTutorial"
#define delayForSubView 0.3
#define delayForHint 1.5
#define delayForHintStart 1
#define delayForHintLong 5.0
#define delayForAnimation 0.5

#define kLeaderboardID @"com.iosappsbuilder.tetris.score"
typedef enum {
    downDirectionMove,
    rightDirectionMove,
    leftDirectionMove
} DirectionMove;
typedef enum {
    rightDirectionRotate,
    leftDirectionRotate
} DirectionRotate;

typedef enum {
    NoShape,
    SquareShape,
    ZShape,
    SShape,
    LShape,
    JShape,
    IShape,
    TShape
} TypeShape;

#endif
