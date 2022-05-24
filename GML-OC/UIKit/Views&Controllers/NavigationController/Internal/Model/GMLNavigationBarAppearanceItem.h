//
//  GMLNavigationBarAppearanceItem.h
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#import <Foundation/Foundation.h>
#import "GMLConfigureNavigationControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@protocol GMLNavigationBarAppearanceProtocol;
@interface GMLNavigationBarAppearanceItem : NSObject<NSCopying>
@property (nonatomic, copy, readonly) id<GMLNavigationBarAppearanceProtocol> appearance;
@property (nonatomic, assign, readonly) GMLNavigationBarAppearanceEffectivePeriod effectiveType;

- (instancetype)initWithAppearance:(id<GMLNavigationBarAppearanceProtocol>)appearance effectiveType:(GMLNavigationBarAppearanceEffectivePeriod)effectiveType;
@end

NS_ASSUME_NONNULL_END
