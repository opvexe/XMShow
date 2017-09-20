//
//  PresentView.m
//  presentAnimation
//
//  Created by 许博 on 16/7/14.
//  Copyright © 2016年 许博. All rights reserved.
//

#import "PresentView.h"
#import "UIImageView+WebCache.h"

@interface PresentView ()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) void(^completeBlock)(BOOL finished,NSInteger finishCount); // 新增了回调参数 finishCount， 用来记录动画结束时累加数量，将来在3秒内，还能继续累加
@end

@implementation PresentView

// 根据礼物个数播放动画
- (void)animateWithCompleteBlock:(completeBlock)completed{

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self shakeNumberLabel];
    }];
    self.completeBlock = completed;
}

- (void)shakeNumberLabel{
    _animCount ++;
//    NSLog(@"shakeNumberLabel");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePresendView) object:nil];//可以取消成功。
    [self performSelector:@selector(hidePresendView) withObject:nil afterDelay:2];
    
    self.skLabel.text = [NSString stringWithFormat:@"X %ld",_animCount];
    [self.skLabel startAnimWithDuration:0.3];
}

- (void)hidePresendView
{
    [UIView animateWithDuration:0.30 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y - 20, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.completeBlock) {
            self.completeBlock(finished,_animCount);
        }
        [self reset];
        _finished = finished;
        [self removeFromSuperview];
    }];
}

// 重置
- (void)reset {
    
    self.frame = _originFrame;
    self.alpha = 1;
    self.animCount = 0;
    self.skLabel.text = @"";
}

- (instancetype)init {
    if (self = [super init]) {
        _originFrame = self.frame;
        [self setUI];
    }
    return self;
}

#pragma mark 布局 UI
- (void)layoutSubviews {
    
    [super layoutSubviews];
    _headImageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    _headImageView.backgroundColor = [UIColor whiteColor];
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height / 2;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _nameLabel.frame = CGRectMake(_headImageView.frame.size.width + 5, 5, _headImageView.frame.size.width * 3, 10);
    _giftLabel.frame = CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_headImageView.frame) - 10 - 5, _nameLabel.frame.size.width, 10);
    
    _bgImageView.frame = self.bounds;
    _bgImageView.layer.cornerRadius = self.frame.size.height / 2;
    _bgImageView.layer.masksToBounds = YES;
    
    _giftImageView.frame = CGRectMake(CGRectGetMaxX(self.frame) + 5, self.frame.size.height - 45, 50, 50);
    _giftImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _skLabel.frame = CGRectMake(CGRectGetMaxX(_giftImageView.frame),0, 120, 40);
    
}

#pragma mark 初始化 UI
- (void)setUI {
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor orangeColor];
    
    _headImageView = [[UIImageView alloc] init];
    _giftImageView = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    _giftLabel = [[UILabel alloc] init];
    _nameLabel.textColor  = [UIColor whiteColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:13];
    _giftLabel.textColor  = [UIColor yellowColor];
    _giftLabel.font = [UIFont boldSystemFontOfSize:13];
    
    // 初始化动画label
    _skLabel =  [[ShakeLabel alloc] init];
    _skLabel.font = [UIFont boldSystemFontOfSize:40];
    _skLabel.borderColor = [UIColor yellowColor];
    _skLabel.textColor = [UIColor orangeColor];
    _skLabel.textAlignment = NSTextAlignmentCenter;
    _animCount = 0;
    
    [self addSubview:_bgImageView];
    [self addSubview:_headImageView];
    [self addSubview:_giftImageView];
    [self addSubview:_nameLabel];
    [self addSubview:_giftLabel];
    [self addSubview:_skLabel];
    
}

- (void)setModel:(GiftModel *)model {
    _model = model;
    _headImageView.image = model.headImage;
    [_giftImageView sd_setImageWithURL:[NSURL URLWithString:model.giftImage]];
    _nameLabel.text = model.name;
    _giftLabel.text = [NSString stringWithFormat:@"赠送 %ld个%@",model.giftCount,model.giftName];
    _giftCount = model.giftCount;
}


@end
