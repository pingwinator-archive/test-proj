//
//  UIPopoverManager.m
//  PopoverManager
//
//  Created by Igor Fedorov on 9/5/10.
//  Copyright 2010 Flash/Flex, iPhone developer at Postindustria. All rights reserved.
//

#import "UIPopoverManager.h"

#define CHANGE_ORIENTATION_DURATION 0.33f

//#define LOG_FUNC NSLog(@"%s [Line %d] ", __PRETTY_FUNCTION__, __LINE__);
#define LOG_FUNC 

@implementation UIView(PopoverTarget)

@end

@interface UIPopoverManager() <UIPopoverControllerDelegate>


@property (nonatomic, strong) UIView* viewForPopover;
@property (nonatomic, unsafe_unretained) id <PopoverTarget> targetView;
@property (nonatomic, unsafe_unretained) id dismissTarget;
@property (nonatomic, assign) CGSize ident;
@property (nonatomic, assign) SEL dismissSelector;
@property (nonatomic, assign) UIInterfaceOrientation currentOrientation;
@property (nonatomic, assign) UIPopoverArrowDirection arrowDirection;
@property (nonatomic, strong) UIPopoverController *popover;


+ (UIPopoverManager*)sharedManager;

- (void)setDefaults;

- (CGRect)targetFrameWithIdent;

- (void)presentPopover;

- (void)dismissPopoverAnimated:(BOOL)animated;

- (void)orientationDidChange:(NSDictionary*)notification;

- (void)addRotationObserving;

- (void)removeObserving;

- (void)addKeyboardObserving;

- (void)keyboardNotification:(NSNotification*)notification;

- (void)showControllerInPopover:(UIViewController*)aController inView:(UIView*)aView forTarget:(id<PopoverTarget>)aTargetView dismissTarget:(id)aDismissTarget dismissSelector:(SEL)aDismissSelector;

@end

@implementation UIPopoverManager

@synthesize popover;
@synthesize viewForPopover;
@synthesize targetView;
@synthesize dismissTarget;
@synthesize ident;
@synthesize dismissSelector;
@synthesize currentOrientation;
@synthesize arrowDirection;


- (void)dealloc 
{
	[self dismissPopoverAnimated:NO];
}

- (id)init 
{
	if ((self = [super init])) {
		self.currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
		[self setDefaults];
	}
	return self;
}


#pragma mark - private

static UIPopoverManager __strong* sharedManager;

+ (UIPopoverManager*)sharedManager 
{
	@synchronized(self) {
		if (sharedManager == nil) {
			sharedManager = [[self alloc] init];
		}
	}
	return sharedManager;
}

- (void)setDefaults 
{
	self.arrowDirection = UIPopoverArrowDirectionAny;
	self.ident = CGSizeMake(0, 0);
}

- (CGRect)targetFrameWithIdent 
{
	if (self.targetView == nil) {
		return CGRectZero;
	}
	
	CGRect res = self.targetView.frame;
	if (self.ident.width || self.ident.height) {
		res = CGRectMake(roundf(self.targetView.center.x + self.ident.width), roundf(self.targetView.center.y + self.ident.height), 1, 1);
	}
	return res;
}

- (void)presentPopover 
{
	LOG_FUNC
	[self.popover presentPopoverFromRect:[self targetFrameWithIdent]
								  inView:self.viewForPopover
				permittedArrowDirections:self.arrowDirection
								animated:YES];
}


- (void)dismissPopoverAnimated:(BOOL)animated 
{
	if (self.popover != nil && self.popover.popoverVisible) {
		[self.popover dismissPopoverAnimated:animated];
		//[self popoverControllerDidDismissPopover:self.popover];
	}
}

