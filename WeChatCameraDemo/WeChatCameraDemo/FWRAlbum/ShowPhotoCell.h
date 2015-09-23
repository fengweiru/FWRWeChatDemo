//
//  ShowPhotoCell.h
//  WeChatCameraDemo
//
//  Created by 冯伟如 on 15/8/28.
//  Copyright (c) 2015年 冯伟如. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowPhotoCell;
@protocol ShowPhotoCellDelegate <NSObject>

- (void)modifiedPhotoWithRow:(NSInteger)row isSelected:(BOOL)isSelected;

@end

@interface ShowPhotoCell : UICollectionViewCell
//选择按钮
@property (nonatomic, strong) UIButton *selectButton;
//照片的位置
@property (nonatomic, assign) NSInteger row;
//代理
@property (nonatomic, retain) id<ShowPhotoCellDelegate> delegate;

- (void)configWithImage:(UIImage *)image;

@end
