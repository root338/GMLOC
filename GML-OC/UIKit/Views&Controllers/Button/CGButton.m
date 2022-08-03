//
//  CGButton.m
//  QuickAskCommunity
//
//  Created by DY on 16/1/15.
//  Copyright © 2016年 ym. All rights reserved.
//

#import "CGButton.h"
#import <UIKit/UILabel.h>
#import <UIKit/UIImage.h>
#import <GML_OC/UIView+GMLAreaAdd.h>

typedef NS_ENUM(NSInteger, _CGButtonHandleContentType) {
    
    _CGButtonHandleContentTypeTitle,
    _CGButtonHandleContentTypeImage,
};

typedef NS_ENUM(NSInteger, _CGButtonContentType) {

    _CGButtonContentTypeContentView,
    _CGButtonContentTypeImageView,
    _CGButtonContentTypeTitleLabel,
};

@interface CGButton ()
{
    ///YES表示正在cg_calculateAreaWithContentType:contentRect:方法中处理布局,
    BOOL _isCalculateAreaButtonContentView;
    
    UIFont          *_defaultAttributedDictIdentifier;
    NSDictionary    *_defaultAttributedDict;
}

@property (nonatomic, strong) UILabel *tempCalculateLabel;

//当图片为空或固定图片大小imageViewSize为CGSizeZero 时该值为零，否则为space属性
//或者标题为空
@property (nonatomic, assign, readonly) CGFloat didHandleSpace;

@property (nullable, nonatomic, strong, readonly) id getCurrentTitleContent;
@property (nullable, nonatomic, strong, readonly) UIImage *getCurrentImage;
@end

@implementation CGButton



- (void)initialization
{
    _contentSubviewOfficeSpace  = 0;
    _space                      = 0;
    _marginEdgeInsets           = UIEdgeInsetsZero;
    _imageViewSize              = CGSizeZero;
}

/**
 计算约束条件下的大小
 */
- (CGSize)intrinsicContentSize
{
    return [self sizeThatFits:CGSizeZero];
}

#pragma mark - 重置按钮布局
- (void)cg_updateButtonLayout
{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self
//                                             selector:@selector(cg_updateButtonLayout)
//                                               object:nil];
    
    [self setNeedsLayout];
}

///获取contentView最大的区域
//- (CGRect)cg_calculateMaxContentRect:(CGRect)contentRect
//{
//    CGRect paramContentRect = contentRect;
//    if (!CGSizeEqualToSize(self.maxSize, CGSizeZero)) {
//        
//        paramContentRect.size = CG_CGMinSize(contentRect.size, CG_CGSizeWidthMaxSize(self.maxSize, self.marginEdgeInsets));
//    }
//    return paramContentRect;
//}

///计算图片在按钮中最适合的大小
- (CGSize)cg_calculateImageSizeWithContentRect:(CGRect)contentRect
{
    UIImage *currentImage   = self.getCurrentImage;
    BOOL useCustomImageView = !CGSizeEqualToSize(self.imageViewSize, CGSizeZero);
    if (!currentImage && !useCustomImageView) {
        return CGSizeZero;
    }
    CGSize imageSize = useCustomImageView ? self.imageViewSize : currentImage.size;
    imageSize       = CGSizeMake(MIN(contentRect.size.width, imageSize.width), MIN(contentRect.size.height, imageSize.height));
    CGFloat space   = self.didHandleSpace;
    
    if (self.buttonStyle == CGButtonStyleHorizonalLeft || self.buttonStyle == CGButtonStyleHorizonalRight) {
        
        CGFloat contentWidth    = CGRectGetWidth(contentRect);
        if (imageSize.width + space > contentWidth) {
            imageSize.width     = contentWidth - space;
        }
        
    }else {
        
        CGFloat contentHeight   = CGRectGetHeight(contentRect);
        if (imageSize.height + space > contentHeight) {
            imageSize.height    = contentHeight - space;
        }
        
    }
    
    return imageSize;
}

