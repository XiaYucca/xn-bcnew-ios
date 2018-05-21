//
//  HomePageInfoTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomePageInfoTableView.h"
//V
#import "HomePageInfoCell.h"
#import "ArticleCommentCell.h"

@interface HomePageInfoTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HomePageInfoTableView

static NSString *homePageInfoCell = @"HomePageInfoCell";
static NSString *articleCommentCell = @"ArticleCommentCell";


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[HomePageInfoCell class] forCellReuseIdentifier:homePageInfoCell];
        
         [self registerClass:[ArticleCommentCell class] forCellReuseIdentifier:articleCommentCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.IsArticle == YES) {
        return self.infos.count;

    }
    return self.pageModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.IsArticle == YES) {
        ArticleCommentModel *info = self.infos[indexPath.row];
        
        
        ArticleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:articleCommentCell forIndexPath:indexPath];
        //shuju
        cell.infoModel = info;
        cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;

        return cell;
    }
    HomePageInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:homePageInfoCell forIndexPath:indexPath];
    
    cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;
    cell.commentModel = self.pageModels[indexPath.row];
    
    cell.articleView.tag = 2000 + indexPath.row;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookArticle:)];
    [cell.articleView addGestureRecognizer:tapGR];
    
    return cell;
}

- (void)lookArticle:(UITapGestureRecognizer *)tapGR {
    
    NSInteger index = tapGR.view.tag - 2000;
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self button:nil selectRowAtIndex:index];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.IsArticle == YES) {
        return 130;
        
    }
    return self.pageModels[indexPath.row].cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
