//
//  ViewController.h
//  TetrisNew
//
//  Created by Natasha on 07.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BGView;
@class BoardView;
#import "BoardViewController.h"

@interface GameViewController : UIViewController<DeleteLineDelegate, GameOverDelegate>
@property (assign, nonatomic) BOOL isStart;
@property (assign, nonatomic) NSInteger gameCount;
- (void)play;
- (void)reset;
- (void)continueGame;
- (void)pauseGame;
////timer
- (void)pauseGameTimer;
@end
