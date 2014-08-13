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
 */
@interface CARCoverScrollViewController : CARCoverViewController <CARCoverScrollViewDataSource, CARCoverScrollViewDelegate>

@property (nonatomic, readonly) NSArray *viewControllers;

/**
 childController.scrollView.panGestureRecognizerの効果範囲をCARCoverScrollViewController.viewに広げるためscrollViewを引数に取っている。
 */
- (void)addChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView;

- (void)insertChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView atIndex:(NSInteger)index;

@end
