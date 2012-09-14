//
//  CSCalendar.m
//  CrowdSync
//
//  Created by Max Mashkov on 9/12/12.
//  Copyright (c) 2012 DIMALEX. All rights reserved.
//

#import "DXCalendar.h"

@interface DXCalendar ()

@property (nonatomic, strong) NSCalendar *calendar;

- (NSCalendar*)currentCalendar;

- (void)changeCurrentCalendar;

@end

@implementation DXCalendar

- (id)init
{
    self = [super init];
    if (self) {
        
        [self changeCurrentCalendar];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeCurrentCalendar)
                                                     name:NSSystemTimeZoneDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSCalendar*)currentCalendar
{
    return [[self shared] currentCalendar];
}

- (NSCalendar*)currentCalendar
{
    return self.calendar;
}

- (void)changeCurrentCalendar
{
    self.calendar = [NSCalendar currentCalendar];
}

@end
