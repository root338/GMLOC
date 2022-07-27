//
//  GMLViewControllerViewStateItem.m
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import "GMLViewControllerViewStateItem.h"

@interface GMLViewControllerViewStateItem ()
@property (nonatomic, assign, readwrite) GMLViewControllerViewState state;
@property (nonatomic, copy, readwrite) GMLViewControllerViewStateCallback block;
@end

@implementation GMLViewControllerViewStateItem

- (instancetype)initWithState:(GMLViewControllerViewState)state block:(GMLViewControllerViewStateCallback)block {
    self = [super init];
    if (self) {
        _state = state;
        _block = [block copy];
    }
    return self;
}

@end
