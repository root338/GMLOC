//
//  GMLViewControllerViewStateItem.h
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import <Foundation/Foundation.h>
#import "GMLViewControllerViewStateDefine.h"

NS_ASSUME_NONNULL_BEGIN
@class UIViewController;

/// 视图状态，存储事件回调和监听状态值
@interface GMLViewControllerViewStateItem : NSObject<GMLViewControllerViewStateToken>

@property (nonatomic, assign, readonly) GMLViewControllerViewState state;
@property (nonatomic, copy, readonly) GMLViewControllerViewStateCallback block;

- (instancetype)initWithState:(GMLViewControllerViewState)state block:(GMLViewControllerViewStateCallback)block;
@end

NS_ASSUME_NONNULL_END
