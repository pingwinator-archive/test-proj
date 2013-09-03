//
//  GameCenterViewController.h
//  TetrisNew
//
//  Created by Natasha on 14.11.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCenterManager.h"
#import <GameKit/GameKit.h>
@interface GameCenterViewController : UIViewController <UIActionSheetDelegate, GKLeaderboardViewControllerDelegate, GameCenterManagerDelegate>
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, assign) NSInteger currentScore;
@property (nonatomic, retain) NSString* currentLeaderBoard;
- (void) showLeaderboard;
- (void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;
@end
