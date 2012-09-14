//
//  DXNumberFormatter.h
//  DXFoundation
//
//  Created by Max Mashkov on 9/13/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXSingleton.h"

@interface DXNumberFormatter : NSNumberFormatter <DXSingleton>

- (NSNumber*)decimalNumberFromString:(NSString*)string;
- (NSString*)stringFromDecimalNumber:(NSNumber*)number;

+ (NSNumber*)decimalNumberFromString:(NSString*)string;
+ (NSString*)stringFromDecimalNumber:(NSNumber*)number;

@end
