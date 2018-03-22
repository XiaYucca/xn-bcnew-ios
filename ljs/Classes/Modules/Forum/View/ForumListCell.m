//
//  ForumListCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumListCell.h"

@interface ForumListCell()
//吧名
//关注量
//发帖量
//更贴数
//关注

//吧名
@property (nonatomic, strong) UILabel *postBarNameLbl;
//关注量
@property (nonatomic, strong) UILabel *followNumLbl;
//发帖量
@property (nonatomic, strong) UILabel *postNumLbl;
//更贴数
@property (nonatomic, strong) UILabel *updatePostNumLbl;
//关注
@property (nonatomic, strong) UIButton *followBtn;

@end

@implementation ForumListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //吧名
    self.postBarNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:17.0];
    [self addSubview:self.postBarNameLbl];
    //关注量
    self.followNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor2
                                                     font:15.0];
    [self addSubview:self.followNumLbl];
    //发帖量
    self.postNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor2
                                                   font:15.0];
    [self addSubview:self.postNumLbl];
    //更贴数
    self.updatePostNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor2
                                                   font:15.0];
    [self addSubview:self.updatePostNumLbl];
    //关注
    self.followBtn = [UIButton buttonWithTitle:@"关注"
                                    titleColor:kWhiteColor
                               backgroundColor:kAppCustomMainColor
                                     titleFont:15.0
                                  cornerRadius:4];
    self.followBtn.layer.borderWidth = 1;
    self.followBtn.layer.borderColor = kAppCustomMainColor.CGColor;
    
    [self addSubview:self.followBtn];
    //布局
    [self setSubviewsLayout];
}

- (void)setSubviewsLayout {
    
    //吧名
    [self.postBarNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@13);
    }];
    //关注量
    [self.followNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.postBarNameLbl.mas_left);
        make.top.equalTo(self.postBarNameLbl.mas_bottom).offset(13);
    }];
    //发帖量
    [self.postNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self.followNumLbl.mas_centerY);
        make.left.equalTo(@(kScreenWidth/3.0));
    }];
    //更贴数
    [self.updatePostNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self.followNumLbl.mas_centerY);
        make.left.equalTo(@(2*kScreenWidth/3.0));
    }];
    //关注
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self.postBarNameLbl.mas_centerY);
        make.right.equalTo(@(-15));
        make.width.equalTo(@60);
        make.height.equalTo(@35);
    }];
}

#pragma mark - Setting
- (void)setForumModel:(ForumModel *)forumModel {
    
    _forumModel = forumModel;
    
    self.postBarNameLbl.text = [NSString stringWithFormat:@"#%@吧#", forumModel.name];
    self.followNumLbl.text = [NSString stringWithFormat:@"关注量:%@", forumModel.followNum];
    self.postNumLbl.text = [NSString stringWithFormat:@"发帖量:%@", forumModel.postNum];
    self.updatePostNumLbl.text = [NSString stringWithFormat:@"今日更贴:%@", forumModel.updateNum];
    if (forumModel.isFollow) {
        
        [self.followBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.followBtn setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    } else {
        
        [self.followBtn setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];
        [self.followBtn setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
    }
}

@end
