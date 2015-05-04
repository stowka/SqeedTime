//
//  VoteOption.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 15/02/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "VoteOption.h"

@implementation VoteOption

@synthesize voteId;
@synthesize datetimeStart;
@synthesize datetimeEnd;
@synthesize voteCount;

- (id) init :(NSString *)_voteId :(NSDate *)_datetimeStart :(NSDate *)_datetimeEnd :(NSString *)_voteCount {
    if (self = [super init]) {
        [self setVoteId:_voteId];
        [self setDatetimeStart:_datetimeStart];
        [self setDatetimeEnd:_datetimeEnd];
        [self setVoteCount:_voteCount];
    }
    return self;
}

@end
