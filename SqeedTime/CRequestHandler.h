//
//  RequestHandler.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CRequestHandler : NSObject
+ (NSDictionary*) post:(NSString*)args;
@end