///计算标题在按钮中最适合的大小
- (CGSize)cg_calculateTitleSizeWithContentRect:(CGRect)contentRect imageSize:(CGSize)imageSize
{
    CGSize tempLabelSize        = contentRect.size;
    CGFloat space               = self.didHandleSpace;
    //获取标题的最大区域
    if (self.buttonStyle == CGButtonStyleHorizonalRight || self.buttonStyle == CGButtonStyleHorizonalLeft) {
        
        tempLabelSize.width     = CGRectGetWidth(contentRect) - (imageSize.width + space);
    }else {
        
        tempLabelSize.height    = CGRectGetHeight(contentRect) - (imageSize.height + space);
    }
    
    /** 获取私有属性，如果直接使用self.titleLabel会导致出现两个一样的标题控件 */
    id titleView    = [self valueForKey:@"_titleView"];
    
    if (![titleView isKindOfClass:[UILabel class]]) {
        //当使用setTitle:forState:方法设置标题时，button不会立即刷新，当立即重新刷新button大小时，会出错
        titleView   = nil;
    }
    CGSize titleSize    = [self calculateCurrentTitleAreaWithTitleLabel:titleView maxSize:tempLabelSize];
    
    titleSize   = CGSizeMake(MIN(tempLabelSize.width, titleSize.width), MIN(tempLabelSize.height, titleSize.height));
    
    return titleSize;
}

- (CGPoint)calculateContentPointWithContentSize:(CGSize)contentSize targetContentSize:(CGSize)targetContentSize
{
    CGPoint contentPoint    = CGPointZero;
    CGFloat contentWidth    = contentSize.width;
    CGFloat contentHeight   = contentSize.height;
    
    switch (self.contentHorizontalAlignment) {
            
        case UIControlContentHorizontalAlignmentLeft:
        case UIControlContentHorizontalAlignmentFill:
            contentPoint.x  = 0;
            break;
        case UIControlContentHorizontalAlignmentRight:
            contentPoint.x  = contentWidth - targetContentSize.width;
            break;
        default:
            contentPoint.x  = (contentWidth - targetContentSize.width) / 2;
            break;
    }
    
    switch (self.contentVerticalAlignment) {
        case UIControlContentVerticalAlignmentTop:
        case UIControlContentVerticalAlignmentFill:
            contentPoint.y  = 0;
            break;
        case UIControlContentVerticalAlignmentBottom:
            contentPoint.y  = contentHeight - targetContentSize.height;
            break;
        default:
            contentPoint.y  = (contentHeight - targetContentSize.height) / 2;
            break;
    }
    return contentPoint;
}

