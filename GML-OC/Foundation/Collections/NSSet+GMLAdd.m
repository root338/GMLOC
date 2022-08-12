//
//  NSSet+GMLAdd.m
//  GML-OC
//
//  Created by GML on 2022/8/5.
//

#import "NSSet+GMLAdd.h"

@implementation NSSet (GMLAdd)

- (NSSet *)intersectSet_gml:(NSSet *)set {
    if (set.count == 0) return NSSet.set;
    if (set == self) return [self copy];
    NSMutableSet *resultSet = [self mutableCopy];
    [resultSet intersectSet:set];
    return resultSet;
}

- (NSSet *)subtractSet_gml:(NSSet *)set {
    if (set.count == 0 || set == self) return [self copy];
    NSMutableSet *resultSet = [self mutableCopy];
    [resultSet minusSet:set];
    return resultSet;
}
- (NSSet *)unionSet_gml:(NSSet *)set {
    if (set.count == 0 || set == self) return [self copy];
    NSMutableSet *resultSet = [self mutableCopy];
    [resultSet unionSet:set];
    return resultSet;
}
- (NSSet *)complementSet_gml:(NSSet *)set {
    if (set.count == 0 || set == self) return NSSet.set;
    NSMutableSet *resultSet = [set mutableCopy];
    [resultSet minusSet:self];
    return resultSet;
}
- (NSSet *)symmetricDifference_gml:(NSSet *)set {
    if (set.count == 0 || set == self) return NSSet.set;
    NSMutableSet *resultSet = [self mutableCopy];
    [resultSet minusSet:set];
    NSMutableSet *complementSet = [set mutableCopy];
    [complementSet minusSet:self];
    [resultSet unionSet:complementSet];
    return resultSet;
}

- (void)diffSet:(NSSet *)set result:(nonnull void (NS_NOESCAPE^)(NSSet<id> *, NSSet<id> *, NSSet<id> *))result {
    if (result == nil) return;
    if (set == self) { result([self copy], NSSet.set, NSSet.set); }
    else if (set.count == 0) { result(NSSet.set, [self copy], NSSet.set); }
    else {
        result([self intersectSet_gml:set], [self subtractSet_gml:set], [self complementSet_gml:set]);
    }
}

@end
