//
//  CARCoverScrollViewController.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 7/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CARCoverTableView.h"

@interface CARCoverScrollViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UICollectionView *coverScrollView;
@property (nonatomic, readonly) CARCoverTableView *coverTableView;

- (void)coverScrollViewDidFinishScrolling;

@end
