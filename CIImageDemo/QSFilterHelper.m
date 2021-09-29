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
        CGRect dframe = result.extent;
        CGFloat dwidth = dframe.size.width;
        CGFloat dheight = dframe.size.height;
        CGFloat centerX = dwidth / 2.0;
        CGFloat centerY = dheight / 2.0;
        CGFloat maxShadowRadiu = sqrt(pow(centerX, 2) + pow(centerY, 2));

//        CIFilter *colorFilter = [CIFilter filterWithName:@"CIConstantColorGenerator"];
//        [colorFilter setValue:[UIColor whiteColor] forKey:@"inputColor"];
//        CIImage *croppedBgImage = [[colorFilter valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
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
            maskImgMax = [[filterAffTOutter valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        }
        
        
        //cbg
        CIFilter *filterConstantColor = [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantColor setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor"];
        CIImage *bgColorImg = [[filterConstantColor valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        //外 destImage
        CIFilter *filterBlendWithDest = [CIFilter filterWithName:@"CIBlendWithMask"];
        [filterBlendWithDest setValue:result forKey:@"inputImage"];
        [filterBlendWithDest setValue:bgColorImg forKey:@"inputBackgroundImage"];
        [filterBlendWithDest setValue:maskImgMax forKey:@"inputMaskImage"];
        CIImage *destImage = [[filterBlendWithDest valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        
        if (minRadius < maxRadius) {
            ///////外maskImg radialGradient
            CIFilter *filterRadialGradient = [CIFilter filterWithName:@"CIRadialGradient"];
            CIVector *civ = [[CIVector alloc] initWithCGPoint:CGPointMake(centerX, centerY)];
            CGFloat maxr = maxShadowRadiu * 1.3;
            [filterRadialGradient setValue:civ forKey:@"inputCenter"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor] forKey:@"inputColor0"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor1"];
            [filterRadialGradient setValue:@(maxRadius) forKey:@"inputRadius1"];//model.realValue * @(maxr)
            [filterRadialGradient setValue:@(0) forKey:@"inputRadius0"];//model.realValue * @(0)
            CIImage *dmaskImgORG = [[filterRadialGradient valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
            
            CIFilter *filter_bgW2CC = [CIFilter filterWithName:@"CIRadialGradient"];
            
            [filterRadialGradient setValue:civ forKey:@"inputCenter"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor0"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor] forKey:@"inputColor1"];
            [filterRadialGradient setValue:@(maxRadius) forKey:@"inputRadius1"];//model.realValue * @(maxr)
            [filterRadialGradient setValue:@(0) forKey:@"inputRadius0"];//model.realValue * @(0)
            CIImage *dmaskImgbgW2CC = [[filterRadialGradient valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
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
                [filterAffTInner setValue:maskImgMin forKey:@"inputImage"];
                [filterAffTInner setValue:[NSValue valueWithCGAffineTransform:transitionInner] forKey:@"inputTransform"];
                maskImgMin = [[filterAffTInner valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            }
            
            
            
            
            //边缘均匀加深
            CGFloat radialRadius = (maxRadius - minRadius) / 3.0;
            CIFilter *filterHeightFieldMask = [CIFilter filterWithName:@"CIHeightFieldFromMask"];//
            [filterHeightFieldMask setValue:maskImgMax forKey:@"inputImage"];
            [filterHeightFieldMask setValue:@(radialRadius) forKey:@"inputRadius"];
            CIImage *dmaskImgHeight = [[filterHeightFieldMask valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
            CIFilter *filterDoubleLoop = [CIFilter filterWithName:@"CISourceOutCompositing"];//CISourceOutCompositing
            [filterDoubleLoop setValue:dmaskImgHeight forKey:@"inputImage"];
            [filterDoubleLoop setValue:maskImgMin forKey:@"inputBackgroundImage"];
            CIImage *dImgRadialGradient = [[filterDoubleLoop valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
            
            
//            CIFilter *filterShaded = [CIFilter filterWithName:@"CIShadedMaterial"];//
//            [filterShaded setValue:destImage forKey:@"inputImage"];//result
//            [filterShaded setValue:dmaskImgHeight forKey:@"inputShadingImage"];
//            [filterShaded setValue:@(radialRadius) forKey:@"inputScale"];
//            CIImage *dImgSourceInner = [[filterShaded valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
//            CIFilter *filterBlendWithMask = [CIFilter filterWithName:@"CIBlendWithMask"];
//            [filterBlendWithMask setValue:croppedImage forKey:@"inputImage"];
//            [filterBlendWithMask setValue:bgColorImg forKey:@"inputBackgroundImage"];
//            [filterBlendWithMask setValue:maskImgMax forKey:@"inputMaskImage"];
//            CIImage *bgImgOutterRadialGradient = [filterBlendWithMask valueForKey:kCIOutputImageKey];

            
            CIFilter *filterBlendLast = [CIFilter filterWithName:@"CIBlendWithAlphaMask"];//CIBlendWithAlphaMask
            [filterBlendLast setValue:dmaskImgORG forKey:@"inputImage"];
            [filterBlendLast setValue:destImage forKey:@"inputBackgroundImage"];
            [filterBlendLast setValue:dmaskImgHeight forKey:@"inputMaskImage"];
            
            CIImage *dImgSourceInner = [[filterBlendLast valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            ///双环 maskImg.path形状
            ///w-c
            CIFilter *filterOutHeight = [CIFilter filterWithName:@"CISourceOutCompositing"];//CISourceOutCompositing
            [filterOutHeight setValue:dmaskImgbgW2CC forKey:@"inputImage"];
            [filterOutHeight setValue:bgColorImg forKey:@"inputBackgroundImage"];
            CIImage *dImgOutHeight = [[filterDoubleLoop valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            //混合模糊
            CIFilter *composite = [CIFilter filterWithName:@"CISourceOverCompositing"];//CISourceOutCompositing
            [composite setValue:dImgRadialGradient forKey:@"inputImage"];
            [composite setValue:destImage forKey:@"inputBackgroundImage"];
            CIImage *dImgResult = [[composite valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
//            CIFilter *composite2 = [CIFilter filterWithName:@"CISourceOverCompositing"];//CISourceOutCompositing
//            [composite2 setValue:dImgSourceInner forKey:@"inputImage"];
//            [composite2 setValue:dImgResult forKey:@"inputBackgroundImage"];
//            dImgResult = [[composite valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            

            
            
            nimg = [UIImage imageWithCIImage:dImgResult];
        } else {
            nimg = [UIImage imageWithCIImage:destImage];
        }
        
    }

    return nimg;
}


@end