- (CGRect)cg_calculateAreaWithContentType:(_CGButtonContentType)paramContentType contentRect:(CGRect)contentRect
{
    CGFloat space   = self.didHandleSpace;
    if (((contentRect.size.width - space) <= 0 || (contentRect.size.height - space) <= 0)) {
        return CGRectZero;
    }
    
    _isCalculateAreaButtonContentView   = YES;
    CGRect targetRect       = CGRectZero;
    CGFloat contentWidth    = CGRectGetWidth(contentRect);
    CGFloat contentHeight   = CGRectGetHeight(contentRect);
    
    CGSize imageSize        = [self cg_calculateImageSizeWithContentRect:contentRect];
    CGSize titleSize        = [self cg_calculateTitleSizeWithContentRect:contentRect imageSize:imageSize];
    
    CGPoint targetPoint = CGPointZero;
    CGSize targetSize   = CGSizeZero;
    
    if (paramContentType == _CGButtonContentTypeImageView) {
        targetSize  = imageSize;
    }else if (paramContentType == _CGButtonContentTypeTitleLabel) {
        targetSize  = titleSize;
    }
    
    if (self.buttonStyle == CGButtonStyleHorizonalLeft || self.buttonStyle == CGButtonStyleHorizonalRight) {
        
        CGFloat targetHeight        = 0.0;   //当前控件的高度
        CGFloat maxContentHeight    = MAX(imageSize.height, titleSize.height);
        CGFloat offset              = 0;
        
        //获取指定视图的高度
        if (paramContentType == _CGButtonContentTypeImageView) {
            targetHeight    = imageSize.height;
            if (imageSize.height < titleSize.height) {
                offset  = self.contentSubviewOfficeSpace;
            }
        }else if (paramContentType == _CGButtonContentTypeTitleLabel) {
            targetHeight    = titleSize.height;
            if (titleSize.height < imageSize.height) {
                offset  = self.contentSubviewOfficeSpace;
            }
        }
        
        CGSize tempTargetSize   = CGSizeMake(titleSize.width + imageSize.width + space,  maxContentHeight);
        
        //获取标题+间距+图像的综合视图相对于ContentRect的起始坐标
        CGPoint contentPoint    = [self calculateContentPointWithContentSize:CGSizeMake(contentWidth, contentHeight) targetContentSize:tempTargetSize];
        
        CGFloat originTargetY   = 0;
        switch (self.contentSubviewAlignment) {
            case CGButtonContentAlignmentTop:
            {
                originTargetY   = offset;
            }
                break;
            case CGButtonContentAlignmentBottom:
            {
                originTargetY   = maxContentHeight - targetHeight - offset;
            }
                break;
            default:
            {
                originTargetY   = (maxContentHeight - targetHeight) / 2;
            }
                break;
        }
        
        //获取综合视图相对于Button的起始坐标，
        targetPoint  = CGPointMake(CGRectGetMinX(contentRect) + contentPoint.x, CGRectGetMinY(contentRect) + contentPoint.y + originTargetY);
        
        if (self.buttonStyle == CGButtonStyleHorizonalLeft) {
            
            if (paramContentType == _CGButtonContentTypeImageView) {
                targetPoint.x += space + titleSize.width;
                if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentFill) {
                    targetPoint.x = MAX(targetPoint.x, CGRectGetMinX(contentRect) + contentWidth - imageSize.width);
                }
            }
        }else {
            if (paramContentType == _CGButtonContentTypeTitleLabel) {
                targetPoint.x   += space + imageSize.width;
                if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentFill) {
                    targetPoint.x = MAX(targetPoint.x, CGRectGetMinX(contentRect) + contentWidth - titleSize.width);
                }
            }
        }
    }else {
        
        CGFloat targetWidth     = 0.0;
        CGFloat maxContentWidth = MAX(imageSize.width, titleSize.width);
        CGFloat offset          = 0;
        
        //获取指定视图的宽度
        if (paramContentType == _CGButtonContentTypeImageView) {
            targetWidth     = imageSize.width;
            if (imageSize.width < titleSize.width) {
                offset  = self.contentSubviewOfficeSpace;
            }
        }else if (paramContentType == _CGButtonContentTypeTitleLabel) {
            targetWidth     = titleSize.width;
            if (titleSize.width < imageSize.width) {
                offset = self.contentSubviewOfficeSpace;
            }
        }
        
        CGSize tempTargetSize   = CGSizeMake(maxContentWidth, titleSize.height + imageSize.height + space);
        
        //获取标题+间距+图像的综合视图相对于ContentRect的起始坐标
        CGPoint contentPoint    = [self calculateContentPointWithContentSize:CGSizeMake(contentWidth, contentHeight) targetContentSize:tempTargetSize];
        
        CGFloat originTargetX   = 0;
        switch (self.contentSubviewAlignment) {
            case CGButtonContentAlignmentLeft:
            {
                originTargetX   = offset;
            }
                break;
            case CGButtonContentAlignmentRight:
            {
                originTargetX   = maxContentWidth - targetWidth - offset;
            }
                break;
            default:
            {
                originTargetX   = (maxContentWidth - targetWidth) / 2;
            }
                break;
        }
        
        //获取综合视图相对于Button的起始坐标，
        targetPoint  = CGPointMake(CGRectGetMinX(contentRect) + contentPoint.x + originTargetX, CGRectGetMinY(contentRect) + contentPoint.y);
        
        if (self.buttonStyle == CGButtonStyleVerticalTop) {
            if (paramContentType == _CGButtonContentTypeImageView) {
                targetPoint.y += space + titleSize.height;
                if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentFill) {
                    targetPoint.y = MAX(targetPoint.y, CGRectGetMinY(contentRect) + contentHeight - imageSize.height);
                }
            }
        }else {
            if (paramContentType == _CGButtonContentTypeTitleLabel) {
                targetPoint.y += space + imageSize.height;
                if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentFill) {
                    targetPoint.y = MAX(targetPoint.y, CGRectGetMinY(contentRect) + contentHeight - titleSize.height);
                }
            }
        }
    }
    
    targetRect = (CGRect){targetPoint, targetSize};
    
    _isCalculateAreaButtonContentView = NO;
    return targetRect;
}

#pragma mark - 重写系统布局方法
- (CGRect)contentRectForBounds:(CGRect)bounds
{
    
    return UIEdgeInsetsInsetRect(self.bounds, self.marginEdgeInsets);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    if (_isCalculateAreaButtonContentView) {
        return CGRectZero;
    }
    CGRect titleRect = [self cg_calculateAreaWithContentType:_CGButtonContentTypeTitleLabel contentRect:contentRect];
    return titleRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    if (_isCalculateAreaButtonContentView) {
        return CGRectZero;
    }
    CGRect imageRect = [self cg_calculateAreaWithContentType:_CGButtonContentTypeImageView contentRect:contentRect];
    return imageRect;
}

- (void)sizeToFit {
    self.size = [self sizeThatFits:CGSizeZero];
}

