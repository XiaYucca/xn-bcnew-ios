//
//  CurrencyKLineHScreenVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyKLineHScreenVC.h"
//Manager
#import "AppConfig.h"
//Category
#import "UILabel+Extension.h"
//V
#import "DetailWebView.h"


@interface CurrencyKLineHScreenVC ()
//k线横屏
@property (nonatomic, strong) DetailWebView *kLineView;

@end

@implementation CurrencyKLineHScreenVC
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self rightAction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBlackColor;
    //
    [self initSubviews];
}

#pragma mark - Init
- (DetailWebView *)kLineView {
    
    if (!_kLineView) {
        
        BaseWeakSelf;
        
        CGFloat w = kScreenHeight;
        CGFloat h = kScreenWidth;
        
        _kLineView = [[DetailWebView alloc] initWithFrame:CGRectMake(0,0, w, h)];
//        _kLineView.center = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
        
//        _kLineView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.view addSubview:_kLineView];
    }
    return _kLineView;
}

- (void)initSubviews {
    
    //返回
    CGFloat rightMargin = -kBottomInsetHeight - kHeight(20);
    CGFloat topMargin = 10;
    
    UIButton *backBtn = [UIButton buttonWithImageName:@""];
    
    [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.kLineView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(topMargin));
        make.right.equalTo(@(rightMargin));
        make.width.equalTo(@(kHeight(40)));
        make.height.equalTo(@(kHeight(40)));
    }];
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    
    //k线图
    //交易对
    NSString *symbol = [NSString stringWithFormat:@"%@/%@", platform.symbol, platform.toSymbol];
    NSString *html = [NSString stringWithFormat:@"%@/index.html?symbol=%@&exchange=%@&isfull=1",@"http://47.52.236.63:2303", symbol, platform.exchangeEname];
    
    [self.kLineView loadRequestWithString:html];
    //
//    [self rightAction];
}

#pragma mark - Events
- (void)clickBack {
    
    [self leftAction];

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)prefersHomeIndicatorAutoHidden{
    
    return YES;
}

#pragma mark - 横屏
- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)leftAction
{
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)rightAction
{
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:orientation];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
