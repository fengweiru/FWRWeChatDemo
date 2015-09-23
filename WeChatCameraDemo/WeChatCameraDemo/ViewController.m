//
//  ViewController.m
//  WeChatCameraDemo
//
//  Created by 冯伟如 on 15/8/27.
//  Copyright (c) 2015年 冯伟如. All rights reserved.
//

#import "ViewController.h"
#import "FWRMenuController.h"
#import "FWRAlbumController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()<FWRMenuControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,FWRAlbumControllerDelegate,UIAlertViewDelegate>
//相机选择界面视图
@property (nonatomic, strong)FWRMenuController *cameraMenu;
//相机
@property (nonatomic, strong)UIImagePickerController *imagePicker;
//选择类型
@property (nonatomic, assign)NSInteger chooseType;
//播放器，用于录制完视屏后播放视频
@property (nonatomic, strong)MPMoviePlayerViewController *player;
//照片展示视图
@property (nonatomic, strong)UIImageView *imageView;
//视频存储地址
@property (nonatomic, strong)NSURL *url;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 375, 500)];
    [self.view addSubview:_imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage imageNamed:@"camera_icon.jpg"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 4, 40, 40);
    [button addTarget:self action:@selector(cameraShow) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)cameraShow
{
    NSArray *namesArrays = @[@"视频",@"拍照",@"从手机相册选择"];
    self.cameraMenu = [[FWRMenuController alloc] initWithNameArrays:namesArrays];
    self.cameraMenu.delegate = self;
    [self.cameraMenu showInView:self.navigationController.view];
}

#pragma mark - FWRMenuController代理
- (void)buttonMenuViewController:(FWRMenuController *)buttonMenu buttonTappedAtIndex:(NSUInteger)index
{
    _chooseType = index + 1;
    if (_chooseType != 3) {
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }else{
        FWRAlbumController *albumCtrl = [[FWRAlbumController alloc] init];
        albumCtrl.delegate = self;
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:albumCtrl];
        [self presentViewController:navCtrl animated:YES completion:nil];
    }
    
}
#pragma mark - UIImagePickerController对象懒加载
- (UIImagePickerController *)imagePicker{
//    if (_chooseType != 3) {
        _imagePicker = [[UIImagePickerController alloc] init];
        //设置为摄像头
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置使用后置摄像头
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        if (_chooseType == 1) {
            _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
            //设置拍摄质量
            _imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
            //设置摄像头模式(拍照、录制视频)
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            //限制拍摄时间
            _imagePicker.videoMaximumDuration = 40;
        }else{
            _imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
            //设置摄像头模式(拍照、录制视频)
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        }
        _imagePicker.cameraViewTransform = CGAffineTransformMakeScale(1, 1);
//    }else{
//        _imagePicker = [[UIImagePickerController alloc] init];
//        //设置从手机相册选择
//        _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    }
    
    _imagePicker.delegate = self;
    
    return _imagePicker;
}

#pragma mark - UIImagePickerController代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *urlStr = [url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *image;
        if (self.imagePicker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        self.imageView.image = image;
//保存图片
//        if (_chooseType == 2) {
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//录像显示
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        self.url = [NSURL fileURLWithPath:videoPath];
        UIAlertView *videoAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您拍摄了一段录像，是否要播放" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"播放", nil];
        [videoAlert show];
    }
}
#pragma mark - UIAlert代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.player != nil) {
        self.player = nil;
    }
    
    self.player = [[MPMoviePlayerViewController alloc] initWithContentURL:self.url];
    [self presentViewController:self.player animated:YES completion:nil];
}

#pragma mark - FWRAlbumController代理
- (void) getPhotosWithArray:(NSArray *)photosArray {
    NSString *message = [NSString stringWithFormat:@"从相册取到%ld张照片",photosArray.count];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
