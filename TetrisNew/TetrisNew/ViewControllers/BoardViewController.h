//
//  BoardViewController.h
//  TetrisNew
//
//  Created by Natasha on 08.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BoardView;
@class TetrisShape;
@protocol DeleteLineDelegate;
@protocol GameOverDelegate;

@interface BoardViewController : UIViewController<UIAlertViewDelegate>
@property (retain, nonatomic) NSMutableSet* boardCells;
@property (retain, nonatomic) NSMutableSet* nextShapeCells;
@property (retain, nonatomic) BoardView* boardView;
@property (retain, nonatomic) BoardView* nextShapeView;
@property (retain, nonatomic) NSTimer* gameTimer;
@property (assign, nonatomic) BOOL gameOver;
@property (assign, nonatomic) BOOL newGame;
@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGPoint startPointNextShape;
@property (assign, nonatomic) NSInteger lines;
@property (assign, nonatomic) id <DeleteLineDelegate>delegate;
@property (assign, nonatomic) id <GameOverDelegate>resetGameDelegate;
- (id)initWithFrame:(CGRect)frame amountCellX:(NSInteger)cellX amountCellY:(NSInteger)cellY;
- (void)start;
- (void)resetBoard;
//manage
- (void)rotateShape:(DirectionRotate) directionRotate;
- (void)moveShape:(DirectionMove) directionMove;
//timer
- (void)startGameTimer;
- (void)stopGameTimer;
//grid
- (void)showGrid:(BOOL)grid;
- (void)showColor:(BOOL)isColor;
@end

@protocol DeleteLineDelegate <NSObject>
- (void)deleteLine:(NSInteger)amount;
@end

@protocol GameOverDelegate <NSObject>
- (void)newGame;
@end



