//
//  TableViewController.h
//  WeChatCameraDemo
//
//  Created by 冯伟如 on 15/8/28.
//  Copyright (c) 2015年 冯伟如. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetHelper.h"

@protocol SelectAlbumDelegate<NSObject>

- (void)selectAlbum:(ALAssetsGroup *)album;

@end

@interface TableViewController : UITableViewController
@property(nonatomic, assign) id<SelectAlbumDelegate> delegate;

@end