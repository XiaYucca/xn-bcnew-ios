//
//  ForumCircleCommentVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumCircleCommentVC.h"
//Extension
#import <IQKeyboardManager.h>
//V
#import "BaseView.h"
#import "InputTextView.h"
#import "InfoCommentDetailTableView.h"
#import "TLPlaceholderView.h"

#define kBottomHeight 50

@interface ForumCircleCommentVC ()<InputTextViewDelegate, RefreshDelegate>

//评论
@property (nonatomic, strong) InfoCommentDetailTableView *tableView;
//底部
@property (nonatomic, strong) BaseView *bottomView;
//输入框
@property (nonatomic, strong) InputTextView *inputTV;
//commentList
@property (nonatomic, strong) InfoCommentModel *commentModel;
//
@property (nonatomic, strong) TLPlaceholderView *footerView;
//回复编号
@property (nonatomic, copy) NSString *replyCode;
//判断是评论还是回复
@property (nonatomic, assign) BOOL isComment;

@end

@implementation ForumCircleCommentVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //隐藏第三方键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //显示第三方键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论详情";
    //评论
    [self initCommentTableView];
    //获取评论列表
    [self requestCommentList];
    //底部
    [self initBottomView];
}

#pragma mark - Init
- (InputTextView *)inputTV {
    
    if (!_inputTV) {
        
        _inputTV = [[InputTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _inputTV.delegate = self;
        
    }
    return _inputTV;
}

/**
 评论列表
 */
- (void)initCommentTableView {
    
    self.tableView = [[InfoCommentDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
        make.bottom.equalTo(@(-kBottomHeight-kBottomInsetHeight));
    }];
    
    self.footerView = [TLPlaceholderView placeholderViewWithImage:@"沙发" text:@"来, 坐下谈谈"];
    
    self.footerView.backgroundColor = kHexColor(@"FAFCFF");
}

- (void)initBottomView {
    
    self.bottomView = [[BaseView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - kBottomHeight - kBottomInsetHeight, kScreenWidth, kBottomHeight)];
    
    self.bottomView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.bottomView];
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self.bottomView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    //点击评论
    UIButton *commentBtn = [UIButton buttonWithTitle:@"说出你的看法"
                                          titleColor:kHexColor(@"#9E9E9E")
                                     backgroundColor:kHexColor(@"E5E5E5")
                                           titleFont:12.0
                                        cornerRadius:17.5];
    
    [commentBtn addTarget:self action:@selector(clickComment) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.height.equalTo(@35);
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-15));
    }];
    
}

#pragma mark - Events
/**
 去占沙发
 */
- (void)clickComment {
    
    self.replyCode = self.code;
    
    self.isComment = YES;
    
    self.tableView.scrollEnabled = NO;
    
    self.inputTV.commentTV.placholder = @"说出你的看法";
    
    [self.inputTV show];
}

#pragma mark - Data

- (void)requestCommentList {
    
    NSString *code = @"628663";
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = code;
    http.showView = self.view;
    http.parameters[@"code"] = self.code;
    if ([TLUser user].userId) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        self.commentModel = [InfoCommentModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.tableView.commentModel = self.commentModel;
        
        [self.tableView reloadData];
        //判断是否有二次评论，没有就展示沙发
        if (self.commentModel.commentList.count == 0) {
            
            self.tableView.tableFooterView = self.footerView;
            
        } else {
            
            self.tableView.tableFooterView = nil;
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - InputTextViewDelegate
- (void)clickedSureBtnWithText:(NSString *)text {
    
    NSString *code = @"628652";
    
    NSString *type = self.isComment ? @"1": @"2";
    NSString *objectCode = self.isComment ? self.code: self.replyCode;
    
    //type(1 资讯 2 评论)
    TLNetworking *http = [TLNetworking new];
    
    http.code = code;
    http.parameters[@"type"] = type;
    http.parameters[@"objectCode"] = objectCode;
    http.parameters[@"content"] = text;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        //评论完成，清空内容
        self.inputTV.commentTV.text = @"";
        
        NSString *code = responseObject[@"data"][@"code"];
        
        if ([code containsString:@"approve"]) {
            
            [TLAlert alertWithInfo:[NSString stringWithFormat:@"发布成功, 您的评论包含敏感字符,我们将进行审核"]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            return ;
        }
        
        [TLAlert alertWithSucces:[NSString stringWithFormat:@"%@成功", @"发布"]];
        
        self.tableView.scrollEnabled = YES;
        //刷新数据
        [self requestCommentList];
        //刷新圈子的评论列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCommentList" object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)clickedCancelBtn {
    
    self.tableView.scrollEnabled = YES;
}

- (void)zanCommentWithComment:(InfoCommentModel *)commentModel {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628653";
    http.showView = self.view;
    http.parameters[@"type"] = @"1";
    http.parameters[@"objectCode"] = commentModel.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *promptStr = [commentModel.isPoint isEqualToString:@"1"] ? @"取消点赞成功": @"点赞成功";
        [TLAlert alertWithSucces:promptStr];
        
        if ([commentModel.isPoint isEqualToString:@"1"]) {
            
            commentModel.isPoint = @"0";
            commentModel.pointCount -= 1;
            
        } else {
            
            commentModel.isPoint = @"1";
            commentModel.pointCount += 1;
        }
        
        [self.tableView reloadData];
        //刷新圈子的评论列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCommentList" object:nil];
        //刷新跟帖量
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPostNum" object:nil];

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshDelegate

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    BaseWeakSelf;
    [self checkLogin:^{
        //刷新点赞状态
        [weakSelf requestCommentList];
        
    } event:^{
        
        InfoCommentModel *commentModel = weakSelf.commentModel;
        
        [weakSelf zanCommentWithComment:commentModel];
    }];
}

/**
 点击回复
 */
- (void)refreshTableViewEventClick:(TLTableView *)refreshTableview selectRowAtIndex:(NSInteger)index {
    
    BaseWeakSelf;
    [self checkLogin:^{
        
        [weakSelf commentWithIndex:index];
    }];
}

- (void)commentWithIndex:(NSInteger)index {
    
    InfoCommentModel *commentModel = self.commentModel.commentList[index];
    
    self.replyCode = commentModel.code;
    self.isComment = NO;
    self.tableView.scrollEnabled = NO;
    
    self.inputTV.commentTV.placholder = [NSString stringWithFormat:@"对%@进行回复", commentModel.nickname];
    [self.inputTV show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
