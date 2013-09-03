//
//  UIApplication+CheckVersion.m
//  TetrisNew
//
//  Created by Natasha on 19.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "UIApplication+CheckVersion.h"

@implementation UIApplication (CheckVersion)
- (BOOL)has4inchDisplay
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) 
    {
        if (([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale) >= 1136.0f) //if screen size 1136x640
        {
            return YES;
        }
    }
    return NO;
}
@end
