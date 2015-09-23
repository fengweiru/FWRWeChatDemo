//
//  FWRMenuController.h
//  WeChatCameraDemo
//
//  Created by 冯伟如 on 15/8/27.
//  Copyright (c) 2015年 冯伟如. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FWRMenuController;
@protocol FWRMenuControllerDelegate <NSObject>

- (void) buttonMenuViewController:(FWRMenuController *)buttonMenu buttonTappedAtIndex:(NSUInteger)index;

@end

@interface FWRMenuController : UIViewController

- (instancetype)initWithNameArrays:(NSArray *)nameArrays;

@property (nonatomic, readonly, getter=isVisible)BOOL visible;

@property (nonatomic, assign) id<FWRMenuControllerDelegate> delegate;

- (void) showInView:(UIView*)view;

- (void)hide;

@end


