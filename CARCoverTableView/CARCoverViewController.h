//
//  CARCoverViewController.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 現状storyboardからは作成できない
 */
@interface CARCoverViewController : UIViewController

@property (nonatomic, readonly) UIView *coverView;
@property (nonatomic, readonly) UIView *contentView;

@property (nonatomic, assign) CGFloat minimumCoverHeight;
@property (nonatomic, assign) CGFloat maximumCoverHeight;

- (id)initWithRootViewController:(UIViewController *)rootViewController scrollView:(UIScrollView *)scrollView;

// @protected
- (void)initializeChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView;
- (void)showChildScrollViewController:(UIViewController *)childController;

@end
