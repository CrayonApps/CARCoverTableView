//
//  CARCoverScrollViewController.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CARCoverScrollView.h"
#import "CARCoverViewController.h"

@class CARCoverScrollController;

@protocol CARCoverScrollControllerDelegate <NSObject>

@required
- (void)coverScrollController:(CARCoverScrollController *)coverScrollController didShowViewController:(UIViewController <CARScrollViewController> *)viewController;

@end

/**
 @brief CoverTable/CollectionViewではcoverScrollViewで選択する階層に異なるViewControllerを置けなかった問題を解決したクラス
 ナビゲーション構造としてはUITabBarControllerと同じ
 
 CoverScrollViewCellを設定するためにCARCoverScrollControllerはサブクラス化して使用する必要がある
 */
@interface CARCoverScrollController : CARCoverViewController <CARCoverScrollViewDataSource, CARCoverScrollViewDelegate>

@property (nonatomic, weak) id <CARCoverScrollControllerDelegate> delegate;

@property (nonatomic, readonly) CARCoverScrollView *coverScrollView;

/**
 viewControllersに入っているインスタンスは UIViewController <CARScrollViewController> * である必要がある
 */
@property (nonatomic, copy) NSArray *viewControllers;

/** CARCoverViewController.rootViewControllerはここに転送される
 */
@property (nonatomic, strong) UIViewController <CARScrollViewController> *currentViewController;

//- (id)initWithRootViewController:(UIViewController *)rootViewController scrollView:(UIScrollView *)scrollView __attribute__ ((deprecated("use init and setViewControllers instead")));

@end

@interface UIViewController (CARCoverScrollController)
- (CARCoverScrollController *)coverScrollController;
@end