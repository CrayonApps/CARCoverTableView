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

/**
 @brief CoverTable/CollectionViewではcoverScrollViewで選択する階層に異なるViewControllerを置けなかった問題を解決したクラス
 ナビゲーション構造としてはUITabBarControllerと同じ
 ContainerViewControllerだがCARCoverScrollViewDataSource, CARCoverScrollViewDelegateの扱いがあるのでサブクラス化して使う
 サブクラス時に上書きする必要があるメソッドは以下
 -scrollView:viewAtIndex:
 */
@interface CARCoverScrollController : CARCoverViewController <CARCoverScrollViewDataSource, CARCoverScrollViewDelegate>

@property (nonatomic, readonly) CARCoverScrollView *coverScrollView;

@property (nonatomic, readonly) NSArray *viewControllers;
@property (nonatomic, readonly) UIViewController *currentViewController;

/**
 childController.scrollView.panGestureRecognizerの効果範囲をCARCoverScrollViewController.viewに広げるためscrollViewを引数に取っている。
 */
- (void)addChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView;

- (void)insertChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView atIndex:(NSInteger)index;

@end
