//
//  TutorialView.m
//  TetrisNew
//
//  Created by Natasha on 03.11.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "TutorialView.h"

@implementation TutorialView

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withText:(NSString*)text andTargetFrame:(CGRect)rect
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        CGRect cloudRect;
        CGRect textRect;
        if(isiPhone) {
            cloudRect = CGRectMake(frame.size.width/2 - 120 , 100, 240, 150);
            textRect = CGRectMake(30, 25, 180, 100);
        } else {
            cloudRect = CGRectMake(frame.size.width/2 - 238 , 330, 480, 200);
            textRect = CGRectMake(60, 50, 380, 100);
        }
        
        UIImageView* hintImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud2.png"]];
        hintImageView.frame = cloudRect;
        [self addSubview:hintImageView];
        [hintImageView release];
        
        UILabel* textLabel = [[UILabel alloc] initWithFrame:textRect];
        
        textLabel.text = [text uppercaseString];
        textLabel.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.f];
        
        if(isiPhone) {
            textLabel.font = tutorialFont;
        } else {
            textLabel.font = settingFont;
        }
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.numberOfLines = 3;
        textLabel.textAlignment = NSTextAlignmentCenter;
        [hintImageView addSubview: textLabel];
        [textLabel release];
        
        UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
        CGSize arrowSize = CGSizeMake(64, 64);
        arrow.frame = CGRectMake(CGRectGetMidX(rect) - arrowSize.width/2, CGRectGetMinY(rect) - arrowSize.height + 10, arrowSize.width, arrowSize.height);
        [self addSubview:arrow];
        [arrow release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
