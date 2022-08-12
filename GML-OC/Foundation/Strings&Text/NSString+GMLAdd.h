//
//  NSString+GMLAdd.h
//  GML-OC
//
//  Created by GML on 2022/8/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (GMLAdd)

/// 移除字符串收尾空白字符
@property (nonatomic, copy, readonly) NSString *trimSpace;

@end

NS_ASSUME_NONNULL_END
