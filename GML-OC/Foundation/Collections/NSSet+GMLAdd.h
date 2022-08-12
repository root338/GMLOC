//
//  NSSet+GMLAdd.h
//  GML-OC
//
//  Created by GML on 2022/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSet<ObjectType> (GMLAdd)
/// 交集
- (NSSet<ObjectType> *)intersectSet_gml:(NSSet<ObjectType> *)set;
/// 减去交集
- (NSSet<ObjectType> *)subtractSet_gml:(NSSet<ObjectType> *)set;
/// 合并
- (NSSet<ObjectType> *)unionSet_gml:(NSSet<ObjectType> *)set;
/// 补集
- (NSSet<ObjectType> *)complementSet_gml:(NSSet<ObjectType> *)set;
/// 减去交集 + 补集
- (NSSet<ObjectType> *)symmetricDifference_gml:(NSSet<ObjectType> *)set;

/// 对比两个Set，返回本身相对于与另一个的交集 (intersectSet), 多余的元素(subtractSet)，和缺失的元素(complementSet)
- (void)diffSet:(NSSet<ObjectType> *)set result:(void (NS_NOESCAPE^) (NSSet<ObjectType> *intersectSet, NSSet<ObjectType> * subtractSet, NSSet<ObjectType> *complementSet))result;

@end

NS_ASSUME_NONNULL_END
