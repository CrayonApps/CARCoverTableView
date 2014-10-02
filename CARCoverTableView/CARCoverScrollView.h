//
//  CARCoverScrollView.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 7/12/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 このクラスは横スクロールビューの動的なheight変化に追従するcell.heightを提供するために作成された
 ・UICollectionView / UICollectionViewLayout で↑が実現できるならそちらの方が良い
 　・delegateメソッドが呼ばれず、レイアウトのアップデート方法も「セルに対する操作（挿入、移動、削除）」があった場合のみを対象としていて使えない
 　・主に以下のログが出る
 　　"the item height must be less that the height of the UICollectionView minus the section insets top and bottom values."
 */

@class CARCoverScrollView;
@class CARCoverScrollViewCell;

@protocol CARCoverScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInCoverScrollView:(CARCoverScrollView *)coverScrollView;
- (CARCoverScrollViewCell *)coverScrollView:(CARCoverScrollView *)coverScrollView cellAtIndex:(NSInteger)index;

@end

@protocol CARCoverScrollViewDelegate <NSObject, UIScrollViewDelegate>

@optional
- (void)coverScrollView:(CARCoverScrollView *)coverScrollView didSelectItemAtIndex:(NSInteger)index;
- (void)coverScrollView:(CARCoverScrollView *)coverScrollView didUpdateCurrentIndex:(NSInteger)index;

@end

@interface CARCoverScrollViewCell : UIView

@property (nonatomic, copy) NSString *reuseIdentifier;

@end

@interface CARCoverScrollView : UIScrollView

@property (nonatomic, weak) IBOutlet id <CARCoverScrollViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id <CARCoverScrollViewDelegate> delegate;

@property (nonatomic, assign) NSInteger currentIndex;

/**
 スクロール時はページングしないが、停止時にはページ単位で止まる
 */
@property (nonatomic, assign, getter = isRoughPagingEnabled) BOOL roughPagingEnabled;

/**
 visibleIndices.count > 2 になるような状態は想定していない
 */
@property (nonatomic, readonly) NSIndexSet *visibleIndices;

- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated;

- (void)reloadData;

- (id)dequeReusableCellWithIdentifier:(NSString *)identifier;

/**
 visibleなセルのみ返る
 */
- (CARCoverScrollViewCell *)coverScrollViewCellAtIndex:(NSInteger)index;

@end
