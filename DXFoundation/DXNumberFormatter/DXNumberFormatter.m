//
//  DXNumberFormatter.m
//  DXFoundation
//
//  Created by Max Mashkov on 9/13/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXNumberFormatter.h"

@interface DXNumberFormatter ()

@property(nonatomic, strong) NSMutableDictionary* formatters;

- (NSNumberFormatter*)formatterForStyle:(NSNumberFormatterStyle)style;

@end

@implementation DXNumberFormatter

- (NSNumberFormatter*)formatterForStyle:(NSNumberFormatterStyle)style
{
    if (!_formatters) {
        self.formatters = [NSMutableDictionary new];
    }
    
    NSString* styleKey = [NSString stringWithFormat:@"%d", style];
    
    NSNumberFormatter* formatter = [self.formatters objectForKey:styleKey];
    
    if (!formatter) {
        formatter = [NSNumberFormatter new];
        formatter.numberStyle = style;
        
        [self.formatters setObject:formatter forKey:styleKey];
    }
    
    return formatter;
}

+ (NSNumber*)numberFromString:(NSString *)string style:(NSNumberFormatterStyle)style
{
    return [[DXNumberFormatter shared] numberFromString:string];
}

+ (NSString*)stringFromNumber:(NSNumber *)number style:(NSNumberFormatterStyle)style
{
    return [[DXNumberFormatter shared] stringFromNumber:number];
}

- (NSNumber*)numberFromString:(NSString *)string style:(NSNumberFormatterStyle)style
{
    return [[self formatterForStyle:style] numberFromString:string];
}

- (NSString*)stringFromNumber:(NSNumber *)number style:(NSNumberFormatterStyle)style
{
    return [[self formatterForStyle:style] stringFromNumber:number];
}

@end
