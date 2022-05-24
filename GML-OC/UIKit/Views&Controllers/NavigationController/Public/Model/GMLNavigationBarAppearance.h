//
//  GMLNavigationBarAppearance.h
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#import <UIKit/UIKit.h>
#import <GML_OC/GMLNavigationBarAppearanceProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMLNavigationBarAppearance : NSObject<GMLMutableNavigationBarAppearanceProtocol>
@property (nullable, nonatomic, copy) UIColor *tintColor;
@property (nullable, nonatomic, copy) UIColor *backgroundColor;
@property (nullable, nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *titleTextAttributes;
@property (nullable, nonatomic, copy) UIImage *backIndicatorImage;
@property (nullable, nonatomic, copy) UIImage *backIndicatorTransitionMaskImage;
@end

NS_ASSUME_NONNULL_END
