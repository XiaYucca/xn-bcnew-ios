//
//  NewsFlashDetailVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "NewsFlashDetailVC.h"
//Manager
#import "TLWXManager.h"
#import "QQManager.h"
//Macro
#import "APICodeMacro.h"
//Framework
//Category
#import "UIScrollView+SnapShot.h"
//Extension
//M
//V
#import "NewsFlashShareView.h"
#import "NewsFlashDetailView.h"
//C

@interface NewsFlashDetailVC ()
//分享
@property (nonatomic, strong) NewsFlashShareView *shareView;
//内容
@property (nonatomic, strong) NewsFlashDetailView *detailView;

@end

@implementation NewsFlashDetailVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"快讯分享";
    //内容
    [self initDetailView];
    //底部按钮
    [self initShareView];
    //获取AppUrl
    [self requestAppUrl];
}

#pragma mark - Init
- (void)initDetailView {
    
    self.detailView = [[NewsFlashDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 50 - kBottomInsetHeight)];
    
    self.detailView.flashModel = self.flashModel;
    self.detailView.url = @"https://www.baidu.com";
    
    [self.view addSubview:self.detailView];
}

- (void)initShareView {
    
    BaseWeakSelf;
    
    CGFloat height = 50;
    
    self.shareView = [[NewsFlashShareView alloc] initWithFrame:CGRectMake(0, self.detailView.yy, kScreenWidth, height)];
    
    self.shareView.shareBlock = ^(NewsFlashShareType type) {
        
        [weakSelf shareEventsWithType:type];
    };
    
    [self.view addSubview:self.shareView];
}

#pragma mark - 分享
- (void)shareEventsWithType:(NewsFlashShareType)type {
    
    UIImage *shareImage = [self.detailView snapshotViewWithCapInsets:UIEdgeInsetsZero];
    
    
    switch (type) {
        case NewsFlashShareTypeWeChat:
        {
            [TLWXManager wxShareImageWithScene:WXSceneSession
                                         title:nil
                                          desc:nil
                                         image:shareImage];
            [TLWXManager manager].wxShare = ^(BOOL isSuccess, int errorCode) {
                
                if (isSuccess) {
                    
                    [TLAlert alertWithSucces:@"分享成功"];
                } else {
                    
                    [TLAlert alertWithError:@"分享失败"];
                }
            };
            
        }break;
            
        case NewsFlashShareTypeTimeLine:
        {
            [TLWXManager wxShareImageWithScene:WXSceneTimeline
                                         title:nil
                                          desc:nil
                                         image:shareImage];
            [TLWXManager manager].wxShare = ^(BOOL isSuccess, int errorCode) {
                
                if (isSuccess) {
                    
                    [TLAlert alertWithSucces:@"分享成功"];
                } else {
                    
                    [TLAlert alertWithError:@"分享失败"];
                }
            };
            
        }break;
            
        case NewsFlashShareTypeQQ:
        {
            [QQManager manager].qqShare = ^(BOOL isSuccess, int errorCode) {
                
                if (isSuccess) {
                    
                    [TLAlert alertWithSucces:@"分享成功"];
                } else {
                    
                    [TLAlert alertWithSucces:@"分享失败"];
                }
            };
            
            [QQManager qqShareImageWithScene:0
                                       title:nil
                                        desc:nil
                                       image:shareImage];
            
        }break;
            
        case NewsFlashShareTypeWeiBo:
        {
            
        }break;
            
        default:
            break;
    }
}

#pragma mark - Data
- (void)requestAppUrl {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_CKEY_CVALUE;
    http.parameters[@"ckey"] = @"h5DownUrl";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.detailView.url = responseObject[@"data"][@"cvalue"];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
