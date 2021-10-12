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
        
        CIImage *maskCIImg = [CIImage imageWithCGImage:maskImg.CGImage];
        CGFloat maskWidth = maskCIImg.extent.size.width;
        CGFloat maskHeight = maskCIImg.extent.size.height;
        CGFloat minWidthMask = maskWidth > maskHeight ? maskHeight : maskWidth;
        //外maskImg white
        CIFilter *filterMaskOutter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        [filterMaskOutter setValue:maskCIImg forKey:kCIInputImageKey];
        [filterMaskOutter setValue:@(maxRadius / minWidthMask) forKey:@"inputScale"];
        [filterMaskOutter setValue:@(1) forKey:@"inputAspectRatio"];
        CIImage *maskImgMax = [filterMaskOutter valueForKey:kCIOutputImageKey];
        CGFloat widthMaskImgOutter = maskImgMax.extent.size.width;
        CGFloat heightMaskImgOutter = maskImgMax.extent.size.height;
        
        NSLog(@"maskImgMax:%@",NSStringFromCGRect(maskImgMax.extent));
        
        if (dwidth - widthMaskImgOutter != 0 || dheight - heightMaskImgOutter != 0) {
            CGAffineTransform transitionOutter = CGAffineTransformMakeTranslation((dwidth - widthMaskImgOutter) / 2.0, (dheight - heightMaskImgOutter) / 2.0);
            CIFilter *filterAffTOutter = [CIFilter filterWithName:@"CIAffineTransform"];
            [filterAffTOutter setValue:maskImgMax forKey:@"inputImage"];
            [filterAffTOutter setValue:[NSValue valueWithCGAffineTransform:transitionOutter] forKey:@"inputTransform"];
            maskImgMax = [[filterAffTOutter valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        }
        
        
        //cbg
        CIFilter *filterConstantCc= [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantCc setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor"];
        CIImage *bgCcImg = [[filterConstantCc valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        CIFilter *filterConstantCb = [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantCb setValue:[CIColor colorWithCGColor:bgColor.CGColor] forKey:@"inputColor"];
        CIImage *bgColorImg = [[filterConstantCb valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        //外 destImage
        CIFilter *filterBlendWithDest = [CIFilter filterWithName:@"CIBlendWithMask"];
        [filterBlendWithDest setValue:result forKey:@"inputImage"];
        [filterBlendWithDest setValue:bgColorImg forKey:@"inputBackgroundImage"];
        //bgCcImg
        [filterBlendWithDest setValue:maskImgMax forKey:@"inputMaskImage"];
        CIImage *destImage = [[filterBlendWithDest valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        
        if (minRadius < maxRadius) {
            ///////外maskImg radialGradient
            CIFilter *filterRadialGradient = [CIFilter filterWithName:@"CIRadialGradient"];
            CIVector *civ = [[CIVector alloc] initWithCGPoint:CGPointMake(centerX, centerY)];
            CGFloat maxr = maxShadowRadiu * 1.3;
            [filterRadialGradient setValue:civ forKey:@"inputCenter"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor0"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor] forKey:@"inputColor1"];
            [filterRadialGradient setValue:@(maxRadius) forKey:@"inputRadius1"];//model.realValue * @(maxr)
            [filterRadialGradient setValue:@(minRadius) forKey:@"inputRadius0"];//model.realValue * @(0)
            CIImage *dmaskImgORGw2c = [[filterRadialGradient valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
            CIFilter *fbgRGLoop = [CIFilter filterWithName:@"CIBlendWithMask"];
            [fbgRGLoop setValue:dmaskImgORGw2c forKey:@"inputImage"];
            [fbgRGLoop setValue:bgCcImg forKey:@"inputBackgroundImage"];
            [fbgRGLoop setValue:maskImgMax forKey:@"inputMaskImage"];
            CIImage *bgImgRGLoop = [[fbgRGLoop valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
//            CIFilter *filter_bgW2CC = [CIFilter filterWithName:@"CIRadialGradient"];
//
//            [filterRadialGradient setValue:civ forKey:@"inputCenter"];
//            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor0"];
//            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor] forKey:@"inputColor1"];
//            [filterRadialGradient setValue:@(maxRadius) forKey:@"inputRadius1"];//model.realValue * @(maxr)
//            [filterRadialGradient setValue:@(0) forKey:@"inputRadius0"];//model.realValue * @(0)
//            CIImage *dmaskImgbgW2CC = [[filterRadialGradient valueForKey:kCIOutputImageKey] imageByCroppingToRect:CGRectMake(0, 0, maxRadius, maxRadius)];
            
            
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
            
            NSLog(@"maskImgMin:%@",NSStringFromCGRect(maskImgMin.extent));
            
            ///双环 maskImg.path形状
              CIFilter *filterDoubleLoop = [CIFilter filterWithName:@"CISourceOutCompositing"];
                [filterDoubleLoop setValue:bgImgRGLoop forKey:@"inputImage"];
                [filterDoubleLoop setValue:maskImgMin forKey:@"inputBackgroundImage"];
                CIImage *dImgRGDoubleLoop = [[filterDoubleLoop valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            ///w-c
//            CIFilter *filterOutHeight = [CIFilter filterWithName:@"CISourceOutCompositing"];//CISourceOutCompositing
//            [filterOutHeight setValue:dmaskImgbgW2CC forKey:@"inputImage"];
//            [filterOutHeight setValue:bgColorImg forKey:@"inputBackgroundImage"];
//            CIImage *dImgOutHeight = [[filterDoubleLoop valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
            
            //边缘均匀加深
            CGFloat radialRadius = (maxRadius - minRadius) * 1.2;
            CIFilter *filterHeightFieldMask = [CIFilter filterWithName:@"CIHeightFieldFromMask"];//
            [filterHeightFieldMask setValue:maskImgMax forKey:@"inputImage"];
            [filterHeightFieldMask setValue:@(radialRadius) forKey:@"inputRadius"];
            CIImage *dmaskImgHeight = [[filterHeightFieldMask valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
         
            //边缘均匀加深 添加透明度
            CIFilter *frg = [CIFilter filterWithName:@"CIMaskToAlpha"];
            [frg setValue:dmaskImgHeight forKey:@"inputImage"];
            CIImage *dImagergEdge = [[frg valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            //destimg 边缘深度
            CIFilter *filterBlendLast = [CIFilter filterWithName:@"CIBlendWithAlphaMask"];//CIMaskToAlpha
            [filterBlendLast setValue:destImage forKey:@"inputImage"];
            [filterBlendLast setValue:bgCcImg forKey:@"inputBackgroundImage"];
            [filterBlendLast setValue:dImagergEdge forKey:@"inputMaskImage"];
            CIImage *destimgImageRG = [[filterBlendLast valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            

            
            CIFilter *fmaskBlur = [CIFilter filterWithName:@"CIMaskedVariableBlur"];
            [fmaskBlur setValue:destimgImageRG forKey:@"inputImage"];
            [fmaskBlur setValue:dImgRGDoubleLoop forKey:@"inputMask"];
            [fmaskBlur setValue:@(maxRadius - minRadius) forKey:@"inputRadius"];
            CIImage *dsreult = [[fmaskBlur valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            //混合背景
            CIFilter *composite = [CIFilter filterWithName:@"CISourceOverCompositing"];//CISourceOutCompositing
            [composite setValue:dsreult forKey:@"inputImage"];
            [composite setValue:bgColorImg forKey:@"inputBackgroundImage"];
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





+ (UIImage *)qs_aaaafilterInnerRadius:(CGFloat)minRadius outerRadius:(CGFloat)maxRadius withMaskImg:(UIImage *)maskImg sourceImage:(UIImage *)sImg  backGroundColor:(UIColor *)bgColor{
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
        //外maskImg white
        CIFilter *filterMaskOutter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        [filterMaskOutter setValue:maskCIImg forKey:kCIInputImageKey];
        [filterMaskOutter setValue:@(maxRadius / minWidthMask) forKey:@"inputScale"];
        [filterMaskOutter setValue:@(1) forKey:@"inputAspectRatio"];
        CIImage *maskImgMax = [filterMaskOutter valueForKey:kCIOutputImageKey];
        CGFloat widthMaskImgOutter = maskImgMax.extent.size.width;
        CGFloat heightMaskImgOutter = maskImgMax.extent.size.height;
        
        NSLog(@"maskImgMax:%@",NSStringFromCGRect(maskImgMax.extent));
        
        if (dwidth - widthMaskImgOutter != 0 || dheight - heightMaskImgOutter != 0) {
            CGAffineTransform transitionOutter = CGAffineTransformMakeTranslation((dwidth - widthMaskImgOutter) / 2.0, (dheight - heightMaskImgOutter) / 2.0);
            CIFilter *filterAffTOutter = [CIFilter filterWithName:@"CIAffineTransform"];
            [filterAffTOutter setValue:maskImgMax forKey:@"inputImage"];
            [filterAffTOutter setValue:[NSValue valueWithCGAffineTransform:transitionOutter] forKey:@"inputTransform"];
            maskImgMax = [[filterAffTOutter valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        }
        
        
        //cbg
        CIFilter *filterConstantCc= [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantCc setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor"];
        CIImage *bgCcImg = [[filterConstantCc valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        CIFilter *filterConstantCb = [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantCb setValue:[CIColor colorWithCGColor:bgColor.CGColor] forKey:@"inputColor"];
        CIImage *bgColorImg = [[filterConstantCb valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        //外 destImage
        CIFilter *filterBlendWithDest = [CIFilter filterWithName:@"CIBlendWithMask"];
        [filterBlendWithDest setValue:result forKey:@"inputImage"];
        [filterBlendWithDest setValue:bgColorImg forKey:@"inputBackgroundImage"];
        //bgCcImg
        [filterBlendWithDest setValue:maskImgMax forKey:@"inputMaskImage"];
        CIImage *destImage = [[filterBlendWithDest valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        
        if (minRadius < maxRadius) {
            ///////外maskImg radialGradient
            CIFilter *filterRadialGradient = [CIFilter filterWithName:@"CIRadialGradient"];
            CIVector *civ = [[CIVector alloc] initWithCGPoint:CGPointMake(centerX, centerY)];
            CGFloat maxr = maxShadowRadiu * 1.3;
            [filterRadialGradient setValue:civ forKey:@"inputCenter"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor0"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor] forKey:@"inputColor1"];
            [filterRadialGradient setValue:@(maxRadius) forKey:@"inputRadius1"];//model.realValue * @(maxr)
            [filterRadialGradient setValue:@(minRadius) forKey:@"inputRadius0"];//model.realValue * @(0)
            CIImage *dmaskImgORGw2c = [[filterRadialGradient valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
            CIFilter *fbgRGLoop = [CIFilter filterWithName:@"CIBlendWithMask"];
            [fbgRGLoop setValue:dmaskImgORGw2c forKey:@"inputImage"];
            [fbgRGLoop setValue:bgCcImg forKey:@"inputBackgroundImage"];
            [fbgRGLoop setValue:maskImgMax forKey:@"inputMaskImage"];
            CIImage *bgImgRGLoop = [[fbgRGLoop valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
//            CIFilter *filter_bgW2CC = [CIFilter filterWithName:@"CIRadialGradient"];
//
//            [filterRadialGradient setValue:civ forKey:@"inputCenter"];
//            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor0"];
//            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor] forKey:@"inputColor1"];
//            [filterRadialGradient setValue:@(maxRadius) forKey:@"inputRadius1"];//model.realValue * @(maxr)
//            [filterRadialGradient setValue:@(0) forKey:@"inputRadius0"];//model.realValue * @(0)
//            CIImage *dmaskImgbgW2CC = [[filterRadialGradient valueForKey:kCIOutputImageKey] imageByCroppingToRect:CGRectMake(0, 0, maxRadius, maxRadius)];
            
            
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
            
            NSLog(@"maskImgMin:%@",NSStringFromCGRect(maskImgMin.extent));
            
            ///双环 maskImg.path形状
              CIFilter *filterDoubleLoop = [CIFilter filterWithName:@"CISourceOutCompositing"];
                [filterDoubleLoop setValue:bgImgRGLoop forKey:@"inputImage"];
                [filterDoubleLoop setValue:maskImgMin forKey:@"inputBackgroundImage"];
                CIImage *dImgRGDoubleLoop = [[filterDoubleLoop valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            ///w-c
//            CIFilter *filterOutHeight = [CIFilter filterWithName:@"CISourceOutCompositing"];//CISourceOutCompositing
//            [filterOutHeight setValue:dmaskImgbgW2CC forKey:@"inputImage"];
//            [filterOutHeight setValue:bgColorImg forKey:@"inputBackgroundImage"];
//            CIImage *dImgOutHeight = [[filterDoubleLoop valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
            
            //边缘均匀加深
            CGFloat radialRadius = (maxRadius - minRadius) * 1.2;
            CIFilter *filterHeightFieldMask = [CIFilter filterWithName:@"CIHeightFieldFromMask"];//
            [filterHeightFieldMask setValue:maskImgMax forKey:@"inputImage"];
            [filterHeightFieldMask setValue:@(radialRadius) forKey:@"inputRadius"];
            CIImage *dmaskImgHeight = [[filterHeightFieldMask valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
         
            //边缘均匀加深 添加透明度
            CIFilter *frg = [CIFilter filterWithName:@"CIMaskToAlpha"];
            [frg setValue:dmaskImgHeight forKey:@"inputImage"];
            CIImage *dImagergEdge = [[frg valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            //destimg 边缘深度
            CIFilter *filterBlendLast = [CIFilter filterWithName:@"CIBlendWithAlphaMask"];//CIMaskToAlpha
            [filterBlendLast setValue:destImage forKey:@"inputImage"];
            [filterBlendLast setValue:bgCcImg forKey:@"inputBackgroundImage"];
            [filterBlendLast setValue:dImagergEdge forKey:@"inputMaskImage"];
            CIImage *destimgImageRG = [[filterBlendLast valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            

            
            CIFilter *fmaskBlur = [CIFilter filterWithName:@"CIMaskedVariableBlur"];
            [fmaskBlur setValue:destimgImageRG forKey:@"inputImage"];
            [fmaskBlur setValue:dImgRGDoubleLoop forKey:@"inputMask"];
            [fmaskBlur setValue:@(maxRadius - minRadius) forKey:@"inputRadius"];
            CIImage *dsreult = [[fmaskBlur valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            //混合背景
            CIFilter *composite = [CIFilter filterWithName:@"CISourceOverCompositing"];//CISourceOutCompositing
            [composite setValue:dsreult forKey:@"inputImage"];
            [composite setValue:bgColorImg forKey:@"inputBackgroundImage"];
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







//多边形 输入一张纯白的mask图片， 双环模糊
+ (UIImage *)qs1_filterInnerRadius:(CGFloat)minRadius outerRadius:(CGFloat)maxRadius withMaskImg:(UIImage *)maskImg sourceImage:(UIImage *)sImg  backGroundColor:(UIColor *)bgColor{
    UIImage *nimg = nil;
    @autoreleasepool {
        CIImage *result = [CIImage imageWithCGImage:sImg.CGImage];
        CGRect dframe = result.extent;
        CGFloat dwidth = dframe.size.width;
        CGFloat dheight = dframe.size.height;
        CGFloat centerX = dwidth / 2.0;
        CGFloat centerY = dheight / 2.0;
        CGFloat maxShadowRadiu = sqrt(pow(centerX, 2) + pow(centerY, 2));
        
        CIImage *maskCIImg = [CIImage imageWithCGImage:maskImg.CGImage];
        CGFloat maskWidth = maskCIImg.extent.size.width;
        CGFloat maskHeight = maskCIImg.extent.size.height;
        CGFloat minWidthMask = maskWidth > maskHeight ? maskHeight : maskWidth;
        //外maskImg white
        CIFilter *filterMaskOutter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        [filterMaskOutter setValue:maskCIImg forKey:kCIInputImageKey];
        [filterMaskOutter setValue:@(maxRadius / minWidthMask) forKey:@"inputScale"];
        [filterMaskOutter setValue:@(1) forKey:@"inputAspectRatio"];
        CIImage *maskImgMax = [filterMaskOutter valueForKey:kCIOutputImageKey];
        CGFloat widthMaskImgOutter = maskImgMax.extent.size.width;
        CGFloat heightMaskImgOutter = maskImgMax.extent.size.height;
        
        NSLog(@"maskImgMax:%@",NSStringFromCGRect(maskImgMax.extent));
        
        if (dwidth - widthMaskImgOutter != 0 || dheight - heightMaskImgOutter != 0) {
            CGAffineTransform transitionOutter = CGAffineTransformMakeTranslation((dwidth - widthMaskImgOutter) / 2.0, (dheight - heightMaskImgOutter) / 2.0);
            CIFilter *filterAffTOutter = [CIFilter filterWithName:@"CIAffineTransform"];
            [filterAffTOutter setValue:maskImgMax forKey:@"inputImage"];
            [filterAffTOutter setValue:[NSValue valueWithCGAffineTransform:transitionOutter] forKey:@"inputTransform"];
            maskImgMax = [[filterAffTOutter valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        }
        
        
        //cbg
        CIFilter *filterConstantCc= [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantCc setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor"];
        CIImage *bgCcImg = [[filterConstantCc valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        CIFilter *filterConstantCb = [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantCb setValue:[CIColor colorWithCGColor:bgColor.CGColor] forKey:@"inputColor"];
        CIImage *bgColorImg = [[filterConstantCb valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        //外 destImage
        CIFilter *filterBlendWithDest = [CIFilter filterWithName:@"CIBlendWithMask"];
        [filterBlendWithDest setValue:result forKey:@"inputImage"];
        [filterBlendWithDest setValue:bgColorImg forKey:@"inputBackgroundImage"];
        //bgCcImg
        [filterBlendWithDest setValue:maskImgMax forKey:@"inputMaskImage"];
        CIImage *destImage = [[filterBlendWithDest valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        
        if (minRadius < maxRadius) {
            ///////外maskImg radialGradient
            CIFilter *filterRadialGradient = [CIFilter filterWithName:@"CIRadialGradient"];
            CIVector *civ = [[CIVector alloc] initWithCGPoint:CGPointMake(centerX, centerY)];
            CGFloat maxr = maxShadowRadiu * 1.3;
            [filterRadialGradient setValue:civ forKey:@"inputCenter"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor0"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor] forKey:@"inputColor1"];
            [filterRadialGradient setValue:@(maxRadius) forKey:@"inputRadius1"];//model.realValue * @(maxr)
            [filterRadialGradient setValue:@(minRadius) forKey:@"inputRadius0"];//model.realValue * @(0)
            CIImage *dmaskImgORGw2c = [[filterRadialGradient valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
            CIFilter *fbgRGLoop = [CIFilter filterWithName:@"CIBlendWithMask"];
            [fbgRGLoop setValue:dmaskImgORGw2c forKey:@"inputImage"];
            [fbgRGLoop setValue:bgCcImg forKey:@"inputBackgroundImage"];
            [fbgRGLoop setValue:maskImgMax forKey:@"inputMaskImage"];
            CIImage *bgImgRGLoop = [[fbgRGLoop valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
//            CIFilter *filter_bgW2CC = [CIFilter filterWithName:@"CIRadialGradient"];
//
//            [filterRadialGradient setValue:civ forKey:@"inputCenter"];
//            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor0"];
//            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor] forKey:@"inputColor1"];
//            [filterRadialGradient setValue:@(maxRadius) forKey:@"inputRadius1"];//model.realValue * @(maxr)
//            [filterRadialGradient setValue:@(0) forKey:@"inputRadius0"];//model.realValue * @(0)
//            CIImage *dmaskImgbgW2CC = [[filterRadialGradient valueForKey:kCIOutputImageKey] imageByCroppingToRect:CGRectMake(0, 0, maxRadius, maxRadius)];
            
            
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
            
            NSLog(@"maskImgMin:%@",NSStringFromCGRect(maskImgMin.extent));
            
            ///双环 maskImg.path形状
              CIFilter *filterDoubleLoop = [CIFilter filterWithName:@"CISourceOutCompositing"];
                [filterDoubleLoop setValue:bgImgRGLoop forKey:@"inputImage"];
                [filterDoubleLoop setValue:maskImgMin forKey:@"inputBackgroundImage"];
                CIImage *dImgRGDoubleLoop = [[filterDoubleLoop valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            ///w-c
//            CIFilter *filterOutHeight = [CIFilter filterWithName:@"CISourceOutCompositing"];//CISourceOutCompositing
//            [filterOutHeight setValue:dmaskImgbgW2CC forKey:@"inputImage"];
//            [filterOutHeight setValue:bgColorImg forKey:@"inputBackgroundImage"];
//            CIImage *dImgOutHeight = [[filterDoubleLoop valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            
            
            //边缘均匀加深
            CGFloat radialRadius = (maxRadius - minRadius) * 1.2;
            CIFilter *filterHeightFieldMask = [CIFilter filterWithName:@"CIHeightFieldFromMask"];//
            [filterHeightFieldMask setValue:maskImgMax forKey:@"inputImage"];
            [filterHeightFieldMask setValue:@(radialRadius) forKey:@"inputRadius"];
            CIImage *dmaskImgHeight = [[filterHeightFieldMask valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
         
            //边缘均匀加深 添加透明度
            CIFilter *frg = [CIFilter filterWithName:@"CIMaskToAlpha"];
            [frg setValue:dmaskImgHeight forKey:@"inputImage"];
            CIImage *dImagergEdge = [[frg valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            //destimg 边缘深度
            CIFilter *filterBlendLast = [CIFilter filterWithName:@"CIBlendWithAlphaMask"];//CIMaskToAlpha
            [filterBlendLast setValue:destImage forKey:@"inputImage"];
            [filterBlendLast setValue:bgCcImg forKey:@"inputBackgroundImage"];
            [filterBlendLast setValue:dImagergEdge forKey:@"inputMaskImage"];
            CIImage *destimgImageRG = [[filterBlendLast valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            

            
            CIFilter *fmaskBlur = [CIFilter filterWithName:@"CIMaskedVariableBlur"];
            [fmaskBlur setValue:destimgImageRG forKey:@"inputImage"];
            [fmaskBlur setValue:dImgRGDoubleLoop forKey:@"inputMask"];
            [fmaskBlur setValue:@(maxRadius - minRadius) forKey:@"inputRadius"];
            CIImage *dsreult = [[fmaskBlur valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            //混合背景
            CIFilter *composite = [CIFilter filterWithName:@"CISourceOverCompositing"];//CISourceOutCompositing
            [composite setValue:dsreult forKey:@"inputImage"];
            [composite setValue:bgColorImg forKey:@"inputBackgroundImage"];
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


//多边形 输入一张纯白的mask图片，获得mask形状的边缘溶解的图形
/**
 minRadius 为 maxradius的百分比
 minRadius 0 - 1 实际取值 1- minRadius
 maxRadius为大于0的值
 */
+ (UIImage *)qs2_filterInnerRadius:(CGFloat)minRadius outerRadius:(CGFloat)maxRadius withMaskImg:(UIImage *)maskImg sourceImage:(UIImage *)sImg  backGroundColor:(UIColor *)bgColor{
    UIImage *nimg = nil;
    @autoreleasepool {
        CIImage *result = [CIImage imageWithCGImage:sImg.CGImage];
        CGRect dframe = result.extent;
        CGFloat dwidth = dframe.size.width;
        CGFloat dheight = dframe.size.height;
        CGFloat centerX = dwidth / 2.0;
        CGFloat centerY = dheight / 2.0;
        CGFloat maxShadowRadiu = sqrt(pow(centerX, 2) + pow(centerY, 2));
        
        CIImage *maskCIImg = [CIImage imageWithCGImage:maskImg.CGImage];
        CGFloat maskWidth = maskCIImg.extent.size.width;
        CGFloat maskHeight = maskCIImg.extent.size.height;
        CGFloat minWidthMask = maskWidth > maskHeight ? maskHeight : maskWidth;
        //外maskImg white
        CIFilter *filterMaskOutter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        [filterMaskOutter setValue:maskCIImg forKey:kCIInputImageKey];
        [filterMaskOutter setValue:@(maxRadius / minWidthMask) forKey:@"inputScale"];
        [filterMaskOutter setValue:@(1) forKey:@"inputAspectRatio"];
        CIImage *maskImgMax = [filterMaskOutter valueForKey:kCIOutputImageKey];
        CGFloat widthMaskImgOutter = maskImgMax.extent.size.width;
        CGFloat heightMaskImgOutter = maskImgMax.extent.size.height;
        
        NSLog(@"maskImgMax:%@",NSStringFromCGRect(maskImgMax.extent));
        
        if (dwidth - widthMaskImgOutter != 0 || dheight - heightMaskImgOutter != 0) {
            CGAffineTransform transitionOutter = CGAffineTransformMakeTranslation((dwidth - widthMaskImgOutter) / 2.0, (dheight - heightMaskImgOutter) / 2.0);
            CIFilter *filterAffTOutter = [CIFilter filterWithName:@"CIAffineTransform"];
            [filterAffTOutter setValue:maskImgMax forKey:@"inputImage"];
            [filterAffTOutter setValue:[NSValue valueWithCGAffineTransform:transitionOutter] forKey:@"inputTransform"];
            maskImgMax = [[filterAffTOutter valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        }
        
//        //生成ra
//        CIFilter *filterRSrcBg = [CIFilter filterWithName:@"CIRadialGradient"];
//        CIVector *civ = [[CIVector alloc] initWithCGPoint:CGPointMake(centerX, centerY)];
//        CGFloat maxr = maxShadowRadiu * 1.3;
//        [filterRSrcBg setValue:civ forKey:@"inputCenter"];
//        [filterRSrcBg setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor0"];//[UIColor clearColor]
//        [filterRSrcBg setValue:[CIColor colorWithCGColor:[UIColor blackColor].CGColor] forKey:@"inputColor1"];
//        [filterRSrcBg setValue:@(maxRadius) forKey:@"inputRadius1"];//model.realValue * @(maxr)
//        [filterRSrcBg setValue:@(maxRadius * 0.2) forKey:@"inputRadius0"];//model.realValue * @(0)
//        CIImage *imgRSrcBg = [[filterRSrcBg valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        
        //cbg
        CIFilter *filterConstantCc= [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantCc setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor"];
        CIImage *bgCcImg = [[filterConstantCc valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        CIFilter *filterConstantCb = [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantCb setValue:[CIColor colorWithCGColor:bgColor.CGColor] forKey:@"inputColor"];
        CIImage *bgColorImg = [[filterConstantCb valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        //外 destImage
        CIFilter *filterBlendWithDest = [CIFilter filterWithName:@"CIBlendWithMask"];
        [filterBlendWithDest setValue:result forKey:@"inputImage"];
        [filterBlendWithDest setValue:bgColorImg forKey:@"inputBackgroundImage"];
        //bgCcImg
        [filterBlendWithDest setValue:maskImgMax forKey:@"inputMaskImage"];
        CIImage *destImage = [[filterBlendWithDest valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        
        if (minRadius < maxRadius) {
            ///////外maskImg radialGradient
            CIFilter *filterRadialGradient = [CIFilter filterWithName:@"CIRadialGradient"];
            CIVector *civ = [[CIVector alloc] initWithCGPoint:CGPointMake(centerX, centerY)];
            CGFloat maxr = maxShadowRadiu * 1.3;
            [filterRadialGradient setValue:civ forKey:@"inputCenter"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor0"];
            [filterRadialGradient setValue:[CIColor colorWithCGColor:bgColor.CGColor] forKey:@"inputColor1"];
            [filterRadialGradient setValue:@(maxRadius) forKey:@"inputRadius1"];//model.realValue * @(maxr)
            [filterRadialGradient setValue:@(minRadius) forKey:@"inputRadius0"];//model.realValue * @(0)
            CIImage *dmaskImgORGw2c = [[filterRadialGradient valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
            
            //边缘均匀加深
            CGFloat radialRadius = (maxRadius - minRadius) * 0.7;
            CIFilter *filterHeightFieldMask = [CIFilter filterWithName:@"CIHeightFieldFromMask"];//
            [filterHeightFieldMask setValue:maskImgMax forKey:@"inputImage"];
            [filterHeightFieldMask setValue:@(radialRadius) forKey:@"inputRadius"];
            CIImage *dmaskImgHeight = [[filterHeightFieldMask valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            CIFilter *filterHeightFieldMask1 = [CIFilter filterWithName:@"CIHeightFieldFromMask"];//
            [filterHeightFieldMask1 setValue:maskImgMax forKey:@"inputImage"];
            [filterHeightFieldMask1 setValue:@(radialRadius) forKey:@"inputRadius"];
            dmaskImgHeight = [[filterHeightFieldMask1 valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            CIFilter *filterHeightFieldMask2 = [CIFilter filterWithName:@"CIHeightFieldFromMask"];//
            [filterHeightFieldMask2 setValue:maskImgMax forKey:@"inputImage"];
            [filterHeightFieldMask2 setValue:@(radialRadius) forKey:@"inputRadius"];
            dmaskImgHeight = [[filterHeightFieldMask2 valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            CIFilter *filterHeightFieldMask3 = [CIFilter filterWithName:@"CIHeightFieldFromMask"];//
            [filterHeightFieldMask3 setValue:maskImgMax forKey:@"inputImage"];
            [filterHeightFieldMask3 setValue:@(radialRadius) forKey:@"inputRadius"];
            dmaskImgHeight = [[filterHeightFieldMask3 valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
         
            //边缘均匀加深 添加透明度
            CIFilter *frg = [CIFilter filterWithName:@"CIMaskToAlpha"];
            [frg setValue:dmaskImgHeight forKey:@"inputImage"];
            CIImage *dImagergEdge = [[frg valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            //destimg 边缘深度
            CIFilter *filterBlendLast = [CIFilter filterWithName:@"CIBlendWithAlphaMask"];//CIMaskToAlpha
            [filterBlendLast setValue:destImage forKey:@"inputImage"];
            [filterBlendLast setValue:bgCcImg forKey:@"inputBackgroundImage"];
            [filterBlendLast setValue:dImagergEdge forKey:@"inputMaskImage"];
            CIImage *destimgImageRG = [[filterBlendLast valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
            
            //混合背景
            CIFilter *composite = [CIFilter filterWithName:@"CISourceOverCompositing"];//CISourceOutCompositing
            [composite setValue:destimgImageRG forKey:@"inputImage"];
            [composite setValue:bgColorImg forKey:@"inputBackgroundImage"];
            CIImage *dImgResult = [[composite valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];

            nimg = [UIImage imageWithCIImage:dImgResult];
        } else {
            nimg = [UIImage imageWithCIImage:destImage];
        }
        
    }

    return nimg;
}



+ (UIImage *)qs_radiusOuterRadius:(CGFloat)maxRadius withMaskImg:(UIImage *)maskImg sourceImage:(UIImage *)sImg  backGroundColor:(UIColor *)bgColor{
    
    
    UIImage *nimg = nil;
    @autoreleasepool {
        CIImage *result = [CIImage imageWithCGImage:sImg.CGImage];
        CGRect dframe = result.extent;
        CGFloat dwidth = dframe.size.width;
        CGFloat dheight = dframe.size.height;
        CGFloat centerX = dwidth / 2.0;
        CGFloat centerY = dheight / 2.0;
        CGFloat maxShadowRadiu = sqrt(pow(centerX, 2) + pow(centerY, 2));
        
        CIImage *maskCIImg = [CIImage imageWithCGImage:maskImg.CGImage];
        CGFloat maskWidth = maskCIImg.extent.size.width;
        CGFloat maskHeight = maskCIImg.extent.size.height;
        CGFloat minWidthMask = maskWidth > maskHeight ? maskHeight : maskWidth;
        
    //cbg
        CIFilter *filterConstantCc= [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantCc setValue:[CIColor colorWithCGColor:bgColor.CGColor] forKey:@"inputColor"];//[UIColor clearColor].CGColor
        CIImage *bgCcImg = [[filterConstantCc valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        CIFilter *filterRadialGradient = [CIFilter filterWithName:@"CIRadialGradient"];
        CIVector *civ = [[CIVector alloc] initWithCGPoint:CGPointMake(centerX, centerY)];
        CGFloat maxr = maxShadowRadiu * 1.3;
        [filterRadialGradient setValue:civ forKey:@"inputCenter"];
        [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor0"];//[UIColor clearColor]
        [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor blackColor].CGColor] forKey:@"inputColor1"];
        [filterRadialGradient setValue:@(maxRadius) forKey:@"inputRadius1"];//model.realValue * @(maxr)
        [filterRadialGradient setValue:@(maxRadius * 0.2) forKey:@"inputRadius0"];//model.realValue * @(0)
        CIImage *dmaskImgORGw2c = [[filterRadialGradient valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        
//        CIFilter *fbgRGLoop = [CIFilter filterWithName:@"CIBlendWithMask"];
//        [fbgRGLoop setValue:dmaskImgORGw2c forKey:@"inputImage"];
//        [fbgRGLoop setValue:bgCcImg forKey:@"inputBackgroundImage"];
//        [fbgRGLoop setValue:result forKey:@"inputMaskImage"];
        
        //混合背景
        CIFilter *composite = [CIFilter filterWithName:@"CISourceOverCompositing"];//CISourceOutCompositing
        [composite setValue:dmaskImgORGw2c forKey:@"inputImage"];
        [composite setValue:result forKey:@"inputBackgroundImage"];
        CIImage *dImgResult = [[composite valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        nimg = [UIImage imageWithCIImage:dImgResult];
    }
    
    return nimg;
}


//多边形 输入一张纯白的mask图片，获得mask形状的边缘溶解的图形
/**
 minRadius 为 maxradius的百分比
 minRadius 0.5 - 1 实际取值 1- minRadius
 maxRadius为0 - 1的值
 */
+ (UIImage *)qs3_filterInnerRadius:(CGFloat)minRadius outerRadius:(CGFloat)maxRadius withMaskImg:(UIImage *)maskImg sourceImage:(UIImage *)sImg  backGroundColor:(UIColor *)bgColor{
    UIImage *nimg = nil;
    @autoreleasepool {
        CIImage *result = [CIImage imageWithCGImage:sImg.CGImage];
        CGRect dframe = result.extent;
        CGFloat dwidth = dframe.size.width;
        CGFloat dheight = dframe.size.height;
        CGFloat centerX = dwidth / 2.0;
        CGFloat centerY = dheight / 2.0;
        CGFloat maxShadowRadiu = sqrt(pow(centerX, 2) + pow(centerY, 2));
        CGFloat maxr = maxShadowRadiu * 1.3;
        
        
        CIImage *maskCIImg = [CIImage imageWithCGImage:maskImg.CGImage];
        CGFloat maskWidth = maskCIImg.extent.size.width;
        CGFloat maskHeight = maskCIImg.extent.size.height;
        CGFloat minWidthMask = maskWidth > maskHeight ? maskHeight : maskWidth;
        //外maskImg white
        CIFilter *filterMaskOutter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        [filterMaskOutter setValue:maskCIImg forKey:kCIInputImageKey];
        [filterMaskOutter setValue:@(maxRadius / minWidthMask) forKey:@"inputScale"];
        [filterMaskOutter setValue:@(1) forKey:@"inputAspectRatio"];
        CIImage *maskImgMax = [filterMaskOutter valueForKey:kCIOutputImageKey];
        CGFloat widthMaskImgOutter = maskImgMax.extent.size.width;
        CGFloat heightMaskImgOutter = maskImgMax.extent.size.height;
        
        NSLog(@"maskImgMax:%@",NSStringFromCGRect(maskImgMax.extent));
        
        if (dwidth - widthMaskImgOutter != 0 || dheight - heightMaskImgOutter != 0) {
            CGAffineTransform transitionOutter = CGAffineTransformMakeTranslation((dwidth - widthMaskImgOutter) / 2.0, (dheight - heightMaskImgOutter) / 2.0);
            CIFilter *filterAffTOutter = [CIFilter filterWithName:@"CIAffineTransform"];
            [filterAffTOutter setValue:maskImgMax forKey:@"inputImage"];
            [filterAffTOutter setValue:[NSValue valueWithCGAffineTransform:transitionOutter] forKey:@"inputTransform"];
            maskImgMax = [[filterAffTOutter valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        }
        
        
        //cbg
        CIFilter *filterConstantCc= [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantCc setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor"];
        CIImage *bgCcImg = [[filterConstantCc valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        CIFilter *filterConstantCb = [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantCb setValue:[CIColor colorWithCGColor:bgColor.CGColor] forKey:@"inputColor"];
        CIImage *bgColorImg = [[filterConstantCb valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        //外 destImage
        CIFilter *filterBlendWithDest = [CIFilter filterWithName:@"CIBlendWithMask"];
        [filterBlendWithDest setValue:result forKey:@"inputImage"];
        [filterBlendWithDest setValue:bgColorImg forKey:@"inputBackgroundImage"];
        //bgCcImg
        [filterBlendWithDest setValue:maskImgMax forKey:@"inputMaskImage"];
        CIImage *destImage = [[filterBlendWithDest valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        
        //边缘均匀加深
        CGFloat radialRadius = (maxRadius - minRadius) * maxr * 0.7;
        CIFilter *filterHeightFieldMask = [CIFilter filterWithName:@"CIHeightFieldFromMask"];//
        [filterHeightFieldMask setValue:maskImgMax forKey:@"inputImage"];
        [filterHeightFieldMask setValue:@(radialRadius) forKey:@"inputRadius"];
        CIImage *dmaskImgHeight = [[filterHeightFieldMask valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
//            CGFloat radialRadius = (maxRadius - minRadius) * 1.2;
//            CIFilter *filterHeightFieldMask2 = [CIFilter filterWithName:@"CIHeightFieldFromMask"];//
//            [filterHeightFieldMask2 setValue:maskImgMax forKey:@"inputImage"];
//            [filterHeightFieldMask2 setValue:@(radialRadius) forKey:@"inputRadius"];
//            dmaskImgHeight = [[filterHeightFieldMask2 valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
//
        //边缘均匀加深 添加透明度
        CIFilter *frg = [CIFilter filterWithName:@"CIMaskToAlpha"];
        [frg setValue:dmaskImgHeight forKey:@"inputImage"];
        CIImage *dImagergEdge = [[frg valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        //destimg 边缘深度
        CIFilter *filterBlendLast = [CIFilter filterWithName:@"CIBlendWithAlphaMask"];//CIMaskToAlpha
        [filterBlendLast setValue:destImage forKey:@"inputImage"];
        [filterBlendLast setValue:bgCcImg forKey:@"inputBackgroundImage"];
        [filterBlendLast setValue:dImagergEdge forKey:@"inputMaskImage"];
        CIImage *destimgImageRG = [[filterBlendLast valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        //混合背景
        CIFilter *composite = [CIFilter filterWithName:@"CISourceOverCompositing"];//CISourceOutCompositing
        [composite setValue:destimgImageRG forKey:@"inputImage"];
        [composite setValue:bgColorImg forKey:@"inputBackgroundImage"];
        CIImage *dImgResult = [[composite valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];

        nimg = [UIImage imageWithCIImage:dImgResult];
        
    }

    return nimg;
}


+ (UIImage *)qs4_filterSportInnerRadius:(CGFloat)minRadius outerRadius:(CGFloat)maxRadius srcImg:(UIImage*)src{
    UIImage *nimg = nil;
    @autoreleasepool {
        
        CIImage *result = [CIImage imageWithCGImage:src.CGImage];
        CGRect dframe = result.extent;
        CGFloat dwidth = dframe.size.width;
        CGFloat dheight = dframe.size.height;
        CGFloat centerX = dwidth / 2.0;
        CGFloat centerY = dheight / 2.0;
        CGFloat maxShadowRadiu = sqrt(pow(centerX, 2) + pow(centerY, 2));
        CGFloat maxr = maxShadowRadiu * 1.3;
        
        CIVector *center = [[CIVector alloc] initWithX:centerX Y:centerY Z:maxRadius];//
        CIVector *centerZzero = [[CIVector alloc] initWithX:centerX Y:centerY Z:0];
        CIColor *lightC = [CIColor colorWithCGColor:[UIColor greenColor].CGColor];
        CIFilter *frg = [CIFilter filterWithName:@"CISpotLight"];
        [frg setValue:result forKey:@"inputImage"];
        [frg setValue:center forKey:@"inputLightPosition"];
        [frg setValue:centerZzero forKey:@"inputLightPointsAt"];
        [frg setValue:@(3.0) forKey:@"inputBrightness"];
        [frg setValue:@(1) forKey:@"inputConcentration"];
        [frg setValue:lightC forKey:@"inputColor"];
        CIImage *dImgResult = [[frg valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];

        nimg = [UIImage imageWithCIImage:dImgResult];
    }
    return  nimg;
}


+ (UIImage *)qs5_filterSportInnerRadius:(CGFloat)minRadius outerRadius:(CGFloat)maxRadius srcImg:(UIImage*)src {
    UIImage *nimg = nil;
    @autoreleasepool {
        CIImage *result = [CIImage imageWithCGImage:src.CGImage];
        
        CGRect dframe = result.extent;
        CGFloat dwidth = dframe.size.width;
        CGFloat dheight = dframe.size.height;
        CGFloat centerX = dwidth / 2.0;
        CGFloat centerY = dheight / 2.0;
        CGFloat maxShadowRadiu = sqrt(pow(centerX, 2) + pow(centerY, 2));
        CGFloat maxr = maxShadowRadiu * 1.3;
        
        CIFilter *hf = [CIFilter filterWithName:@"CISpotColor"];
        [hf setDefaults];
        [hf setValue:result forKey:@"inputImage"];
        [hf setValue:[CIColor colorWithRed:1.0 green:0.0 blue:0.0] forKey: @"inputCenterColor1"];
        [hf setValue:[CIColor colorWithRed:1.0 green:0.0 blue:0.0] forKey: @"inputReplacementColor1"];
        [hf setValue:[NSNumber numberWithFloat:0.1] forKey: @"inputCloseness1"];
        [hf setValue:[NSNumber numberWithFloat:1.0] forKey: @"inputContrast1"];

        CIImage *dImgResult = [[hf valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];

        nimg = [UIImage imageWithCIImage:dImgResult];
    }

    return nimg;
}



+ (UIImage *)qs6_filterInnerRadius:(CGFloat)minRadius outerRadius:(CGFloat)maxRadius sourceImage:(UIImage *)sImg  backGroundColor:(UIColor *)bgColor{
    UIImage *nimg = nil;
    @autoreleasepool {
        CIImage *result = [CIImage imageWithCGImage:sImg.CGImage];
        CGRect dframe = result.extent;
        CGFloat dwidth = dframe.size.width;
        CGFloat dheight = dframe.size.height;
        CGFloat centerX = dwidth / 2.0;
        CGFloat centerY = dheight / 2.0;
        CGFloat maxShadowRadiu = sqrt(pow(centerX, 2) + pow(centerY, 2));
        
        CGFloat minWidth = dwidth > dheight ? dheight : dwidth;
        
       
        CIFilter *filterRadialGradient = [CIFilter filterWithName:@"CIRadialGradient"];
        CIVector *civ = [[CIVector alloc] initWithCGPoint:CGPointMake(centerX, centerY)];
        CGFloat maxr = maxShadowRadiu * 1.3;
        [filterRadialGradient setValue:civ forKey:@"inputCenter"];
        [filterRadialGradient setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor0"];
        [filterRadialGradient setValue:[CIColor colorWithCGColor:bgColor.CGColor] forKey:@"inputColor1"];
        [filterRadialGradient setValue:@(maxRadius) forKey:@"inputRadius1"];//model.realValue * @(maxr)
        [filterRadialGradient setValue:@(minRadius) forKey:@"inputRadius0"];//model.realValue * @(0)
        CIImage *dmaskImgORGw2c = [[filterRadialGradient valueForKey:kCIOutputImageKey] imageByCroppingToRect:CGRectMake(0, 0, minWidth, minWidth)];
        
        CIVector *topLeft = [[CIVector alloc] initWithX:0 Y:0];
        CIVector *topRight = [[CIVector alloc] initWithX:dwidth Y:0];
        CIVector *bottomLeft = [[CIVector alloc] initWithX:0 Y:dheight * 1.5];
        CIVector *bottomRight = [[CIVector alloc] initWithX:dwidth Y:dheight * 1.5];
        
        //外maskImg white
        CIFilter *filterMaskOutter = [CIFilter filterWithName:@"CIPerspectiveTransform"];
        [filterMaskOutter setValue:dmaskImgORGw2c forKey:kCIInputImageKey];
        [filterMaskOutter setValue:topLeft forKey:@"inputTopLeft"];
        [filterMaskOutter setValue:topRight forKey:@"inputTopRight"];
        [filterMaskOutter setValue:bottomLeft forKey:@"inputBottomLeft"];
        [filterMaskOutter setValue:bottomRight forKey:@"inputBottomRight"];
        CIImage *maskImgMax = [filterMaskOutter valueForKey:kCIOutputImageKey];
        
        
        //混合背景
        CIFilter *composite = [CIFilter filterWithName:@"CISourceOverCompositing"];//CISourceOutCompositing
        [composite setValue:maskImgMax forKey:@"inputImage"];
        [composite setValue:result forKey:@"inputBackgroundImage"];
        CIImage *dImgResult = [[composite valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];

        nimg = [UIImage imageWithCIImage:dImgResult];
        
    }

    return nimg;
}


@end
