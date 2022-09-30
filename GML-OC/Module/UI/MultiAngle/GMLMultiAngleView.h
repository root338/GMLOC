//
//  GMLMultiAngleView.h
//  QuickAskCommunity
//
//  Created by apple on 2020/5/26.
//  Copyright © 2020 ym. All rights reserved.
//

#import <UIKit/UIView.h>

@protocol GMLMultiAngleProtocol;
NS_ASSUME_NONNULL_BEGIN

/**
 * 支持多角，背景渐变设置的视图
 * 视图在 AutoLayout 下的大小由 contentView 实现的 sizeThatFits: 决定
 * 可以通过自定义 CGPath 来自定义视图形状
 */
@interface GMLMultiAngleView<__covariant ObjectType: UIView *> : UIView

@property (nonatomic, readonly) id<GMLMultiAngleProtocol> configure;

@property (nonatomic, assign) UIEdgeInsets contentMarginInsets;

@property (nullable, nonatomic, strong) ObjectType contentView;

- (instancetype)initWithContentView:(nullable ObjectType)contentView configure:(void (NS_NOESCAPE ^ _Nullable) (id<GMLMultiAngleProtocol> configure))block;
@end

NS_ASSUME_NONNULL_END
