//
//  CARCoverViewControllerProtected.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/15/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CARCoverViewControllerProtected <NSObject>

@required
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

- (void)initializeCoverViewController;
- (void)initializeChildScrollViewController:(UIViewController *)childController;
- (void)showChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView;

@end
