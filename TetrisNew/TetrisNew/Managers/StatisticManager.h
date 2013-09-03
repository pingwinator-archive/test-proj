//
//  StatisticManager.h
//  TetrisNew
//
//  Created by Natasha on 13.11.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flurry.h"

#define flurryKey @"STPJ6GDXJCNGWT7FR2JH"
#define startGameMessage @"StartGame"
#define gameOverMessage @"GameOver"
#define pauseGameMessage @"PauseGame"
#define resetGameMessage @"ResetGame"
#define scoreGameKey @"ScoreGameKey"
#define scoreGameMessage @"ScoreGame"

@interface StatisticManager : NSObject
+ (void)logMessage:(NSString*)message;
+ (void)sendScoreGame:(NSInteger)score;
+ (id) sharedInstance;
@end
