//
//  GMLViewControllerViewStateItem.m
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import "GMLViewControllerViewStateItem.h"

@interface GMLViewControllerViewStateItem ()
@property (nonatomic, strong) GMLViewControllerViewStateItem *item; // 私有设置强引用
@property (nonatomic, copy, readwrite) GMLViewShowStateBlock block;
@end

@implementation GMLViewControllerViewStateItem

- (void)dealloc {
    NSLog(@"%@, %@", NSStringFromSelector(_cmd), self);
}
- (instancetype)initWithBlock:(GMLViewShowStateBlock)block {
    self = [super init];
    if (self) {
        _block = [block copy];
        _item = self; // 初始化时 强行造成引用循环，导致无法释放
    }
    return self;
}

- (void)cancel {
    _item = nil; //取消时，解开引用循环，并释放
}

@end