- (CGSize)sizeThatFits:(CGSize)paramSize
{
    //!!先使用imageView大小，在调用titleLabel大小，否则计算会出错，原因暂时没查
    CGSize imageSize = CGSizeZero;
    if (!CGSizeEqualToSize(self.imageViewSize, CGSizeZero)) {
        imageSize   = self.imageViewSize;
    }else {
        imageSize   = self.getCurrentImage.size;
    }
    
    //当使用setTitle:forState:方法设置标题时，button不会立即刷新，当立即重新刷新button大小时，会使用原标题进行计算出错
    CGSize titleSize    = [self calculateCurrentTitleAreaWithTitleLabel:self.titleLabel maxSize:CGSizeEqualToSize(paramSize, CGSizeZero) ? CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) : paramSize];
    CGFloat space       = self.didHandleSpace;
    
    CGSize size;
    
    if (self.buttonStyle == CGButtonStyleHorizonalLeft || self.buttonStyle == CGButtonStyleHorizonalRight) {
        size = CGSizeMake(titleSize.width + space + imageSize.width, MAX(titleSize.height, imageSize.height));
    }else {
        size = CGSizeMake(MAX(titleSize.width, imageSize.width), titleSize.height + space + imageSize.height);
    }
    
    size = CGSizeMake(size.width + _marginEdgeInsets.left + _marginEdgeInsets.right, size.height + _marginEdgeInsets.top + _marginEdgeInsets.bottom);
    
    if (paramSize.width > 0.001 && paramSize.width < size.width) {
        size.width  = paramSize.width;
    }
    if (paramSize.height > 0.001 && paramSize.height < size.height) {
        size.height = paramSize.height;
    }
    
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

- (CGSize)calculateCurrentTitleAreaWithTitleLabel:(UILabel *)titleLabel maxSize:(CGSize)maxSize;
{
    /// 使用静态文本计算是因为还没有想到计算指定行的大小
    static UILabel *calculateLabel = nil;
    if (calculateLabel == nil) {
        calculateLabel = UILabel.new;
    }
    if (titleLabel == nil) {
        calculateLabel.font = [UIFont systemFontOfSize:15];
    }else {
        calculateLabel.numberOfLines = titleLabel.numberOfLines;
        calculateLabel.font = titleLabel.font;
    }
    /// 重新赋值，是因为Button的titleLabel赋值不是实时的，在计算时有可能是以前设置的文本
    id currentTitleValue = self.getCurrentTitleContent;
    if ([currentTitleValue isKindOfClass:[NSAttributedString class]]) {
        calculateLabel.attributedText  = currentTitleValue;
    }else {
        calculateLabel.text = currentTitleValue;
    }
    CGSize titleSize = [calculateLabel sizeThatFits:maxSize];
    //单纯使用富文本进行计算，与Label的 sizeThatFits: 方法计算会出现稍微的偏差，从而导致内容显示不全
    titleSize.width     = ceil(titleSize.width);
    titleSize.height    = ceil(titleSize.height);
    
    return titleSize;
}

//#pragma mark - 约束系统方法重写

#pragma mark - 内容获取
- (id)handleContentWithType:(_CGButtonHandleContentType)type state:(UIControlState)state
{
    id value    = nil;
    
    UIControlState controlState;
    
    controlState    = UIControlStateDisabled;
    if (state & controlState) {
        return [self getContentWithType:type state:controlState];
    }
    
    controlState    = UIControlStateHighlighted;
    if (state & controlState) {
        value   = [self getContentWithType:type state:controlState];
        state   -= controlState;
        if (value) {
            return value;
        }
    }
    
    controlState    = UIControlStateSelected;
    if (state & controlState) {
        return [self getContentWithType:type state:controlState];
    }
    
    controlState    = UIControlStateNormal;
    if (state == controlState) {
        return [self getContentWithType:type state:controlState];
    }
    
    if (@available(iOS 9.0, *)) {
        
        controlState    = UIControlStateFocused;
        if (controlState && (state & controlState)) {
            return [self getContentWithType:type state:controlState];
        }
    }
    
    controlState    = UIControlStateApplication;
    if (state & controlState) {
        return [self getContentWithType:type state:controlState];
    }
    
    controlState    = UIControlStateReserved;
    if (state & controlState) {
        return [self getContentWithType:type state:controlState];
    }
    
    return nil;
}

- (id)getContentWithType:(_CGButtonHandleContentType)type state:(UIControlState)state
{
    id value    = nil;
    if (type == _CGButtonHandleContentTypeImage) {
        value   = [self imageForState:state];
    }else {
        value   = [self attributedTitleForState:state];
        if (value == nil) {
            value   = [self titleForState:state];
        }
    }
    return value;
}

#pragma mark - 属性设置
- (void)setButtonStyle:(CGButtonStyle)buttonStyle
{
    if (buttonStyle != _buttonStyle) {
        _buttonStyle = buttonStyle;
        [self cg_updateButtonLayout];
    }
}

