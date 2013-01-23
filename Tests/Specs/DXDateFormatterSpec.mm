#import "DXDateFormatter.h"

SPEC_BEGIN(DXDateFormatterSpec)

describe(@"DXDateFormatter", ^{

    it(@"Required time zone should equal to system time zone", ^{
        NSTimeZone *timeZone = [[DXDateFormatter shared] requiredTimeZone];

        assertThat(timeZone, isNot(equalTo([NSTimeZone systemTimeZone])));
    });
    
    it(@"Should return correct string from date", ^{
        
        NSString *dateFormat = @"MMM dd, yyyy HH:mm:ss";
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [[DXDateFormatter shared] requiredTimeZone];
        dateFormatter.dateFormat = dateFormat;
        
        NSString *dateString = @"Jul 05, 2012 15:44:11";
        
        NSDate *dateFromDefaultFormatter = [dateFormatter dateFromString:dateString];
        
        NSDate *dateFromDXDateFormatter = [[DXDateFormatter shared] dateFromString:dateString dateFormat:dateFormat];
        
        assertThat(dateFromDefaultFormatter, isNot(equalTo(dateFromDXDateFormatter)));
    });
});

SPEC_END
