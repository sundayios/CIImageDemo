//
//  main.m
//  CIImageDemo
//
//  Created by admin on 2021/9/28.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}





/**
 @autoreleasepool {
     CIImage *result = [CIImage imageWithCGImage:self.imagePicture.CGImage];
     CGFloat centerX = CGRectGetWidth(result.extent) / 2.0;
     CGFloat centerY =CGRectGetHeight(result.extent) / 2.0;
     CGFloat maxRadiu = sqrt(pow(centerX, 2) + pow(centerY, 2));
     
     for (NSNumber *tag in modelsDict) {
         
         if (tag.integerValue == EDABtnTag_CIExposureAdjust) {//调整曝光
             CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust"];
             [filter setValue:result forKey:kCIInputImageKey];
             [filter setValue:@(slider.value) forKey:@"inputEV"];
             result = [filter valueForKey:kCIOutputImageKey];

         } else if (tag.integerValue == EDABtnTag_Brightness) {//亮度
             CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
             [filter setValue:result forKey:kCIInputImageKey];
             [filter setValue:@(slider.value) forKey:@"inputBrightness"];
             result = [filter valueForKey:kCIOutputImageKey];
         } else if (tag.integerValue == EDABtnTag_Contrast) {//对比度
             CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
             [filter setValue:result forKey:kCIInputImageKey];
             [filter setValue:@(slider.value) forKey:@"inputContrast"];
             result = [filter valueForKey:kCIOutputImageKey];

         } else if (tag.integerValue == EDABtnTag_Saturation) {//饱和度
             CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
             [filter setValue:result forKey:kCIInputImageKey];
             [filter setValue:@(slider.value) forKey:@"inputSaturation"];
             result = [filter valueForKey:kCIOutputImageKey];
         } else if (tag.integerValue == EDABtnTag_Highlights) {//高光
             CIFilter *filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
             [filter setValue:result forKey:kCIInputImageKey];
             [filter setValue:@(slider.value) forKey:@"inputHighlightAmount"];
             result = [filter valueForKey:kCIOutputImageKey];
         } else if (tag.integerValue == EDABtnTag_Shadow) {//阴影
             CIFilter *filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
             [filter setValue:result forKey:kCIInputImageKey];
             [filter setValue:@(slider.value) forKey:@"inputShadowAmount"];
             result = [filter valueForKey:kCIOutputImageKey];
         }
         else if (tag.integerValue == EDABtnTag_CISepiaTone) {//色调
             CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
             [filter setValue:result forKey:kCIInputImageKey];
             [filter setValue:@(slider.value) forKey:@"inputIntensity"];
             result = [filter valueForKey:kCIOutputImageKey];
         }
         else if (tag.integerValue == EDABtnTag_Temperature) {//色温
             CIFilter *filter = [CIFilter filterWithName:@"CITemperatureAndTint"];
             [filter setValue:result forKey:kCIInputImageKey];
             [filter setValue:[CIVector vectorWithX:slider.value Y:0] forKey:@"inputNeutral"];
             [filter setValue:[CIVector vectorWithX:model.defaultValue Y:0] forKey:@"inputTargetNeutral"];
             result = [filter valueForKey:kCIOutputImageKey];
         } else if (tag.integerValue == EDABtnTag_Grain) {//颗粒
             CIFilter *filter3 = [CIFilter filterWithName:@"CIRandomGenerator"];
            CIImage *filter3Img = [[filter3 valueForKey:kCIOutputImageKey] imageByCroppingToRect:result.extent];
             
             CIFilter *filter4 = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
             [filter4 setValue:filter3Img forKey:kCIInputImageKey];
             CIImage *filter4Img = [[filter4 valueForKey:kCIOutputImageKey] imageByCroppingToRect:result.extent];
             
             CIFilter *filteralpha = [CIFilter filterWithName:@"CIColorMatrix"];
             [filteralpha setValue:filter4Img forKey:kCIInputImageKey];//croppedImage
             [filteralpha setValue:[[CIVector alloc] initWithX:0 Y:0 Z:0 W:slider.value] forKey:@"inputAVector"];
            CIImage *croppedImage2 = [[filteralpha valueForKey:kCIOutputImageKey] imageByCroppingToRect:result.extent];

            CIFilter *composite = [CIFilter filterWithName:@"CIHardLightBlendMode"];   //CIHardLightBlendMode  CILightenBlendMode
            [composite setValue:result forKey:kCIInputImageKey];
            [composite setValue:croppedImage2 forKey:kCIInputBackgroundImageKey];
             result = [composite valueForKey:kCIOutputImageKey];
         }else if (tag.integerValue == EDABtnTag_Sharpening) {//锐化
             CIFilter *filter = [CIFilter filterWithName:@"CISharpenLuminance"];
             [filter setValue:result forKey:kCIInputImageKey];
             [filter setValue:@(slider.value) forKey:@"inputSharpness"];
             result = [filter valueForKey:kCIOutputImageKey];
         } else if (tag.integerValue == EDABtnTag_DarkAngle) {//暗角

             CIFilter *filter = [CIFilter filterWithName:@"CIRadialGradient"];
             CIVector *civ = [[CIVector alloc] initWithCGPoint:CGPointMake(centerX, centerY)];
             CGFloat maxr = maxRadiu * 1.3;
             [filter setValue:civ forKey:@"inputCenter"];
             [filter setValue:[CIColor colorWithCGColor:UIColor.clearColor.CGColor] forKey:@"inputColor0"];
             [filter setValue:[CIColor colorWithCGColor:UIColor.blackColor.CGColor] forKey:@"inputColor1"];
             [filter setValue:@(slider.value * maxr) forKey:@"inputRadius1"];
             [filter setValue:@(slider.value * 0.8 * maxr) forKey:@"inputRadius0"];
             CIImage *croppedImage = [[filter valueForKey:kCIOutputImageKey] imageByCroppingToRect:result.extent];

             CIFilter *composite = [CIFilter filterWithName:@"CISourceOverCompositing"];//CISourceOutCompositing
            [composite setValue:croppedImage forKey:@"inputImage"];
            [composite setValue:result forKey:@"inputBackgroundImage"];
             //kCIInputBackgroundImageKey

             result = [composite valueForKey:kCIOutputImageKey];
         } else if (tag.integerValue == EDABtnTag_WhiteColorOrder){
             if (slider.value < 0) {
                 CIFilter *filter1 = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
                 [filter1 setValue:result forKey:kCIInputImageKey];
                 [filter1 setValue:@(fabs(slider.value)) forKey:@"inputShadowAmount"];
                 result = [filter1 valueForKey:kCIOutputImageKey];
             }
             CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
             [filter setValue:result forKey:kCIInputImageKey];
             if (slider.value > 0) {
                 [filter setValue:@(1 + fabs(slider.value) * 0.25) forKey:@"inputSaturation"];
             }else{
                 [filter setValue:@(slider.value * 0.6) forKey:@"inputBrightness"];
                 [filter setValue:@(1 - fabs(slider.value) * 0.4) forKey:@"inputSaturation"];
             }
             result = [filter valueForKey:kCIOutputImageKey];
             if (slider.value < 0) {
                 CIFilter *filter1 = [CIFilter filterWithName:@"CIColorMonochrome"];
                 [filter1 setValue:result forKey:kCIInputImageKey];
                 [filter1 setValue:[CIColor colorWithCGColor:[UIColor blackColor].CGColor] forKey:@"inputColor"];
                 [filter1 setValue:@(model.maxValue - slider.value) forKey:@"inputIntensity"];
                 result = [filter1 valueForKey:kCIOutputImageKey];
             }
            
         }else if (tag.integerValue == EDABtnTag_BlackColorOrder){

             if (slider.value < 0) {
                 CIFilter *filter1 = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
                 [filter1 setValue:result forKey:kCIInputImageKey];
                 [filter1 setValue:@(fabs(slider.value * 1.2)) forKey:@"inputShadowAmount"];
                 result = [filter1 valueForKey:kCIOutputImageKey];
             }


             CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
             [filter setValue:result forKey:kCIInputImageKey];
             if (slider.value > 0) {
                 [filter setValue:@(1 + fabs(slider.value) * 0.25) forKey:@"inputSaturation"];
             }else{
                 [filter setValue:@(slider.value * 0.8) forKey:@"inputBrightness"];
                 [filter setValue:@(1 - fabs(slider.value) * 0.5) forKey:@"inputSaturation"];
             }
             result = [filter valueForKey:kCIOutputImageKey];

             if (slider.value < 0) {
                 CIFilter *filter1 = [CIFilter filterWithName:@"CIColorMonochrome"];
                 [filter1 setValue:result forKey:kCIInputImageKey];
                 [filter1 setValue:[CIColor colorWithCGColor:[UIColor blackColor].CGColor] forKey:@"inputColor"];
                 [filter1 setValue:@((model.maxValue - slider.value) * 1.2) forKey:@"inputIntensity"];
                 result = [filter1 valueForKey:kCIOutputImageKey];
             }
             
         }else if(tag.integerValue == EDABtnTag_CIHueAdjust){
             CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
             [filter setValue:result forKey:kCIInputImageKey];
             [filter setValue:@(slider.value) forKey:@"inputSaturation"];
             result = [filter valueForKey:kCIOutputImageKey];
         }
     }
     CIImage* cropped = [result imageByCroppingToRect:CGRectMake(0, 0, self.imagePicture.size.width, self.imagePicture.size.height)];
     return [[UIImage alloc] initWithCIImage:cropped];
 }
 **/
