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

@protocol CARCoverScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInScrollView:(CARCoverScrollView *)scrollView;
- (UIView *)scrollView:(CARCoverScrollView *)scrollView viewAtIndex:(NSInteger)index;

@end

@protocol CARCoverScrollViewDelegate <NSObject, UIScrollViewDelegate>

@optional
- (void)scrollView:(CARCoverScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index;

/**
 layoutSubviews でトリガされるので実際にスクロールしているかどうかはdelegate側で判定する必要がある
 @param velocity x 軸の速度
 */
- (void)scrollView:(CARCoverScrollView *)scrollView didScrollWithVelocity:(CGFloat)velocity;

@end

@interface CARCoverScrollView : UIScrollView

@property (nonatomic, weak) IBOutlet id <CARCoverScrollViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id <CARCoverScrollViewDelegate> delegate;

/**
 visibleIndices.count > 2 になるような状態は想定していない
 */
@property (nonatomic, readonly) NSIndexSet *visibleIndices;

- (void)reloadData;

- (id)dequeReusableView;

@end
