//
//  GameCenterViewController.m
//  TetrisNew
//
//  Created by Natasha on 14.11.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "GameCenterViewController.h"

@interface GameCenterViewController ()

@end

@implementation GameCenterViewController
@synthesize gameCenterManager;
@synthesize currentScore;
@synthesize currentLeaderBoard;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.currentLeaderBoard = kLeaderboardID;
    self.currentScore = 0;
    [GameCenterManager authenticateUser];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showLeaderboard
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL)
    {
        leaderboardController.category = self.currentLeaderBoard;
        leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
        leaderboardController.leaderboardDelegate = self;
        [self presentModalViewController: leaderboardController animated: YES];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated: YES];
    [viewController release];
}
@end
