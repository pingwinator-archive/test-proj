//
//  UIViewController+Deprecated.h
//  UberSocial
//
//  Created by Developer on 31.08.12.
//  Copyright (c) 2012 UberMedia, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Deprecated)

- (void)deprecatedPresentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;

- (void)deprecatedDismissModalViewControllerAnimated:(BOOL)animated;

- (UIViewController*)parent;
@end
