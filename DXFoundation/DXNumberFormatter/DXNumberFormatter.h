//
//  DXNumberFormatter.h
//  DXFoundation
//
//  Created by Max Mashkov on 9/13/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXSingleton.h"

@interface DXNumberFormatter : NSNumberFormatter <DXSingleton>

+ (NSNumber*)numberFromString:(NSString *)string style:(NSNumberFormatterStyle)style;
+ (NSString*)stringFromNumber:(NSNumber *)number style:(NSNumberFormatterStyle)style;

- (NSNumber*)numberFromString:(NSString *)string style:(NSNumberFormatterStyle)style;
- (NSString*)stringFromNumber:(NSNumber *)number style:(NSNumberFormatterStyle)style;

@end
