//
//  CARCoverViewControllerProtected.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/26/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CARScrollViewController <NSObject>

@required
@property (nonatomic, readonly) UIScrollView *scrollView;

@end

@protocol CARCoverViewControllerProtected <NSObject>

@required
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

- (void)initializeCoverViewController;

- (void)initializeChildScrollViewController:(UIViewController <CARScrollViewController> *)childController;
- (void)showChildScrollViewController:(UIViewController <CARScrollViewController> *)childController;
- (void)hideChildScrollViewController;

@end
