//
//  QSFilterHelper.m
//  CIImageDemo
//
//  Created by admin on 2021/9/28.
//

#import "QSFilterHelper.h"

@implementation QSFilterHelper


+ (UIImage *)qs_CIPerspectiveTransformImg:(UIImage *)imgS {
    
    UIImage *nimg = nil;
    @autoreleasepool {
        
        CIImage *ciSImg = [CIImage imageWithCGImage:imgS.CGImage];
        NSLog(@"----------b:%@",NSStringFromCGRect(ciSImg.extent));
        CIImage* douterImg = [ciSImg imageByCroppingToRect:CGRectMake(0, 0, 300, 200)];
        NSLog(@"----------a:%@",NSStringFromCGRect(douterImg.extent));
        nimg = [[UIImage alloc] initWithCIImage:douterImg];
        NSLog(@"----------a-UIimage:%@",NSStringFromCGSize(nimg.size));
    }
    return nimg;
}



+ (UIImage *)qs_SourceImg:(UIImage *)imgS {
    
    UIImage *nimg = nil;
    @autoreleasepool {
        
        CIImage *ciSImg = [CIImage imageWithCGImage:imgS.CGImage];
        NSLog(@"----------b:%@",NSStringFromCGRect(ciSImg.extent));
        CIImage* douterImg = [ciSImg imageByCroppingToRect:CGRectMake(0, 0, 300, 200)];
        NSLog(@"----------a:%@",NSStringFromCGRect(douterImg.extent));
        nimg = [[UIImage alloc] initWithCIImage:douterImg];
        NSLog(@"----------a-UIimage:%@",NSStringFromCGSize(nimg.size));
    }
    return nimg;
}


+ (UIImage *)qs_SourceOuter:(UIImage *)imgS maskImg:(UIImage *)maskImg {
    
    UIImage *nimg = nil;
    @autoreleasepool {
        CIImage *cimaskImg = [CIImage imageWithCGImage:maskImg.CGImage];
        CIImage *ciSImg = [CIImage imageWithCGImage:imgS.CGImage];
        
//        CGAffineTransform scaleT = CGAffineTransformMakeScale(1.5, 1.5);
//        CGAffineTransform transition = CGAffineTransformTranslate(scaleT, ciSImg.extent.size.width / 2.0, ciSImg.extent.size.height / 2.0);
        
        CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        [filter setValue:cimaskImg forKey:kCIInputImageKey];
        [filter setValue:@(5) forKey:@"inputScale"];
        [filter setValue:@(1) forKey:@"inputAspectRatio"];
        CIImage *tempCImg = [filter valueForKey:kCIOutputImageKey];
        
        
        CGAffineTransform transition = CGAffineTransformMakeTranslation((ciSImg.extent.size.width - tempCImg.extent.size.width) / 2.0, (ciSImg.extent.size.height  - tempCImg.extent.size.height) / 2.0);
//        CGAffineTransform scaleT = CGAffineTransformScale(transition, 5, 5);
        
        
        
        
        CIFilter *filterAff = [CIFilter filterWithName:@"CIAffineTransform"];
        [filterAff setValue:tempCImg forKey:@"inputImage"];
        [filterAff setValue:[NSValue valueWithCGAffineTransform:transition] forKey:@"inputTransform"];
//        CIImage *tempCImg = [[filterAff valueForKey:kCIOutputImageKey] imageByCroppingToRect:ciSImg.extent];
        tempCImg = [filterAff valueForKey:kCIOutputImageKey];
        
        
        
        
        CIFilter *filterOuter = [CIFilter filterWithName:@"CISourceOutCompositing"];//CISourceOutCompositing
       [filterOuter setValue:ciSImg forKey:@"inputImage"];
       [filterOuter setValue:tempCImg forKey:@"inputBackgroundImage"];
       CIImage* douterImg = [[filterOuter valueForKey:kCIOutputImageKey] imageByCroppingToRect:ciSImg.extent];
        nimg = [[UIImage alloc] initWithCIImage:douterImg];
    }
    return nimg;
}

+ (UIImage *)bezierPathMask:(UIBezierPath *)bezierPath inerRadius:(CGFloat)minRadius outerRadius:(CGFloat)maxRadius{
    
    
    return nil;
}


