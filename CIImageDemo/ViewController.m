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

- (UIImageView *)imgV {
    if (!_imgV) {
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 400, 500)];
        _imgV.contentMode = UIViewContentModeCenter;//UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}

- (UISlider *)sliderInnerRadius{
    if (!_sliderInnerRadius) {
        _sliderInnerRadius = [[UISlider alloc] initWithFrame:CGRectMake(20, 700, self.view.frame.size.width - 40, 30)];
        _sliderInnerRadius.thumbTintColor = [UIColor greenColor];
        _sliderInnerRadius.minimumValue = 0;
        _sliderInnerRadius.maximumValue = 2;
    }
    return _sliderInnerRadius;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imgV];
    
    [self.sliderInnerRadius addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.sliderInnerRadius];
    
    
}

- (void)sliderChange:(UISlider *)sender {
    UIImage *nimg = [QSFilterHelper qs_filterScale:sender.value withImg:self.img];
    NSLog(@"%@",NSStringFromCGSize(nimg.size));
    
    self.imgV.image = nimg;
}

@end
