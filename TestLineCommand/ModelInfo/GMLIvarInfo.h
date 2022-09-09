//
//  GMLIvarInfo.h
//  TestLineCommand
//
//  Created by GML on 2022/8/30.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "GMLRuntimeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMLIvarInfo : NSObject

@property (nonatomic, readonly) Ivar ivar;
@property (nonatomic, readonly) ptrdiff_t offset;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) GMLEncodingType type;

- (instancetype)initWithIvar:(Ivar)ivar;

@end

NS_ASSUME_NONNULL_END
