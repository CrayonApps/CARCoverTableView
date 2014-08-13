//
//  CARCoverViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverViewController.h"

@interface CARCoverViewController ()

@property (nonatomic, readonly) UIViewController *rootViewController;

- (void)contentScrollViewDidScroll:(CGPoint)contentOffset;

@end

@implementation CARCoverViewController

@synthesize coverView = _coverView;
@synthesize contentView = _contentView;
@synthesize minimumCoverHeight = _minimumCoverHeight;
@synthesize maximumCoverHeight = _maximumCoverHeight;
@synthesize rootViewController = _rootViewController;

- (id)initWithRootViewController:(UIViewController *)rootViewController scrollView:(UIScrollView *)scrollView {

	NSAssert(rootViewController, @"rootViewController cannot be nil");
	NSAssert(scrollView, @"scrollView cannot be nil");
	
	self = [super init];
	if (self) {
		
		CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
		_minimumCoverHeight = 44.0f;
		_maximumCoverHeight = screenHeight * 0.3f;
		
		_rootViewController = rootViewController;
		[self initializeChildScrollViewController:rootViewController scrollView:scrollView];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.view addSubview:self.contentView];
	[self.view addSubview:self.coverView];
	
	// サブクラスで上書きするとき、_rootViewControllerがnilなら実行されない
	[self showChildScrollViewController:self.rootViewController];
}

#pragma mark - ContainerViewController Methods
#pragma mark UIKit
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
	return YES;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods {
	return YES;
}

#pragma mark Custom
- (void)initializeChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView {

	[childController removeFromParentViewController];
	[childController willMoveToParentViewController:self];
	
	[self addChildViewController:childController];
	[childController didMoveToParentViewController:self];
		
	UIPanGestureRecognizer *scrollViewPanGestureRecognizer = scrollView.panGestureRecognizer;
	[scrollView removeGestureRecognizer:scrollViewPanGestureRecognizer];
	[self.view addGestureRecognizer:scrollViewPanGestureRecognizer];
		
	UIEdgeInsets contentInset = scrollView.contentInset;
	contentInset.top += self.maximumCoverHeight;	// contentInset.topで複雑な処理をしている場合は考慮していない
	scrollView.contentInset = contentInset;
	
	[scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)showChildScrollViewController:(UIViewController *)childController {
	
	childController.view.frame = self.contentView.bounds;
	childController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.contentView addSubview:childController.view];
}

#pragma mark - Accessor
- (void)setMinimumCoverHeight:(CGFloat)minimumCoverHeight {
// TODO:
	[self doesNotRecognizeSelector:_cmd];
}

- (void)setMaximumCoverHeight:(CGFloat)maximumCoverHeight {
	// TODO:
	[self doesNotRecognizeSelector:_cmd];
}

#pragma mark Subviews
- (UIView *)coverView {
	if (_coverView == nil) {
		
		CGRect frame = self.view.bounds;
		frame.size.height = self.minimumCoverHeight;
			
		_coverView = [[UIView alloc] initWithFrame:frame];
		_coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_coverView.clipsToBounds = YES;
	}
	return _coverView;
}

- (UIView *)contentView {
	if (_contentView == nil) {
		
		CGRect frame = self.view.bounds;
		frame.origin.y = self.minimumCoverHeight;
		frame.size.height -= frame.origin.y;

		_contentView = [[UIView alloc] initWithFrame:frame];
		_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_contentView.clipsToBounds = YES;
	}
	return _contentView;
}

#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if ([keyPath isEqualToString:@"contentOffset"]) {
		NSValue *contentOffsetValue = change[@"new"];
		[self contentScrollViewDidScroll:contentOffsetValue.CGPointValue];
	}
}

#pragma mark - Zooming
- (void)contentScrollViewDidScroll:(CGPoint)contentOffset {
	
	CGFloat y = contentOffset.y;
	
	CGRect coverFrame = self.coverView.frame;
		
	if (y >= 0.0f) {
		coverFrame.size.height = self.minimumCoverHeight;
	}
	else {
		coverFrame.size.height = self.minimumCoverHeight - y;
	}
	
	self.coverView.frame = coverFrame;
}

@end
