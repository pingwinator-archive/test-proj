//
//  SettingViewController.h
//  TetrisNew
//
//  Created by Natasha on 10.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CompetitionBlock)(void);
@interface SettingViewController : UIViewController
@property (assign, nonatomic) BOOL showGrid;
@property (assign, nonatomic) BOOL showColor;
@property (assign, nonatomic) BOOL showTutorial;
@property (copy, nonatomic) CompetitionBlock competitionBlock;
+ (BOOL)loadSettingGrid;
+ (void)saveSettingGrid:(BOOL)grid;
+ (BOOL)loadSettingColor;
+ (void)saveSettingColor:(BOOL)showColor;
+ (BOOL)loadSettingTutorial;
+ (void)saveSettingTutorial:(BOOL)showTutorial;
@end
