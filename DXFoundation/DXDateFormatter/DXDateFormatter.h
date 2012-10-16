//
//  DXDateFormatter.h
//  DXFoundation
//
//  Created by Max Mashkov on 9/13/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXSingleton.h"

@interface DXDateFormatter : NSDateFormatter <DXSingleton>

+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;
+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat;

- (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;
- (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat;

@end
