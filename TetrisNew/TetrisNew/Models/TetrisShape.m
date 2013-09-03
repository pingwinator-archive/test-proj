 //
//  TetrisShape.m
//  TetrisNew
//
//  Created by Natasha on 07.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "TetrisShape.h"
#import "Cell.h"
#import "stdlib.h"

@interface TetrisShape()
@property (retain, nonatomic) NSMutableSet* shapePoints;
@property (retain, nonatomic) NSMutableArray* shapesCollection;
@property (retain, nonatomic) NSMutableArray* colorsCollection;
@property (assign, nonatomic) TypeShape curTypeShape;
- (CGPoint)getNextCenter:(CGPoint)localCenter withDirection:(DirectionMove)direction;
- (void)randomTypeShape;
- (NSInteger)randomNumberFrom:(NSInteger)from To:(NSInteger)to;
- (NSMutableSet*)transformation:(NSSet*)localShapePoints withLocalCentre:(CGPoint)cntr;
- (NSMutableSet*)rotateShape:(DirectionRotate)directionRotate withChanges:(BOOL)isDeepRotate;
- (NSMutableSet*)tryRotateCurrentShape:(DirectionRotate)direction;
//- (NSMutableSet*)tryRotateCurrentShape;
- (NSMutableArray*)initRotatingShapeArray;
@end
@implementation TetrisShape
@synthesize centerPoint;
@synthesize shapePoints;
@synthesize shapesCollection;
@synthesize colorsCollection;
@synthesize shapeColor;
@synthesize rotateShapeCollection;
@synthesize numbState;
@synthesize curTypeShape;
- (void)dealloc
{
    self.shapePoints = nil;
    self.shapesCollection = nil;
    self.colorsCollection = nil;
    self.shapeColor = nil;
    self.rotateShapeCollection = nil;
    [super dealloc];
}

- (NSMutableArray*)shapesCollection
{
    if (!shapesCollection) {
        shapesCollection =  [[NSMutableArray alloc] initWithObjects:
                             [NSMutableSet setWithObjects:PointToObj(CGPointMake(0, 0)), nil], //None
                             [NSMutableSet setWithObjects:PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(1, 0)), PointToObj(CGPointMake(0, 1)), PointToObj(CGPointMake(1, 1)), nil], //SquareShape
                             [NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(0, 1)), PointToObj(CGPointMake(1, 1)), nil], //SShape
                             [NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, 1)), PointToObj(CGPointMake(0, 1)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(1, 0)), nil], //ZShape
                             [NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, -1)), PointToObj(CGPointMake(0, -1)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(0, 1)), nil], //LShape
                             [NSMutableSet setWithObjects:PointToObj(CGPointMake(1, -1)), PointToObj(CGPointMake(0, -1)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(0, 1)), nil], //JShape
                             [NSMutableSet setWithObjects:PointToObj(CGPointMake(0, -1)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(0, 1)), PointToObj(CGPointMake(0, 2)), nil], //IShape
                             [NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(1, 0)), PointToObj(CGPointMake(0, 1)), nil], //TShape
                             nil];
    }
    return shapesCollection;
}

- (NSMutableArray*)colorsCollection
{
    if (!colorsCollection) {
        colorsCollection = [[NSMutableArray alloc] initWithObjects:
                            [UIColor blackColor],
                            [UIColor colorWithRed:255.0f/255.0f green:246.0f/255.0f blue:143.0f/255.0f alpha:1],//yellow
                            [UIColor colorWithRed:255.0f/255.0f green:130.0f/255.0f blue:71.0f/255.0f alpha:1],//orange
                            [UIColor colorWithRed:100.0f/255.0f green:149.0f/255.0f blue:237.0f/255.0f alpha:1],//blue
                            [UIColor colorWithRed:222.0f/255.0f green:222.0f/255.0f blue:222.0f/255.0f alpha:1],//gray
                            [UIColor colorWithRed:153.0f/255.0f green:204.0f/255.0f blue:50.0f/255.0f alpha:1],//green
                            [UIColor colorWithRed:255.0f/255.0f green:99.0f/255.0f blue:71.0f/255.0f alpha:1],//tomato
                            [UIColor colorWithRed:205.0f/255.0f green:105.0f/255.0f blue:201.0f/255.0f alpha:1],//orchid
                            [UIColor redColor],
                            nil];
    }
    return colorsCollection;
}

- (id)initRandomShapeWithCenter:(CGPoint)center
{
    self = [super init];
    if(self) {
        [self randomTypeShape];
        self.rotateShapeCollection = [self initRotatingShapeArray];
        self.numbState = 0;
        self.centerPoint = center;
    }
    return self;
}

- (NSInteger)randomNumberFrom:(NSInteger)from To:(NSInteger)to
{
    return (from + arc4random() % to);
}

- (void)randomTypeShape
{
    TypeShape randomTypeShape = [self randomNumberFrom:1 To:[self.shapesCollection count] - 1];
    self.curTypeShape = (TypeShape)randomTypeShape;
    self.shapePoints = [self.shapesCollection objectAtIndex:randomTypeShape];
    self.shapeColor = [self.colorsCollection objectAtIndex:randomTypeShape];
  //  DBLog(@"shape %u", self.curTypeShape);
}

- (NSMutableSet*)getShapePoints
{
    return [self transformation:self.shapePoints withLocalCentre:self.centerPoint];
}

#pragma mark - Move Shape

//deep move, change center of the shape
- (void)deepMove:(DirectionMove)directionMove
{
    self.centerPoint = [self getNextCenter:self.centerPoint withDirection:directionMove];
}

