//
//  DXDateFormatter.m
//  DXFoundation
//
//  Created by Max Mashkov on 9/13/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXDateFormatter.h"


@interface DXDateFormatter ()

@property(nonatomic, strong) NSMutableDictionary* formatters;

- (void)changeSystemTimeZone;

- (NSDateFormatter*)formatterForDateFormat:(NSString*)dateFormat;

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

- (NSDateFormatter*)formatterForDateFormat:(NSString *)dateFormat
{
    if (!_formatters) {
        self.formatters = [NSMutableDictionary new];
    }
    
    NSDateFormatter* formatter = [self.formatters objectForKey:dateFormat];
    
    if (!formatter) {
        DXDateFormatter *selfCopy = [self copy];
        selfCopy.formatters = nil;
        
        formatter = (NSDateFormatter *)selfCopy;
        formatter.dateFormat = dateFormat;
        
        [self.formatters setObject:formatter forKey:dateFormat];
    }
    
    return formatter;
}

- (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    return [[self formatterForDateFormat:dateFormat] stringFromDate:date];
}

- (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat
{
    return [[self formatterForDateFormat:dateFormat] dateFromString:string];
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

- (NSTimeZone*)requiredTimeZone
{
    return [NSTimeZone systemTimeZone];
}

- (void)changeSystemTimeZone
{
    self.timeZone = [self requiredTimeZone];
}


@end
