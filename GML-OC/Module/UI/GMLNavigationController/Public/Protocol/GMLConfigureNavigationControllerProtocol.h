//
//  GMLConfigureNavigationControllerProtocol.h
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#ifndef GMLConfigureNavigationControllerProtocol_h
#define GMLConfigureNavigationControllerProtocol_h

@protocol GMLNavigationBarAppearanceProtocol, GMLMutableNavigationBarAppearanceProtocol;
typedef NS_ENUM(NSInteger, GMLNavigationBarAppearanceEffectivePeriod) {
    GMLNavigationBarAppearanceOnlyMyselfEffective, // 仅自己有效
    GMLNavigationBarAppearanceAfterOneselfEffective, // 自己及自己之后都有效
};
@protocol GMLConfigurationNavigationBarAppearance <NSObject>
/// 配置导航栏样式
/// @param defaultAppearance 通过此 block 可以获取当前导航栏默认的样式配置
- (id<GMLNavigationBarAppearanceProtocol>)navigationBarAppearanceWithDefaultAppearance:(id<GMLNavigationBarAppearanceProtocol>(^)(void))defaultAppearance;
@optional
/// 导航栏样式配置的有效期，不实现此方法时的有效期为 GMLNavigationBarAppearanceOnlyMyselfEffective
@property (nonatomic, readonly) GMLNavigationBarAppearanceEffectivePeriod navigationBarAppearanceEffectiveType;
@end

@protocol GMLConfigureNavigationController <NSObject>
@optional
/// 是否隐藏导航栏，不实现时为默认的设置值
@property (nonatomic, readonly) BOOL isHiddenNavigationBar;

@end

#endif /* GMLConfigureNavigationControllerProtocol_h */