- (void)orientationDidChange:(id)notification 
{
	LOG_FUNC
	[self dismissPopoverAnimated:NO];
	UIInterfaceOrientation toOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	NSTimeInterval duration = CHANGE_ORIENTATION_DURATION;
	if (UIDeviceOrientationIsPortrait(currentOrientation)) {
		if (UIDeviceOrientationIsPortrait(toOrientation)) {
			duration += CHANGE_ORIENTATION_DURATION;
		}
	} else {
		if (UIDeviceOrientationIsLandscape(toOrientation)) {
			duration += CHANGE_ORIENTATION_DURATION;
		}
	}
    
	[self performSelector:@selector(presentPopover) withObject:nil afterDelay:duration];
}

- (void) keyboardNotification:(NSNotification*)notification 
{
    [self dismissPopoverAnimated:NO];
	[self performSelector:@selector(presentPopover) withObject:nil afterDelay:0.33f];
}

- (void)addRotationObserving 
{
	LOG_FUNC
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(orientationDidChange:)
												 name:UIApplicationDidChangeStatusBarOrientationNotification 
											   object:nil];
}

- (void)addKeyboardObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObserving 
{
	LOG_FUNC
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showControllerInPopover:(UIViewController*)aController 
						 inView:(UIView*)aView 
					  forTarget:(id<PopoverTarget>)aTargetView 
				  dismissTarget:(id)aDismissTarget 
				dismissSelector:(SEL)aDismissSelector 
{
	LOG_FUNC
	[self dismissPopoverAnimated:NO];
	self.targetView = aTargetView;
	self.viewForPopover = aView;
	self.dismissTarget = aDismissTarget;
	self.dismissSelector = aDismissSelector;
	UIPopoverController *newPopover = [[UIPopoverController alloc] initWithContentViewController:aController];
	self.popover = newPopover;
	[self.popover setDelegate:self];
	[self addRotationObserving];
    [self addKeyboardObserving];
	[self presentPopover];
}

#pragma mark - public

+ (UIPopoverController*)currentPopover 
{
	return [[UIPopoverManager sharedManager] popover];
}

+ (void)setArrowDirection:(UIPopoverArrowDirection)aDirection 
{
	[UIPopoverManager sharedManager].arrowDirection = aDirection;
}

+ (void)setIndent:(float)aValue
{
	[UIPopoverManager sharedManager].ident = CGSizeMake(aValue, aValue);
}

+ (void)setIndentX:(float)x andY:(float)y  
{
	[UIPopoverManager sharedManager].ident = CGSizeMake(x, y);
}


+ (void)showControllerInPopover:(UIViewController*)aController inView:(UIView*)aView forTarget:(id<PopoverTarget>)aTargetView 
{
	[UIPopoverManager showControllerInPopover:aController inView:aView forTarget:aTargetView dismissTarget:nil dismissSelector:NULL];
}

+ (void)showControllerInPopover:(UIViewController*)aController 
                         inView:(UIView*)aView forTarget:(id<PopoverTarget>)aTargetView 
                  dismissTarget:(id)aDismissTarget 
                dismissSelector:(SEL)aDismissSelector 
{
	[[UIPopoverManager sharedManager] showControllerInPopover:aController inView:aView forTarget:aTargetView dismissTarget:aDismissTarget dismissSelector:aDismissSelector];
}

+ (void)dismissPopover 
{
	[[UIPopoverManager sharedManager] dismissPopoverAnimated:NO];
	[[UIPopoverManager currentPopover].delegate popoverControllerDidDismissPopover:[UIPopoverManager currentPopover]];
}

+ (void)dismissPopoverAnimated:(BOOL)animated
{
	[[UIPopoverManager sharedManager] dismissPopoverAnimated:animated];
	[[UIPopoverManager currentPopover].delegate popoverControllerDidDismissPopover:[UIPopoverManager currentPopover]];
}


#pragma mark -
#pragma mark UIPopoverControllerDelegate methods



- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController 
{
	LOG_FUNC;
	[self removeObserving];
   // SAFE_CALL(self.dismissTarget, self.dismissSelector);
    if ([self.dismissTarget respondsToSelector:self.dismissSelector]) {
        [self.dismissTarget performSelector:self.dismissSelector withObject:nil afterDelay:0];
    }
	self.popover = nil;
	[self setDefaults];
}

@end
