//
//  AlertHelper.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 27/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertHelper : NSObject
+ (void) error :(NSString *)message;
+ (void) status :(NSString *)message;
+ (void) alert :(NSString *)message :(NSString *)title;
+ (void) show :(NSString *)message :(NSString *)title;
@end
