//
//  DXNumberFormatter.m
//  DXFoundation
//
//  Created by Max Mashkov on 9/13/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXNumberFormatter.h"

@implementation DXNumberFormatter

- (NSNumber*)decimalNumberFromString:(NSString*)string
{
    [self setNumberStyle:NSNumberFormatterDecimalStyle];
    return [self numberFromString:string];
}

- (NSString*)stringFromDecimalNumber:(NSNumber*)number
{
    [self setNumberStyle:NSNumberFormatterDecimalStyle];
    return [self stringFromNumber:number];
}

+ (NSNumber*)decimalNumberFromString:(NSString*)string
{
    return [[DXNumberFormatter shared] decimalNumberFromString:string];
}

+ (NSString*)stringFromDecimalNumber:(NSNumber*)number
{
    return [[DXNumberFormatter shared] stringFromNumber:number];
}

@end
