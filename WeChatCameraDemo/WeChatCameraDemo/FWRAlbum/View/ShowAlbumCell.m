//
//  ShowAlbumCell.m
//  WeChatCameraDemo
//
//  Created by 冯伟如 on 15/8/28.
//  Copyright (c) 2015年 冯伟如. All rights reserved.
//

#import "ShowAlbumCell.h"

@implementation ShowAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self.contentView addSubview:self.posterImageView];
        
        self.albumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 120, 30)];
        [self.contentView addSubview:self.albumNameLabel];
        
        self.albumCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 15, 80, 30)];
        [self.contentView addSubview:self.albumCountLabel];
        
    }
    return self;
}

- (void)configWithALAssetsGroup:(ALAssetsGroup *)group {
    CGImageRef posterImageRef = [group posterImage];
    UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
    self.posterImageView.image = posterImage;
    self.albumNameLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    self.albumCountLabel.text = [NSString stringWithFormat:@"(%d)",[@(group.numberOfAssets) intValue]];

}

@end
