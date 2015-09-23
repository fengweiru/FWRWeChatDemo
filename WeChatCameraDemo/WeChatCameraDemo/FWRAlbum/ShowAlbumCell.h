//
//  ShowAlbumCell.h
//  WeChatCameraDemo
//
//  Created by 冯伟如 on 15/8/28.
//  Copyright (c) 2015年 冯伟如. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetHelper.h"

@interface ShowAlbumCell : UITableViewCell

//显示最后一张照片
@property (nonatomic, strong)UIImageView *posterImageView;
//相册名
@property (nonatomic, strong)UILabel *albumNameLabel;
//相册中照片数量
@property (nonatomic, strong)UILabel *albumCountLabel;

- (void)configWithALAssetsGroup:(ALAssetsGroup *)group;

@end
