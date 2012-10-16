//
//  DXCalendar.h
//  DXFoundation
//
//  Created by Max Mashkov on 9/12/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXSingleton.h"

@interface DXCalendar : NSObject <DXSingleton>

+ (NSCalendar*)currentCalendar;

@end
