//
//  BoardView.h
//  TetrisNew
//
//  Created by Natasha on 07.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardView : UIView
@property (assign, nonatomic) NSInteger amountCellX;
@property (assign, nonatomic) NSInteger amountCellY;
@property (retain, nonatomic) NSMutableSet* boardCellsForDrawing;
@property (retain, nonatomic) NSMutableSet* nextShapeCellsForDrawing;
@property (assign, nonatomic) CGFloat cellWidth;
@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) BOOL showGrid;
@property (assign, nonatomic) BOOL showColor;
- (id)initWithFrame:(CGRect)frame amountCellX:(NSInteger)cellX amountCellY:(NSInteger)cellY;
@end
