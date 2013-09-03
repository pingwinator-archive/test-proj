//
//  StatisticManager.m
//  TetrisNew
//
//  Created by Natasha on 13.11.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "StatisticManager.h"

@interface StatisticManager()
- (void)initStatistic;
@end

@implementation StatisticManager
+ (id)sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        DBLog(@"sharedInstance");
        return [[self alloc] init];
    });
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initStatistic];
    }
    return self;
}
- (void)initStatistic
{
    [Flurry startSession: flurryKey];
}

+ (void)logMessage:(NSString*)message
{
#ifdef RELEASE
    [self sharedInstance];
    [Flurry logEvent:message];
#endif
}

+ (void)sendScoreGame:(NSInteger)score
{
#ifdef RELEASE
    [self sharedInstance];
    NSString *tmpString = [NSString stringWithFormat:@"Total Score: %d", score, nil];
    NSDictionary* scoreParametrs = [NSDictionary dictionaryWithObjectsAndKeys: tmpString, scoreGameKey, nil];
    [Flurry logEvent:scoreGameMessage withParameters:scoreParametrs];
#endif
}
@end
