//
//  GMLMethodInfo.h
//  TestLineCommand
//
//  Created by GML on 2022/8/30.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface GMLMethodInfo : NSObject

@property (nonatomic, readonly) Method method;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) IMP imp;
@property (nonatomic, readonly) SEL selector;

- (instancetype)initWithMethod:(Method)method;
@end

NS_ASSUME_NONNULL_END