//get move shape for check
- (NSMutableSet*)getMovedShape:(DirectionMove)directionMove
{
    return [self transformation:self.shapePoints withLocalCentre:[self getNextCenter:self.centerPoint withDirection:directionMove]];
}

#pragma mark - Rotate Shape

- (void)deepRotate:(DirectionRotate)directionRotate
{
    self.shapePoints = [self rotateShape:directionRotate withChanges:YES];//[self rotate: directionRotate];
}

//get rotated shape for check
- (NSMutableSet*)getRotatedShape:(DirectionRotate)directionRotate
{
    return [self transformation:[self tryRotateCurrentShape: directionRotate] withLocalCentre:self.centerPoint];
}

//private
- (NSMutableArray*)initRotatingShapeArray
{
    NSMutableArray* test = [NSMutableArray array];
    switch (self.curTypeShape) {
        case (NSInteger)SquareShape: {
            [test addObject: self.shapePoints];
        }
            break;
        case ZShape: {
            [test addObject: [NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(0, 1)), PointToObj(CGPointMake(1, 1)), nil]];
            [test addObject: [NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, 1)), PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(0, 0)),PointToObj(CGPointMake(0, -1)), nil]];
        }
            break;
        case SShape: {
            [test addObject:[NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, 1)), PointToObj(CGPointMake(0, 1)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(1, 0)), nil]];
            [test addObject:[NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, 1)), PointToObj(CGPointMake(0, 1)), PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(0, 2)), nil]];
        }
            break;
        case LShape: {
            [test addObject:  [NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, -1)), PointToObj(CGPointMake(0, -1)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(0, 1)), nil]];
            [test addObject:  [NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, -1)), PointToObj(CGPointMake(0, -1)), PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(1, -1)), nil]];
            [test addObject:  [NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, -1)), PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(-1, 1)), PointToObj(CGPointMake(0, 1)), nil]];
            [test addObject:  [NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(1, 0)), PointToObj(CGPointMake(1, -1)), nil]];
        }
            break;
        case JShape: {
            [test addObject:[NSMutableSet setWithObjects:PointToObj(CGPointMake(1, -1)), PointToObj(CGPointMake(0, -1)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(0, 1)), nil]];
            [test addObject:[NSMutableSet setWithObjects:PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(-1, -1)), PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(1, 0)), nil]];
            [test addObject:[NSMutableSet setWithObjects:PointToObj(CGPointMake(0, -1)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(0, 1)), PointToObj(CGPointMake(-1, 1)), nil]];
            [test addObject:[NSMutableSet setWithObjects:PointToObj(CGPointMake(1, -1)), PointToObj(CGPointMake(0, -1)), PointToObj(CGPointMake(-1, -1)), PointToObj(CGPointMake(1, 0)), nil]];
        }
            break;
        case IShape: {
            [test addObject: [NSMutableSet setWithObjects:PointToObj(CGPointMake(0, -1)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(0, 1)), PointToObj(CGPointMake(0, 2)), nil]];
            [test addObject: [NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(1, 0)), PointToObj(CGPointMake(2, 0)), nil]];
        }
            break;
        case TShape: {
            [test addObject:[NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(1, 0)), PointToObj(CGPointMake(0, 1)), nil]];
            [test addObject:[NSMutableSet setWithObjects:PointToObj(CGPointMake(0, -1)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(0, 1)), PointToObj(CGPointMake(1, 0)), nil]];
            [test addObject:[NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(1, 0)), PointToObj(CGPointMake(0, -1)), nil]];
            [test addObject:[NSMutableSet setWithObjects:PointToObj(CGPointMake(-1, 0)), PointToObj(CGPointMake(0, 0)), PointToObj(CGPointMake(0, -1)), PointToObj(CGPointMake(0, 1)), nil]];
        }
            break;
        default:
            break;
    }
    return test;
}

- (NSMutableSet*)rotateShape:(DirectionRotate)directionRotate withChanges:(BOOL)isDeepRotate
{
    NSInteger tempNumbState = self.numbState;
    if(directionRotate == leftDirectionRotate) {
        if(tempNumbState == 0) {
           tempNumbState = [self.rotateShapeCollection count] - 1;
        } else {
           tempNumbState--;
        }
    } else {
        tempNumbState++;

        if(tempNumbState  == [self.rotateShapeCollection count]) {
            tempNumbState = 0;
        }
    }
    if(isDeepRotate) {
        self.numbState = tempNumbState;
    }
    return [self.rotateShapeCollection objectAtIndex:tempNumbState];
}

- (NSMutableSet*)tryRotateCurrentShape:(DirectionRotate)direction
{
    return [self rotateShape:direction withChanges:NO];
}

- (CGPoint)getNextCenter:(CGPoint)localCenter withDirection:(DirectionMove)direction
{
     CGPoint newCenter;
     switch (direction) {
        case (rightDirectionMove):
        {
            newCenter = CGPointMake(localCenter.x + 1, localCenter.y);
        }
            break;
        case(leftDirectionMove):
        {
            newCenter = CGPointMake(localCenter.x - 1, localCenter.y);
        }
            break;
        case(downDirectionMove):
        {
            newCenter = CGPointMake(localCenter.x, localCenter.y + 1);
        }
             break;
        default:
            break;
    }
    return newCenter;
}

//return absolute shape coordinates with current center
- (NSMutableSet*)transformation:(NSSet*)localShapePoints withLocalCentre:(CGPoint)cntr
{
    NSMutableSet* shapeLocalSet = [[[NSMutableSet alloc] init] autorelease];
    for (NSValue* v in localShapePoints) {
        CGPoint p = PointFromObj(v);
        p.x += cntr.x;
        p.y += cntr.y;
        [shapeLocalSet addObject:PointToObj(p)];
    }
    return shapeLocalSet;
}

@end
