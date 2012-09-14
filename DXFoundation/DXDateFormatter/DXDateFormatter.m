//
//  DXDateFormatter.m
//  DXFoundation
//
//  Created by Max Mashkov on 9/13/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDateFormatter.h"

@interface DXDateFormatter ()

- (void)changeSystemTimeZone;

@end

@implementation DXDateFormatter

- (id)init
{
    self = [super init];
    if (self) {
        [self changeSystemTimeZone];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeSystemTimeZone)
                                                     name:NSSystemTimeZoneDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    self.dateFormat = dateFormat;
    return [self stringFromDate:date];
}

- (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat
{
    self.dateFormat = dateFormat;
    return [self dateFromString:string];
}

+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    return [[DXDateFormatter shared] stringFromDate:date
                                         dateFormat:dateFormat];
}

+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat
{
    return [[DXDateFormatter shared] dateFromString:string
                                         dateFormat:dateFormat];
}


- (void)changeSystemTimeZone
{
    self.timeZone = [NSTimeZone systemTimeZone];
}


@end