- (void)setSpace:(CGFloat)space
{
    if (space != _space) {
        _space = space;
        [self cg_updateButtonLayout];
    }
}

- (void)setMarginEdgeInsets:(UIEdgeInsets)marginEdgeInsets
{
    if (!UIEdgeInsetsEqualToEdgeInsets(marginEdgeInsets, _marginEdgeInsets)) {
        _marginEdgeInsets = marginEdgeInsets;
        [self cg_updateButtonLayout];
    }
}

- (void)setContentSubviewAlignment:(CGButtonContentAlignment)contentSubviewAlignment
{
    if (contentSubviewAlignment != _contentSubviewAlignment) {
        _contentSubviewAlignment   = contentSubviewAlignment;
        [self cg_updateButtonLayout];
    }
}

- (void)setContentSubviewOfficeSpace:(CGFloat)contentSubviewOfficeSpace
{
    if (_contentSubviewOfficeSpace != contentSubviewOfficeSpace) {
        
        _contentSubviewOfficeSpace  = contentSubviewOfficeSpace;
        [self cg_updateButtonLayout];
    }
}

//- (void)setMaxSize:(CGSize)maxSize
//{
//    if (!CGSizeEqualToSize(maxSize, _maxSize)) {
//        _maxSize = maxSize;
//        [self cg_performAfterZeroDelaySelector:@selector(cg_updateButtonLayout)];
//    }
//}

- (CGFloat)didHandleSpace
{
    BOOL useCustomImageView = !CGSizeEqualToSize(self.imageViewSize, CGSizeZero);
    if (!self.getCurrentImage && !useCustomImageView) {
        return 0;
    }
    
    id currentTitleValue    = self.getCurrentTitleContent;
    if (![currentTitleValue respondsToSelector:@selector(length)] || ![currentTitleValue length]) {
        return 0;
    }
    return self.space;
}

- (id)getCurrentTitleContent
{
    if (self.setupCurrentTitleContent) {
        return self.setupCurrentTitleContent(self, self.state);
    }else if (self.handleCurrentContentType == CGButtonHandleCurrentContentTypeDefalut) {
        return [self handleContentWithType:_CGButtonHandleContentTypeTitle state:self.state];
    }
    return self.currentAttributedTitle ? self.currentAttributedTitle : self.currentTitle;
}

- (UIImage *)getCurrentImage
{
    if (self.setupCurrentImage) {
        self.setupCurrentImage(self, self.state);
    }else if (self.handleCurrentContentType == CGButtonHandleCurrentContentTypeDefalut) {
        return [self handleContentWithType:_CGButtonHandleContentTypeImage state:self.state];
    }
    
    return self.currentImage;
}

@end

@implementation CGButton (CGCreateButton)

+ (__kindof CGButton *)createButtonWithType:(UIButtonType)buttonType style:(CGButtonStyle)buttonStyle space:(CGFloat)space title:(NSString *)title font:(nullable UIFont *)font titleColor:(nullable UIColor *)titleColor image:(nullable UIImage *)image
{
    CGButton *button = [CGButton buttonWithType:buttonType];
    !title?: [button setTitle:title forState:UIControlStateNormal];
    !titleColor?: [button setTitleColor:titleColor forState:UIControlStateNormal];
    !font?: [button.titleLabel setFont:font];
    !image?: [button setImage:image forState:UIControlStateNormal];
    button.buttonStyle  = buttonStyle;
    button.space        = space;
    return button;
}

+ (__kindof CGButton *)createButtonWithType:(UIButtonType)buttonType style:(CGButtonStyle)buttonStyle space:(CGFloat)space title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor imageName:(nullable NSString *)imageName
{
    return [self createButtonWithType:buttonType style:buttonStyle space:space title:title font:font titleColor:titleColor image:imageName ? [UIImage imageNamed:imageName] : nil];
}

+ (__kindof CGButton *)createButtonWithType:(UIButtonType)buttonType style:(CGButtonStyle)buttonStyle space:(CGFloat)space title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor imageForOriginal:(UIImage *)image
{
    return [self createButtonWithType:buttonType style:buttonStyle space:space title:title font:font titleColor:titleColor image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

+ (__kindof CGButton *)createButtonWithType:(UIButtonType)buttonType style:(CGButtonStyle)buttonStyle space:(CGFloat)space title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor imageNameForOriginal:(NSString *)imageName
{
    UIImage *image  = nil;
    if (imageName != nil) {
        image   = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return [self createButtonWithType:buttonType style:buttonStyle space:space title:title font:font titleColor:titleColor image:image];
}

@end
