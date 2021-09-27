//
//  QSFilterHelper.m
//  CIImageDemo
//
//  Created by admin on 2021/9/28.
//

#import "QSFilterHelper.h"

@implementation QSFilterHelper

+ (UIImage *)bezierPathMask:(UIBezierPath *)bezierPath inerRadius:(CGFloat)minRadius outerRadius:(CGFloat)maxRadius{
    
    
    return nil;
}


+ (UIImage *)qs_filterScale:(CGFloat)dscale withImg:(UIImage *)sourceImg{
    UIImage *nimg = nil;
    @autoreleasepool {
        CIImage *result = [CIImage imageWithCGImage:sourceImg.CGImage];
        
        CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        [filter setValue:result forKey:kCIInputImageKey];
        [filter setValue:@(dscale) forKey:@"inputScale"];
        [filter setValue:@(1) forKey:@"inputAspectRatio"];
        result = [filter valueForKey:kCIOutputImageKey];
        nimg = [[UIImage alloc] initWithCIImage:result];
    }
    
    return nimg;
}

@end
