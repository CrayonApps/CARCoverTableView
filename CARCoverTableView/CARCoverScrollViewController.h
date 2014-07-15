//
//  CARCoverScrollViewController.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 7/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CARCoverTableView.h"
#import "CARCoverScrollView.h"

/**
 @brief
 UIScrollViewDelegate のいくつかを使用しているのでサブクラスする場合は必要に応じてsuperを呼ぶこと
 */
@interface CARCoverScrollViewController : UITableViewController

@property (nonatomic, weak) IBOutlet CARCoverScrollView *coverScrollView;
@property (nonatomic, readonly) CARCoverTableView *coverTableView;

/**
 スクロール時はページングしないが、停止時にはページ単位で止まる
 CARCoverScrollView に実装したいが、 UIScrollViewDelegate のメソッドを使用する関係でこちらに実装している
 */
@property (nonatomic, assign, getter = isRoughPagingEnabled) BOOL roughPagingEnabled;

- (void)coverScrollViewDidFinishScrolling;

@end
