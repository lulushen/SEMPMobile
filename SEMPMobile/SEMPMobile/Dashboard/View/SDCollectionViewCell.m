//
//  SDCollectionViewCell.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/15.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDCollectionViewCell.h"

@implementation SDCollectionViewCell

- (instancetype)init
{
//    self = [super initWithCoder:coder];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor blueColor];
        _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        NSLog(@"$$$4ewrewrwrw====%f",self.frame.size.width);
        NSLog(@"===%f",_imageView.frame.size.width);

        //用来设置图片的显示方式，如居中、居右，是否缩放等
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        // 自动调整view的高度，以保证左边距和右边距不变,上边距和下边距不变
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        _imageView.alpha = .7f;
    }else {
        _imageView.alpha = 1.f;
    }
}

@end
