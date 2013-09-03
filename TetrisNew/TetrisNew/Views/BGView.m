//
//  BGView.m
//  TetrisNew
//
//  Created by Natasha on 07.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "BGView.h"
#import "BGViewBorder.h"
#import "UIApplication+CheckVersion.h"
@interface BGView()

- (void)customInit;

@end
@implementation BGView
@synthesize viewBorder;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)customInit
{
    if(isiPhone) {
        UIImageView* bgImage = [[[UIImageView alloc] initWithFrame:self.frame] autorelease];
        bgImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;;
        if([[UIApplication sharedApplication] has4inchDisplay]) {
            [bgImage setImage:[UIImage imageNamed:@"back@2x-h568.png"] ];
        } else {
           [bgImage setImage:[UIImage imageNamed:@"back.png"]]; 
        }
        bgImage.alpha = 0.7f;
        [self addSubview:bgImage];
    } else {
        //iPad
        UIImageView* bgImage = [[[UIImageView alloc] initWithFrame:self.frame] autorelease];
        bgImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;;

        [bgImage setImage:[UIImage imageNamed:@"back-ipad.png"] ];
        bgImage.alpha = 0.7f;
        [self addSubview:bgImage];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
}
*/
@end
