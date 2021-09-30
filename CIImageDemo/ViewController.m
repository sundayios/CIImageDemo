//
//  ViewController.m
//  CIImageDemo
//
//  Created by admin on 2021/9/28.
//

#import "ViewController.h"
#import "QSFilterHelper.h"
#import "UIImage+SQExtension.h"

@interface ViewController ()

@property (nonatomic, strong) UIImage *maskImg;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIImageView *imgV1;

@property (nonatomic, strong) UISlider *sliderInnerRadius;
@property (nonatomic, strong) UISlider *sliderOuterRadius;


@end

@implementation ViewController

- (UIImage *)img {
    if (!_img) {
        _img = [UIImage imageNamed:@"meinv.jpg"];
    }
    return _img;
}

- (UIImage *)maskImg {
    if (!_maskImg) {
        _maskImg = [UIImage sq_ImageWithColor:[UIColor whiteColor] withPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 300, 500)]];
        //[UIImage imageNamed:@"bailiang.png"];
    }
    return _maskImg;
}

- (UIImageView *)imgV {
    if (!_imgV) {
        _imgV = [[UIImageView alloc] init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
        //UIViewContentModeCenter;
        //UIViewContentModeScaleAspectFit
    }
    return _imgV;
}
- (UIImageView *)imgV1 {
    if (!_imgV1) {
        _imgV1 = [[UIImageView alloc] init];
        _imgV1.contentMode = UIViewContentModeScaleAspectFit;
        //UIViewContentModeCenter;
    }
    return _imgV1;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn setTitle:@"button" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _btn;
}


- (UISlider *)sliderOuterRadius{
    if (!_sliderOuterRadius) {
        _sliderOuterRadius = [[UISlider alloc] initWithFrame:CGRectMake(20, 650, self.view.frame.size.width - 40, 30)];
        _sliderOuterRadius.thumbTintColor = [UIColor greenColor];
        _sliderOuterRadius.minimumValue = 0;
        _sliderOuterRadius.maximumValue = 3000;
        _sliderOuterRadius.value = 2000;
    }
    return _sliderOuterRadius;
}
- (UISlider *)sliderInnerRadius{
    if (!_sliderInnerRadius) {
        _sliderInnerRadius = [[UISlider alloc] initWithFrame:CGRectMake(20, 690, self.view.frame.size.width - 40, 30)];
        _sliderInnerRadius.thumbTintColor = [UIColor greenColor];
        _sliderInnerRadius.minimumValue = 0;
        _sliderInnerRadius.maximumValue = 3000;
        _sliderInnerRadius.value = 2000;
    }
    return _sliderInnerRadius;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat widthImgv = self.view.frame.size.width / 2.0;
    self.imgV.frame = CGRectMake(0, 30, widthImgv, 700);
    self.imgV1.frame = CGRectMake(widthImgv, 30, widthImgv, 700);
    
    [self.view addSubview:self.imgV];
    [self.view addSubview:self.imgV1];
    
    self.imgV.image = [UIImage imageNamed:@"bailiang.png"];
    [self.sliderOuterRadius addTarget:self action:@selector(sliderOutChange:) forControlEvents:UIControlEventValueChanged];
    [self.sliderInnerRadius addTarget:self action:@selector(sliderInChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.sliderOuterRadius];
    [self.view addSubview:self.sliderInnerRadius];
    
    self.btn.frame = CGRectMake(100, 750, 200, 50);
    [self.btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    

//    UIImage *sImg = [UIImage imageNamed:@"bailiang.png"];
    self.imgV1.image = self.img;
    
    
}
- (void)sliderOutChange:(UISlider *)sender {
    NSLog(@"%.f",sender.value);
    UIImage *nimg = [QSFilterHelper qs_filterInnerRadius:self.sliderInnerRadius.value outerRadius:sender.value withMaskImg:self.maskImg sourceImage:self.img backGroundColor:[UIColor blackColor]];
    [self img1SetNewImge:nimg];
}
- (void)sliderInChange:(UISlider *)sender {
    NSLog(@"%.f",sender.value);
    UIImage *nimg = [QSFilterHelper qs_filterInnerRadius:sender.value outerRadius:self.sliderOuterRadius.value withMaskImg:self.maskImg sourceImage:self.img backGroundColor:[UIColor blackColor]];
    [self img1SetNewImge:nimg];
    
}
- (void)img1SetNewImge:(UIImage *)img {
//    self.imgV1.image = [UIImage new];
//    self.imgV1.image = nil;
    self.imgV1.image = img;
    [self.view setNeedsLayout];
}
//- (void)getLayerImage {
//    CIFilter *filterConstantColor = [CIFilter filterWithName:@"CIConstantColorGenerator"];
//    [filterConstantColor setValue:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor] forKey:@"inputColor"];
//    CIImage *bgImgClearOuter = [[filterConstantColor valueForKey:kCIOutputImageKey] imageByCroppingToRect:CGRectMake(0, 0, 500, 500)];
//
//    CALayer *dlayer = [CALayer layer];
//    dlayer.backgroundColor = [UIColor blackColor].CGColor;
//    dlayer.masksToBounds = YES;
//    dlayer.frame = CGRectMake(0, 0, 800, 900);
//    dlayer.contents =  bgImgClearOuter;
//    [dlayer setNeedsLayout];
//    dlayer.delegate = self;
//    //(__bridge id)
//
//
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    [path addArcWithCenter:CGPointMake(300, 300) radius:100 startAngle:0 endAngle:2 * M_PI clockwise:YES];
//    CAShapeLayer *slayer = [CAShapeLayer layer];
//    slayer.frame = CGRectMake(0, 0, 500, 700);
//    slayer.path = path.CGPath;
//
//    dlayer.mask = slayer;
//
////    filte
////    __bridge CGImageRef _Nonnull
//    UIImage *nimg = [UIImage imageWithCIImage:dlayer.contents];
//    NSLog(@"dd------:%@",NSStringFromCGSize(nimg.size));
//    self.imgV1.image = nimg;
//}

//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
//  // 绘图
//  CGContextSaveGState(ctx);
//    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
////    CGContextFillPath(<#CGContextRef  _Nullable c#>)
////    CGContextDrawImage(ctx, CGRectMake(0.0, 0.0, 150.0, 150.0), image.CGImage);
//    CGContextRestoreGState(ctx);
//}


- (void)buttonAction:(UIButton *)sender{
    [self heightAction];
    
}
//- (void)customBezierPath {
//    UIImage *img;
////    UIImage *img = [UIImage sq_ImageWithColor:[UIColor blackColor] withPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 300, 500)]];
////    img = [
//    //[UIImage imageMaskWithContentSize:CGSizeMake(80, 100) maskWidth:30 colors:@[[UIColor blackColor],[UIColor whiteColor]] cornerRadius:40 fillContent:YES];
//
//    self.imgV1.image = img;
//}

- (void)heightAction{
    
    UIImage *nimg;
    @autoreleasepool {
        
        //边缘均匀加深
        CIImage *maskImgMax = [CIImage imageWithCGImage:self.maskImg.CGImage];
        CGRect dframe = maskImgMax.extent;
        CIFilter *filterHeightFieldMask = [CIFilter filterWithName:@"CIHeightFieldFromMask"];//
        [filterHeightFieldMask setValue:maskImgMax forKey:@"inputImage"];
        [filterHeightFieldMask setValue:@(20) forKey:@"inputRadius"];
        CIImage *dmaskImgHeight = [[filterHeightFieldMask valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
       
        
        
        //destimg 边缘深度
        CIFilter *frg = [CIFilter filterWithName:@"CIMaskToAlpha"];//CIMaskToAlpha
        [frg setValue:dmaskImgHeight forKey:@"inputImage"];
        
        
        
        CIImage *dImageRG = [[frg valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        //cbg
        CIFilter *filterConstantCc= [CIFilter filterWithName:@"CIConstantColorGenerator"];
        [filterConstantCc setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor"];
        CIImage *bgCcImg = [[filterConstantCc valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        //destimg 边缘深度
        CIFilter *filterBlendLast = [CIFilter filterWithName:@"CIBlendWithAlphaMask"];//CIMaskToAlpha
        [filterBlendLast setValue:maskImgMax forKey:@"inputImage"];
        [filterBlendLast setValue:bgCcImg forKey:@"inputBackgroundImage"];
        [filterBlendLast setValue:dImageRG forKey:@"inputMaskImage"];
        
        CIImage *dImg = [[filterBlendLast valueForKey:kCIOutputImageKey] imageByCroppingToRect:dframe];
        
        
        nimg = [UIImage imageWithCIImage:dImg];
    }
    self.imgV1.backgroundColor = [UIColor blackColor];
    self.imgV1.image = nimg;
    
}
@end
