//
//  AdMobRewardedVideoAds.m
//
//  Created by Dolice on 2017/08/03.
//  Copyright © 2017 Masaki Hirokawa. All rights reserved.
//

#import "AdMobRewardedVideoAds.h"

@implementation AdMobRewardedVideoAds

#pragma mark - Shared Manager

static id sharedInstance = nil;

+ (id)sharedManager
{
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

#pragma mark - AdMob Rewarded Video Ads

// AdMob動画リワード広告広告読み込み
- (void)loadRewardedVideoAds:(UIViewController *)viewController usePersonalizedAds:(BOOL)usePersonalizedAds
{
    if (![viewController isEqual:self.rootViewController]) {
        self.rootViewController = viewController;
    }
    
    self.usePersonalizedAds = usePersonalizedAds;
    
    self.adMobRewardedAd = [[GADRewardedAd alloc] initWithAdUnitID:GAD_TEST_MODE ? GAD_REWARD_TEST_UNIT_ID : GAD_REWARD_UNIT_ID];

    GADRequest *request = [GADRequest request];
    if (GAD_TEST_MODE) {
        [[GADMobileAds sharedInstance] requestConfiguration].testDeviceIdentifiers = @[kGADSimulatorID,
                                                                                       @"Test Device ID"];
    }
    
    if (!self.usePersonalizedAds) {
        GADExtras *extras = [[GADExtras alloc] init];
        extras.additionalParameters = @{@"npa": @"1"};
        [request registerAdNetworkExtras:extras];
    }
    //NSLog(@"RewardedVideoAds -> usePersonalizedAds: %d", self.usePersonalizedAds);
    
    [self.adMobRewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
      if (error) {
          // 再生完了フラグを下ろす
          self->isCompletePlaying = NO;
          
          // アクティビティインジケーターのアニメーション停止
          [self stopActivityIndicator];
      } else {
          //NSLog(@"Reward based video ad is received.");
          
          // 動画リワード広告表示
          if (self.adMobRewardedAd.isReady) {
              [self.adMobRewardedAd presentFromRootViewController:self.rootViewController delegate:self];
          }
          
          // アクティビティインジケーターのアニメーション停止
          [self stopActivityIndicator];
      }
    }];
    
    // アクティビティインジケータのアニメーション開始
    CGFloat const screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    CGFloat const screenHeight = [[UIScreen mainScreen] bounds].size.height;
    [self startActivityIndicator:self.rootViewController.view center:CGPointMake(screenWidth / 2, screenHeight / 2)
                         styleId:AI_WHITE hidesWhenStopped:YES showOverlay:YES];
    
    // 再生完了フラグを下ろす
    isCompletePlaying = NO;
}

// リワード提供
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward
{
    //NSLog(@"rewardedAd:userDidEarnReward:");
    
    // TODO: リワード提供
    
    
    // 再生完了フラグを立てる
    isCompletePlaying = YES;
}

// 動画リワード広告が開かれた時に呼ばれる
- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd
{
    //NSLog(@"rewardedAdDidPresent:");
    
    // 再生完了フラグを下ろす
    isCompletePlaying = NO;
}

// 動画リワード広告がエラーで開かれなかった時に呼ばれる
- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error
{
    //NSLog(@"rewardedAd:didFailToPresentWithError");
    
    // 再生完了フラグを下ろす
    isCompletePlaying = NO;
    
    // アクティビティインジケーターのアニメーション停止
    [self stopActivityIndicator];
}

// 動画リワード広告が閉じられた時に呼ばれる
- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd
{
    //NSLog(@"rewardedAd:rewardedAdDidDismiss");
    
    // TODO: 再生が完了していればお知らせアラート表示
    if (isCompletePlaying) {
        
    }
}

#pragma mark - Activity Indicator

// アクティビティインジケーターのアニメーション開始
- (void)startActivityIndicator:(id)view center:(CGPoint)center styleId:(NSInteger)styleId hidesWhenStopped:(BOOL)hidesWhenStopped showOverlay:(BOOL)showOverlay
{
    // インジケーター初期化
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    
    // スタイルを設定
    switch (styleId) {
        case AI_GRAY:
            _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            
            break;
        case AI_WHITE:
            _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            
            break;
        case AI_WHITE_LARGE:
            _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            
            break;
    }
    
    // スタイルに応じて寸法変更
    if (_activityIndicator.activityIndicatorViewStyle == UIActivityIndicatorViewStyleWhiteLarge) {
        _activityIndicator.frame = CGRectMake(0, 0, 50.0, 50.0);
    } else {
        _activityIndicator.frame = CGRectMake(0, 0, 20.0, 20.0);
    }
    
    // 座標をセンターに指定
    _activityIndicator.center = center;
    
    // 停止した時に隠れるよう設定
    _activityIndicator.hidesWhenStopped = hidesWhenStopped;
    
    // インジケーターアニメーション開始
    [_activityIndicator startAnimating];
    
    // オーバーレイ表示フラグ保持
    _showOverlay = showOverlay;
    
    // オーバーレイ表示
    if (_showOverlay) {
        _overlay = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _overlay.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5f];
        [view addSubview:_overlay];
    }
    
    // 画面に追加
    [view addSubview:_activityIndicator];
}

// アクティビティインジケーターのアニメーション停止
- (void)stopActivityIndicator
{
    if (_showOverlay) {
        [_overlay removeFromSuperview];
    }
    [_activityIndicator stopAnimating];
}

@end
