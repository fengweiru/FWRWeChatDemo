//
//  ShowPhotoCell.m
//  WeChatCameraDemo
//
//  Created by 冯伟如 on 15/8/28.
//  Copyright (c) 2015年 冯伟如. All rights reserved.
//

#import "ShowPhotoCell.h"

#define CELLLENGTH (MAINSCREEN.size.width-25)/4

@implementation ShowPhotoCell
{
    UIImageView *_photoImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELLLENGTH, CELLLENGTH)];
        [self.contentView addSubview:_photoImageView];
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _selectButton.frame = CGRectMake(CELLLENGTH/4*3, 0, CELLLENGTH/4, CELLLENGTH/4);
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"unChoose"] forState:UIControlStateNormal];
        _selectButton.tintColor = [UIColor clearColor];
        [_selectButton addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectButton];
    }
    return self;
}

- (void)configWithImage:(UIImage *)image
{
    _photoImageView.image = image;
    _selectButton.selected = NO;
}

#pragma mark - 按钮方法
- (void)selectClick {
    if (_selectButton.selected == NO) {
        _selectButton.selected = YES;
    }else {
        _selectButton.selected = NO;
    }
    if (self.delegate != nil) {
        [self.delegate modifiedPhotoWithRow:self.row isSelected:_selectButton.selected];
    }
}

@end
