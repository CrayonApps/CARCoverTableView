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

// 変更が一カ所のみのプロパティをreadonlyにしてみるテスト
@property (nonatomic, readonly) NSMutableArray *reusableViews;
@property (nonatomic, readonly) NSMutableDictionary *allViews;
@property (nonatomic, weak) NSArray *defaultSubviews;

@property (nonatomic, readonly) NSIndexSet *previousVisibleIndices;
@property (nonatomic, readonly) NSInteger itemCount;
@property (nonatomic, assign, getter = isReloadingData) BOOL reloadingData;
@property (nonatomic, readonly) NSDate *previousLayoutDate;
@property (nonatomic, readonly) CGPoint previousOffset;
@property (nonatomic, readonly) CGPoint velocity;
@property (nonatomic, assign, getter = isInertialScrolling) BOOL inertialScrolling;

- (void)initializeCoverScrollView;

- (void)reloadItemCount;

- (void)enqueueAllViews;
- (void)enqueueReuseableViewAtIndex:(NSInteger)index;

- (void)getDatas;
- (void)prepareViews;

- (void)initializeView:(UIView *)view;
- (void)viewDidSelect:(CARCoverScrollViewSelectionRecognizer *)gestureRecognizer;

- (void)calculateVelocity;

/**
 ページを中央に揃える
 */
- (void)fitCoverScrollViewPage;
- (void)didPan:(UIPanGestureRecognizer *)recognizer;

@end

@implementation CARCoverScrollView

@synthesize delegate = _coverScrollViewDelegate;
@synthesize reusableViews = _reusableViews;
@synthesize allViews = _allViews;
@synthesize previousVisibleIndices = _previousVisibleIndices;
@synthesize itemCount = _itemCount;
@synthesize previousLayoutDate = _previousLayoutDate;
@synthesize previousOffset = _previousOffset;
@synthesize velocity = _velocity;
@synthesize roughPagingEnabled = _roughPagingEnabled;

@dynamic visibleIndices;
@dynamic currentIndex;

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
	
	_reusableViews = [[NSMutableArray alloc] init];
	_allViews = [[NSMutableDictionary alloc] init];
	self.defaultSubviews = self.subviews.copy;
	
	self.scrollsToTop = NO;
	self.backgroundColor = [UIColor whiteColor];
	
	NSAssert(self.panGestureRecognizer, @"");
	[self.panGestureRecognizer addTarget:self action:@selector(didPan:)];
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

- (NSInteger)currentIndex {
	return (self.contentOffset.x / self.bounds.size.width);
}

- (NSInteger)itemCount {
	
	if (_itemCount == NSNotFound) {
		[self reloadItemCount];
	}
	return _itemCount;
}

- (void)setRoughPagingEnabled:(BOOL)roughPagingEnabled {
	
	if (roughPagingEnabled) {
		[self fitCoverScrollViewPage];
	}
	
	_roughPagingEnabled = roughPagingEnabled;
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
- (void)calculateVelocity {
	
	// layoutSubviews 以外から呼ばれることは想定していない
	
	NSDate *now = [NSDate date];
	NSTimeInterval interval = [now timeIntervalSinceDate:self.previousLayoutDate];

	if (interval < 0.01) {
		// スクロールのないときに呼ばれることを防ぐため：スクロール時に layoutSubviews が呼ばれる間隔を測ったところ 0.01~0.03 だった
		return;
	}
	
	if (self.previousLayoutDate) {
		// 最後の _previousLayoutDate 代入があるので、if条件を逆にしてreturnができない
		
		CGPoint diff = CGPointZero;
		diff.x = self.contentOffset.x - self.previousOffset.x;
		diff.y = self.contentOffset.y - self.previousOffset.y;
		
		CGPoint currentVelocity = CGPointZero;
		currentVelocity.x = diff.x / interval;
		currentVelocity.y = diff.y / interval;
		
		_velocity = currentVelocity;
		
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fitCoverScrollViewPage) object:nil];
		
		if (fabsf(self.velocity.x) < 200.0f) {
			[self fitCoverScrollViewPage];
		}
	}

	_previousLayoutDate = now;
	_previousOffset = self.contentOffset;
}

#pragma mark - Layout
- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	[self prepareViews];
	[self calculateVelocity];
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
	
	_previousVisibleIndices = visibleIndices.copy;
	
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

#pragma mark - UIPanGestureRecognizer Receivers
- (void)didPan:(UIPanGestureRecognizer *)recognizer {
	
	switch (recognizer.state) {
		case UIGestureRecognizerStateChanged:
			self.inertialScrolling = NO;
			break;
			
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed: {
			
			CGPoint velocityInView = [recognizer velocityInView:self];
			self.inertialScrolling = YES;
			
			if (velocityInView.x == 0.0f) {
				[self fitCoverScrollViewPage];
			}
			else {
				// didPan より layoutSubviews の方が先に呼ばれるのでここであらかじめ呼んでおく。
				// スクロールが
				[self performSelector:@selector(fitCoverScrollViewPage) withObject:nil afterDelay:0.05];
			}
			break;
		}
		default:
			break;
	}
}

- (void)fitCoverScrollViewPage {

	if (self.inertialScrolling == NO) {
		return;
	}
	self.inertialScrolling = NO;
	
	if (self.isRoughPagingEnabled == NO) {
		return;
	}
	
	CGFloat x = self.contentOffset.x;
	CGFloat boundsWidth = self.bounds.size.width;
	
	if (boundsWidth == 0.0f) {
		return;
	}
	
	NSInteger floorX = floorf(x);
	NSInteger floorBoundsWidth = floorf(boundsWidth);
	NSInteger index = floorX / floorBoundsWidth;
	
	if (index == (x / boundsWidth)) {
		// fitしている場合
		return;
	}
	
	CGFloat threshold = (boundsWidth * index) + (boundsWidth / 2.0f);
	CGPoint contentOffset = self.contentOffset;
	
	if (x > threshold) {
		contentOffset.x = boundsWidth * (index + 1);
	}
	else {
		contentOffset.x = boundsWidth * index;
	}
	
	CGFloat maxContentOffsetX = self.contentSize.width - boundsWidth;
	
	if (contentOffset.x < 0.0f) {
		contentOffset.x = 0.0f;
	}
	else if (contentOffset.x > maxContentOffsetX) {
		contentOffset.x = maxContentOffsetX;
	}
	
	[self setContentOffset:contentOffset animated:YES];
}

@end

@implementation CARCoverScrollViewSelectionRecognizer
@end