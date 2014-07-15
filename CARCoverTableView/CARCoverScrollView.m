//
//  CARCoverScrollView.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 7/12/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverScrollView.h"

/**
 @brief view.gestureRecognizers から判別できるようにするためだけの空クラス
 */
@interface CARCoverScrollViewSelectionRecognizer : UITapGestureRecognizer
@end

@interface CARCoverScrollView ()

@property (nonatomic, strong) NSMutableArray *reusableViews;
@property (nonatomic, strong) NSMutableDictionary *allViews;
@property (nonatomic, weak) NSArray *defaultSubviews;

@property (nonatomic, strong) NSIndexSet *previousVisibleIndices;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign, getter = isReloadingData) BOOL reloadingData;
@property (nonatomic, strong) NSDate *previousLayoutDate;
@property (nonatomic, assign) CGPoint previousOffset;

- (void)initializeCoverScrollView;

- (void)reloadItemCount;

- (void)enqueueAllViews;
- (void)enqueueReuseableViewAtIndex:(NSInteger)index;

- (void)getDatas;
- (void)prepareViews;

- (void)initializeView:(UIView *)view;
- (void)viewDidSelect:(CARCoverScrollViewSelectionRecognizer *)gestureRecognizer;

- (void)sendVelocityToDelegate;

@end

@implementation CARCoverScrollView

@synthesize delegate = _coverScrollViewDelegate;
@synthesize itemCount = _itemCount;

@dynamic visibleIndices;

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
	
	self = [super init];
	if (self) {
		[self initializeCoverScrollView];
	}
	return self;
}

- (void)awakeFromNib {
	[self initializeCoverScrollView];
	[super awakeFromNib];
}

- (void)initializeCoverScrollView {
	
	self.reusableViews = [[NSMutableArray alloc] init];
	self.allViews = [[NSMutableDictionary alloc] init];
	self.defaultSubviews = self.subviews.copy;
	
	self.scrollsToTop = NO;
	self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Accessor
- (void)setContentSize:(CGSize)contentSize {
	
	contentSize.height = 1.0f;
	
	[super setContentSize:contentSize];
}

- (void)setDelegate:(id<CARCoverScrollViewDelegate>)delegate {
	
	_coverScrollViewDelegate = delegate;
	[super setDelegate:delegate];
}

- (NSInteger)itemCount {
	
	if (_itemCount == NSNotFound) {
		[self reloadItemCount];
	}
	return _itemCount;
}

- (NSIndexSet *)visibleIndices {
		
	if (self.itemCount == 0) {
		return nil;
	}
	
	CGFloat x = self.contentOffset.x;
	CGFloat boundsWidth = self.bounds.size.width;
	
	if (boundsWidth == 0.0f) {
		return nil;
	}
	
	NSInteger floorX = floorf(x);
	NSInteger floorBoundsWidth = floorf(boundsWidth);
	NSInteger index = floorX / floorBoundsWidth;
	
	// 1px以下のスクロール時に正確な値が返せないと思われる
	// numberOfItemsを超えて1画面分スクロールするとout of boundsになると思われる（可能なのか？）
	if (floorX % floorBoundsWidth == 0.0f) {
		return [NSIndexSet indexSetWithIndex:index];
	}
	
	if (index >= self.itemCount - 1) {
		return [NSIndexSet indexSetWithIndex:index];
	}
	if (index < 0) {
		return [NSIndexSet indexSetWithIndex:0];
	}
	
	NSMutableIndexSet *indices = [NSMutableIndexSet indexSet];
	[indices addIndex:index + 1];
	[indices addIndex:index];
	
	return indices;
}

#pragma mark - Reusable Views
- (id)dequeReusableView {
	
	UIView *view = self.reusableViews.lastObject;
	[self.reusableViews removeLastObject];
	
	return view;
}

- (void)enqueueAllViews {
	
	NSArray *views = [self.allViews allValues];
		
	[self.reusableViews addObjectsFromArray:views];
	[self.allViews removeAllObjects];
}

- (void)enqueueReuseableViewAtIndex:(NSInteger)index {
	
	UIView *view = self.allViews[@(index)];
	
	if (view == nil) {
		return;
	}
		
	[view removeFromSuperview];
	[self.allViews removeObjectForKey:@(index)];
	[self.reusableViews addObject:view];
}

#pragma mark - Reload
- (void)reloadData {
	
	self.reloadingData = YES;
	
	[self getDatas];
	[self setNeedsLayout];
}

- (void)reloadItemCount {
	NSAssert([self.dataSource respondsToSelector:@selector(numberOfItemsInScrollView:)], @"");
	_itemCount = [self.dataSource numberOfItemsInScrollView:self];
}

- (void)getDatas {
	
	[self reloadItemCount];

	CGSize contentSize = self.bounds.size;
	contentSize.width *= self.itemCount;
	
	self.contentSize = contentSize;
}

#pragma mark - Delegation
- (void)sendVelocityToDelegate {
	
	NSDate *now = [NSDate date];
	
	if (self.previousLayoutDate) {
		if ([self.delegate respondsToSelector:@selector(scrollView:didScrollWithVelocity:)]) {
			
// DoNotRevert: self.panGestureRecognizer.velocityInView では慣性スクロール時の速度（指が離れてからの速度）がとれないため
//			CGPoint velocity = [self.panGestureRecognizer velocityInView:self];
			
			NSTimeInterval interval = [now timeIntervalSinceDate:self.previousLayoutDate];
			CGFloat diffX = self.contentOffset.x - self.previousOffset.x;
			CGFloat velocity = diffX / interval;
			
			[self.delegate scrollView:self didScrollWithVelocity:velocity];
		}
	}

	self.previousLayoutDate = now;
	self.previousOffset = self.contentOffset;
}

#pragma mark - Layout
- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	[self prepareViews];
	[self sendVelocityToDelegate];
}

