//
//  BGViewBorder.m
//  TetrisNew
//
//  Created by Natasha on 11.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "BGViewBorder.h"
#import "UIApplication+CheckVersion.h"
@interface BGViewBorder()
@property (retain, nonatomic) UILabel* superLabel;
@property (assign, nonatomic) CGFloat offset;
- (void)addSuperLabel;
@end
@implementation BGViewBorder
@synthesize superLabel;
@synthesize offset;

- (void)dealloc
{
    self.superLabel = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSuperLabel];
        self.offset = 0.f;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andOffset:(CGFloat)_offset
{
    self = [super initWithFrame:frame];
    if (self) {
        self.offset = _offset;
        [self addSuperLabel];
    }
    return self;
}


- (void)addSuperLabel
{
    self.superLabel = [[[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 60)/2, self.offset, 50, 12)] autorelease];
    self.superLabel.text = @"SUPER";
    [self.superLabel setFont:textButtonFont];
    self.superLabel.backgroundColor = [UIColor colorWithRed:39.0f/255.0f green:64.0f/255.0f blue:139.0f/255.0f alpha:1];
    self.superLabel.textColor = [UIColor whiteColor];
    self.superLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:self.superLabel];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, borderThin);
    
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    
    CGContextAddRect(context, CGRectMake(rect.origin.x + offSetBorderThin + self.offset, rect.origin.y + offSetBorderThin + self.offset, rect.size.width - (rect.origin.x + offSetBorderThin  + self.offset) * 2, rect.size.height - ( rect.origin.y + offSetBorderThin + self.offset) * 2));
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, borderThick);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextAddRect(context, CGRectMake(rect.origin.x + offsetBorderThick + self.offset, rect.origin.y + offsetBorderThick + self.offset, rect.size.width - (rect.origin.x + offsetBorderThick + self.offset) * 2, rect.size.height - ( rect.origin.y + offsetBorderThick + self.offset) * 2 ));
    
    CGContextStrokePath(context);
}
@end
