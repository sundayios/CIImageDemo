//
//  QSFilterHelper.h
//  CIImageDemo
//
//  Created by admin on 2021/9/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSFilterHelper : NSObject

+ (UIImage *)qs_SourceImg:(UIImage *)imgS;

+ (UIImage *)qs_SourceOuter:(UIImage *)imgS maskImg:(UIImage *)maskImg;

+ (UIImage *)qs_filterInnerRadius:(CGFloat)minRadius outerRadius:(CGFloat)outerRadius withMaskImg:(UIImage *)maskImg sourceImage:(UIImage *)sImg  backGroundColor:(UIColor *)bgColor;
@end

NS_ASSUME_NONNULL_END
