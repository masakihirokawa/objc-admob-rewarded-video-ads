//
//  AdMobRewardedVideoAds.h
//
//  Created by Dolice on 2017/08/03.
//  Copyright © 2017 Masaki Hirokawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefineManager.h"

@import GoogleMobileAds;

@interface AdMobRewardedVideoAds : NSObject <GADRewardedAdDelegate> {
    BOOL isCompletePlaying;
}

#pragma mark - property
@property (nonatomic, strong) GADRewardedAd    *adMobRewardedAd;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, assign) BOOL             usePersonalizedAds;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIView                  *overlay;
@property (nonatomic, assign) BOOL                    showOverlay;

#pragma mark - enumerator
typedef NS_ENUM(NSUInteger, activityIndicatorStyles) {
    AI_GRAY        = 1,
    AI_WHITE       = 2,
    AI_WHITE_LARGE = 3
};

#pragma mark - public method
+ (id)sharedManager;
- (void)loadRewardedVideoAds:(UIViewController *)viewController usePersonalizedAds:(BOOL)usePersonalizedAds;

@end
