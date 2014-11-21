//
//  GlobalClass.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalClass : NSObject

@property (nonatomic) int USER_ID;
@property (nonatomic) int CURRENT_SQEED;
@property (nonatomic) NSString* USER_TOKEN;

+ (GlobalClass*)globalClass;
@end