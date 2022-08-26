//
//  GMLNavigationBarAppearanceManager.h
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#import <Foundation/Foundation.h>
#import "GMLNavigationBarAppearanceProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class GMLNavigationBarAppearanceItem, GMLNavigationBarAppearanceManager, UINavigationBar, UINavigationBarAppearance;
@protocol GMLNavigationBarAppearanceProtocol, GMLMutableNavigationBarAppearanceProtocol;
@protocol GMLNavigationBarAppearanceManagerDelegate <NSObject>

@optional
- (void)navigationBarCurrentUsingAppearanceDidChangeManager:(GMLNavigationBarAppearanceManager *)manager;

/// 指定创建的自定外观配置
- (id<GMLMutableNavigationBarAppearanceProtocol>)createMutableNavigationBarAppearanceWithMangaer:(GMLNavigationBarAppearanceManager *)manager;

@end

@interface GMLNavigationBarAppearanceManager : NSObject

@property (nullable, nonatomic, weak) id<GMLNavigationBarAppearanceManagerDelegate> delegate;
@property (nullable, nonatomic, copy) id<GMLNavigationBarAppearanceProtocol> defaultAppearance;
/// 弹入 nil 外观配置，表示没有配置外观，当之前存在 YJNavigationBarAppearanceAfterOneselfEffective 类型的外观时，会自动替换 defaultAppearance 值
- (void)pushNilAppearance;
- (void)push:(GMLNavigationBarAppearanceItem *)item;
- (void)pop;
- (void)removeAllAppearance;
- (void)removeAppearancesInRange:(NSRange)range;
- (void)updateAppearance:(void(^)(GMLNavigationBarAppearanceManager *manager))block;

/// 下一个 nil 配置的默认外观配置
- (id<GMLMutableNavigationBarAppearanceProtocol>)lastNilDefaultAppearance;
- (id<GMLMutableNavigationBarAppearanceProtocol>)currentUsingAppearance;

- (id<GMLMutableNavigationBarAppearanceProtocol>)currentNavigationBarAppearance API_AVAILABLE(ios(13.0));
- (id<GMLMutableNavigationBarAppearanceProtocol>)appearanceWithNavigationBar:(UINavigationBar *)navigationBar;
- (id<GMLMutableNavigationBarAppearanceProtocol>)appearanceWithNavigationBarAppearance:(UINavigationBarAppearance *)appearance API_AVAILABLE(ios(13.0));

- (void)applyTo:(UINavigationBar *)navigationBar;
- (void)applyToNavigationBarAppearance:(UINavigationBarAppearance *)appearance  API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
