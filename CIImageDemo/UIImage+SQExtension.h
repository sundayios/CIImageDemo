//
//  UIImage+SQExtension.h
//  CIImageDemo
//
//  Created by Biggerlens on 2021/9/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SQExtension)

+ (UIImage *)sq_ImageWithColor:(UIColor *)bgColor withPath:(UIBezierPath *)bezierPath;
+ (id) imageMaskWithContentSize:(CGSize) innerSize maskWidth:(CGFloat) frameWidth colors:(NSArray*) colors
                   cornerRadius:(CGFloat) cornerRadius fillContent:(BOOL) needFillColor;
@end

NS_ASSUME_NONNULL_END
