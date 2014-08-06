//
//  CARCoverCollectionViewController.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/6/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CARCoverCollectionView.h"
#import "CARCoverScrollView.h"

@interface CARCoverCollectionViewController : UICollectionViewController

@property (nonatomic, weak) IBOutlet CARCoverScrollView *coverScrollView;
@property (nonatomic, readonly) CARCoverCollectionView *coverCollectionView;

@end
