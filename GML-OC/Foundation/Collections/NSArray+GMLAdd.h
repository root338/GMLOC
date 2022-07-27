//
//  NSArray+GMLAdd.h
//  GML-OC
//
//  Created by GML on 2022/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (GMLAdd)

- (nullable NSArray *)map_gml:(id _Nullable (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;
- (nullable NSArray<ObjectType> *)filter_gml:(BOOL (NS_NOESCAPE^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;
- (nullable id)reduceWithInit:(id)result block:(void (NS_NOESCAPE ^) (id result, ObjectType obj, NSUInteger idx, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END
