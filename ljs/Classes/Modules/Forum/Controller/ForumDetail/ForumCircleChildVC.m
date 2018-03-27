//
//  ForumCircleChildVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumCircleChildVC.h"
//Macro
//Framework
//Category
//Extension
//M
#import "ForumCommentModel.h"
//V
#import "ForumCircleTableView.h"
//C
#import "ForumCircleCommentVC.h"

@interface ForumCircleChildVC ()<RefreshDelegate>
//圈子
@property (nonatomic, strong) ForumCircleTableView *tableView;
//commentList
@property (nonatomic, strong) NSArray <ForumCommentModel *>*comments;

//回复编号
@property (nonatomic, copy) NSString *replyCode;

@end

@implementation ForumCircleChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"RefreshForumDetail" object:nil];

}

- (void)refresh:(NSNotification *)notification {
 
    //获取最新圈子
    [self requestCircleList];
}

#pragma mark - Setting
- (void)setVcCanScroll:(BOOL)vcCanScroll {
    
    _vcCanScroll = vcCanScroll;
    
    self.tableView.vcCanScroll = vcCanScroll;
    
    self.tableView.contentOffset = CGPointZero;
}

#pragma mark - Init
/**
 评论列表
 */
- (void)initTableView {
    
    self.tableView = [[ForumCircleTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40 - kBottomInsetHeight) style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无帖子"];

    self.tableView.tag = 1800 + self.index;
    self.tableView.detailModel = _detailModel;
    self.tableView.refreshDelegate = self;

    [self.view addSubview:self.tableView];
    
}

#pragma mark - Setting
- (void)setDetailModel:(ForumDetailModel *)detailModel {
    
    _detailModel = detailModel;
    
    //圈子
    [self initTableView];
    //获取最新圈子
    [self requestCircleList];
    //添加通知
    [self addNotification];
}

#pragma mark - Data

- (void)requestCircleList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628662";
    helper.parameters[@"plateCode"] = self.detailModel.code;
    
    if (![TLUser user].isLogin) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[ForumCommentModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.comments = objs;
        weakSelf.tableView.newestComments = objs;
        [weakSelf.tableView reloadData_tl];
        
        weakSelf.refreshSuccess();
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.comments = objs;
            
            weakSelf.tableView.newestComments = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)clickZan:(ForumCommentModel *)commentModel {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628201";
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
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ForumCommentModel *commentModel = indexPath.section == 0 ? self.detailModel.hotPostList[indexPath.row]: self.comments[indexPath.row];
    
    ForumCircleCommentVC *detailVC = [ForumCircleCommentVC new];
    
    detailVC.code = commentModel.code;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    BaseWeakSelf;
    
    [self checkLogin:^{
        
        NSInteger section = index/1000;
        NSInteger row = index - section*1000;
        
        ForumCommentModel *commentModel = section == 0 ? weakSelf.detailModel.hotPostList[row]: weakSelf.comments[row];
        
        [weakSelf clickZan:commentModel];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
