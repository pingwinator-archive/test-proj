//
//  TetrisShape.h
//  TetrisNew
//
//  Created by Natasha on 07.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TetrisShape : NSObject
@property (retain, nonatomic) UIColor* shapeColor;
@property (retain, nonatomic) NSMutableArray* rotateShapeCollection;
@property (assign, nonatomic) CGPoint centerPoint;
@property (assign, nonatomic) NSInteger numbState;
- (NSMutableSet*)getShapePoints;
- (id)initRandomShapeWithCenter:(CGPoint)center;

- (void)deepMove:(DirectionMove)directionMove;
- (NSMutableSet*)getMovedShape:(DirectionMove)directionMove;

- (void)deepRotate:(DirectionRotate)directionRotate;
- (NSMutableSet*)getRotatedShape:(DirectionRotate)directionRotate;
@end
