//
//  GMLProtocolFlagManager.m
//  GML-OC
//
//  Created by GML on 2022/5/30.
//

#import "GMLProtocolFlagManager.h"
#import <objc/runtime.h>

@implementation GMLProtocolFlagManager

+ (void)test {
    
}
- (BOOL)respondsToSelector:(SEL)aSelector {
    
}
+ (BOOL)instancesRespondToSelector:(SEL)aSelector {
    
}
- (NSDictionary<NSString *,NSNumber *> *)flagInfoWithObject:(id)object protocols:(Protocol *)protocols {
    unsigned int outCount;
    Protocol * __unsafe_unretained *supportProtocolList = class_copyProtocolList([object class], &outCount);
    if (supportProtocolList == NULL) return nil;
    
    NSMutableDictionary *flagInfo = NSMutableDictionary.dictionary;
    for (int index = 0; index < outCount; index++) {
        Protocol *protocol = supportProtocolList[index];
        unsigned int protocolOutCount;
        protocol_copyPropertyList2(protocol, &protocolOutCount, <#BOOL isRequiredProperty#>, true)
        flagInfo[protocol] = @"";
    }
    
}

@end
