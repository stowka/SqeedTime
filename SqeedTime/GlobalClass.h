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

// properties to cache new sqeed data
@property (nonatomic) NSString* NEW_SQEED_TITLE;
@property (nonatomic) NSString* NEW_SQEED_DESCRIPTION;
@property (nonatomic) int NEW_SQEED_CATEGORY_ID;
@property (nonatomic) NSDate* NEW_SQEED_START;
@property (nonatomic) NSDate* NEW_SQEED_END;
@property (nonatomic) NSString* NEW_SQEED_PLACE;

+ (GlobalClass*)globalClass;
@end