+ (UIImage *)qs_filterScale:(CGFloat)dscale withImg:(UIImage *)sourceImg{
    UIImage *nimg = nil;
    @autoreleasepool {
        CIImage *maskImg = [CIImage imageWithCGImage:sourceImg.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        [filter setValue:maskImg forKey:kCIInputImageKey];
        [filter setValue:@(dscale) forKey:@"inputScale"];
        [filter setValue:@(1) forKey:@"inputAspectRatio"];
        maskImg = [filter valueForKey:kCIOutputImageKey];
        nimg = [[UIImage alloc] initWithCIImage:maskImg];
    }
    return nimg;
}



+ (UIImage *)qs_filterInnerRadius:(CGFloat)minRadius outerRadius:(CGFloat)maxRadius withMaskImg:(UIImage *)maskImg sourceImage:(UIImage *)sImg  backGroundColor:(UIColor *)bgColor{
    UIImage *nimg = nil;
    @autoreleasepool {
        CIImage *result = [CIImage imageWithCGImage:sImg.CGImage];
        CGFloat dwidth = result.extent.size.width;
        CGFloat dheight = result.extent.size.height;
        CGFloat centerX = dwidth / 2.0;
        CGFloat centerY = dheight / 2.0;
        CGFloat maxShadowRadiu = sqrt(pow(centerX, 2) + pow(centerY, 2));

//        CIFilter *colorFilter = [CIFilter filterWithName:@"CIConstantColorGenerator"];
//        [colorFilter setValue:[UIColor whiteColor] forKey:@"inputColor"];
//        CIImage *croppedBgImage = [[colorFilter valueForKey:kCIOutputImageKey] imageByCroppingToRect:result.extent];
        
        CIImage *maskCIImg = [CIImage imageWithCGImage:maskImg.CGImage];
        CGFloat maskWidth = maskCIImg.extent.size.width;
        CGFloat maskHeight = maskCIImg.extent.size.height;
        CGFloat minWidthMask = maskWidth > maskHeight ? maskHeight : maskWidth;
        //外maskImg
        CIFilter *filterMaskOutter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        [filterMaskOutter setValue:maskCIImg forKey:kCIInputImageKey];
        [filterMaskOutter setValue:@(maxRadius / minWidthMask) forKey:@"inputScale"];
        [filterMaskOutter setValue:@(1) forKey:@"inputAspectRatio"];
        CIImage *maskImgMax = [filterMaskOutter valueForKey:kCIOutputImageKey];
        CGFloat widthMaskImgOutter = maskImgMax.extent.size.width;
        CGFloat heightMaskImgOutter = maskImgMax.extent.size.height;
        
        if (dwidth - widthMaskImgOutter != 0 || dheight - heightMaskImgOutter != 0) {
            CGAffineTransform transitionOutter = CGAffineTransformMakeTranslation((dwidth - widthMaskImgOutter) / 2.0, (dheight - heightMaskImgOutter) / 2.0);
            CIFilter *filterAffTOutter = [CIFilter filterWithName:@"CIAffineTransform"];
            [filterAffTOutter setValue:maskImgMax forKey:@"inputImage"];
            [filterAffTOutter setValue:[NSValue valueWithCGAffineTransform:transitionOutter] forKey:@"inputTransform"];
            maskImgMax = [filterAffTOutter valueForKey:kCIOutputImageKey];
        }
        
        
        //clearbg
        CIFilter *filterConstantColor = [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantColor setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor"];
        CIImage *bgImgClearOuter = [[filterConstantColor valueForKey:kCIOutputImageKey] imageByCroppingToRect:result.extent];
        
        //外 destImage
        CIFilter *filterBlendWithDest = [CIFilter filterWithName:@"CIBlendWithMask"];
        [filterBlendWithDest setValue:result forKey:@"inputImage"];
        [filterBlendWithDest setValue:bgImgClearOuter forKey:@"inputBackgroundImage"];
        [filterBlendWithDest setValue:maskImgMax forKey:@"inputMaskImage"];
        CIImage *destImage = [[filterBlendWithDest valueForKey:kCIOutputImageKey] imageByCroppingToRect:result.extent];
        
        
        
        if (minRadius < maxRadius) {
            //内maskImg
            CIFilter *filterMaskInner = [CIFilter filterWithName:@"CILanczosScaleTransform"];
            [filterMaskInner setValue:maskCIImg forKey:kCIInputImageKey];
            [filterMaskInner setValue:@(minRadius / minWidthMask) forKey:@"inputScale"];
            [filterMaskInner setValue:@(1) forKey:@"inputAspectRatio"];
            CIImage *maskImgMin = [filterMaskInner valueForKey:kCIOutputImageKey];
            CGFloat widthMaskImgInner = maskImgMin.extent.size.width;
            CGFloat heightMaskImgInner = maskImgMin.extent.size.height;
            
            if (dwidth - widthMaskImgInner != 0 || dheight - heightMaskImgInner != 0) {
                CGAffineTransform transitionInner = CGAffineTransformMakeTranslation((dwidth - widthMaskImgInner) / 2.0, (dheight - heightMaskImgInner) / 2.0);
                CIFilter *filterAffTInner = [CIFilter filterWithName:@"CIAffineTransform"];
                [filterAffTInner setValue:maskImgMax forKey:@"inputImage"];
                [filterAffTInner setValue:[NSValue valueWithCGAffineTransform:transitionInner] forKey:@"inputTransform"];
                maskImgMin = [filterAffTInner valueForKey:kCIOutputImageKey];
            }
            //
            CIFilter *filterRadialGradient = [CIFilter filterWithName:@"CIRadialGradient"];
            CIVector *civ = [[CIVector alloc] initWithCGPoint:CGPointMake(centerX, centerY)];
            CGFloat maxr = maxShadowRadiu * 1.3;
            [filterRadialGradient setValue:civ forKey:@"inputCenter"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor0"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:bgColor.CGColor] forKey:@"inputColor1"];
            [filterRadialGradient setValue:@(maxr) forKey:@"inputRadius1"];//model.realValue *
            [filterRadialGradient setValue:@(0) forKey:@"inputRadius0"];//model.realValue *
            CIImage *croppedImage = [[filterRadialGradient valueForKey:kCIOutputImageKey] imageByCroppingToRect:result.extent];
           
            /////外maskImg radialGradient
            CIFilter *filterBlendWithMask = [CIFilter filterWithName:@"CIBlendWithMask"];
            [filterBlendWithMask setValue:croppedImage forKey:@"inputImage"];
            [filterBlendWithMask setValue:bgImgClearOuter forKey:@"inputBackgroundImage"];
            [filterBlendWithMask setValue:maskImgMax forKey:@"inputMaskImage"];

            CIImage *bgImgOutterRadialGradient = [[filterBlendWithMask valueForKey:kCIOutputImageKey] imageByCroppingToRect:result.extent];
            
            /////双环 maskImg.path形状
            CIFilter *filterDoubleLoop = [CIFilter filterWithName:@"CISourceOutCompositing"];//CISourceOutCompositing
            [filterDoubleLoop setValue:bgImgOutterRadialGradient forKey:@"inputImage"];
            [filterDoubleLoop setValue:maskImgMin forKey:@"inputBackgroundImage"];
            //kCIInputBackgroundImageKey

            CIImage *dImgRadialGradient = [[filterDoubleLoop valueForKey:kCIOutputImageKey] imageByCroppingToRect:result.extent];
            //边缘均匀加深

            CGFloat radialRadius = (maxRadius - minRadius) / 3.0;
            CIFilter *filterHeightFieldMask = [CIFilter filterWithName:@"CIHeightFieldFromMask"];//
            [filterHeightFieldMask setValue:dImgRadialGradient forKey:@"inputImage"];
            [filterHeightFieldMask setValue:@(radialRadius) forKey:@"inputRadius"];
            CIImage *dmaskImgRadailGradient = [[filterHeightFieldMask valueForKey:kCIOutputImageKey] imageByCroppingToRect:result.extent];
            
//            CIFilter *filerLast = [CIFilter filterWithName:@"CISourceOverCompositing"];//CISourceOutCompositing
//            [filerLast setValue:dmaskImgRadailGradient forKey:@"inputImage"];
//            [filerLast setValue:destImage forKey:@"inputBackgroundImage"];
            
            CIFilter *filerLast = [CIFilter filterWithName:@"CIShadedMaterial"];
            [filerLast setValue:destImage forKey:@"inputImage"];
            [filerLast setValue:dmaskImgRadailGradient forKey:@"inputShadingImage"];
            [filerLast setValue:@(radialRadius) forKey:@"inputScale"];
            
            CIImage *dImgSourceInner = [[filerLast valueForKey:kCIOutputImageKey] imageByCroppingToRect:result.extent];
            nimg = [UIImage imageWithCIImage:dImgSourceInner];
        } else {
            nimg = [UIImage imageWithCIImage:destImage];
        }
        
    }

    return nimg;
}


@end
