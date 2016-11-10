//
//  FWRAlbumController.m
//  WeChatCameraDemo
//
//  Created by 冯伟如 on 15/8/28.
//  Copyright (c) 2015年 冯伟如. All rights reserved.
//

#import "FWRAlbumController.h"
#import "ShowPhotoCell.h"
#import "AssetHelper.h"
#import "FWRAlbumConfigure.h"
#import "FWRPhotoBrowserViewController.h"

#define CELLLENGTH (MAINSCREEN.size.width-25)/4
#define kCELLReuseId (@"collectionCellId")


@interface FWRAlbumController ()<UICollectionViewDataSource,UICollectionViewDelegate,ShowPhotoCellDelegate>
{
    ALAssetsGroup *_group;
}
//UICollectionView用来显示图片
@property (nonatomic, strong) UICollectionView *collectionView;
//显示当前选择照片数量
@property (nonatomic, strong) UILabel *showNumLabel;
//确定按钮
@property (nonatomic, strong) UIButton *confButton;
//照片数组
@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) ALAssetsGroup *currentAlbum;
//已选择的照片数组
@property (nonatomic, strong) NSMutableArray *selectPhotos;
//转成已选图数组
@property (nonatomic, strong) NSMutableArray *selectImagesArray;

@end

@implementation FWRAlbumController{
    NSMutableArray *_selectPhotoNames;
}

- (void)dealloc
{

}

- (instancetype)initWithPhoto:(ALAssetsGroup *)group
{
    if (self = [super init]) {
        
        _group = group;
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.selectPhotos.count == 0) {
        self.showNumLabel.text = @"请选择照片";
    }else {
        self.showNumLabel.text = [NSString stringWithFormat:@"已经选择%lu张照片",self.selectPhotos.count];
    }
    if (self.collectionView) {
        [self.collectionView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"相机胶卷";
    
    [self loadPhoto];
    
    [self createBarButtonItem];
    
    [self createCollectionView];
    
    
}

#pragma mark - 读取照片
- (void)loadPhoto {
    self.selectPhotos = [[NSMutableArray alloc] init];
    _selectPhotoNames = [[NSMutableArray alloc] init];
    
    if (_group) {
        [self showPhoto:_group];
        return;
    }
    
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
    
    WeakSelf;
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        
        if ([group numberOfAssets] > 0) {
            [weakSelf showPhoto:group];
        }else{
            NSLog(@"读取相册完毕");
            [weakSelf.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    [[AssetHelper defaultAssetsLibrary] enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:nil];
}
//显示图片
- (void)showPhoto:(ALAssetsGroup *)album
{
    if (album != nil) {
//        if (self.currentAlbum == nil || [[self.currentAlbum valueForProperty:ALAssetsGroupPropertyName] isEqualToString:[album valueForProperty:ALAssetsGroupPropertyName]]) {
            self.currentAlbum = album;
            if (!self.photos) {
                self.photos = [[NSMutableArray alloc] init];
            }else {
                [self.photos removeAllObjects];
            }
//        }
        WeakSelf;
            ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [weakSelf.photos addObject:result];
                }else{
                    
                }
            };
            
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [self.currentAlbum setAssetsFilter:onlyPhotosFilter];
            [self.currentAlbum enumerateAssetsUsingBlock:assetsEnumerationBlock];
            self.title = [self.currentAlbum valueForProperty:ALAssetsGroupPropertyName];
            [self.collectionView reloadData];
    }
}

#pragma mark - 创建按钮
- (void)createBarButtonItem {
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(0, 4, 40, 40);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    UIButton *chooseAlbumButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [chooseAlbumButton setTitle:@"相册" forState:UIControlStateNormal];
    [chooseAlbumButton addTarget:self action:@selector(chooseAlbumClick) forControlEvents:UIControlEventTouchUpInside];
    chooseAlbumButton.frame = CGRectMake(0, 4, 40, 40);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:chooseAlbumButton];
    self.navigationItem.leftBarButtonItem = rightItem;
}

#pragma mark - 取消方法
- (void)cancelClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 选择相册方法
- (void)chooseAlbumClick {
    [self.navigationController popViewControllerAnimated:true];
    [self.selectPhotos removeAllObjects];
}

#pragma mark - 创建UICollectionView和Label、Button
- (void)createCollectionView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.itemSize = CGSizeMake(CELLLENGTH, CELLLENGTH);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, MAINSCREEN.size.width, MAINSCREEN.size.height-64-49) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[ShowPhotoCell class] forCellWithReuseIdentifier:kCELLReuseId];
    [self.view addSubview:self.collectionView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINSCREEN.size.height-49, MAINSCREEN.size.width, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    self.showNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, MAINSCREEN.size.height-49+1+10, 190, 28)];
    self.showNumLabel.text = @"请选择照片";
    [self.view addSubview:self.showNumLabel];
    
    self.confButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.confButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confButton addTarget:self action:@selector(confClick) forControlEvents:UIControlEventTouchUpInside];
    self.confButton.frame = CGRectMake(MAINSCREEN.size.width-10-50, MAINSCREEN.size.height-49+1+10, 50, 28);
    [self.view addSubview:self.confButton];
}
//确定选择照片
- (void)confClick {
    [self turnToImageWithALAssetArray:self.selectPhotos];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.delegate) {
        [self.delegate getPhotosWithArray:self.selectImagesArray];
    }
    
    NSLog(@"确定");
}

#pragma mark - UICollectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShowPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCELLReuseId forIndexPath:indexPath];
    
    cell.row = indexPath.row;
    
    ALAsset *asset = self.photos[indexPath.row];
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage *image = [UIImage imageWithCGImage:thumbnailImageRef];
    
    [cell configWithImage:image];
    cell.delegate = self;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FWRPhotoBrowserViewController *vc = [[FWRPhotoBrowserViewController alloc] initWithPhotoArray:[NSArray arrayWithArray:self.photos] atIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - ShowPhotoCell代理
- (void)modifiedPhotoWithRow:(NSInteger)row isSelected:(BOOL)isSelected
{
    if (isSelected) {
        ALAsset *asset = self.photos[row];
        [self.selectPhotos addObject:asset];
        [_selectPhotoNames addObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
    }else {
        ALAsset *asset = self.photos[row];
        for (ALAsset *a in self.selectPhotos) {
            NSString *strA = [a valueForProperty:ALAssetPropertyAssetURL];
            NSString *strAsset = [asset valueForProperty:ALAssetPropertyAssetURL];
            if ([strA isEqual:strAsset]) {
                [self.selectPhotos removeObject:a];
                break;
            }
        }
        
        [_selectPhotoNames removeObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
    }
    
    if (self.selectPhotos.count == 0) {
        self.showNumLabel.text = @"请选择照片";
    }else {
        self.showNumLabel.text = [NSString stringWithFormat:@"已经选择%lu张照片",self.selectPhotos.count];
    }
}

#pragma mark - ALAsset转成UIImage
- (void)turnToImageWithALAssetArray:(NSMutableArray *)assetsArray {
    if (self.selectImagesArray) {
        [self.selectImagesArray removeAllObjects];
    }else{
        self.selectImagesArray = [NSMutableArray array];
    }
    for (ALAsset *a in assetsArray) {
        CGImageRef thumbnailImageRef = [a thumbnail];
        UIImage *image = [UIImage imageWithCGImage:thumbnailImageRef];
        [self.selectImagesArray addObject:image];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
