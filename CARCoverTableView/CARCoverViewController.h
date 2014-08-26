//
//  CARCoverViewController.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CARCoverViewControllerProtocols.h"

/**
 現状storyboardからは作成できない
 */
@interface CARCoverViewController : UIViewController <CARCoverViewControllerProtected>

@property (nonatomic, strong) UIViewController <CARScrollViewController> *rootViewController;

@property (nonatomic, readonly) UIView *coverView;
@property (nonatomic, readonly) UIView *contentView;

@property (nonatomic, assign) CGFloat minimumCoverHeight;
@property (nonatomic, assign) CGFloat maximumCoverHeight;

@end

@interface UIViewController (CARCoverViewController)
- (CARCoverViewController *)coverViewController;
@end