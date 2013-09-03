//
//  BoardViewController.m
//  TetrisNew
//
//  Created by Natasha on 08.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "BoardViewController.h"
#import "BoardView.h"
#import "TetrisShape.h"
#import "Cell.h"
#import "StatisticManager.h"
@interface BoardViewController ()
@property (retain, nonatomic) TetrisShape* nextShape;
@property (retain, nonatomic) TetrisShape* currentShape;
@property (retain, nonatomic) NSMutableSet* borderSet;
@property (retain, nonatomic) NSMutableSet* fallenShapeSet;
@property (assign, nonatomic) CGFloat gameTimerInterval;
- (NSMutableSet*)deleteLine:(NSMutableSet*)boardPoints line:(NSInteger)numberLine;
- (BOOL)validationMove:(NSMutableSet*)validateSet;
- (void)timerTick;
- (void)showGrid:(BOOL)grid;
- (void)invokeDeleteLineDelegate;
@end

@implementation BoardViewController
@synthesize boardView;
@synthesize gameOver;
@synthesize nextShape;
@synthesize currentShape;
@synthesize boardCells;
@synthesize borderSet;
@synthesize fallenShapeSet;
@synthesize nextShapeView;
@synthesize nextShapeCells;
@synthesize newGame;
@synthesize gameTimer;
@synthesize lines;
@synthesize gameTimerInterval;

- (void)setBoardCells:(NSMutableSet*)_boardCells
{
    [boardCells release];
    boardCells = [_boardCells retain];
    self.boardView.boardCellsForDrawing = _boardCells;
}

