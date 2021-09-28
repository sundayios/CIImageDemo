//
//  ViewController.m
//  CIImageDemo
//
//  Created by admin on 2021/9/28.
//

#import "ViewController.h"
#import "QSFilterHelper.h"

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
        _maskImg = [UIImage imageNamed:@"bailiang.png"];
    }
    return _maskImg;
}

- (UIImageView *)imgV {
    if (!_imgV) {
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 200, 300)];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
        //UIViewContentModeCenter;
        //UIViewContentModeScaleAspectFit
    }
    return _imgV;
}
- (UIImageView *)imgV1 {
    if (!_imgV1) {
        _imgV1 = [[UIImageView alloc] init];
        _imgV1.contentMode = UIViewContentModeCenter;//UIViewContentModeScaleAspectFit;
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

- (UISlider *)sliderInnerRadius{
    if (!_sliderInnerRadius) {
        _sliderInnerRadius = [[UISlider alloc] initWithFrame:CGRectMake(20, 700, self.view.frame.size.width - 40, 30)];
        _sliderInnerRadius.thumbTintColor = [UIColor greenColor];
        _sliderInnerRadius.minimumValue = 0;
        _sliderInnerRadius.maximumValue = 200;
        _sliderInnerRadius.value = 200;
    }
    return _sliderInnerRadius;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imgV];
    [self.view addSubview:self.imgV1];
    
    CGFloat widthImgv = self.view.frame.size.width / 2.0;
    self.imgV.frame = CGRectMake(0, 30, widthImgv, 700);
    self.imgV1.frame = CGRectMake(widthImgv, 30, widthImgv, 700);
    self.imgV.image = [UIImage imageNamed:@"bailiang.png"];
    
    [self.sliderInnerRadius addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.sliderInnerRadius];
    
    self.btn.frame = CGRectMake(100, 750, 200, 50);
    [self.btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    
    UIImage *sImg = [UIImage imageNamed:@"bailiang.png"];
    self.imgV1.image = sImg;
    
    
}

- (void)sliderChange:(UISlider *)sender {
    UIImage *nimg = [QSFilterHelper qs_filterInnerRadius:0.8 * sender.value outerRadius:sender.value withMaskImg:self.maskImg sourceImage:self.img backGroundColor:[UIColor blackColor]];
    self.imgV1.image = nimg;
}


- (void)buttonAction:(UIButton *)sender{
    UIImage *sImg = [UIImage imageNamed:@"bailiang.png"];
    UIImage *nimg = [QSFilterHelper qs_SourceImg:sImg];
    //[QSFilterHelper qs_SourceOuter:self.img maskImg:sImg];
    self.imgV1.image = nimg;
}
@end
