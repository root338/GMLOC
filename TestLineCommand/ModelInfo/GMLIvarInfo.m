//
//  GMLIvarInfo.m
//  TestLineCommand
//
//  Created by GML on 2022/8/30.
//

#import "GMLIvarInfo.h"
#import "GMLRuntimePrivate.h"

@interface GMLIvarInfo ()

@property (nonatomic, readwrite) Ivar ivar;
@property (nonatomic, readwrite) ptrdiff_t offset;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, readwrite) GMLEncodingType type;
@end

@implementation GMLIvarInfo

- (instancetype)initWithIvar:(Ivar)ivar {
    self = [super init];
    if (self == nil) return nil;
    
    _ivar = ivar;
    _name = [NSString stringWithUTF8String:ivar_getName(ivar)];
    _offset = ivar_getOffset(ivar);
    _type = GMLGetEncodingType(ivar_getTypeEncoding(ivar));
    return self;
}

@end