- (void)prepareViews {
	
	NSIndexSet *addViewIndices = nil;
	NSIndexSet *visibleIndices = self.visibleIndices;

	if (self.isReloadingData) {
		[self enqueueAllViews];
		
		addViewIndices = self.visibleIndices;
	}
	else {
	
		NSMutableIndexSet *indices = [NSMutableIndexSet indexSet];
		
		[self.previousVisibleIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
			
			if ([visibleIndices containsIndex:idx] == NO) {
				[self enqueueReuseableViewAtIndex:idx];
			}
		}];

		[visibleIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
			
			if ([self.previousVisibleIndices containsIndex:idx] == NO) {
				[indices addIndex:idx];
			}
		}];

		addViewIndices = indices.copy;
	}
	
	CGFloat boundsWidth = self.bounds.size.width;
	
	[addViewIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		
		NSAssert([self.dataSource respondsToSelector:@selector(scrollView:viewAtIndex:)], @"");
		
		UIView *view = [self.dataSource scrollView:self viewAtIndex:idx];
		NSAssert(view, @"");
		[self initializeView:view];
		
		CGRect frame = self.frame;
		frame.origin.y = 0.0f;
		frame.origin.x = boundsWidth * idx;
		
		view.frame = frame;
		[self addSubview:view];

		self.allViews[@(idx)] = view;
	}];
	
	for (UIView *view in self.defaultSubviews) {
		[self bringSubviewToFront:view];
	}
	
	self.previousVisibleIndices = visibleIndices.copy;
	
	self.reloadingData = NO;
}

#pragma mark - View Initialization
- (void)initializeView:(UIView *)view {
	
	BOOL hasSelectionRecognizer = NO;
	
	for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
		if ([recognizer isKindOfClass:[CARCoverScrollViewSelectionRecognizer class]]) {
			hasSelectionRecognizer = YES;
			break;
		}
	}
	
	if (hasSelectionRecognizer == NO) {
		CARCoverScrollViewSelectionRecognizer *gestureRecognizer = [[CARCoverScrollViewSelectionRecognizer alloc] initWithTarget:self action:@selector(viewDidSelect:)];
		gestureRecognizer.cancelsTouchesInView = NO;
		[view addGestureRecognizer:gestureRecognizer];
	}
	
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - View Selection
- (void)viewDidSelect:(CARCoverScrollViewSelectionRecognizer *)gestureRecognizer {
	
	if ([self.delegate respondsToSelector:@selector(scrollView:didSelectItemAtIndex:)]) {
		UIView *view = gestureRecognizer.view;
		NSNumber *key = [_allViews allKeysForObject:view][0];
		NSInteger index = key.integerValue;
		
		[self.delegate scrollView:self didSelectItemAtIndex:index];
	}
}

@end

@implementation CARCoverScrollViewSelectionRecognizer
@end