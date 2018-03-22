//
//  SearchHistoryChildVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SearchHistoryChildVC.h"
//V
#import "SearchHistoryTableView.h"

@interface SearchHistoryChildVC ()
//
@property (nonatomic, strong) SearchHistoryTableView *tableView;

@end

@implementation SearchHistoryChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self addNotification];
    //
    [self initTableView];
    //获取历史搜索
    [self getHistoryRecords];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[SearchHistoryTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];

    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"没有查找到历史搜索" topMargin:100];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickSearch:) name:@"UserClickSearch" object:nil];
}

- (void)clickSearch:(NSNotification *)notification {
    
    NSString *searchStr = notification.object;
    
    NSArray *myarray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"HistorySearch"];
    
    NSMutableArray *historyArr = [myarray mutableCopy];
    
    [historyArr addObject:searchStr];
    
    if (historyArr==nil) {
        
        historyArr = [[NSMutableArray alloc]init];
        
    }else if ([historyArr containsObject:searchStr]) {
        
        [historyArr removeObject:searchStr];
    }
    [historyArr insertObject:searchStr atIndex:0];
    
    NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
    
    [mydefaults setObject:historyArr forKey:@"HistorySearch"];
    
    [mydefaults synchronize];
    //刷新数据
    [self getHistoryRecords];
}

#pragma mark - Data
- (void)getHistoryRecords {
    
    NSArray *myarray = [[NSUserDefaults standardUserDefaults]arrayForKey:@"HistorySearch"];

    NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];

    if (myarray == nil) {
        
        NSArray *historyArr = @[];
        
        [mydefaults setObject:historyArr forKey:@"HistorySearch"];
    }
    
    if (myarray.count == 0) {
        
        self.tableView.tableFooterView =         self.tableView.placeHolderView;
    } else {
        
        [self.tableView.placeHolderView removeFromSuperview];
        self.tableView.historyRecords = myarray;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end