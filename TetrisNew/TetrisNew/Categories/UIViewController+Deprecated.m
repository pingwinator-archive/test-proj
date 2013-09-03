//
//  UIViewController+Deprecated.m
//  UberSocial
//
//  Created by Developer on 31.08.12.
//  Copyright (c) 2012 UberMedia, Inc. All rights reserved.
//

#import "UIViewController+Deprecated.h"



@implementation UIViewController (Deprecated)

- (void)deprecatedPresentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self presentViewController:modalViewController animated:animated  completion:nil];
    } else {
DISABLE_DEPRICADETED_WARNINGS_BEGIN
        [self presentModalViewController:modalViewController animated:animated];
DISABLE_DEPRICADETED_WARNINGS_END
    }
}

- (void)deprecatedDismissModalViewControllerAnimated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:animated completion:nil];
    } else {
DISABLE_DEPRICADETED_WARNINGS_BEGIN
        [self dismissModalViewControllerAnimated:animated];
DISABLE_DEPRICADETED_WARNINGS_END
    }
}

- (UIViewController*)parent
{
    UIViewController* viewController = nil;
    if (self.parentViewController)
    {
        viewController = self.parentViewController;
    }
    else if( [self respondsToSelector: @selector( presentingViewController )] && [self presentingViewController])
    {
        viewController = self.presentingViewController;
    }
    return viewController;
}
@end
