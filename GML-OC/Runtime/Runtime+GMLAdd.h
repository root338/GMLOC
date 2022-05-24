//
//  Runtime+GMLAdd.h
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSObject (GMLRuntimeAdd)

+ (void)swizzledClassMethodAtSelector:(SEL)selector1 withClassMethodAtSelector:(SEL)selector2;
+ (void)swizzledInstanceMethodAtSelector:(SEL)selector1 withInstanceMethodAtSelector:(SEL)selector2;

@end

NS_ASSUME_NONNULL_END
