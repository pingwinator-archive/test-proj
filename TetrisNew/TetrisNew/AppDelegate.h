//
//  AppDelegate.h
//  TetrisNew
//
//  Created by Natasha on 07.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GameViewController *viewController;

@end
