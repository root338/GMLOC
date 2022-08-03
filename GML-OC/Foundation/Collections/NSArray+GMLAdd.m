//
//  NSArray+GMLAdd.m
//  GML-OC
//
//  Created by GML on 2022/7/22.
//

#import "NSArray+GMLAdd.h"

@implementation NSArray (GMLAdd)

- (NSArray *)map_gml:(id (NS_NOESCAPE^)(id _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    NSMutableArray *mArr = NSMutableArray.array;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = block(obj, idx, stop);
        if (value) [mArr addObject:value];
    }];
    return mArr;
}

- (NSArray *)filter_gml:(BOOL (NS_NOESCAPE^)(id _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:block];
    if (indexSet.count == 0) return nil;
    return [self objectsAtIndexes:indexSet];
}

- (id)reduceWithInit:(id)result block:(void (NS_NOESCAPE^)(id _Nonnull, id _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(result, obj, idx, stop);
    }];
    return result;
}
- (id)reduceArrayWithBlock:(void (NS_NOESCAPE^)(NSMutableArray * _Nonnull, id _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    return [self reduceWithInit:NSMutableArray.array block:block];
}

@end
