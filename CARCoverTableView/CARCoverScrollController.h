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

@protocol CARScrollViewController <NSObject>
@required
@property (nonatomic, readonly) UIScrollView *scrollView;
@end

/**
 @brief CoverTable/CollectionViewではcoverScrollViewで選択する階層に異なるViewControllerを置けなかった問題を解決したクラス
 ナビゲーション構造としてはUITabBarControllerと同じ
 ContainerViewControllerだがCARCoverScrollViewDataSource, CARCoverScrollViewDelegateの扱いがあるのでサブクラス化して使う
 サブクラス時に上書きする必要があるメソッドは以下
 -scrollView:viewAtIndex:
 */
@interface CARCoverScrollController : CARCoverViewController <CARCoverScrollViewDataSource, CARCoverScrollViewDelegate>

@property (nonatomic, readonly) CARCoverScrollView *coverScrollView;

/**
 viewControllersに入っているインスタンスは UIViewController <CARScrollViewController> * である必要がある
 */
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, readonly) UIViewController <CARScrollViewController> *currentViewController;

@end

@interface UIViewController (CARCoverScrollController)
- (CARCoverScrollController *)coverScrollController;
@end