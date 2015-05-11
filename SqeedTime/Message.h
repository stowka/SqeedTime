//
//  Message.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/02/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *datetime;
@property (strong, nonatomic) NSString *name;
@property BOOL fromMe;
@property BOOL pending;

@end
