//
//  GMLMethodInfo.m
//  TestLineCommand
//
//  Created by GML on 2022/8/30.
//

#import "GMLMethodInfo.h"

@interface GMLMethodInfo ()

@property (nonatomic, readwrite) Method method;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, readwrite) IMP imp;
@property (nonatomic, readwrite) SEL selector;
@end

@implementation GMLMethodInfo

- (instancetype)initWithMethod:(Method)method {
    self = [super init];
    if (self == nil) return nil;
    _method = method;
    _selector = method_getName(method);
    _name = NSStringFromSelector(_selector);
    _imp = method_getImplementation(method);
    return self;
}

@end
