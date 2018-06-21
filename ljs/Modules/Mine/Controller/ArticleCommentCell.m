//
//  ArticleCommentCell.m
//  ljs
//
//  Created by shaojianfei on 2018/5/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ArticleCommentCell.h"
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "UILabel+Extension.h"
#import "ArticleModel.h"
@interface ArticleCommentCell()
//缩略图
@property (nonatomic, strong) UIImageView *infoIV;
//标题
@property (nonatomic, strong) UILabel *titleLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//收藏数
@property (nonatomic, strong) UILabel *collectNumLbl;
@property (nonatomic, strong) UIButton *seeNumber;

@end
@implementation ArticleCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //缩略图
    self.infoIV = [[UIImageView alloc] init];
    
    self.infoIV.contentMode = UIViewContentModeScaleAspectFill;
    self.infoIV.clipsToBounds = YES;
    self.infoIV.layer.cornerRadius = 4;
    
    [self addSubview:self.infoIV];
    //标题
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor
                                                 font:15.0];
    self.titleLbl.numberOfLines = 0;
    
    [self addSubview:self.titleLbl];
    //时间
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:13.0];
    [self addSubview:self.timeLbl];
    self.seeNumber = [UIButton buttonWithTitle:@"0"
                                    titleColor:kTextColor2
                               backgroundColor:kClearColor
                                     titleFont:13.0];
    [self.seeNumber setImage:[UIImage imageNamed:@"已报名浏览"] forState:UIControlStateNormal];
    [self addSubview:self.seeNumber];
   
    //收藏数
    self.collectNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor2
                                                      font:13.0];
    
    self.collectNumLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.collectNumLbl];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    CGFloat x = 15;
    
    //缩略图
    [self.infoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-x));
        make.top.equalTo(@10);
        make.width.equalTo(@110);
        make.height.equalTo(@100);
    }];
    //标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.infoIV.mas_top);
        make.left.equalTo(@(x));
        make.right.equalTo(self.infoIV.mas_left).offset(-10);
        make.height.lessThanOrEqualTo(@60);
    }];
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(x));
        make.bottom.equalTo(self.infoIV.mas_bottom).offset(0);
    }];
    [self.seeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.infoIV.mas_left).offset(-20);
        make.top.equalTo(self.timeLbl.mas_top).offset(0);
        make.height.equalTo(@20);
    }];
    //收藏数
//    [self.collectNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.infoIV.mas_left).offset(0);
//        make.centerY.equalTo(self.timeLbl.mas_centerY);
//    }];
}

#pragma mark - Setting
- (void)setInfoModel:(ArticleCommentModel *)infoModel {
    
    _infoModel = infoModel;
    
    [self.titleLbl labelWithTextString:infoModel.title lineSpace:5];
    [self.infoIV sd_setImageWithURL:[NSURL URLWithString:[infoModel.advPic convertImageUrl]] placeholderImage:kImage(PLACEHOLDER_SMALL)];
    NSString *str = [infoModel.updateDatetime convertDate];

    self.timeLbl.text = str ;
    [self.seeNumber setTitle:infoModel.readCount forState:UIControlStateNormal];

    
//    self.collectNumLbl.text = [NSString stringWithFormat:@"%@", infoModel.readCount];
}


@end
