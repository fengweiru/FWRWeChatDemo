//
//  FWRPhotoBrowserViewController.m
//  WeChatCameraDemo
//
//  Created by medzone on 16/11/4.
//  Copyright © 2016年 冯伟如. All rights reserved.
//

#import "FWRPhotoBrowserViewController.h"
#import "FWRAlbumConfigure.h"

@interface FWRPhotoBrowserViewController ()

@property (nonatomic, strong) NSArray *photoArray;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL isHidden;

@end

@implementation FWRPhotoBrowserViewController

- (instancetype)initWithPhotoArray:(NSArray *)photoArray atIndex:(NSInteger)index
{
    if (self = [super init]) {
        
        self.photoArray = [NSArray arrayWithArray:photoArray];
        self.index = index;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationSlide];
    self.isHidden = true;
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationSlide];
    self.isHidden = false;
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setTopBarAndBottomBar];
}

- (void)setTopBarAndBottomBar
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.4];
    [self.view addSubview:topView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.4];
    [self.view addSubview:bottomView];
    
    topView.frame = CGRectMake(0, 0, KscreenW, 64);
    backButton.frame = CGRectMake(5, 12, 40, 40);
    bottomView.frame = CGRectMake(0, KScreenH-44, KscreenW, 44);
}

- (void)clickToBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (BOOL)prefersStatusBarHidden
{
    return self.isHidden;//隐藏为YES，显示为NO
}

@end
