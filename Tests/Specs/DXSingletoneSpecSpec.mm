#import <Cedar-iOS/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

using namespace Cedar::Matchers;

#import "DXSingletone.h"

@interface SingletoneTestClass : NSObject <DXSingletone>

@end

@implementation SingletoneTestClass

@end

SPEC_BEGIN(DXSingletoneSpec)

describe(@"DXSingletone", ^{
    it(@"Should return instance of class", ^{
        assertThat([SingletoneTestClass shared], notNilValue());
        assertThatBool([[SingletoneTestClass shared] isKindOfClass:[SingletoneTestClass class]], equalToBool(YES));
    });
    
    it(@"Should return same instance for each call", ^{
        SingletoneTestClass *instanceA = [SingletoneTestClass shared];
        SingletoneTestClass *instanceB = [SingletoneTestClass shared];
        
        assertThat(instanceA, equalTo(instanceB));
    });
});

SPEC_END
