//
//  BoardView.m
//  TetrisNew
//
//  Created by Natasha on 07.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "BoardView.h"
#import <QuartzCore/QuartzCore.h>
#import "Cell.h"
@interface BoardView()
@property (assign, nonatomic) CGFloat cellDistance;
@property (retain, nonatomic) NSIndexPath* cellIndexPath;
@property (retain, nonatomic) NSMutableArray* cellImageViewCollection;
@property (retain, nonatomic) NSMutableSet* prevBoardState;
@end

@implementation BoardView
@synthesize boardCellsForDrawing;
@synthesize amountCellX;
@synthesize amountCellY;
@synthesize cellHeight;
@synthesize cellWidth;
@synthesize nextShapeCellsForDrawing;
@synthesize showGrid;
@synthesize showColor;
@synthesize cellIndexPath;
@synthesize cellImageViewCollection;
@synthesize prevBoardState;

- (void)dealloc
{
    self.boardCellsForDrawing = nil;
    self.nextShapeCellsForDrawing = nil;
    self.cellIndexPath = nil;
    self.cellImageViewCollection = nil;
    self.prevBoardState = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.amountCellX = 10;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame amountCellX:(NSInteger)cellX amountCellY:(NSInteger)cellY
{
    self = [self initWithFrame:frame];
    if(self) {
        self.showGrid = YES;
        self.showColor = NO;
        self.amountCellX = cellX;
        self.amountCellY = cellY;
        self.cellWidth = (self.frame.size.width - 2 * boardBorderWidth) / self.amountCellX;
        self.cellHeight = (self.frame.size.height - 2 *  boardBorderWidth) / self.amountCellY;
        self.cellDistance = self.cellWidth / 10;
        self.cellImageViewCollection = [NSMutableArray array];
        self.prevBoardState = [NSMutableSet set];
        
        for (int i = 0; i < self.amountCellY; i++) {
            for (int j = 0; j < self.amountCellX; j++) {
                UIImageView* cellImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty.png"] highlightedImage:[UIImage imageNamed:@"cell.png"]]autorelease];
                cellImageView.frame = CGRectMake(boardBorderWidth + j * self.cellWidth, boardBorderWidth + i * self.cellHeight, self.cellWidth, self.cellHeight);
                
                [self.cellImageViewCollection addObject:cellImageView];
                //DBLog(@"(%d, %d) position %d", j, i, [self.cellImageViewCollection indexOfObject:cellImageView]);
                [self addSubview:cellImageView];
            }
        }
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void)setBoardCellsForDrawing:(NSMutableSet *)_boardCellsForDrawing
{
    //boardCellsForDrawing - old
    //_boardCellsForDrawing - current
    
    NSMutableSet* diffPrev = [NSMutableSet setWithSet:boardCellsForDrawing];
    
    NSMutableSet* intersect = [NSMutableSet setWithSet:boardCellsForDrawing];
    [intersect intersectSet:_boardCellsForDrawing];
    
    [diffPrev minusSet:intersect];
    
    for (Cell* cell in diffPrev) {
        UIImageView* imageViewCurCell = [self cellImageViewForPoint:cell.point];
        if(imageViewCurCell) {
            imageViewCurCell.highlighted = NO;
        }
    }
    
    NSMutableSet* diff = [NSMutableSet setWithSet:_boardCellsForDrawing];
    [diff minusSet:boardCellsForDrawing];
   
    for (Cell* cell in diff) {
        UIImageView* imageViewCurCell = [self cellImageViewForPoint:cell.point];
        if(imageViewCurCell) {
            imageViewCurCell.highlighted = YES;
        }
    }
    [boardCellsForDrawing autorelease];
    boardCellsForDrawing = [_boardCellsForDrawing retain];
 }

- (void)setNextShapeCellsForDrawing:(NSMutableSet *)_nextShapeCellsForDrawing
{
    NSMutableSet* diffPrev = [NSMutableSet setWithSet:nextShapeCellsForDrawing];
    [diffPrev minusSet:_nextShapeCellsForDrawing];
    for (Cell* cell in diffPrev) {
        UIImageView* imageViewCurCell = [self cellImageViewForPoint:cell.point];
        if(imageViewCurCell) {
            imageViewCurCell.highlighted = NO;
        }
    }
    
    NSMutableSet* diff = [NSMutableSet setWithSet:_nextShapeCellsForDrawing];
    [diff minusSet:nextShapeCellsForDrawing];
    
    for (Cell* cell in diff) {
        UIImageView* imageViewCurCell = [self cellImageViewForPoint:cell.point];
        if(imageViewCurCell) {
            imageViewCurCell.highlighted = YES;
        }
    }
    
    [nextShapeCellsForDrawing autorelease];
    nextShapeCellsForDrawing = [_nextShapeCellsForDrawing retain];
}

- (UIImageView*)cellImageViewForPoint:(CGPoint)point
{
    if(point.y >= 0) {
    NSUInteger n = point.y * self.amountCellX + point.x;
    
        return [self.cellImageViewCollection objectAtIndex:n];//[[UIImageView alloc]init];
    } else {
        return nil;
    }
}
@end
