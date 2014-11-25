//
//  Category.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 25/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCategory : NSObject
@property NSInteger cId;
@property NSString* cLabel;
@property NSString* cIconName;

- (id) initWithId:(NSInteger) categoryId;
+ (void) getCategories;
@end
