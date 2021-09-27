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

+ (UIImage *)qs_filterScale:(CGFloat)dscale withImg:(UIImage *)sourceImg;
@end

NS_ASSUME_NONNULL_END
