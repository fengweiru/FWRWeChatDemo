//
//  FWRPhotoGroupViewController.m
//  WeChatCameraDemo
//
//  Created by 冯伟如 on 15/8/28.
//  Copyright (c) 2015年 冯伟如. All rights reserved.
//

#import "FWRPhotoGroupViewController.h"
#import "ShowAlbumCell.h"
#import "FWRAlbumController.h"
#import "FWRAlbumConfigure.h"

#define REUSECELLID @"cellId"

@interface FWRPhotoGroupViewController ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *albums;
@end

@implementation FWRPhotoGroupViewController

- (void)dealloc
{
    
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
        self.navigationItem.rightBarButtonItem = cancelItem;
        self.title = @"选择相册";
    }
    return self;
}

#pragma mark - 取消返回照片选择界面
- (void)cancelClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.albums == nil) {
        _albums = [[NSMutableArray alloc] init];
    }else {
        [self.albums removeAllObjects];
    }
    
    [self.tableView registerClass:[ShowAlbumCell class] forCellReuseIdentifier:REUSECELLID];
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has declined access to it.";
                break;
                
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
    };
    
    WeakSelf;
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        ALAssetsFilter *onlyPhoyosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhoyosFilter];
        if ([group numberOfAssets] > 0) {
            [weakSelf.albums addObject:group];
        }else {
            [weakSelf.tableView reloadData];
        }
    };
    
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [[AssetHelper defaultAssetsLibrary] enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = REUSECELLID;
    ShowAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    ALAssetsGroup *group = [_albums objectAtIndex:indexPath.row];
    [cell configWithALAssetsGroup:group];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    ALAssetsGroup *group = [_albums objectAtIndex:indexPath.row];
//    if (self.delegate) {
//        [self.delegate selectAlbum:group];
//    }
    FWRAlbumController *vc = [[FWRAlbumController alloc] initWithPhoto:group];
    vc.delegate = self.delegatevc;
    [self.navigationController pushViewController:vc animated:true];
}

@end
