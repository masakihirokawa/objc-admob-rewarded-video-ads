//
//  ViewController.m
//  AdMobRewardedVideoAdsSample
//
//  Created by Dolice on 2020/07/09.
//  Copyright © 2020 Dolice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 動画リワード広告の読み込みボタン配置
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Load" forState:UIControlStateNormal];
    [button sizeToFit];
    
    CGFloat const screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    CGFloat const screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat const buttonWidth  = 200;
    CGFloat const buttonHeight = 50;
    
    CGFloat const buttonX = roundf((screenWidth / 2) - (buttonWidth / 2));
    CGFloat const buttonY = roundf((screenHeight / 2) - (buttonHeight / 2));
    button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    
    button.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [button addTarget:self action:@selector(loadRewardedVideoAdsButtonTapEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

// 動画リワード広告の読み込みボタンのタップイベント
- (void)loadRewardedVideoAdsButtonTapEvent:(UIButton *)button
{
    // AdMob動画リワード広告読み込み
    [[AdMobRewardedVideoAds sharedManager] loadRewardedVideoAds:self usePersonalizedAds:YES];
}

@end
