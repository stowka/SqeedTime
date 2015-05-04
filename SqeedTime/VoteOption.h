//
//  VoteOption.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 15/02/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteOption : NSObject
@property NSDate *datetimeStart;
@property NSDate *datetimeEnd;
@property NSString *voteId;
@property NSString *voteCount;

- (id) init :(NSString *)_voteId :(NSDate *)_datetimeStart :(NSDate *)_datetimeEnd :(NSString *)_voteCount;
@end