- (void)dealloc
{
    self.boardView = nil;
    self.fallenShapeSet = nil;
    self.borderSet = nil;
    self.gameTimer = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame amountCellX:(NSInteger)cellX amountCellY:(NSInteger)cellY
{
    self = [super init];
    if(self) {
    
        self.lines = 0;
        self.boardView = [[[BoardView alloc] initWithFrame:frame amountCellX:cellX amountCellY:cellY] autorelease];
        self.boardView.backgroundColor = [UIColor clearColor];
        self.gameOver = NO;
        self.newGame = NO;
        
        self.borderSet = [[[NSMutableSet alloc] init] autorelease];
        for (NSInteger i = 0; i < self.boardView.amountCellX ; i++) {
            [borderSet addObject:PointToObj(CGPointMake(i, self.boardView.amountCellY))];
        }
        for (NSInteger j = -2; j < self.boardView.amountCellY; j++) {
            [borderSet addObject:PointToObj(CGPointMake(-1, j))];
            [borderSet addObject:PointToObj(CGPointMake(self.boardView.amountCellX, j))];
        }
        if(isiPhone) {
            self.nextShapeView = [[[BoardView alloc] initWithFrame:CGRectMake(self.boardView.frame.size.width + self.boardView.frame.origin.x + 5, self.boardView.frame.size.height - 130, 50, 50) amountCellX:4 amountCellY:4] autorelease];
        } else {
            self.nextShapeView = [[[BoardView alloc] initWithFrame:CGRectMake(self.boardView.frame.size.width + self.boardView.frame.origin.x + 10, self.boardView.frame.size.height - 250, 135,135) amountCellX:4 amountCellY:4] autorelease];
        }
        self.nextShapeView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Update

- (void)updateShape
{
    self.startPoint = CGPointMake(5, -2);
    self.currentShape = [[[TetrisShape alloc] initRandomShapeWithCenter:self.startPoint] autorelease];
    [self stopGameTimer];
    [self startGameTimer];
    self.fallenShapeSet = [[[NSMutableSet alloc] init] autorelease];
}

- (void)updateBoard
{
    NSMutableSet* cellsCurrentBoard = [[[NSMutableSet alloc] initWithSet:[Cell pointsToCells:[self.currentShape getShapePoints] withColor:self.currentShape.shapeColor]] autorelease];
    [cellsCurrentBoard unionSet:self.fallenShapeSet];
    self.boardCells = cellsCurrentBoard;
}

-(void)updateNextShape
{
    self.nextShape = [[[TetrisShape alloc] initRandomShapeWithCenter:CGPointMake(1, 1)] autorelease];
    self.nextShapeCells = [Cell pointsToCells:[self.nextShape getShapePoints] withColor:self.nextShape.shapeColor];
    self.nextShapeView.nextShapeCellsForDrawing =  self.nextShapeCells;
    [self stopGameTimer];
    [self startGameTimer];
    self.startPointNextShape = CGPointMake(1, 1);
}

- (void)resetBoard
{
    self.boardCells = [NSMutableSet set];
    self.nextShapeCells = [NSMutableSet set];
    [self.fallenShapeSet removeAllObjects];
  
    self.lines = 0;
    self.gameTimerInterval = 1.0f;
    [self invokeDeleteLineDelegate];
   
    [self stopGameTimer];

    self.currentShape = nil;
    self.gameOver = NO;
}

#pragma mark - Move Shape

- (void)moveShape:(DirectionMove) directionMove
{
    NSMutableSet* tempSet = [NSMutableSet setWithSet:[self.currentShape getMovedShape:directionMove]];
    if([self validationMove:tempSet])
    {
        [self.currentShape deepMove:directionMove];
        [self updateBoard];
    } else {
        if (directionMove == downDirectionMove && !self.gameOver) {
            NSInteger amountDeleted = 0;
            NSInteger minY = self.boardView.amountCellY;
            NSInteger maxY = 0;
            [self.fallenShapeSet unionSet:[Cell pointsToCells:[self.currentShape getShapePoints] withColor:self.currentShape.shapeColor]];
            //check for game over
            BOOL showGameOverAlert = NO;
            for (Cell* c in self.boardCells) {
                if(c.point.y == 1 && [self.boardCells count]>10 && !showGameOverAlert) {
                    self.gameOver = YES;
                    showGameOverAlert = YES;
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game Over", @"")  message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"New game", @"") otherButtonTitles:nil, nil];
                    [alert show];
                    [self stopGameTimer];
                }
            }
            //check line where shape was add
            for (NSValue* v in [self.currentShape getShapePoints]) {
                if(PointFromObj(v).y > maxY) {
                    maxY = PointFromObj(v).y;
                }
                if(PointFromObj(v).y < minY) {
                    minY = PointFromObj(v).y;
                }
            }
            for (NSInteger i = maxY; i >= minY; i--) {
                NSInteger count = 0;
                for (Cell* c in self.fallenShapeSet) {
                    if(c.point.y == i + amountDeleted) {
                        count++;
                    }
                }
                    if (count == self.boardView.amountCellX)
                    {
                        self.fallenShapeSet = [self deleteLine:self.fallenShapeSet line:i+amountDeleted];
                        amountDeleted++;
                    }
            }
            self.currentShape = self.nextShape;
            self.currentShape.centerPoint =  self.startPoint;
            [self updateNextShape];
        }
    }
}

- (void)rotateShape:(DirectionRotate) directionRotate
{
    NSMutableSet* tempSet = [NSMutableSet setWithSet:[self.currentShape getRotatedShape:directionRotate]];
    DBLog(@"2");
    if([self validationMove:tempSet]) {
        [self.currentShape deepRotate:directionRotate];
         [self updateBoard];
        DBLog(@"3");
    }
    DBLog(@"4");
}

- (void)invokeDeleteLineDelegate
{
    if ([self.delegate respondsToSelector:@selector(deleteLine:)]) {
        [self.delegate deleteLine:self.lines];
    }
}

- (NSMutableSet*)deleteLine:(NSMutableSet*)boardPoints line:(NSInteger)numberLine
{
    //amount of deleted line
    self.lines++;
    [self invokeDeleteLineDelegate];
    if(self.lines % 2 == 0) {
        self.gameTimerInterval *= 0.91f;
        [self stopGameTimer];
        [self startGameTimer];
    }
    
    NSMutableSet* tempSet = [NSMutableSet setWithSet:[Cell cellsToPoints:boardPoints]];
    for (NSInteger i = 0; i < [self.boardCells count]; i++) {
        if([tempSet intersectsSet:[NSMutableSet setWithObjects:PointToObj(CGPointMake(i, numberLine)), nil]]) {
            //?
            [UIView animateWithDuration:0.1 animations:^(void) {
                [tempSet removeObject:PointToObj(CGPointMake(i, numberLine))];
                [self updateBoard];
            }];
            
        }
    }
    NSMutableSet* setResult = [[[NSMutableSet alloc] init] autorelease];
    
    for (Cell* c in self.boardCells) {
        if([tempSet intersectsSet:[NSMutableSet setWithObject:[Cell cellToPointObj:c]]]) {
            if(c.point.y < numberLine) {
                [setResult addObject:[[[Cell alloc] initWithPoint:CGPointMake(c.point.x, c.point.y + 1) andColor:c.colorCell] autorelease]];
            } else {
                [setResult addObject:[[[Cell alloc] initWithPoint:CGPointMake(c.point.x, c.point.y) andColor:c.colorCell] autorelease]];
            }
        }
    }
    return setResult;
 }

- (BOOL)validationMove:(NSMutableSet*)validateSet
{
    NSMutableSet* set = [[[NSMutableSet alloc] initWithSet:validateSet] autorelease];
    [set intersectSet:self.borderSet];
    return ![validateSet intersectsSet:self.borderSet] && ![validateSet intersectsSet:[Cell cellsToPoints: self.fallenShapeSet]];
}

- (void)start
{
    self.gameTimerInterval = 1.0f;
    [self updateBoard];
    [self updateNextShape];
    [self updateShape];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        if([self.resetGameDelegate respondsToSelector:@selector(newGame)]) {
            [self.resetGameDelegate newGame];
        }
    }
}

#pragma mark - Timer

- (void)timerTick
{
    if(self.gameOver) {
        [StatisticManager logMessage:gameOverMessage];
        [StatisticManager sendScoreGame:self.lines];
        [self stopGameTimer];
    } else {
        [self moveShape:downDirectionMove];
    }
}

- (void)startGameTimer
{
    if(!self.gameTimer) {
       self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:self.gameTimerInterval target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    }
 }

- (void)stopGameTimer
{
    [self.gameTimer invalidate];
    self.gameTimer = nil;
}

#pragma mark - Settings 

- (void)showGrid:(BOOL)grid
{
    self.boardView.showGrid = grid;
    self.nextShapeView.showGrid = grid;
}

- (void)showColor:(BOOL)isColor
{
    self.boardView.showColor = isColor;
    self.nextShapeView.showColor = isColor;
}
@end
