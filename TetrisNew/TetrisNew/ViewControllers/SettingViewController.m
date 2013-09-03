//
//  SettingViewController.m
//  TetrisNew
//
//  Created by Natasha on 10.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "SettingViewController.h"
#import "UIViewController+Deprecated.h"
@interface SettingViewController ()
@property (retain, nonatomic) UIButton* closeButton;
@property (retain, nonatomic) UISwitch* toggleShowGridButton;
@property (retain, nonatomic) UISwitch* toggleAddColorButton;
@end

@implementation SettingViewController 
@synthesize closeButton;
@synthesize showGrid;
@synthesize showColor;
@synthesize showTutorial;
@synthesize toggleShowGridButton;
@synthesize toggleAddColorButton;
- (void)dealloc
{
    self.closeButton = nil;
    self.toggleAddColorButton = nil;
    self.toggleShowGridButton = nil;
    [super dealloc];
}

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
    self.showGrid = [SettingViewController loadSettingGrid];
    self.showColor = [SettingViewController loadSettingColor];
    self.showTutorial = [SettingViewController loadSettingTutorial];
    CGRect rect;
    if(isiPhone) {
        rect = CGRectMake(20, 20, 170, 20);
        UILabel* showGridLabel = [[[UILabel alloc] initWithFrame:rect] autorelease];
        showGridLabel.text = NSLocalizedString(@"Show grid", @"");
        [showGridLabel setFont:settingFont];
        [self.view addSubview: showGridLabel];
        
        self.toggleShowGridButton = [[[UISwitch alloc] initWithFrame:CGRectMake(rect.origin.x + 200, rect.origin.y, 50, 50)] autorelease];
        [self.toggleShowGridButton setOn:[SettingViewController loadSettingGrid]];
        [self.toggleShowGridButton addTarget:self action:@selector(changeShowGridToggle) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.toggleShowGridButton];
        
        //color setting
        CGRect rectForColor = CGRectMake(rect.origin.x, rect.origin.y + 50, 170, 20);
        UILabel* showColorLabel = [[[UILabel alloc] initWithFrame:rectForColor] autorelease];
        showColorLabel.text = NSLocalizedString(@"Add color", @"");
        [showColorLabel setFont:settingFont];
 
        [self.view addSubview:showColorLabel];
        
        self.toggleAddColorButton = [[[UISwitch alloc] initWithFrame:CGRectMake(rectForColor.origin.x + 200, rectForColor.origin.y, 50, 50)] autorelease];
        [self.toggleAddColorButton setOn:[SettingViewController loadSettingColor]];
        [self.toggleAddColorButton addTarget:self action:@selector(changeColorToggle) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.toggleAddColorButton];
            
        //close button
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.closeButton.frame = CGRectMake(self.view.frame.size.width/2 - 30, rectForColor.origin.y + 50, 70, 30);
        [self.closeButton setTitle:NSLocalizedString(@"Ok", @"") forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.closeButton];
    } else {
        CGSize viewSize = self.contentSizeForViewInPopover;
        rect = CGRectMake(20, 20, 200, 30);
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        UILabel* showGridLabel = [[[UILabel alloc] initWithFrame:rect] autorelease];
        showGridLabel.text = NSLocalizedString(@"Show grid", @"");
        [showGridLabel setFont:settingFont];
        [self.view addSubview: showGridLabel];
        
        self.toggleShowGridButton = [[[UISwitch alloc] initWithFrame:CGRectMake(viewSize.width - 100, rect.origin.y, 50, 50)] autorelease];
        [self.toggleShowGridButton setOn:[SettingViewController loadSettingGrid]];
        [self.toggleShowGridButton addTarget:self action:@selector(changeShowGridToggle) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.toggleShowGridButton];
        
        //color setting
        CGRect rectForColor = CGRectMake(rect.origin.x, rect.origin.y + 50 , 200, 30);
        UILabel* showColorLabel = [[[UILabel alloc] initWithFrame:rectForColor] autorelease];
        showColorLabel.text = NSLocalizedString(@"Add color", @"");
        [showColorLabel setFont:settingFont];
        [self.view addSubview:showColorLabel];
        
        self.toggleAddColorButton = [[[UISwitch alloc] initWithFrame:CGRectMake(viewSize.width - 100, rectForColor.origin.y, 50, 50)] autorelease];
        [self.toggleAddColorButton setOn:[SettingViewController loadSettingColor]];
        [self.toggleAddColorButton addTarget:self action:@selector(changeColorToggle) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.toggleAddColorButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)close
{
    [[self parent] deprecatedDismissModalViewControllerAnimated:YES];
}

- (void)changeShowGridToggle
{
    self.showGrid = !self.showGrid;
    [SettingViewController saveSettingGrid:self.showGrid];
    if(self.competitionBlock) {
        self.competitionBlock();
    }
}

- (void)changeColorToggle
{
    self.showColor = !self.showColor;
    [SettingViewController saveSettingColor:self.showColor];
    if(self.competitionBlock) {
        self.competitionBlock();
    }
}

- (void)changeTutorialToggle
{
    self.showTutorial = !self.showTutorial;
    [SettingViewController saveSettingTutorial:self.showTutorial];
    if(self.competitionBlock) {
        self.competitionBlock();
    }
}

+ (void)saveSettingGrid:(BOOL)grid
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setBool:grid forKey:kShowGrid];
    [def synchronize];
}

+ (void)saveSettingColor:(BOOL)showColor
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setBool:showColor forKey:kShowColor];
    [def synchronize];
}

+ (void)saveSettingTutorial:(BOOL)showTutorial
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setBool:showTutorial forKey:kShowTutorial];
    [def synchronize];
}

+ (BOOL)loadSettingGrid
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    return [def boolForKey:kShowGrid];
}

+ (BOOL)loadSettingColor
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    return [def boolForKey:kShowColor];
}

+ (BOOL)loadSettingTutorial
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    return [def boolForKey:kShowTutorial];
}
@end
