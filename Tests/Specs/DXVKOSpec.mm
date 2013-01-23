#import "NSObject+DXKVO.h"

@interface DXKVOTestClass : NSObject

@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *otherValue;

@end

@implementation DXKVOTestClass
@end


SPEC_BEGIN(DXVKOSpec)

describe(@"DXVKO", ^{
    __block DXKVOTestClass *testObject = nil;
    beforeEach(^{
        testObject = [DXKVOTestClass new];

    });
    
    it(@"Should call callback block on property changes", ^{
        __block BOOL wasCalled = NO;
        [testObject addObserverForKeyPath:@"value" expectedValue:nil callback:^{
            wasCalled = YES;
        }];
        
        testObject.value = @"test";
        
        assertThatBool(wasCalled, equalToBool(YES));
    });

    it(@"Should call callback only for required properties change", ^{
        __block BOOL wasCalled = NO;
        [testObject addObserverForKeyPath:@"value" expectedValue:nil callback:^{
            wasCalled = YES;
        }];

        testObject.otherValue = @"test";

        assertThatBool(wasCalled, equalToBool(NO));
    });
});

SPEC_END
