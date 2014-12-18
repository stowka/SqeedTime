//
//  SqeedCategory.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 25/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqeedCategory : NSObject
@property NSString* categoryId;
@property NSString* label;

- (id) initWithIndex :(int)index;
- (id) initWithId :(NSString *)_categoryId;
@end
