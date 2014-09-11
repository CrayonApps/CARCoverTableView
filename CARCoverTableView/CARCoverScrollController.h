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

@optional
- (void)coverScrollController:(CARCoverScrollController *)coverScrollController didShowViewController:(UIViewController <CARScrollViewController> *)viewController;
- (void)coverScrollController:(CARCoverScrollController *)coverScrollController didChangeViewControllers:(NSArray *)viewControllers;

@end

/**
 @brief CoverTable/CollectionViewではcoverScrollViewで選択する階層に異なるViewControllerを置けなかった問題を解決したクラス
 ナビゲーション構造としてはUITabBarControllerと同じ
 
 CoverScrollViewCellを設定するためにCARCoverScrollControllerはサブクラス化して使用する必要がある
 
 注）ViewController階層に組み込まれる前に CARCoverViewController.coverScrollView.currentIndex を設定することは可能だが、その後 layoutIfNeeded 系のメソッドを使用すると currentIndex が0に戻ってしまうので注意
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

@property (nonatomic, assign, getter = isHorizontalScrollingEnabledOnContentView) BOOL horizontalScrollingEnabledOnContentView;

//- (id)initWithRootViewController:(UIViewController *)rootViewController scrollView:(UIScrollView *)scrollView __attribute__ ((deprecated("use init and setViewControllers instead")));

@end

@interface UIViewController (CARCoverScrollController)
- (CARCoverScrollController *)coverScrollController;
@end